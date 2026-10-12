-- ============================================================================
-- Crowne Plaza Hotel Management System - Multi-Dimensional Analytical Cubes
-- Module: GROUP BY CUBE, ROLLUP, GROUPING SETS, and Analytical SQL Windowing
-- Purpose: Executive Hospitality Analytics, Revenue Management & Cohort Modeling
-- ============================================================================

-- 1. Multi-Dimensional Revenue Cube (Room Type x Floor x Month)
CREATE OR REPLACE VIEW public.vw_analytical_revenue_cube AS
SELECT 
    COALESCE(rm.room_type, 'ALL ROOM TYPES') AS dimension_room_type,
    COALESCE(CAST(CASE WHEN rm.room_number LIKE '1%' THEN 1 ELSE 2 END AS VARCHAR), 'ALL FLOORS') AS dimension_floor,
    COALESCE(TO_CHAR(res.check_in, 'YYYY-MM'), 'ALL MONTHS') AS dimension_period,
    GROUPING(rm.room_type) AS grp_room_type,
    GROUPING(CASE WHEN rm.room_number LIKE '1%' THEN 1 ELSE 2 END) AS grp_floor,
    GROUPING(TO_CHAR(res.check_in, 'YYYY-MM')) AS grp_period,
    COUNT(res.reservation_id) AS total_bookings_count,
    SUM(res.check_out - res.check_in) AS total_nights_sold,
    SUM(fn_calculate_stay_cost(res.room_id, res.check_in, res.check_out)) AS gross_tariff_revenue,
    ROUND(AVG(fn_calculate_stay_cost(res.room_id, res.check_in, res.check_out) / (res.check_out - res.check_in)), 2) AS adr_realized
FROM public.reservations res
JOIN public.rooms rm ON res.room_id = rm.room_id
WHERE res.status IN ('Confirmed', 'Checked-in', 'Checked-out')
GROUP BY CUBE (
    rm.room_type,
    CASE WHEN rm.room_number LIKE '1%' THEN 1 ELSE 2 END,
    TO_CHAR(res.check_in, 'YYYY-MM')
)
ORDER BY grp_room_type, grp_floor, grp_period;

-- 2. Hierarchical Rollup: Year -> Quarter -> Month -> Daily Stay Volume
CREATE OR REPLACE VIEW public.vw_hierarchical_stay_rollup AS
SELECT 
    COALESCE(TO_CHAR(check_in, 'YYYY'), 'TOTAL ALL YEARS') AS report_year,
    COALESCE('Q' || TO_CHAR(check_in, 'Q'), 'TOTAL QUARTER') AS report_quarter,
    COALESCE(TO_CHAR(check_in, 'Month'), 'TOTAL MONTH') AS report_month,
    COUNT(reservation_id) AS total_reservations,
    SUM(check_out - check_in) AS aggregate_room_nights,
    SUM(fn_calculate_stay_cost(room_id, check_in, check_out)) AS aggregate_revenue
FROM public.reservations
WHERE status <> 'Cancelled'
GROUP BY ROLLUP (
    TO_CHAR(check_in, 'YYYY'),
    'Q' || TO_CHAR(check_in, 'Q'),
    TO_CHAR(check_in, 'Month')
);

-- 3. Customer Lifetime Value (CLV) & RFM Segmentation Matrix
CREATE OR REPLACE VIEW public.vw_guest_rfm_segmentation AS
WITH guest_aggregates AS (
    SELECT 
        c.customer_id,
        c.name AS guest_name,
        c.email,
        COUNT(r.reservation_id) AS total_stays,
        MAX(r.check_in) AS last_stay_date,
        CURRENT_DATE - MAX(r.check_in) AS days_since_last_visit,
        COALESCE(SUM(fn_calculate_stay_cost(r.room_id, r.check_in, r.check_out)), 0) AS total_spend
    FROM public.customers c
    LEFT JOIN public.reservations r ON c.customer_id = r.customer_id AND r.status <> 'Cancelled'
    GROUP BY c.customer_id, c.name, c.email
),
rfm_ranked AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY days_since_last_visit DESC) AS r_score, -- Recent visitors get higher score
        NTILE(4) OVER (ORDER BY total_stays ASC) AS f_score,            -- Frequent visitors get higher score
        NTILE(4) OVER (ORDER BY total_spend ASC) AS m_score             -- High spenders get higher score
    FROM guest_aggregates
)
SELECT 
    customer_id,
    guest_name,
    email,
    total_stays,
    last_stay_date,
    days_since_last_visit,
    total_spend,
    r_score, f_score, m_score,
    CASE 
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Crown Platinum VIP'
        WHEN f_score >= 3 AND m_score >= 2 THEN 'Loyal High-Value Regular'
        WHEN r_score >= 3 AND f_score = 1 THEN 'Promising New Guest'
        WHEN r_score = 1 AND f_score >= 2 THEN 'At-Risk Lapsed Guest'
        ELSE 'Standard Guest'
    END AS guest_relationship_tier
FROM rfm_ranked;
