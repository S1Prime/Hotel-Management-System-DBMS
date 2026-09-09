-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM - USEFUL SQL QUERIES FOR PGADMIN / PSQL
-- ================================================================================

-- 1. View all registered customer profiles
SELECT * FROM customers ORDER BY customer_id ASC;

-- 2. View all room inventory details
SELECT * FROM rooms ORDER BY room_number ASC;

-- 3. View all reservation records
SELECT * FROM reservations ORDER BY reservation_id ASC;


-- ================================================================================
-- ADVANCED RELATIONAL QUERIES (JOINING CUSTOMERS, ROOMS, & RESERVATIONS)
-- ================================================================================

-- 4. View which customer booked which room with check-in/check-out dates
SELECT 
    res.reservation_id,
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    r.room_number,
    r.room_type,
    r.price_per_night,
    res.check_in,
    res.check_out,
    res.status AS reservation_status
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
ORDER BY res.reservation_id DESC;


-- 5. View currently occupied rooms along with the guest occupying them
SELECT 
    r.room_number,
    r.room_type,
    r.price_per_night,
    c.name AS guest_name,
    c.email AS guest_email,
    res.check_in,
    res.check_out
FROM rooms r
JOIN reservations res ON r.room_id = res.room_id
JOIN customers c ON res.customer_id = c.customer_id
WHERE r.status = 'Occupied' AND res.status IN ('Booked', 'Occupied')
ORDER BY r.room_number ASC;


-- 6. Count total reservations and calculated stay revenue per customer
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    COUNT(res.reservation_id) AS total_bookings,
    SUM((res.check_out - res.check_in) * r.price_per_night) AS total_tariff_amount
FROM customers c
JOIN reservations res ON c.customer_id = res.customer_id
JOIN rooms r ON res.room_id = r.room_id
GROUP BY c.customer_id, c.name, c.email
ORDER BY total_tariff_amount DESC;