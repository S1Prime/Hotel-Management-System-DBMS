-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — STORED PROCEDURES & FUNCTIONS (PL/pgSQL)
-- PostgreSQL DBMS Specification
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. FUNCTION: CALCULATE STAY COST (SCALAR UDF)
-- Computes the base room charges given room ID and stay duration
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calculate_stay_cost(
    p_room_id INT,
    p_check_in DATE,
    p_check_out DATE
)
RETURNS NUMERIC AS $$
DECLARE
    v_rate NUMERIC(10,2);
    v_nights INT;
BEGIN
    IF (p_check_out <= p_check_in) THEN
        RAISE EXCEPTION 'Check-out date must be strictly after check-in date.';
    END IF;

    SELECT price_per_night INTO v_rate
    FROM rooms
    WHERE room_id = p_room_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room ID % does not exist.', p_room_id;
    END IF;

    v_nights := (p_check_out - p_check_in);
    RETURN ROUND(v_rate * v_nights, 2);
END;
$$ LANGUAGE plpgsql;


-- --------------------------------------------------------------------------------
-- 2. PROCEDURE: ATOMIC ROOM RESERVATION WITH OVERLAP PREVENTION
-- Validates availability and inserts reservation safely in a transaction
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_create_reservation(
    p_customer_id INT,
    p_room_id INT,
    p_check_in DATE,
    p_check_out DATE,
    p_number_of_guests INT,
    p_special_requests TEXT DEFAULT '',
    INOUT p_reservation_id INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_conflict_count INT;
    v_room_active BOOLEAN;
BEGIN
    -- Verify room existence and active flag
    SELECT is_active INTO v_room_active
    FROM rooms
    WHERE room_id = p_room_id;

    IF NOT FOUND OR v_room_active = FALSE THEN
        RAISE EXCEPTION 'Room ID % is inactive or does not exist.', p_room_id;
    END IF;

    -- Overlapping dates conflict check
    SELECT COUNT(*) INTO v_conflict_count
    FROM reservations
    WHERE room_id = p_room_id
      AND status IN ('Confirmed', 'Checked-in', 'Booked')
      AND check_in < p_check_out
      AND check_out > p_check_in;

    IF v_conflict_count > 0 THEN
        RAISE EXCEPTION 'Room ID % is already booked for the selected dates (% to %).', 
            p_room_id, p_check_in, p_check_out;
    END IF;

    -- Insert new reservation
    INSERT INTO reservations (
        customer_id, room_id, check_in, check_out, number_of_guests, special_requests, status
    ) VALUES (
        p_customer_id, p_room_id, p_check_in, p_check_out, p_number_of_guests, p_special_requests, 'Confirmed'
    ) RETURNING reservation_id INTO p_reservation_id;

    -- If booking begins today, update room status to Occupied
    IF p_check_in = CURRENT_DATE THEN
        UPDATE rooms SET status = 'Occupied' WHERE room_id = p_room_id;
    END IF;

    RAISE NOTICE 'Reservation #% successfully created for customer %.', p_reservation_id, p_customer_id;
END;
$$;


-- --------------------------------------------------------------------------------
-- 3. PROCEDURE: GUEST CHECK-IN
-- Validates reservation and activates guest stay
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_check_in_guest(
    p_reservation_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_room_id INT;
    v_status VARCHAR(20);
BEGIN
    SELECT room_id, status INTO v_room_id, v_status
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % not found.', p_reservation_id;
    END IF;

    IF v_status NOT IN ('Confirmed', 'Booked') THEN
        RAISE EXCEPTION 'Cannot check in. Current reservation status is: %', v_status;
    END IF;

    UPDATE reservations SET status = 'Checked-in' WHERE reservation_id = p_reservation_id;
    UPDATE rooms SET status = 'Occupied' WHERE room_id = v_room_id;

    RAISE NOTICE 'Reservation #% checked in successfully. Room % is now Occupied.', p_reservation_id, v_room_id;
END;
$$;


-- --------------------------------------------------------------------------------
-- 4. PROCEDURE: GUEST CHECK-OUT & AUTOMATED INVOICE GENERATION
-- Calculates room tariff, tallies service orders, adds tax/discounts, creates bill
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_process_checkout(
    p_reservation_id INT,
    p_discount_rate NUMERIC(4,2) DEFAULT 0.00,
    INOUT p_bill_id INT DEFAULT NULL,
    INOUT p_final_total NUMERIC(10,2) DEFAULT 0.00
)
LANGUAGE plpgsql AS $$
DECLARE
    v_room_id INT;
    v_check_in DATE;
    v_check_out DATE;
    v_rate NUMERIC(10,2);
    v_nights INT;
    v_room_charge NUMERIC(10,2);
    v_service_charge NUMERIC(10,2);
    v_tax NUMERIC(10,2);
    v_discount NUMERIC(10,2);
    v_subtotal NUMERIC(10,2);
BEGIN
    -- 1. Fetch reservation & room pricing
    SELECT res.room_id, res.check_in, res.check_out, r.price_per_night
    INTO v_room_id, v_check_in, v_check_out, v_rate
    FROM reservations res
    JOIN rooms r ON res.room_id = r.room_id
    WHERE res.reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation #% not found.', p_reservation_id;
    END IF;

    -- Calculate base room charge
    v_nights := GREATEST(1, (v_check_out - v_check_in));
    v_room_charge := ROUND(v_rate * v_nights, 2);

    -- 2. Tally room services charge
    SELECT COALESCE(SUM(s.price * sr.quantity), 0.00)
    INTO v_service_charge
    FROM service_requests sr
    JOIN services s ON sr.service_id = s.service_id
    WHERE sr.reservation_id = p_reservation_id
      AND sr.status != 'Cancelled';

    -- 3. Calculate tax (5%) and discount
    v_subtotal := v_room_charge + v_service_charge;
    v_discount := ROUND(v_subtotal * (COALESCE(p_discount_rate, 0.0) / 100.0), 2);
    v_tax := ROUND((v_subtotal - v_discount) * 0.05, 2);
    p_final_total := ROUND((v_subtotal - v_discount) + v_tax, 2);

    -- 4. Upsert Bill Record
    INSERT INTO bills (
        reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status
    ) VALUES (
        p_reservation_id, v_room_charge, v_service_charge, v_tax, v_discount, p_final_total, 'Paid'
    )
    ON CONFLICT (reservation_id) DO UPDATE SET
        room_charge = EXCLUDED.room_charge,
        service_charge = EXCLUDED.service_charge,
        tax = EXCLUDED.tax,
        discount = EXCLUDED.discount,
        total_amount = EXCLUDED.total_amount,
        payment_status = 'Paid'
    RETURNING bill_id INTO p_bill_id;

    -- 5. Update reservation status to Checked-out (Fires room cleaning trigger!)
    UPDATE reservations SET status = 'Checked-out' WHERE reservation_id = p_reservation_id;

    RAISE NOTICE 'Checkout complete for Res #%. Bill #% generated. Total: $%', 
        p_reservation_id, p_bill_id, p_final_total;
END;
$$;


-- --------------------------------------------------------------------------------
-- 5. TABLE-VALUED FUNCTION: CUSTOMER COMPLETE STAY HISTORY
-- Returns tabular folio of every booking made by a specific customer
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_customer_stay_history(p_customer_id INT)
RETURNS TABLE (
    res_id INT,
    room_no VARCHAR(10),
    room_type VARCHAR(50),
    check_in DATE,
    check_out DATE,
    total_nights INT,
    status VARCHAR(20),
    total_paid NUMERIC(10,2),
    invoice_status VARCHAR(20)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        res.reservation_id,
        r.room_number,
        r.room_type,
        res.check_in,
        res.check_out,
        (res.check_out - res.check_in) AS total_nights,
        res.status,
        COALESCE(b.total_amount, 0.00) AS total_paid,
        COALESCE(b.payment_status, 'Unbilled') AS invoice_status
    FROM reservations res
    JOIN rooms r ON res.room_id = r.room_id
    LEFT JOIN bills b ON res.reservation_id = b.reservation_id
    WHERE res.customer_id = p_customer_id
    ORDER BY res.check_in DESC;
END;
$$ LANGUAGE plpgsql;


-- --------------------------------------------------------------------------------
-- 6. PROCEDURE: ORDER HOTEL AMENITY / ROOM SERVICE
-- Verifies active stay and places order with quantity validation
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_order_room_service(
    p_reservation_id INT,
    p_service_id INT,
    p_quantity INT,
    INOUT p_request_id INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_res_status VARCHAR(20);
    v_svc_available BOOLEAN;
BEGIN
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Order quantity must be at least 1.';
    END IF;

    -- Ensure reservation is in-house
    SELECT status INTO v_res_status
    FROM reservations
    WHERE reservation_id = p_reservation_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation #% not found.', p_reservation_id;
    END IF;

    IF v_res_status != 'Checked-in' THEN
        RAISE EXCEPTION 'Room service can only be ordered for currently Checked-in guests (current status: %).', v_res_status;
    END IF;

    -- Ensure service is active
    SELECT is_available INTO v_svc_available
    FROM services
    WHERE service_id = p_service_id;

    IF NOT FOUND OR v_svc_available = FALSE THEN
        RAISE EXCEPTION 'Service ID % is currently unavailable.', p_service_id;
    END IF;

    INSERT INTO service_requests (reservation_id, service_id, quantity, status)
    VALUES (p_reservation_id, p_service_id, p_quantity, 'Requested')
    RETURNING request_id INTO p_request_id;

    RAISE NOTICE 'Room service request #% created successfully.', p_request_id;
END;
$$;
