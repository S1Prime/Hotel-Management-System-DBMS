-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — QUERY OPTIMIZER BENCHMARK & PLAN ANALYSIS
-- PostgreSQL Cost-Based Optimizer (CBO), Execution Plans & Heap Inspections
-- ================================================================================
-- Focus: Deep analysis of query execution plans (EXPLAIN ANALYZE, BUFFERS, COSTS),
-- Index-Only Scans vs Seq Scans, Join Algorithms (Hash vs Merge vs Nested Loop).
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. OPTIMIZER BENCHMARK: OVERLAPPING DATES RESERVATION CHECK
-- --------------------------------------------------------------------------------
-- Plan Inspection: Verifies that the composite index 'idx_reservations_room_dates'
-- performs an efficient Index Scan rather than a Sequential Scan.
EXPLAIN (ANALYZE, BUFFERS, COSTS, VERBOSE)
SELECT reservation_id, check_in, check_out
FROM reservations
WHERE room_id = 1
  AND status NOT IN ('Cancelled', 'Checked-out')
  AND check_in < '2026-12-05'::DATE
  AND check_out > '2026-12-01'::DATE;

-- --------------------------------------------------------------------------------
-- 2. OPTIMIZER BENCHMARK: COVERING INDEX WITH ZERO-HEAP VISITS
-- --------------------------------------------------------------------------------
-- Demonstrates an Index-Only Scan using the partial index on available rooms.
EXPLAIN (ANALYZE, BUFFERS, COSTS)
SELECT room_type, price_per_night
FROM rooms
WHERE status = 'Available' AND is_active = TRUE;

-- --------------------------------------------------------------------------------
-- 3. JOIN STRATEGY DEMONSTRATION: HASH JOIN VS NESTED LOOP
-- --------------------------------------------------------------------------------
-- A. Hash Join Demonstration on multi-table billing aggregation:
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    r.room_type,
    COUNT(res.reservation_id) AS total_stays,
    AVG(b.total_amount) AS average_bill
FROM rooms r
JOIN reservations res ON r.room_id = res.room_id
JOIN bills b ON res.reservation_id = b.reservation_id
GROUP BY r.room_type;

-- --------------------------------------------------------------------------------
-- 4. VIEW: BUFFER CACHE HIT RATIO & SYSTEM MEMORY HEALTH
-- --------------------------------------------------------------------------------
-- High-performance RDBMS installations must achieve > 95% buffer cache hit ratio
CREATE OR REPLACE VIEW vw_database_cache_hit_ratio AS
SELECT 
    'Hotel Management System Buffer Cache' AS metric_description,
    SUM(heap_blks_read) AS disk_blocks_read,
    SUM(heap_blks_hit)  AS memory_buffer_hits,
    ROUND(
        (SUM(heap_blks_hit)::NUMERIC / NULLIF(SUM(heap_blks_hit) + SUM(heap_blks_read), 0)::NUMERIC) * 100.0, 
        2
    ) AS cache_hit_ratio_percentage,
    CASE 
        WHEN ROUND((SUM(heap_blks_hit)::NUMERIC / NULLIF(SUM(heap_blks_hit) + SUM(heap_blks_read), 0)::NUMERIC) * 100.0, 2) >= 95.00 
        THEN 'EXCELLENT (Memory Cached)'
        ELSE 'TUNING REQUIRED'
    END AS memory_health_status
FROM pg_statio_user_tables;

-- --------------------------------------------------------------------------------
-- 5. VIEW: TABLE SIZE, INDEX SIZE & BLOAT TELEMETRY
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_table_storage_footprint AS
SELECT 
    schemaname AS schema,
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_disk_footprint,
    pg_size_pretty(pg_relation_size(relid)) AS table_data_size,
    pg_size_pretty(pg_indexes_size(relid)) AS indexes_size,
    n_live_tup AS active_rows_count,
    n_dead_tup AS dead_tuples_pending_vacuum
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Verification
SELECT * FROM vw_database_cache_hit_ratio;
SELECT * FROM vw_table_storage_footprint LIMIT 10;
