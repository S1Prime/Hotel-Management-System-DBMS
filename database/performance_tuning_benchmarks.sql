-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — QUERY OPTIMIZATION, INDEXING & BENCHMARKING
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Partial & Filtered Indexes (Index Size & Write Reduction)
-- 2. Covering Indexes with INCLUDE Clause (Zero-Heap Index-Only Scans)
-- 3. Functional / Expression-Based Indexes (Case-Insensitive Lookups)
-- 4. Benchmark Harness: Sequential Scan vs Bitmap Index Scan vs Index-Only Scan
-- 5. Buffer Cache Hit Ratio & Index Utilization Diagnostics (pg_stat system views)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: ADVANCED INDEXING ARCHITECTURE
-- --------------------------------------------------------------------------------

-- 1.1 Partial Index: Only index pending bills (frequently queried by cashiers)
-- Drastically reduces B-Tree depth and RAM footprint by omitting settled 'Paid' bills
DROP INDEX IF EXISTS idx_bills_pending_partial;
CREATE INDEX idx_bills_pending_partial 
    ON bills (reservation_id, total_amount) 
    WHERE payment_status = 'Pending';

-- 1.2 Partial Index: Active Room Inventory
DROP INDEX IF EXISTS idx_rooms_active_available;
CREATE INDEX idx_rooms_active_available 
    ON rooms (room_type, price_per_night) 
    WHERE is_active = TRUE AND status = 'Available';

-- 1.3 Functional / Expression Index: Fast case-insensitive customer email lookups
DROP INDEX IF EXISTS idx_customers_email_lower;
CREATE INDEX idx_customers_email_lower 
    ON customers (LOWER(email));

-- 1.4 Covering Index with INCLUDE Clause (Index-Only Scan)
-- Enables answering reservation verification queries strictly from RAM index pages without visiting table heap
DROP INDEX IF EXISTS idx_reservations_covering_dates;
CREATE INDEX idx_reservations_covering_dates 
    ON reservations (room_id, check_in, check_out) 
    INCLUDE (customer_id, status);

-- 1.5 Composite B-Tree Index for Date-Range Overlap Lookups
DROP INDEX IF EXISTS idx_reservations_date_range;
CREATE INDEX idx_reservations_date_range 
    ON reservations (check_in, check_out, status);


-- --------------------------------------------------------------------------------
-- SECTION 2: EXPLAIN (ANALYZE, BUFFERS) BENCHMARK HARNESS
-- --------------------------------------------------------------------------------

-- Benchmark 1: Functional Email Lookup (Forces Index Scan on idx_customers_email_lower)
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT customer_id, name, phone
FROM customers
WHERE LOWER(email) = 'alexander.smith_1@gmail.com';

-- Benchmark 2: Covering Index-Only Scan on Reservations
-- Note: Check execution plan in pgAdmin (F7) to confirm 'Index Only Scan' and Heap Fetches = 0
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT room_id, check_in, check_out, customer_id, status
FROM reservations
WHERE room_id = 5 
  AND check_in >= '2026-01-01' 
  AND check_out <= '2026-12-31';

-- Benchmark 3: Partial Index Scan for Outstanding Accounts Receivable
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT reservation_id, total_amount
FROM bills
WHERE payment_status = 'Pending' AND total_amount > 200.00;


-- --------------------------------------------------------------------------------
-- SECTION 3: SYSTEM PERFORMANCE DIAGNOSTICS & BUFFER HIT RATIO
-- --------------------------------------------------------------------------------

-- 3.1 Database Buffer Cache Hit Ratio (Should be > 99% in production)
SELECT 
    datname AS database_name,
    blks_read AS disk_blocks_read,
    blks_hit AS ram_blocks_hit,
    ROUND(
        (blks_hit::NUMERIC / NULLIF(blks_hit + blks_read, 0)) * 100.0, 
        3
    ) AS cache_hit_percentage
FROM pg_stat_database
WHERE datname = current_database();

-- 3.2 Index Usage Efficiency & Scan Counters Across User Tables
SELECT 
    relname AS table_name,
    seq_scan AS sequential_scans,
    seq_tup_read AS tuples_read_via_seq_scan,
    idx_scan AS index_scans,
    idx_tup_fetch AS tuples_fetched_via_index,
    ROUND(
        (idx_scan::NUMERIC / NULLIF(idx_scan + seq_scan, 0)) * 100.0, 
        2
    ) AS index_scan_ratio_pct
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- 3.3 Physical Disk Footprint of Tables vs Indexes (Storage Sizing)
SELECT 
    c.relname AS object_name,
    pg_size_pretty(pg_relation_size(c.oid)) AS disk_size,
    CASE c.relkind
        WHEN 'r' THEN 'Table Heap'
        WHEN 'i' THEN 'B-Tree Index'
        WHEN 'm' THEN 'Materialized View'
        WHEN 'p' THEN 'Partitioned Table'
        ELSE 'Other'
    END AS object_type
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
ORDER BY pg_relation_size(c.oid) DESC
LIMIT 20;
