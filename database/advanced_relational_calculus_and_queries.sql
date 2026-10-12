-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — RELATIONAL CALCULUS, PIVOTS & GRAPH TRAVERSAL
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Tuple Relational Calculus (TRC) & Domain Relational Calculus (DRC) in SQL
-- 2. Dynamic Matrix Pivoting (Cross-Tabulation of Room Categories across Months)
-- 3. Dynamic Unpivoting (Normalizing Multi-Column Financial Ledgers)
-- 4. Temporal Range Window Framing (RANGE BETWEEN INTERVAL ... PRECEDING)
-- 5. Recursive Graph Adjacency: Connecting Adjoining Family Suites
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: TUPLE & DOMAIN RELATIONAL CALCULUS TRANSLATIONS
-- --------------------------------------------------------------------------------

-- 1.1 TRC Expression: { t | t ∈ customers ∧ ∃r ∈ reservations (r.customer_id = t.customer_id ∧ r.status = 'Confirmed') }
-- English: "Retrieve all customers who possess at least one confirmed reservation."
SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM reservations r 
    WHERE r.customer_id = c.customer_id AND r.status = 'Confirmed'
);

-- 1.2 DRC Expression: { <name, email> | ∃cid, phone, pwd, ts ( <cid, name, email, phone, pwd, ts> ∈ customers ∧ 
--       ¬ ∃rid, r_cid, r_rid, in, out, g, req, bts, st ( <rid, r_cid, r_rid, in, out, g, req, bts, st> ∈ reservations ∧ r_cid = cid ) ) }
-- English: "Find the name and email of registered customers who have NEVER made a booking."
SELECT c.name, c.email
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM reservations r 
    WHERE r.customer_id = c.customer_id
);

-- 1.3 Universal Quantification (∀):
-- English: "Find rooms that have been booked by EVERY customer in the database."
-- In SQL / Relational Calculus: Using Double Negation (NOT EXISTS ... NOT EXISTS)
SELECT rm.room_id, rm.room_number, rm.room_type
FROM rooms rm
WHERE NOT EXISTS (
    SELECT c.customer_id 
    FROM customers c
    WHERE NOT EXISTS (
        SELECT 1 
        FROM reservations r 
        WHERE r.customer_id = c.customer_id AND r.room_id = rm.room_id
    )
);


-- --------------------------------------------------------------------------------
-- SECTION 2: CROSS-TABULATION MATRIX PIVOT (ROOM REVENUE ACROSS MONTHS)
-- --------------------------------------------------------------------------------

-- Pivots monthly revenues into columns (Jan, Feb, Mar, Apr, etc.) without requiring external extensions
SELECT 
    rm.room_type,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 1), 0.00), 2) AS jan_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 2), 0.00), 2) AS feb_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 3), 0.00), 2) AS mar_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 4), 0.00), 2) AS apr_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 5), 0.00), 2) AS may_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 6), 0.00), 2) AS jun_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 7), 0.00), 2) AS jul_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 8), 0.00), 2) AS aug_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 9), 0.00), 2) AS sep_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 10), 0.00), 2) AS oct_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 11), 0.00), 2) AS nov_revenue,
    ROUND(COALESCE(SUM(b.total_amount) FILTER (WHERE EXTRACT(MONTH FROM b.bill_date) = 12), 0.00), 2) AS dec_revenue,
    ROUND(COALESCE(SUM(b.total_amount), 0.00), 2) AS annual_category_total
FROM rooms rm
JOIN reservations r ON rm.room_id = r.room_id
LEFT JOIN bills b ON r.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY rm.room_type
ORDER BY annual_category_total DESC;


-- --------------------------------------------------------------------------------
-- SECTION 3: REVERSE UNPIVOT (NORMALIZING DENORMALIZED BILL COMPONENTS)
-- --------------------------------------------------------------------------------

