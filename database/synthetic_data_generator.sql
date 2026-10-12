-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ENTERPRISE SYNTHETIC DATA GENERATOR (100% PURE SQL)
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Capabilities:
-- 1. Generates 500+ realistic guest profiles using combinatorial name arrays
-- 2. Expands room inventory across 5 floors with differentiated price points
-- 3. Generates 1,000+ realistic reservations across multiple seasons & years
-- 4. Simulates 2,000+ guest room service orders & folio invoices
-- 5. Enables stress-testing, index benchmarking, and Viva defense demonstrations
-- ================================================================================

CREATE OR REPLACE PROCEDURE sp_generate_enterprise_synthetic_dataset(
    p_customer_target INT DEFAULT 200,
    p_reservations_target INT DEFAULT 500
)
LANGUAGE plpgsql AS $$
DECLARE
    v_first_names TEXT[] := ARRAY['Alexander', 'Benjamin', 'Charlotte', 'Daniel', 'Emma', 'Fiona', 'George', 'Hannah', 'Isaac', 'Jessica', 'Liam', 'Mia', 'Noah', 'Olivia', 'Paul', 'Quinn', 'Rachel', 'Samuel', 'Tara', 'Victor', 'William', 'Zoe', 'Aarav', 'Priya', 'Rohan', 'Ananya', 'Vikram', 'Neha', 'Kabir', 'Sneha', 'David', 'Sarah', 'James', 'Emily', 'Michael'];
    v_last_names TEXT[] := ARRAY['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Wilson', 'Anderson', 'Taylor', 'Thomas', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Sharma', 'Patel', 'Verma', 'Gupta', 'Singh', 'Reddy', 'Chopra'];
    v_domains TEXT[] := ARRAY['gmail.com', 'outlook.com', 'yahoo.com', 'icloud.com', 'corporate.org', 'luxurytravel.net'];
    v_cust_count INT;
    v_start_res_id INT;
BEGIN
    RAISE NOTICE '==================================================';
    RAISE NOTICE 'STARTING SYNTHETIC DATASET GENERATION';
    RAISE NOTICE '==================================================';

    -- ----------------------------------------------------------------------------
    -- 1. BULK INSERT REALISTIC CUSTOMER ACCOUNTS
    -- ----------------------------------------------------------------------------
    RAISE NOTICE '1. Generating synthetic customers...';
    
    INSERT INTO customers (name, email, phone, password_hash, created_at)
    SELECT 
        first_name || ' ' || last_name AS name,
        LOWER(first_name || '.' || last_name || '_' || seq || '@' || domain_name) AS email,
        '+1 (' || LPAD((200 + (seq % 700))::TEXT, 3, '0') || ') 555-' || LPAD((1000 + (seq % 9000))::TEXT, 4, '0') AS phone,
        -- Default bcrypt/scrypt hash representation
        'scrypt:32768:8:1$syntheticGuestHash$' || seq AS password_hash,
        CURRENT_TIMESTAMP - (random() * 730 || ' days')::INTERVAL AS created_at
    FROM (
        SELECT 
            s AS seq,
            v_first_names[1 + floor(random() * array_length(v_first_names, 1))::INT] AS first_name,
            v_last_names[1 + floor(random() * array_length(v_last_names, 1))::INT] AS last_name,
            v_domains[1 + floor(random() * array_length(v_domains, 1))::INT] AS domain_name
        FROM generate_series(1, p_customer_target) s
    ) gen
    ON CONFLICT (email) DO NOTHING;

    -- ----------------------------------------------------------------------------
    -- 2. EXPAND MULTI-FLOOR LUXURY ROOM INVENTORY
    -- ----------------------------------------------------------------------------
    RAISE NOTICE '2. Expanding hotel room inventory across 5 floors...';

    INSERT INTO rooms (room_number, room_type, price_per_night, status, is_active)
    SELECT 
        floor_num || LPAD(room_index::TEXT, 2, '0') AS room_number,
        CASE 
            WHEN floor_num IN (1, 2) THEN 'Standard Deluxe'
            WHEN floor_num IN (3, 4) THEN 'Executive King'
            ELSE 'Presidential Suite'
        END AS room_type,
        CASE 
            WHEN floor_num IN (1, 2) THEN 120.00 + (room_index * 5)
            WHEN floor_num IN (3, 4) THEN 240.00 + (room_index * 10)
            ELSE 550.00 + (room_index * 25)
        END AS price_per_night,
        'Available' AS status,
        TRUE AS is_active
    FROM generate_series(1, 5) AS floor_num
    CROSS JOIN generate_series(1, 10) AS room_index
    ON CONFLICT (room_number) DO NOTHING;

    -- ----------------------------------------------------------------------------
    -- 3. BULK SYNTHETIC HISTORICAL & CURRENT RESERVATIONS
    -- ----------------------------------------------------------------------------
    RAISE NOTICE '3. Generating realistic multi-year reservation stays...';

    INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, special_requests, booking_date, status)
    SELECT 
        c.customer_id,
        rm.room_id,
        booking_info.in_date,
        booking_info.out_date,
        1 + floor(random() * 3)::INT AS number_of_guests,
        CASE floor(random() * 5)::INT
            WHEN 0 THEN 'Late check-in requested'
            WHEN 1 THEN 'High floor, quiet corner room'
            WHEN 2 THEN 'Extra pillows and feather duvet'
            WHEN 3 THEN 'Airport pickup shuttle needed'
            ELSE ''
        END AS special_requests,
        booking_info.in_date - (1 + floor(random() * 30)::INT || ' days')::INTERVAL AS booking_date,
        CASE 
            WHEN booking_info.out_date < CURRENT_DATE THEN 'Checked-out'
            WHEN booking_info.in_date <= CURRENT_DATE AND booking_info.out_date >= CURRENT_DATE THEN 'Checked-in'
            ELSE 'Confirmed'
        END AS status
    FROM (
        SELECT 
            s AS seq,
            (CURRENT_DATE - 365 + (s % 450) * 1) AS in_date,
            (CURRENT_DATE - 365 + (s % 450) * 1 + (1 + (s % 6))) AS out_date
        FROM generate_series(1, p_reservations_target) s
    ) booking_info
    JOIN LATERAL (
        SELECT customer_id FROM customers ORDER BY random() LIMIT 1
    ) c ON TRUE
    JOIN LATERAL (
        SELECT room_id FROM rooms ORDER BY random() LIMIT 1
    ) rm ON TRUE;

    -- ----------------------------------------------------------------------------
    -- 4. BULK GENERATE GUEST IN-ROOM SERVICE REQUESTS
    -- ----------------------------------------------------------------------------
    RAISE NOTICE '4. Generating guest service requests...';

    INSERT INTO service_requests (reservation_id, service_id, quantity, request_date, status)
    SELECT 
        r.reservation_id,
        s.service_id,
        1 + floor(random() * 3)::INT AS quantity,
        r.booking_date + (12 || ' hours')::INTERVAL AS request_date,
        CASE 
            WHEN r.status = 'Checked-out' THEN 'Completed'
            WHEN r.status = 'Checked-in' THEN 'Completed'
            ELSE 'Requested'
        END AS status
    FROM reservations r
    CROSS JOIN LATERAL (
        SELECT service_id FROM services ORDER BY random() LIMIT (1 + floor(random() * 2)::INT)
    ) s
    WHERE random() > 0.40;

    -- ----------------------------------------------------------------------------
    -- 5. BULK GENERATE MATCHING INVOICES & BILLS
    -- ----------------------------------------------------------------------------
    RAISE NOTICE '5. Computing matching itemized billing ledgers...';

    INSERT INTO bills (reservation_id, room_charge, service_charge, tax, discount, total_amount, bill_date, payment_status)
    SELECT 
        r.reservation_id,
        calc.computed_room_charge,
        calc.computed_service_charge,
        calc.computed_tax,
        0.00 AS discount,
        (calc.computed_room_charge + calc.computed_service_charge + calc.computed_tax) AS total_amount,
        r.check_out AS bill_date,
        CASE 
            WHEN r.status = 'Checked-out' THEN 'Paid'
            WHEN r.status = 'Checked-in' THEN 'Pending'
            ELSE 'Pending'
        END AS payment_status
    FROM reservations r
    JOIN rooms rm ON r.room_id = rm.room_id
    JOIN LATERAL (
        SELECT 
            ROUND(((r.check_out - r.check_in) * rm.price_per_night), 2) AS computed_room_charge,
            COALESCE((
                SELECT SUM(sr.quantity * sv.price)
                FROM service_requests sr
                JOIN services sv ON sr.service_id = sv.service_id
                WHERE sr.reservation_id = r.reservation_id
            ), 0.00) AS computed_service_charge,
            ROUND((((r.check_out - r.check_in) * rm.price_per_night) * 0.12), 2) AS computed_tax
    ) calc ON TRUE
    ON CONFLICT (reservation_id) DO NOTHING;

    RAISE NOTICE '==================================================';
    RAISE NOTICE 'ENTERPRISE DATASET GENERATION COMPLETE';
    RAISE NOTICE '==================================================';
END;
$$;
