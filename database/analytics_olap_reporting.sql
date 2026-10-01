-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED ANALYTICS, OLAP & BI REPORTING
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Window Functions (Ranking, Offset/Lead-Lag, Running Aggregations, Frame Specs)
-- 2. Multidimensional OLAP Aggregations (ROLLUP, CUBE, GROUPING SETS)
-- 3. Hospitality Key Performance Indicators (RevPAR, ADR, Occupancy Rate)
-- 4. Customer RFM (Recency, Frequency, Monetary) Segmentation
-- 5. Cross-Tabulation & Monthly Revenue Matrices
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: WINDOW FUNCTIONS & RANKING ALGORITHMS
-- --------------------------------------------------------------------------------

-- 1.1 Customer Spending Quartiles & Deciles using NTILE()
-- Classifies customers into 4 spending tiers (Quartile 1 = Top Spenders, Quartile 4 = Budget)
SELECT 
    c.customer_id,
    c.name AS guest_name,
    c.email,
    COUNT(r.reservation_id) AS total_stays,
    COALESCE(SUM(b.total_amount), 0.00) AS total_spend,
    NTILE(4) OVER (ORDER BY COALESCE(SUM(b.total_amount), 0) DESC) AS spending_quartile,
    PERCENT_RANK() OVER (ORDER BY COALESCE(SUM(b.total_amount), 0)) AS spend_percent_rank,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY COALESCE(SUM(b.total_amount), 0) DESC) = 1 THEN 'Platinum Tier'
        WHEN NTILE(4) OVER (ORDER BY COALESCE(SUM(b.total_amount), 0) DESC) = 2 THEN 'Gold Tier'
        WHEN NTILE(4) OVER (ORDER BY COALESCE(SUM(b.total_amount), 0) DESC) = 3 THEN 'Silver Tier'
        ELSE 'Bronze Tier'
    END AS computed_loyalty_tier
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id
LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY c.customer_id, c.name, c.email
ORDER BY total_spend DESC;

-- 1.2 Room Category Rank by Total Generated Revenue (DENSE_RANK & ROW_NUMBER)
SELECT 
    rm.room_type,
    rm.room_number,
    COUNT(r.reservation_id) AS times_booked,
    COALESCE(SUM(b.room_charge), 0) AS total_room_revenue,
    ROW_NUMBER() OVER (PARTITION BY rm.room_type ORDER BY COALESCE(SUM(b.room_charge), 0) DESC) AS rank_within_type,
    DENSE_RANK() OVER (ORDER BY COALESCE(SUM(b.room_charge), 0) DESC) AS overall_hotel_rank
FROM rooms rm
LEFT JOIN reservations r ON rm.room_id = r.room_id
LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY rm.room_type, rm.room_number
ORDER BY rm.room_type, rank_within_type;

-- 1.3 Day-over-Day Revenue Variance & Growth Momentum using LAG() and LEAD()
WITH daily_revenue AS (
    SELECT 
        DATE(bill_date) AS txn_date,
        COUNT(bill_id) AS invoices_settled,
        SUM(total_amount) AS revenue
    FROM bills
    WHERE payment_status = 'Paid'
    GROUP BY DATE(bill_date)
)
SELECT 
    txn_date,
    revenue AS current_day_revenue,
    LAG(revenue, 1) OVER (ORDER BY txn_date) AS previous_day_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY txn_date) AS absolute_growth,
    ROUND(
        CASE 
            WHEN LAG(revenue, 1) OVER (ORDER BY txn_date) IS NULL OR LAG(revenue, 1) OVER (ORDER BY txn_date) = 0 THEN 0.00
            ELSE ((revenue - LAG(revenue, 1) OVER (ORDER BY txn_date)) / LAG(revenue, 1) OVER (ORDER BY txn_date)) * 100.0
        END, 2
    ) AS pct_growth_vs_yesterday,
    LEAD(revenue, 1) OVER (ORDER BY txn_date) AS next_day_revenue_forecast
FROM daily_revenue
ORDER BY txn_date ASC;

