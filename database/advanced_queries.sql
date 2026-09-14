-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED SQL, WINDOW FUNCTIONS & ANALYTICS
-- PostgreSQL DBMS Specification for Academic Viva & Portfolio Evaluation
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. WINDOW FUNCTION (RANK & DENSE_RANK):
-- Rank rooms by tariff within each room category
-- --------------------------------------------------------------------------------
SELECT 
    room_id,
    room_number,
    room_type,
    price_per_night,
    RANK() OVER (PARTITION BY room_type ORDER BY price_per_night DESC) AS tariff_rank,
    DENSE_RANK() OVER (ORDER BY price_per_night DESC) AS hotel_wide_rank
FROM rooms
WHERE is_active = TRUE;


-- --------------------------------------------------------------------------------
-- 2. WINDOW FUNCTION (ROW_NUMBER):
-- Retrieve the most recent reservation per customer
-- --------------------------------------------------------------------------------
WITH ranked_reservations AS (
    SELECT 
        res.reservation_id,
        res.customer_id,
        c.name AS guest_name,
        res.room_id,
        res.check_in,
        res.check_out,
        res.status,
        ROW_NUMBER() OVER (PARTITION BY res.customer_id ORDER BY res.check_in DESC) AS seq_no
    FROM reservations res
    JOIN customers c ON res.customer_id = c.customer_id
)
SELECT reservation_id, customer_id, guest_name, room_id, check_in, check_out, status
FROM ranked_reservations
WHERE seq_no = 1;


-- --------------------------------------------------------------------------------
-- 3. WINDOW FUNCTION (RUNNING TOTAL):
-- Compute cumulative daily hotel revenue over time
-- --------------------------------------------------------------------------------
SELECT 
    bill_id,
    bill_date::DATE AS invoice_date,
    total_amount AS current_invoice,
    SUM(total_amount) OVER (ORDER BY bill_date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM bills
WHERE payment_status = 'Paid';


-- --------------------------------------------------------------------------------
-- 4. WINDOW FUNCTION (LAG & LEAD):
-- Compare each customer's invoice with their previous visit
-- --------------------------------------------------------------------------------
SELECT 
    c.name AS guest_name,
    res.reservation_id,
    res.check_in,
    b.total_amount AS current_bill,
    LAG(b.total_amount, 1) OVER (PARTITION BY c.customer_id ORDER BY res.check_in ASC) AS previous_bill,
    b.total_amount - LAG(b.total_amount, 1) OVER (PARTITION BY c.customer_id ORDER BY res.check_in ASC) AS bill_difference
FROM customers c
JOIN reservations res ON c.customer_id = res.customer_id
JOIN bills b ON res.reservation_id = b.reservation_id
WHERE b.payment_status = 'Paid';


-- --------------------------------------------------------------------------------
-- 5. MULTI-LEVEL COMMON TABLE EXPRESSION (CTE):
-- Calculate customer retention and repeat visitor ratios
-- --------------------------------------------------------------------------------
WITH customer_booking_counts AS (
    SELECT 
        c.customer_id,
        c.name,
        COUNT(res.reservation_id) AS total_stays
    FROM customers c
    LEFT JOIN reservations res ON c.customer_id = res.customer_id
    GROUP BY c.customer_id, c.name
),
booking_categories AS (
    SELECT 
        customer_id,
        name,
        total_stays,
        CASE 
            WHEN total_stays = 0 THEN 'Never Booked'
            WHEN total_stays = 1 THEN 'One-time Visitor'
            ELSE 'Repeat Loyal Customer'
        END AS customer_segment
    FROM customer_booking_counts
)
SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage_of_base
FROM booking_categories
GROUP BY customer_segment;


-- --------------------------------------------------------------------------------
-- 6. RECURSIVE CTE:
-- Generate upcoming 7 days date calendar and project scheduled departures
-- --------------------------------------------------------------------------------
WITH RECURSIVE date_series AS (
    SELECT CURRENT_DATE AS calendar_date
    UNION ALL
    SELECT (calendar_date + INTERVAL '1 day')::DATE
    FROM date_series
    WHERE calendar_date < CURRENT_DATE + INTERVAL '6 days'
)
SELECT 
    ds.calendar_date,
    COUNT(res.reservation_id) AS scheduled_departures
FROM date_series ds
LEFT JOIN reservations res ON res.check_out = ds.calendar_date AND res.status = 'Checked-in'
GROUP BY ds.calendar_date
ORDER BY ds.calendar_date ASC;


-- --------------------------------------------------------------------------------
-- 7. CORRELATED SUBQUERY WITH EXISTS:
-- Find all customers who have ordered room service during any stay
-- --------------------------------------------------------------------------------
SELECT c.customer_id, c.name, c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM reservations res
    JOIN service_requests sr ON res.reservation_id = sr.reservation_id
    WHERE res.customer_id = c.customer_id
);


