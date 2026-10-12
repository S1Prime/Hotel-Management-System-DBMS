-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DATABASE VERIFICATION & HEALTH AUDIT
-- PostgreSQL Pure SQL Inspection Suite (Replaces verification Python scripts)
-- ================================================================================
-- Usage in pgAdmin 4: Open in Query Tool and press F5.
-- Usage in psql: psql -U postgres -d hotel_management -f database/verify_database.sql
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. ENTITY ROW COUNT & SYSTEM OVERVIEW
-- --------------------------------------------------------------------------------
SELECT 
    '1. Customers' AS table_name, COUNT(*) AS total_records FROM customers
UNION ALL
SELECT '2. Staff Accounts', COUNT(*) FROM staff
UNION ALL
SELECT '3. Rooms Inventory', COUNT(*) FROM rooms
UNION ALL
SELECT '4. Services Catalog', COUNT(*) FROM services
UNION ALL
SELECT '5. Reservations', COUNT(*) FROM reservations
UNION ALL
SELECT '6. Service Requests', COUNT(*) FROM service_requests
UNION ALL
SELECT '7. Bills & Invoices', COUNT(*) FROM bills
UNION ALL
SELECT '8. Housekeeping Tasks', COUNT(*) FROM housekeeping_tasks
UNION ALL
SELECT '9. Audit Log Entries', COUNT(*) FROM audit_logs;


-- --------------------------------------------------------------------------------
-- 2. CUSTOMERS INSPECTION (Replaces verify_customers.py)
-- --------------------------------------------------------------------------------
SELECT 
    customer_id,
    name,
    email,
    phone,
    TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI:SS') AS registered_on,
    CASE 
        WHEN password_hash LIKE 'scrypt:%' OR password_hash LIKE 'pbkdf2:%' THEN 'Hashed (Secure)'
        ELSE 'Plaintext (Insecure)'
    END AS password_security_status
FROM customers
ORDER BY customer_id ASC;


-- --------------------------------------------------------------------------------
-- 3. ROOMS INVENTORY INSPECTION (Replaces verify_rooms.py)
-- --------------------------------------------------------------------------------
SELECT 
    room_id,
    room_number,
    room_type,
    price_per_night,
    status,
    is_active,
    CASE 
        WHEN status = 'Available' THEN 'Ready for Guest'
        WHEN status = 'Occupied' THEN 'Guest In-House'
        WHEN status = 'Cleaning' THEN 'Housekeeping in Progress'
        ELSE 'Under Maintenance'
    END AS operational_state
FROM rooms
ORDER BY room_number ASC;


-- --------------------------------------------------------------------------------
-- 4. RESERVATIONS & BOOKING CALENDAR (Replaces verify_reservations.py)
-- --------------------------------------------------------------------------------
SELECT 
    res.reservation_id,
    c.name AS guest_name,
    c.phone AS guest_contact,
    r.room_number,
    r.room_type,
    res.check_in,
    res.check_out,
    (res.check_out - res.check_in) AS total_nights,
    res.number_of_guests,
    res.status AS booking_status,
    COALESCE(b.total_amount, 0.00) AS billed_amount,
    COALESCE(b.payment_status, 'Unbilled') AS payment_status
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id
ORDER BY res.reservation_id DESC;


-- --------------------------------------------------------------------------------
-- 5. RELATIONAL INTEGRITY & CONSTRAINT HEALTH CHECKS
-- Returns 0 rows if constraints and relationships are 100% consistent
-- --------------------------------------------------------------------------------
-- Check 5A: Orphan reservations with invalid customer or room references
SELECT 'Orphan Reservations' AS issue, COUNT(*) AS violated_rows
FROM reservations res
LEFT JOIN customers c ON res.customer_id = c.customer_id
LEFT JOIN rooms r ON res.room_id = r.room_id
WHERE c.customer_id IS NULL OR r.room_id IS NULL

UNION ALL

-- Check 5B: Inverted reservation dates (check_out <= check_in)
SELECT 'Inverted Dates (check_out <= check_in)', COUNT(*)
FROM reservations
WHERE check_out <= check_in

UNION ALL

-- Check 5C: Non-positive room prices
SELECT 'Invalid Room Tariff (price <= 0)', COUNT(*)
FROM rooms
WHERE price_per_night <= 0;


-- --------------------------------------------------------------------------------
-- 6. ACTIVE DATABASE VIEWS VERIFICATION
-- --------------------------------------------------------------------------------
-- View A: Active in-house & upcoming reservations
SELECT * FROM vw_active_reservations;

-- View B: Revenue summary aggregated per room category
SELECT * FROM vw_revenue_summary;

-- View C: Customer loyalty classification
SELECT * FROM vw_customer_loyalty_ranking;


-- --------------------------------------------------------------------------------
-- 7. AUDIT TRAIL LOG SAMPLE (Verifies Trigger Automation)
-- --------------------------------------------------------------------------------
SELECT 
    log_id,
    table_name,
    operation,
    record_id,
    changed_by,
    TO_CHAR(changed_at, 'YYYY-MM-DD HH24:MI:SS') AS timestamp
FROM audit_logs
ORDER BY log_id DESC
LIMIT 10;
