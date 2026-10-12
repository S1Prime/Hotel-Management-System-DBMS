-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — SAMPLE SQL OPERATIONS & BUSINESS WORKFLOWS
-- PostgreSQL Pure SQL Operational Suite (Replaces Python seed/test scripts)
-- ================================================================================
-- Demonstrates end-to-end hotel lifecycle using SQL DML, Stored Procedures & Triggers
-- ================================================================================

-- --------------------------------------------------------------------------------
-- WORKFLOW 1: REGISTER A NEW CUSTOMER (Replaces test_registration.py)
-- --------------------------------------------------------------------------------
INSERT INTO customers (name, email, phone, password_hash)
VALUES (
    'Alexander Hayes',
    'alexander.hayes@example.com',
    '+1 (555) 901-2345',
    'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0'
)
ON CONFLICT (email) DO UPDATE 
SET phone = EXCLUDED.phone
RETURNING customer_id, name, email, created_at;


-- --------------------------------------------------------------------------------
-- WORKFLOW 2: CREATE A NEW ROOM RESERVATION (Replaces seed_reservation.py)
-- Invokes stored procedure with automated double-booking prevention check
-- --------------------------------------------------------------------------------
DO $$
DECLARE
    v_res_id INT;
    v_cust_id INT;
BEGIN
    -- Fetch customer ID for Alexander Hayes
    SELECT customer_id INTO v_cust_id 
    FROM customers 
    WHERE email = 'alexander.hayes@example.com';

    -- Call Stored Procedure for booking Room 102 (Standard AC Room)
    CALL sp_create_reservation(
        p_customer_id := v_cust_id,
        p_room_id := 2,
        p_check_in := '2026-11-01',
        p_check_out := '2026-11-05',
        p_number_of_guests := 2,
        p_reservation_id := v_res_id
    );

    RAISE NOTICE 'Workflow 2: Created new reservation with ID = %', v_res_id;
END $$;


-- --------------------------------------------------------------------------------
-- WORKFLOW 3: GUEST CHECK-IN
-- Updates reservation status to 'Checked-in' and room status to 'Occupied'
-- --------------------------------------------------------------------------------
DO $$
DECLARE
    v_target_res_id INT;
BEGIN
    SELECT reservation_id INTO v_target_res_id
    FROM reservations
    WHERE status = 'Confirmed'
    ORDER BY reservation_id DESC
    LIMIT 1;

    IF v_target_res_id IS NOT NULL THEN
        CALL sp_check_in_guest(v_target_res_id);
        RAISE NOTICE 'Workflow 3: Checked in reservation #%', v_target_res_id;
    END IF;
END $$;


-- --------------------------------------------------------------------------------
-- WORKFLOW 4: ORDER ROOM AMENITY / SERVICE
-- Orders 2x Gourmet Breakfast for the in-house guest
-- --------------------------------------------------------------------------------
DO $$
DECLARE
    v_target_res_id INT;
    v_request_id INT;
BEGIN
    SELECT reservation_id INTO v_target_res_id
    FROM reservations
    WHERE status = 'Checked-in'
    ORDER BY reservation_id DESC
    LIMIT 1;

    IF v_target_res_id IS NOT NULL THEN
        CALL sp_order_room_service(
            p_reservation_id := v_target_res_id,
            p_service_id := 1, -- Gourmet Breakfast
            p_quantity := 2,
            p_request_id := v_request_id
        );
        RAISE NOTICE 'Workflow 4: Service request #% created for reservation #%', v_request_id, v_target_res_id;
    END IF;
END $$;


-- --------------------------------------------------------------------------------
-- WORKFLOW 5: GUEST CHECK-OUT & AUTOMATED BILLING INVOICE
-- Calculates stay tariff, sums service requests, applies 10% discount, adds tax,
-- creates the bill, and fires the trigger setting the room to 'Cleaning'
-- --------------------------------------------------------------------------------
DO $$
DECLARE
    v_target_res_id INT;
    v_bill_id INT;
    v_total NUMERIC(10,2);
BEGIN
    SELECT reservation_id INTO v_target_res_id
    FROM reservations
    WHERE status = 'Checked-in'
    ORDER BY reservation_id DESC
    LIMIT 1;

    IF v_target_res_id IS NOT NULL THEN
        CALL sp_process_checkout(
            p_reservation_id := v_target_res_id,
            p_discount_rate := 10.00,
            p_bill_id := v_bill_id,
            p_final_total := v_total
        );
        RAISE NOTICE 'Workflow 5: Checkout complete. Bill #% generated for total amount: $%', v_bill_id, v_total;
    END IF;
END $$;


-- --------------------------------------------------------------------------------
-- WORKFLOW 6: CANCELLATION & AUTOMATIC ROOM RELEASE
-- Demonstrates trigger reverting room status to 'Available' upon cancellation
-- --------------------------------------------------------------------------------
DO $$
DECLARE
    v_test_res_id INT;
BEGIN
    -- Create temporary test booking
    INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, status)
    VALUES (1, 5, '2026-12-01', '2026-12-05', 1, 'Confirmed')
    RETURNING reservation_id INTO v_test_res_id;

    -- Update room to Occupied for demo
    UPDATE rooms SET status = 'Occupied' WHERE room_id = 5;

    -- Cancel the reservation (Fires fn_cancel_room_available trigger!)
    UPDATE reservations SET status = 'Cancelled' WHERE reservation_id = v_test_res_id;

    RAISE NOTICE 'Workflow 6: Cancelled reservation #%. Trigger reverted Room #5 status to Available.', v_test_res_id;
END $$;


-- --------------------------------------------------------------------------------
-- WORKFLOW 7: VERIFY WORKFLOW RESULTS
-- --------------------------------------------------------------------------------
SELECT 
    b.bill_id,
    res.reservation_id,
    c.name AS guest_name,
    r.room_number,
    b.room_charge,
    b.service_charge,
    b.discount,
    b.tax,
    b.total_amount,
    b.payment_status,
    r.status AS current_room_status
FROM bills b
JOIN reservations res ON b.reservation_id = res.reservation_id
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
ORDER BY b.bill_id DESC
LIMIT 3;
