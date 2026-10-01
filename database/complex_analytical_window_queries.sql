-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED BUSINESS INTELLIGENCE & WINDOW ANALYTICS
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Guest Lifetime Value & RFM Behavioral Clustering
-- 2. Basket Analysis (Market Basket Analysis in SQL for Service Cross-Selling)
-- 3. Room Turnaround Efficiency & Housekeeping Productivity
-- 4. Revenue Leakage & Outstanding Folio Aging Analysis (Aging Buckets)
-- 5. Seasonality Multipliers & Predictive Occupancy Curves
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: MARKET BASKET ANALYSIS (SERVICE CROSS-SELL CO-OCCURRENCE)
-- --------------------------------------------------------------------------------

-- Identifies which hotel services are most frequently ordered together by the same guest
WITH service_pairs AS (
    SELECT 
        sr1.service_id AS service_a_id,
        s1.service_name AS service_a_name,
        sr2.service_id AS service_b_id,
        s2.service_name AS service_b_name,
        sr1.reservation_id
    FROM service_requests sr1
    JOIN service_requests sr2 
        ON sr1.reservation_id = sr2.reservation_id 
       AND sr1.service_id < sr2.service_id -- Prevent mirror pairs (A,B and B,A) and self-pairs (A,A)
    JOIN services s1 ON sr1.service_id = s1.service_id
    JOIN services s2 ON sr2.service_id = s2.service_id
)
SELECT 
    service_a_name,
    service_b_name,
    COUNT(DISTINCT reservation_id) AS co_occurrence_count,
    ROUND(
        (COUNT(DISTINCT reservation_id)::NUMERIC / 
        (SELECT COUNT(DISTINCT reservation_id) FROM service_requests)) * 100.0, 
        2
    ) AS support_percentage
FROM service_pairs
GROUP BY service_a_name, service_b_name
ORDER BY co_occurrence_count DESC;


-- --------------------------------------------------------------------------------
-- SECTION 2: ACCOUNTS RECEIVABLE AGING ANALYSIS (AGING BUCKETS)
-- --------------------------------------------------------------------------------

-- Classifies unpaid guest invoices into aging brackets: 0-30, 31-60, 61-90, 90+ days
SELECT 
    c.customer_id,
    c.name AS guest_name,
    c.phone,
    b.bill_id,
    b.total_amount,
    b.bill_date,
    (CURRENT_DATE - b.bill_date::DATE) AS days_outstanding,
    CASE 
        WHEN (CURRENT_DATE - b.bill_date::DATE) <= 30 THEN 'Current (0-30 Days)'
        WHEN (CURRENT_DATE - b.bill_date::DATE) BETWEEN 31 AND 60 THEN 'Aging (31-60 Days)'
        WHEN (CURRENT_DATE - b.bill_date::DATE) BETWEEN 61 AND 90 THEN 'Overdue (61-90 Days)'
        ELSE 'Severely Delinquent (90+ Days)'
    END AS aging_bucket,
    SUM(b.total_amount) OVER (
        PARTITION BY c.customer_id 
        ORDER BY b.bill_date
    ) AS customer_cumulative_outstanding
FROM bills b
JOIN reservations r ON b.reservation_id = r.reservation_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE b.payment_status = 'Pending'
ORDER BY days_outstanding DESC;


-- --------------------------------------------------------------------------------
-- SECTION 3: STAFF CLEANING PRODUCTIVITY & SPEED ANALYTICS
-- --------------------------------------------------------------------------------

SELECT 
    rm.room_type,
    COUNT(ht.task_id) AS total_cleaning_runs,
    ROUND(AVG(EXTRACT(EPOCH FROM (ht.completed_at - ht.created_at)) / 60.0), 1) AS avg_turnaround_minutes,
    ROUND(MIN(EXTRACT(EPOCH FROM (ht.completed_at - ht.created_at)) / 60.0), 1) AS fastest_turnaround_minutes,
    ROUND(MAX(EXTRACT(EPOCH FROM (ht.completed_at - ht.created_at)) / 60.0), 1) AS longest_turnaround_minutes,
    -- Percentile Ranking of turnaround speed across room types
    ROUND(
        PERCENT_RANK() OVER (ORDER BY AVG(EXTRACT(EPOCH FROM (ht.completed_at - ht.created_at))))::NUMERIC, 
        2
    ) AS turnaround_speed_efficiency_rank
FROM housekeeping_tasks ht
JOIN rooms rm ON ht.room_id = rm.room_id
WHERE ht.status = 'Completed' AND ht.completed_at IS NOT NULL
GROUP BY rm.room_type;


-- --------------------------------------------------------------------------------
-- SECTION 4: SEASONAL REVENUE VARIANCE & PEAK DETECTION
-- --------------------------------------------------------------------------------

WITH monthly_totals AS (
    SELECT 
        EXTRACT(MONTH FROM b.bill_date)::INT AS month_num,
        TO_CHAR(b.bill_date, 'Mon') AS month_name,
        SUM(b.total_amount) AS monthly_revenue,
        COUNT(b.bill_id) AS total_bookings
    FROM bills b
    WHERE b.payment_status = 'Paid'
    GROUP BY EXTRACT(MONTH FROM b.bill_date), TO_CHAR(b.bill_date, 'Mon')
),
hotel_annual_average AS (
    SELECT AVG(monthly_revenue) AS avg_monthly_baseline FROM monthly_totals
)
SELECT 
    mt.month_num,
    mt.month_name,
    mt.monthly_revenue,
    mt.total_bookings,
    ROUND(haa.avg_monthly_baseline, 2) AS benchmark_average,
    ROUND(mt.monthly_revenue - haa.avg_monthly_baseline, 2) AS variance_from_benchmark,
    CASE 
        WHEN mt.monthly_revenue >= haa.avg_monthly_baseline * 1.25 THEN 'High Peak Season'
        WHEN mt.monthly_revenue <= haa.avg_monthly_baseline * 0.75 THEN 'Low Off-Peak Season'
        ELSE 'Normal Shoulder Season'
    END AS seasonal_classification
FROM monthly_totals mt
CROSS JOIN hotel_annual_average haa
ORDER BY mt.month_num;