-- 1.4 Rolling 7-Day Moving Average & Cumulative Running Totals (Window Framing Specification)
SELECT 
    DATE(b.bill_date) AS settlement_date,
    SUM(b.total_amount) AS daily_total,
    -- Running Cumulative Total from Day 1 to Current Day
    SUM(SUM(b.total_amount)) OVER (
        ORDER BY DATE(b.bill_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_running_revenue,
    -- 7-Day Centered/Trailing Moving Average
    ROUND(AVG(SUM(b.total_amount)) OVER (
        ORDER BY DATE(b.bill_date)
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7day_avg_revenue
FROM bills b
WHERE b.payment_status = 'Paid'
GROUP BY DATE(b.bill_date)
ORDER BY settlement_date ASC;


-- --------------------------------------------------------------------------------
-- SECTION 2: MULTIDIMENSIONAL OLAP AGGREGATIONS
-- --------------------------------------------------------------------------------

-- 2.1 Hierarchical Rollup: Year -> Quarter -> Month Revenue Drilldown (ROLLUP)
SELECT 
    COALESCE(TO_CHAR(b.bill_date, 'YYYY'), 'All Years') AS report_year,
    COALESCE('Q' || TO_CHAR(b.bill_date, 'Q'), 'All Quarters') AS report_quarter,
    COALESCE(TO_CHAR(b.bill_date, 'Month'), 'All Months') AS report_month,
    COUNT(b.bill_id) AS total_invoices,
    SUM(b.room_charge) AS subtotal_rooms,
    SUM(b.service_charge) AS subtotal_services,
    SUM(b.tax) AS subtotal_tax,
    SUM(b.total_amount) AS grand_total_revenue
FROM bills b
WHERE b.payment_status = 'Paid'
GROUP BY ROLLUP (
    TO_CHAR(b.bill_date, 'YYYY'),
    'Q' || TO_CHAR(b.bill_date, 'Q'),
    TO_CHAR(b.bill_date, 'Month')
)
ORDER BY report_year, report_quarter, report_month;

-- 2.2 Cross-Dimensional Analysis: Room Category x Payment Status Matrix (CUBE)
SELECT 
    COALESCE(rm.room_type, 'TOTAL (All Categories)') AS room_category,
    COALESCE(b.payment_status, 'TOTAL (All Statuses)') AS payment_state,
    COUNT(DISTINCT r.reservation_id) AS reservation_count,
    COALESCE(SUM(b.total_amount), 0.00) AS gross_billed_amount,
    ROUND(COALESCE(AVG(b.total_amount), 0.00), 2) AS avg_invoice_size
FROM rooms rm
JOIN reservations r ON rm.room_id = r.room_id
LEFT JOIN bills b ON r.reservation_id = b.reservation_id
GROUP BY CUBE (rm.room_type, b.payment_status)
ORDER BY rm.room_type NULLS LAST, b.payment_status NULLS LAST;

-- 2.3 Custom Targeted Management Reporting using GROUPING SETS
-- Produces three distinct aggregation levels in a single query execution pass:
-- Level 1: Room Type summary
-- Level 2: Service Type summary
-- Level 3: Grand Total
SELECT 
    rm.room_type,
    s.service_name,
    COUNT(DISTINCT r.reservation_id) AS total_bookings,
    COUNT(sr.request_id) AS total_service_requests,
    COALESCE(SUM(sr.quantity * s.price), 0.00) AS service_revenue_generated
FROM rooms rm
CROSS JOIN services s
LEFT JOIN reservations r ON rm.room_id = r.room_id
LEFT JOIN service_requests sr ON r.reservation_id = sr.reservation_id AND sr.service_id = s.service_id
GROUP BY GROUPING SETS (
    (rm.room_type),
    (s.service_name),
    ()
)
ORDER BY rm.room_type NULLS LAST, s.service_name NULLS LAST;


-- --------------------------------------------------------------------------------
-- SECTION 3: HOSPITALITY INDUSTRY METRICS (ADR, RevPAR, OCCUPANCY RATE)
-- --------------------------------------------------------------------------------

-- 3.1 Industry KPIs: Average Daily Rate (ADR) and Revenue Per Available Room (RevPAR)
CREATE OR REPLACE VIEW vw_hospitality_kpis AS
WITH hotel_inventory AS (
    SELECT COUNT(*) AS total_available_inventory FROM rooms WHERE is_active = TRUE
),
daily_stay_aggregates AS (
    SELECT 
        d.calendar_date,
        COUNT(DISTINCT r.reservation_id) AS occupied_rooms_count,
        COALESCE(SUM(rm.price_per_night), 0.00) AS daily_room_revenue
    FROM (
        -- Generate date series for the last 30 days
        SELECT CURRENT_DATE - s AS calendar_date 
        FROM generate_series(0, 30) AS s
    ) d
    LEFT JOIN reservations r 
        ON d.calendar_date >= r.check_in 
       AND d.calendar_date < r.check_out 
       AND r.status IN ('Checked-in', 'Confirmed', 'Booked')
    LEFT JOIN rooms rm ON r.room_id = rm.room_id
    GROUP BY d.calendar_date
)
SELECT 
    dsa.calendar_date,
    hi.total_available_inventory,
    dsa.occupied_rooms_count,
    ROUND((dsa.occupied_rooms_count::NUMERIC / NULLIF(hi.total_available_inventory, 0)) * 100.0, 2) AS occupancy_rate_pct,
    dsa.daily_room_revenue,
    -- ADR: Average Daily Rate = Total Room Revenue / Occupied Rooms
    ROUND(COALESCE(dsa.daily_room_revenue / NULLIF(dsa.occupied_rooms_count, 0), 0.00), 2) AS adr_average_daily_rate,
    -- RevPAR: Revenue Per Available Room = Total Room Revenue / Total Available Inventory
    ROUND(COALESCE(dsa.daily_room_revenue / NULLIF(hi.total_available_inventory, 0), 0.00), 2) AS revpar_revenue_per_available_room
FROM daily_stay_aggregates dsa
CROSS JOIN hotel_inventory hi
ORDER BY dsa.calendar_date DESC;


-- --------------------------------------------------------------------------------
-- SECTION 4: CUSTOMER RFM (RECENCY, FREQUENCY, MONETARY) SEGMENTATION
-- --------------------------------------------------------------------------------

-- 4.1 Enterprise RFM Scoring Engine for Marketing & Retention
CREATE OR REPLACE VIEW vw_customer_rfm_analysis AS
WITH rfm_raw AS (
    SELECT 
        c.customer_id,
        c.name,
        c.email,
        -- Recency: Days since last completed checkout
        COALESCE(CURRENT_DATE - MAX(r.check_out), 999) AS days_since_last_stay,
        -- Frequency: Total completed reservations
        COUNT(DISTINCT r.reservation_id) AS frequency_stays,
        -- Monetary: Total revenue collected from guest
        COALESCE(SUM(b.total_amount), 0.00) AS monetary_total
    FROM customers c
    LEFT JOIN reservations r ON c.customer_id = r.customer_id AND r.status IN ('Checked-out', 'Confirmed')
    LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
    GROUP BY c.customer_id, c.name, c.email
),
rfm_scores AS (
    SELECT 
        customer_id,
        name,
        email,
        days_since_last_stay,
        frequency_stays,
        monetary_total,
        -- Recency Score (1-5): 5 is most recent
        NTILE(5) OVER (ORDER BY days_since_last_stay DESC) AS r_score,
        -- Frequency Score (1-5): 5 is most frequent
        NTILE(5) OVER (ORDER BY frequency_stays ASC) AS f_score,
        -- Monetary Score (1-5): 5 is highest spend
        NTILE(5) OVER (ORDER BY monetary_total ASC) AS m_score
    FROM rfm_raw
)
SELECT 
    customer_id,
    name,
    email,
    days_since_last_stay,
    frequency_stays,
    monetary_total,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS composite_rfm_score,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions / VIP Guests'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal High Value'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Promising New Guests'
        WHEN r_score <= 2 AND f_score >= 4 THEN 'At-Risk Loyalists (Need Retention Email)'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Hibernating / Lost'
        ELSE 'Potential Loyalist'
    END AS customer_segment
FROM rfm_scores
ORDER BY composite_rfm_score DESC, monetary_total DESC;
