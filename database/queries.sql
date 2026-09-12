-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM - COMPREHENSIVE SQL DEMONSTRATION QUERIES FOR DBMS VIVA
-- ================================================================================

-- 1. SELECT & WHERE: View all available active rooms
SELECT room_id, room_number, room_type, price_per_night, status
FROM rooms
WHERE status = 'Available' AND is_active = TRUE
ORDER BY room_number ASC;

-- 2. DISTINCT: View unique room categories offered by the hotel
SELECT DISTINCT room_type
FROM rooms
ORDER BY room_type ASC;

-- 3. INNER JOIN: Detailed Guest Stay & Reservation Summary
SELECT 
    res.reservation_id,
    c.name AS guest_name,
    c.email AS guest_email,
    c.phone AS guest_phone,
    r.room_number,
    r.room_type,
    res.check_in,
    res.check_out,
    (res.check_out - res.check_in) AS total_nights,
    res.status AS reservation_status
FROM reservations res
INNER JOIN customers c ON res.customer_id = c.customer_id
INNER JOIN rooms r ON res.room_id = r.room_id
ORDER BY res.reservation_id DESC;

-- 4. LEFT JOIN: Rooms with current/past bookings count (Includes rooms never booked)
SELECT 
    r.room_number,
    r.room_type,
    r.price_per_night,
    COUNT(res.reservation_id) AS total_times_booked
FROM rooms r
LEFT JOIN reservations res ON r.room_id = res.room_id
GROUP BY r.room_id, r.room_number, r.room_type, r.price_per_night
ORDER BY total_times_booked DESC;

-- 5. GROUP BY & HAVING: Customers who made more than 1 reservation
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    COUNT(res.reservation_id) AS booking_count
FROM customers c
INNER JOIN reservations res ON c.customer_id = res.customer_id
GROUP BY c.customer_id, c.name, c.email
HAVING COUNT(res.reservation_id) >= 1
ORDER BY booking_count DESC;

-- 6. AGGREGATE FUNCTIONS (COUNT, SUM, AVG): Total & Average Financial Statistics
SELECT 
    COUNT(bill_id) AS total_invoices_issued,
    SUM(total_amount) AS total_hotel_revenue,
    AVG(total_amount) AS average_invoice_value,
    SUM(room_charge) AS total_room_tariff_collected,
    SUM(service_charge) AS total_service_fees_collected
FROM bills
WHERE payment_status = 'Paid';

-- 7. SUBQUERY: Find rooms with a price higher than the overall average room price
SELECT room_number, room_type, price_per_night
FROM rooms
WHERE price_per_night > (SELECT AVG(price_per_night) FROM rooms)
ORDER BY price_per_night DESC;

-- 8. SUBQUERY WITH IN: Customers who currently have an active room service request
SELECT customer_id, name, email, phone
FROM customers
WHERE customer_id IN (
    SELECT res.customer_id
    FROM reservations res
    INNER JOIN service_requests sr ON res.reservation_id = sr.reservation_id
    WHERE sr.status IN ('Requested', 'Processing')
);

-- 9. DATE FILTERING & OVERLAP CHECK: Find reservations checked in during July 2026
SELECT reservation_id, customer_id, room_id, check_in, check_out, status
FROM reservations
WHERE check_in >= '2026-07-01' AND check_in <= '2026-07-31'
ORDER BY check_in ASC;

-- 10. DATE OVERLAP CONFLICT QUERY (Used in Flask API for Double Booking Prevention)
-- Parameters: room_id = 1, new_check_in = '2026-07-29', new_check_out = '2026-08-01'
SELECT reservation_id, room_id, check_in, check_out, status
FROM reservations
WHERE room_id = 1
  AND status NOT IN ('Cancelled', 'Checked-out')
  AND check_in < '2026-08-01'
  AND check_out > '2026-07-29';

-- 11. ACTIVE RESERVATIONS VIEW QUERY
SELECT * FROM vw_active_reservations;

-- 12. AVAILABLE ROOMS VIEW QUERY
SELECT * FROM vw_available_rooms;

-- 13. REVENUE SUMMARY BY ROOM TYPE VIEW QUERY
SELECT * FROM vw_revenue_summary;

-- 14. MOST BOOKED ROOM TYPE STATS
SELECT 
    r.room_type,
    COUNT(res.reservation_id) AS times_booked,
    SUM(res.check_out - res.check_in) AS total_nights_sold
FROM rooms r
INNER JOIN reservations res ON r.room_id = res.room_id
GROUP BY r.room_type
ORDER BY times_booked DESC;

-- 15. CUSTOMER RESERVATION HISTORY & EXPENDITURE
SELECT 
    c.customer_id,
    c.name AS guest_name,
    res.reservation_id,
    r.room_number,
    res.check_in,
    res.check_out,
    b.total_amount AS invoice_total,
    b.payment_status
FROM customers c
INNER JOIN reservations res ON c.customer_id = res.customer_id
INNER JOIN rooms r ON res.room_id = r.room_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id
ORDER BY c.customer_id ASC, res.check_in DESC;

-- 16. ROOM SERVICE ORDER FULFILLMENT BREAKDOWN BY GUEST
SELECT 
    sr.request_id,
    r.room_number,
    c.name AS guest_name,
    s.service_name,
    sr.quantity,
    s.price AS unit_price,
    (sr.quantity * s.price) AS total_service_cost,
    sr.status AS service_status,
    sr.request_date
FROM service_requests sr
INNER JOIN services s ON sr.service_id = s.service_id
INNER JOIN reservations res ON sr.reservation_id = res.reservation_id
INNER JOIN rooms r ON res.room_id = r.room_id
INNER JOIN customers c ON res.customer_id = c.customer_id
ORDER BY sr.request_id DESC;

-- 17. HOUSEKEEPING TASK QUEUE STATUS
SELECT 
    hk.task_id,
    r.room_number,
    r.room_type,
    hk.task_type,
    hk.status AS task_status,
    hk.created_at,
    hk.completed_at
FROM housekeeping_tasks hk
INNER JOIN rooms r ON hk.room_id = r.room_id
ORDER BY hk.task_id DESC;

-- 18. OCCUPANCY PERCENTAGE CALCULATOR
SELECT 
    COUNT(*) AS total_rooms,
    COUNT(CASE WHEN status = 'Occupied' THEN 1 END) AS occupied_count,
    COUNT(CASE WHEN status = 'Available' THEN 1 END) AS available_count,
    ROUND((COUNT(CASE WHEN status = 'Occupied' THEN 1 END)::NUMERIC / COUNT(*)::NUMERIC) * 100, 2) AS occupancy_percentage
FROM rooms
WHERE is_active = TRUE;

-- 19. UNPAID PENDING INVOICES REPORT
SELECT 
    b.bill_id,
    b.reservation_id,
    c.name AS guest_name,
    c.email AS guest_email,
    r.room_number,
    b.total_amount,
    b.bill_date
FROM bills b
INNER JOIN reservations res ON b.reservation_id = res.reservation_id
INNER JOIN customers c ON res.customer_id = c.customer_id
INNER JOIN rooms r ON res.room_id = r.room_id
WHERE b.payment_status = 'Pending'
ORDER BY b.bill_date DESC;