-- Transforms horizontal bill columns (room_charge, service_charge, tax) into normalized vertical line items
SELECT 
    b.bill_id,
    b.reservation_id,
    charge_item.component_type,
    charge_item.amount
FROM bills b
CROSS JOIN LATERAL (
    VALUES 
        ('Base Accommodation', b.room_charge),
        ('Ancillary Services', b.service_charge),
        ('Statutory Tax (GST)', b.tax)
) AS charge_item(component_type, amount)
WHERE charge_item.amount > 0
ORDER BY b.bill_id, charge_item.amount DESC;


-- --------------------------------------------------------------------------------
-- SECTION 4: TEMPORAL RANGE WINDOW FRAMING (INTERVAL-BASED MOVING TOTALS)
-- --------------------------------------------------------------------------------

-- Calculates 3-day preceding rolling average without relying on fixed row counts (handles skipped dates)
SELECT 
    b.bill_date::DATE AS invoice_day,
    SUM(b.total_amount) AS daily_collected,
    ROUND(AVG(SUM(b.total_amount)) OVER (
        ORDER BY b.bill_date::DATE
        RANGE BETWEEN INTERVAL '3 days' PRECEDING AND CURRENT ROW
    ), 2) AS trailing_3day_range_moving_avg
FROM bills b
WHERE b.payment_status = 'Paid'
GROUP BY b.bill_date::DATE
ORDER BY invoice_day ASC;


-- --------------------------------------------------------------------------------
-- SECTION 5: RECURSIVE ADJACENT ROOM ALLOCATION (GRAPH ADJACENCY PATHS)
-- --------------------------------------------------------------------------------

-- Table: Physical Room Adjacency Graph (Connects interconnected/adjoining doors)
CREATE TABLE IF NOT EXISTS room_adjacency_graph (
    source_room_id INT REFERENCES rooms(room_id) ON DELETE CASCADE,
    adjacent_room_id INT REFERENCES rooms(room_id) ON DELETE CASCADE,
    has_connecting_door BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (source_room_id, adjacent_room_id)
);

-- Seed adjoining rooms on same floor (e.g. 101 <-> 102, 102 <-> 103)
INSERT INTO room_adjacency_graph (source_room_id, adjacent_room_id, has_connecting_door)
SELECT r1.room_id, r2.room_id, TRUE
FROM rooms r1
JOIN rooms r2 ON LEFT(r1.room_number, 1) = LEFT(r2.room_number, 1)
             AND ABS(RIGHT(r1.room_number, 2)::INT - RIGHT(r2.room_number, 2)::INT) = 1
ON CONFLICT DO NOTHING;

-- Recursive Query: Find multi-room interconnected clusters of 3+ vacant adjoining rooms for VIP delegations
WITH RECURSIVE room_clusters AS (
    -- Anchor: Vacant available starting room
    SELECT 
        rm.room_id AS initial_room_id,
        rm.room_id AS current_room_id,
        rm.room_number::TEXT AS cluster_path,
        1 AS cluster_depth
    FROM rooms rm
    WHERE rm.status = 'Available' AND rm.is_active = TRUE

    UNION ALL

    -- Recursive Step: Follow connecting doors to next available adjoining room
    SELECT 
        rc.initial_room_id,
        rag.adjacent_room_id,
        rc.cluster_path || ' ↔ ' || rm_next.room_number,
        rc.cluster_depth + 1
    FROM room_clusters rc
    JOIN room_adjacency_graph rag ON rc.current_room_id = rag.source_room_id
    JOIN rooms rm_next ON rag.adjacent_room_id = rm_next.room_id
    WHERE rm_next.status = 'Available'
      AND rc.cluster_depth < 4
      AND POSITION(rm_next.room_number IN rc.cluster_path) = 0
)
SELECT 
    cluster_path AS connected_room_suite,
    cluster_depth AS total_connected_rooms
FROM room_clusters
WHERE cluster_depth >= 2
ORDER BY total_connected_rooms DESC;
