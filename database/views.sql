-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DATABASE VIEWS & MATERIALIZED VIEWS
-- PostgreSQL DBMS Specification
-- ================================================================================

-- --------------------------------------------------------------------------------
-- VIEW 1: ACTIVE & UPCOMING RESERVATIONS
-- Denormalized join of reservations, customers, and rooms for front desk operations
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_active_reservations CASCADE;
CREATE VIEW vw_active_reservations AS
SELECT 
    res.reservation_id,
    c.customer_id,
    c.name AS guest_name,
    c.email AS guest_email,
    c.phone AS guest_phone,
    r.room_id,
    r.room_number,
    r.room_type,
    r.price_per_night,
    res.check_in,
    res.check_out,
    (res.check_out - res.check_in) AS total_nights,
    res.number_of_guests,
    res.special_requests,
    res.status AS reservation_status,
    res.booking_date
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
WHERE res.status IN ('Confirmed', 'Checked-in', 'Booked');


-- --------------------------------------------------------------------------------
-- VIEW 2: AVAILABLE ROOMS INVENTORY CATALOG
-- Instant filter for rooms ready for immediate guest check-in
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_available_rooms CASCADE;
CREATE VIEW vw_available_rooms AS
SELECT 
    room_id,
    room_number,
    room_type,
    price_per_night,
    status
FROM rooms
WHERE status = 'Available' AND is_active = TRUE;


-- --------------------------------------------------------------------------------
-- VIEW 3: FINANCIAL REVENUE BREAKDOWN BY ROOM CATEGORY
-- Aggregates room charges, add-on service charges, and overall revenue per category
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_revenue_summary CASCADE;
CREATE VIEW vw_revenue_summary AS
SELECT 
    r.room_type,
    COUNT(res.reservation_id) AS total_bookings,
    COALESCE(SUM(b.room_charge), 0.00) AS total_room_revenue,
    COALESCE(SUM(b.service_charge), 0.00) AS total_service_revenue,
    COALESCE(SUM(b.tax), 0.00) AS total_tax_collected,
    COALESCE(SUM(b.total_amount), 0.00) AS grand_total_revenue
FROM rooms r
LEFT JOIN reservations res ON r.room_id = res.room_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY r.room_type;


-- --------------------------------------------------------------------------------
-- VIEW 4: CUSTOMER LOYALTY TIERS & LIFETIME VALUE (LTV)
-- Ranks guests into loyalty tiers using CASE expressions and aggregate spend
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_customer_loyalty_ranking CASCADE;
CREATE VIEW vw_customer_loyalty_ranking AS
SELECT 
    c.customer_id,
    c.name AS guest_name,
    c.email AS guest_email,
    c.phone,
    COUNT(DISTINCT res.reservation_id) AS lifetime_reservations,
    COALESCE(SUM(b.total_amount), 0.00) AS lifetime_expenditure,
    CASE 
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 50000 THEN 'Platinum VIP'
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 25000 THEN 'Gold Preferred'
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 10000 THEN 'Silver Member'
        ELSE 'Standard Guest'
    END AS loyalty_tier
FROM customers c
LEFT JOIN reservations res ON c.customer_id = res.customer_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY c.customer_id, c.name, c.email, c.phone;


-- --------------------------------------------------------------------------------
-- VIEW 5: HOUSEKEEPING OPERATIONS QUEUE
-- Operational board for room cleaners and maintenance staff
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_housekeeping_queue CASCADE;
CREATE VIEW vw_housekeeping_queue AS
SELECT 
    ht.task_id,
    r.room_number,
    r.room_type,
    r.status AS current_room_status,
    ht.task_type,
    ht.status AS task_status,
    ht.notes,
    ht.created_at AS assigned_time
FROM housekeeping_tasks ht
JOIN rooms r ON ht.room_id = r.room_id
WHERE ht.status != 'Completed'
ORDER BY ht.created_at ASC;


-- --------------------------------------------------------------------------------
-- VIEW 6: POPULAR SERVICES & AMENITIES LEADERBOARD
-- Ranks hotel amenities by request volume and total revenue generated
-- --------------------------------------------------------------------------------
DROP VIEW IF EXISTS vw_service_popularity CASCADE;
CREATE VIEW vw_service_popularity AS
SELECT 
    s.service_id,
    s.service_name,
    s.price AS unit_price,
    COUNT(sr.request_id) AS total_orders_placed,
    COALESCE(SUM(sr.quantity), 0) AS total_units_consumed,
    COALESCE(SUM(s.price * sr.quantity), 0.00) AS total_revenue_generated
FROM services s
LEFT JOIN service_requests sr ON s.service_id = sr.service_id AND sr.status != 'Cancelled'
GROUP BY s.service_id, s.service_name, s.price;


-- --------------------------------------------------------------------------------
-- MATERIALIZED VIEW: MONTHLY EXECUTIVE FINANCIAL PERFORMANCE
-- Pre-aggregated summary for executive reports (refreshed periodically)
-- --------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS mv_monthly_financial_report;
CREATE MATERIALIZED VIEW mv_monthly_financial_report AS
SELECT 
    TO_CHAR(b.bill_date, 'YYYY-MM') AS billing_month,
    COUNT(b.bill_id) AS total_invoices,
    SUM(b.room_charge) AS gross_room_revenue,
    SUM(b.service_charge) AS gross_service_revenue,
    SUM(b.tax) AS gross_tax_collected,
    SUM(b.discount) AS total_discounts_granted,
    SUM(b.total_amount) AS net_revenue
FROM bills b
WHERE b.payment_status = 'Paid'
GROUP BY TO_CHAR(b.bill_date, 'YYYY-MM')
ORDER BY billing_month DESC;

-- Unique index for concurrent refreshes
CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_monthly_billing_month 
ON mv_monthly_financial_report (billing_month);


-- Refresh procedure for the Materialized View
CREATE OR REPLACE PROCEDURE sp_refresh_analytics_views()
LANGUAGE plpgsql AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_monthly_financial_report;
    RAISE NOTICE 'Materialized view mv_monthly_financial_report refreshed successfully.';
END;
$$;
