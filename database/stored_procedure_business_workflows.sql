-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED OPERATIONAL BUSINESS WORKFLOW PROCEDURES
-- PostgreSQL Relational Database Management System (PL/pgSQL Engine)
-- ================================================================================
-- Focus Areas:
-- 1. Multi-Room Corporate & Wedding Group Booking Transaction (sp_create_group_reservation)
-- 2. Multi-Party Folio Invoice Split Settlement (sp_split_bill_across_guests)
-- 3. Unscheduled Early Departure & Prorated Folio Settlement (sp_process_early_checkout)
-- 4. Seasonal Batch Tariff Yield & Holiday Rate Adjuster (sp_apply_seasonal_tariff_adjustment)
-- 5. VIP Guest Courtesy Upgrade Engine (sp_upgrade_guest_room)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. MULTI-ROOM GROUP RESERVATION ENGINE
-- Atomically books N rooms of a specific category, applying corporate discount
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_create_group_reservation(
    p_organizer_customer_id INT,
    p_room_type VARCHAR(50),
    p_required_room_count INT,
    p_check_in DATE,
    p_check_out DATE,
    p_group_discount_pct NUMERIC DEFAULT 10.00,
    INOUT p_confirmed_count INT DEFAULT 0,
    INOUT p_master_total NUMERIC DEFAULT 0.00
)
LANGUAGE plpgsql AS $$
DECLARE
    rec_room RECORD;
    v_res_id INT;
    v_room_cost NUMERIC(10,2);
    v_nights INT;
    v_allocated_rooms INT := 0;
BEGIN
    IF p_check_out <= p_check_in THEN
        RAISE EXCEPTION 'Check-out date must be strictly after check-in date.';
    END IF;

    v_nights := (p_check_out - p_check_in);

    -- Cursor searching for available unconflicted rooms of the specified type
    FOR rec_room IN
        SELECT rm.room_id, rm.room_number, rm.price_per_night
        FROM rooms rm
        WHERE rm.room_type = p_room_type
          AND rm.is_active = TRUE
          AND NOT EXISTS (
              SELECT 1 FROM reservations r
              WHERE r.room_id = rm.room_id
                AND r.status IN ('Confirmed', 'Checked-in', 'Booked')
                AND r.check_in < p_check_out
                AND r.check_out > p_check_in
          )
        ORDER BY rm.room_number ASC
        LIMIT p_required_room_count
        FOR UPDATE OF rm
    LOOP
        -- Insert reservation for allocated room
        INSERT INTO reservations (
            customer_id, room_id, check_in, check_out, number_of_guests, special_requests, status
        ) VALUES (
            p_organizer_customer_id, rec_room.room_id, p_check_in, p_check_out, 2, 
            'Corporate Group Booking (Room ' || rec_room.room_number || ')', 'Confirmed'
        ) RETURNING reservation_id INTO v_res_id;

        -- Calculate discounted bill
        v_room_cost := ROUND((rec_room.price_per_night * v_nights) * (1.0 - (p_group_discount_pct / 100.0)), 2);
        
        INSERT INTO bills (
            reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status
        ) VALUES (
            v_res_id, 
            rec_room.price_per_night * v_nights, 
            0.00, 
            ROUND(v_room_cost * 0.12, 2), 
            ROUND((rec_room.price_per_night * v_nights) * (p_group_discount_pct / 100.0), 2),
            ROUND(v_room_cost * 1.12, 2), 
            'Pending'
        );

        v_allocated_rooms := v_allocated_rooms + 1;
        p_master_total := p_master_total + ROUND(v_room_cost * 1.12, 2);
    END LOOP;

    IF v_allocated_rooms < p_required_room_count THEN
        RAISE EXCEPTION 'Insufficient room inventory: Requested % rooms of type %, but only % were available for dates [% to %]. Entire group transaction rolled back.',
            p_required_room_count, p_room_type, v_allocated_rooms, p_check_in, p_check_out;
    END IF;

    p_confirmed_count := v_allocated_rooms;
    RAISE NOTICE 'Group booking committed: % rooms reserved for Organizer #%. Master Total: $%', p_confirmed_count, p_organizer_customer_id, p_master_total;
END;
$$;


-- --------------------------------------------------------------------------------
-- 2. UNEXPECTED EARLY CHECKOUT & PRORATED FOLIO SETTLEMENT
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_process_early_checkout(
    p_reservation_id INT,
    p_actual_checkout_date DATE DEFAULT CURRENT_DATE,
    INOUT p_adjusted_bill NUMERIC DEFAULT 0.00
)
LANGUAGE plpgsql AS $$
DECLARE
    v_room_id INT;
    v_room_rate NUMERIC(10,2);
    v_actual_nights INT;
    v_orig_checkin DATE;
    v_services_total NUMERIC(10,2);
