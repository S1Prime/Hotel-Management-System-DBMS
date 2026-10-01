-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — MATERIALIZED VIEWS & EXECUTIVE REPORTING DATAMART
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. High-Performance Materialized Views for OLAP & Executive Dashboards
-- 2. Unique B-Tree Indexes on Materialized Views for Concurrent Refresh
-- 3. Non-Blocking Zero-Downtime Data Refresh (REFRESH MATERIALIZED VIEW CONCURRENTLY)
-- 4. Incremental Refresh Tracking & Datamart Execution Logs
-- 5. Complex Multi-Table Aggregation Joins Pre-Calculated for Instant Analytics
-- ================================================================================

-- Table: Datamart Refresh Telemetry History
CREATE TABLE IF NOT EXISTS datamart_refresh_logs (
    refresh_id SERIAL PRIMARY KEY,
    view_name VARCHAR(100) NOT NULL,
    refreshed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_ms NUMERIC(10,2),
    status VARCHAR(20) DEFAULT 'Success',
    message TEXT
);


-- --------------------------------------------------------------------------------
-- 1. MATERIALIZED VIEW: MONTHLY EXECUTIVE FINANCIAL PERFORMANCE
-- --------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS mv_monthly_executive_kpis CASCADE;
CREATE MATERIALIZED VIEW mv_monthly_executive_kpis AS
SELECT 
    TO_CHAR(b.bill_date, 'YYYY-MM') AS fiscal_month,
    EXTRACT(YEAR FROM b.bill_date)::INT AS report_year,
    EXTRACT(MONTH FROM b.bill_date)::INT AS report_month,
    COUNT(DISTINCT r.reservation_id) AS total_settled_stays,
    COUNT(DISTINCT r.customer_id) AS unique_guests_served,
    ROUND(SUM(b.room_charge), 2) AS gross_room_revenue,
    ROUND(SUM(b.service_charge), 2) AS gross_services_revenue,
    ROUND(SUM(b.tax), 2) AS total_taxes_remitted,
    ROUND(SUM(b.discount), 2) AS total_promotional_discounts,
    ROUND(SUM(b.total_amount), 2) AS net_revenue_collected,
    ROUND(AVG(b.total_amount), 2) AS average_folio_value,
    ROUND(AVG(r.check_out - r.check_in), 2) AS average_length_of_stay_nights
FROM bills b
JOIN reservations r ON b.reservation_id = r.reservation_id
WHERE b.payment_status = 'Paid'
GROUP BY 
    TO_CHAR(b.bill_date, 'YYYY-MM'),
    EXTRACT(YEAR FROM b.bill_date),
    EXTRACT(MONTH FROM b.bill_date)
WITH DATA;

-- Unique index required to allow REFRESH MATERIALIZED VIEW CONCURRENTLY
CREATE UNIQUE INDEX IF NOT EXISTS uq_idx_mv_monthly_kpis ON mv_monthly_executive_kpis (fiscal_month);


-- --------------------------------------------------------------------------------
-- 2. MATERIALIZED VIEW: ROOM PERFORMANCE & TURNOVER EFFICIENCY
-- --------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS mv_room_performance_matrix CASCADE;
CREATE MATERIALIZED VIEW mv_room_performance_matrix AS
SELECT 
    rm.room_id,
    rm.room_number,
    rm.room_type,
    rm.price_per_night,
    COUNT(r.reservation_id) AS lifetime_bookings_count,
    COALESCE(SUM(r.check_out - r.check_in), 0) AS total_nights_occupied,
    ROUND(COALESCE(SUM(b.room_charge), 0.00), 2) AS total_room_revenue_generated,
    COUNT(ht.task_id) AS total_housekeeping_cleanings,
    ROUND(COALESCE(AVG(
        EXTRACT(EPOCH FROM (ht.completed_at - ht.created_at)) / 3600.0
    ), 0.00), 2) AS avg_cleaning_turnaround_hours
FROM rooms rm
LEFT JOIN reservations r ON rm.room_id = r.room_id AND r.status IN ('Checked-out', 'Checked-in')
LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
LEFT JOIN housekeeping_tasks ht ON rm.room_id = ht.room_id AND ht.status = 'Completed'
GROUP BY rm.room_id, rm.room_number, rm.room_type, rm.price_per_night
WITH DATA;

CREATE UNIQUE INDEX IF NOT EXISTS uq_idx_mv_room_perf ON mv_room_performance_matrix (room_id);


-- --------------------------------------------------------------------------------
-- 3. MATERIALIZED VIEW: GUEST LOYALTY & REPEAT ENGAGEMENT LEADERBOARD
-- --------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS mv_customer_loyalty_leaderboard CASCADE;
CREATE MATERIALIZED VIEW mv_customer_loyalty_leaderboard AS
SELECT 
    c.customer_id,
    c.name,
    c.email,
    COUNT(DISTINCT r.reservation_id) AS completed_trips,
    COALESCE(SUM(r.check_out - r.check_in), 0) AS total_nights_stayed,
    ROUND(COALESCE(SUM(b.total_amount), 0.00), 2) AS total_lifetime_spend,
    MAX(r.check_out) AS last_stay_date,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(b.total_amount), 0.00) DESC) AS rank_by_revenue
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id AND r.status = 'Checked-out'
LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY c.customer_id, c.name, c.email
WITH DATA;

CREATE UNIQUE INDEX IF NOT EXISTS uq_idx_mv_cust_loyalty ON mv_customer_loyalty_leaderboard (customer_id);


-- --------------------------------------------------------------------------------
-- 4. CONCURRENT REFRESH PROCEDURE (ZERO-DOWNTIME REFRESH)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_refresh_reporting_datamart()
LANGUAGE plpgsql AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed NUMERIC;
BEGIN
    v_start_time := clock_timestamp();

    -- Concurrent refresh avoids blocking concurrent SELECT queries on the dashboard
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_monthly_executive_kpis;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_room_performance_matrix;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_customer_loyalty_leaderboard;

    v_end_time := clock_timestamp();
    v_elapsed := ROUND((EXTRACT(EPOCH FROM (v_end_time - v_start_time)) * 1000)::NUMERIC, 2);

    INSERT INTO datamart_refresh_logs (view_name, duration_ms, status, message)
    VALUES (
        'ALL_DATAMART_MATERIALIZED_VIEWS', 
        v_elapsed, 
        'Success', 
        'Concurrent refresh of all executive views completed in ' || v_elapsed || ' ms.'
    );

    RAISE NOTICE 'Executive datamart refreshed successfully in % ms.', v_elapsed;
END;
$$;