-- --------------------------------------------------------------------------------
-- 8. CORRELATED SUBQUERY WITH NOT EXISTS:
-- Find rooms that have never experienced a cancellation
-- --------------------------------------------------------------------------------
SELECT r.room_id, r.room_number, r.room_type
FROM rooms r
WHERE NOT EXISTS (
    SELECT 1 
    FROM reservations res
    WHERE res.room_id = r.room_id
      AND res.status = 'Cancelled'
);


-- --------------------------------------------------------------------------------
-- 9. SUBQUERY WITH COMPARISON TO 'ALL':
-- Find all rooms whose price per night exceeds ALL rooms of type 'Economy Non-AC Room'
-- --------------------------------------------------------------------------------
SELECT room_number, room_type, price_per_night
FROM rooms
WHERE price_per_night > ALL (
    SELECT price_per_night 
    FROM rooms 
    WHERE room_type = 'Economy Non-AC Room'
);


-- --------------------------------------------------------------------------------
-- 10. SET OPERATION (UNION ALL):
-- Unified audit ledger combining room tariff revenue and room service revenue
-- --------------------------------------------------------------------------------
SELECT 
    b.bill_id,
    'Room Tariff' AS revenue_source,
    b.room_charge AS amount,
    b.bill_date::DATE AS transaction_date
FROM bills b
WHERE b.payment_status = 'Paid'

UNION ALL

SELECT 
    sr.request_id AS bill_id,
    'Service Charge: ' || s.service_name AS revenue_source,
    (s.price * sr.quantity) AS amount,
    sr.request_date::DATE AS transaction_date
FROM service_requests sr
JOIN services s ON sr.service_id = s.service_id
WHERE sr.status = 'Completed'
ORDER BY transaction_date DESC;


-- --------------------------------------------------------------------------------
-- 11. SET OPERATION (EXCEPT):
-- Registered customers who have never made any room reservation
-- --------------------------------------------------------------------------------
SELECT customer_id, name, email
FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM customers
    EXCEPT
    SELECT customer_id FROM reservations
);


-- --------------------------------------------------------------------------------
-- 12. CONDITIONAL AGGREGATION WITH FILTER CLAUSE:
-- Single-pass calculation of room status metrics per room category
-- --------------------------------------------------------------------------------
SELECT 
    room_type,
    COUNT(*) AS total_rooms,
    COUNT(*) FILTER (WHERE status = 'Available') AS available_count,
    COUNT(*) FILTER (WHERE status = 'Occupied') AS occupied_count,
    COUNT(*) FILTER (WHERE status = 'Cleaning') AS cleaning_count,
    ROUND(COUNT(*) FILTER (WHERE status = 'Occupied') * 100.0 / COUNT(*), 1) AS occupancy_pct
FROM rooms
WHERE is_active = TRUE
GROUP BY room_type;


-- --------------------------------------------------------------------------------
-- 13. DATE OVERLAP VALIDATION QUERY (Double-Booking Prevention Logic):
-- Checks if Room 1 is available for dates 2026-08-01 to 2026-08-05
-- --------------------------------------------------------------------------------
SELECT 
    res.reservation_id,
    res.room_id,
    res.check_in,
    res.check_out,
    res.status
FROM reservations res
WHERE res.room_id = 1
  AND res.status IN ('Confirmed', 'Checked-in', 'Booked')
  AND res.check_in < '2026-08-05'
  AND res.check_out > '2026-08-01';