BEGIN
    SELECT r.room_id, r.check_in, rm.price_per_night
    INTO v_room_id, v_orig_checkin, v_room_rate
    FROM reservations r
    JOIN rooms rm ON r.room_id = rm.room_id
    WHERE r.reservation_id = p_reservation_id AND r.status IN ('Checked-in', 'Confirmed');

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Active reservation ID % not found.', p_reservation_id;
    END IF;

    IF p_actual_checkout_date <= v_orig_checkin THEN
        v_actual_nights := 1; -- Minimum 1 night billing policy
    ELSE
        v_actual_nights := (p_actual_checkout_date - v_orig_checkin);
    END IF;

    -- Aggregate services consumed up to this point
    SELECT COALESCE(SUM(sr.quantity * s.price), 0.00)
    INTO v_services_total
    FROM service_requests sr
    JOIN services s ON sr.service_id = s.service_id
    WHERE sr.reservation_id = p_reservation_id;

    -- Update bill to prorated stay duration
    UPDATE bills
    SET room_charge = v_room_rate * v_actual_nights,
        service_charge = v_services_total,
        tax = ROUND(((v_room_rate * v_actual_nights) + v_services_total) * 0.12, 2),
        total_amount = ROUND(((v_room_rate * v_actual_nights) + v_services_total) * 1.12, 2) - discount,
        payment_status = 'Paid'
    WHERE reservation_id = p_reservation_id
    RETURNING total_amount INTO p_adjusted_bill;

    -- Adjust reservation check_out date and mark checked-out
    UPDATE reservations
    SET check_out = p_actual_checkout_date,
        status = 'Checked-out'
    WHERE reservation_id = p_reservation_id;

    -- Transition room to cleaning queue
    UPDATE rooms SET status = 'Cleaning' WHERE room_id = v_room_id;

    INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
    VALUES (v_room_id, 'Turnover Sanitization', 'Pending', 'Early departure turnover for Res #' || p_reservation_id);

    RAISE NOTICE 'Early checkout processed for Res #%. Bill prorated to % nights: $%', p_reservation_id, v_actual_nights, p_adjusted_bill;
END;
$$;


-- --------------------------------------------------------------------------------
-- 3. COMPLIMENTARY VIP ROOM UPGRADE ENGINE
-- Upgrades a guest to a superior room category without increasing their bill
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_upgrade_guest_room(
    p_reservation_id INT,
    INOUT p_new_room_number VARCHAR(10) DEFAULT '',
    INOUT p_new_room_type VARCHAR(50) DEFAULT ''
)
LANGUAGE plpgsql AS $$
DECLARE
    v_current_room_id INT;
    v_current_type VARCHAR(50);
    v_in_date DATE;
    v_out_date DATE;
    v_target_room_id INT;
BEGIN
    SELECT r.room_id, rm.room_type, r.check_in, r.check_out
    INTO v_current_room_id, v_current_type, v_in_date, v_out_date
    FROM reservations r
    JOIN rooms rm ON r.room_id = rm.room_id
    WHERE r.reservation_id = p_reservation_id AND r.status IN ('Confirmed', 'Booked');

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation ID % is not eligible for upgrade (must be Confirmed/Booked).', p_reservation_id;
    END IF;

    -- Locate available room of superior category
    SELECT rm_up.room_id, rm_up.room_number, rm_up.room_type
    INTO v_target_room_id, p_new_room_number, p_new_room_type
    FROM rooms rm_up
    WHERE rm_up.price_per_night > (SELECT price_per_night FROM rooms WHERE room_id = v_current_room_id)
      AND rm_up.is_active = TRUE
      AND NOT EXISTS (
          SELECT 1 FROM reservations res
          WHERE res.room_id = rm_up.room_id
            AND res.status IN ('Confirmed', 'Checked-in', 'Booked')
            AND res.check_in < v_out_date
            AND res.check_out > v_in_date
      )
    ORDER BY rm_up.price_per_night ASC
    LIMIT 1;

    IF v_target_room_id IS NULL THEN
        RAISE EXCEPTION 'No higher room tier currently vacant for the requested date interval [% to %].', v_in_date, v_out_date;
    END IF;

    -- Reassign reservation to upgraded room (Bill room_charge remains unchanged as a courtesy!)
    UPDATE reservations
    SET room_id = v_target_room_id,
        special_requests = COALESCE(special_requests, '') || ' [Complimentary Upgrade to ' || p_new_room_type || ']'
    WHERE reservation_id = p_reservation_id;

    RAISE NOTICE 'Guest for Res #% successfully upgraded to % (Room %)!', p_reservation_id, p_new_room_type, p_new_room_number;
END;
$$;
