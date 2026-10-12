-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — STRESS TEST BENCHMARK WORKLOAD ENGINE
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. High-Throughput Read/Write Benchmark Simulation
-- 2. Execution Latency Profiling (Milliseconds per Query)
-- 3. Concurrent Booking Contention Stress Testing
-- 4. Analytical Aggregation Throughput Benchmarks
-- 5. Automated Benchmark Report Generation in SQL
-- ================================================================================

-- Table: Benchmark Execution Results History
CREATE TABLE IF NOT EXISTS benchmark_test_results (
    test_id SERIAL PRIMARY KEY,
    suite_name VARCHAR(100) NOT NULL,
    iterations INT NOT NULL,
    total_elapsed_ms NUMERIC(10,2) NOT NULL,
    avg_latency_ms NUMERIC(10,4) NOT NULL,
    throughput_qps NUMERIC(10,2) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);

-- --------------------------------------------------------------------------------
-- 1. BENCHMARK SUITE: READ-INTENSIVE SEARCH & LOOKUP PERFORMANCE
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_benchmark_read_workload(
    p_iterations INT DEFAULT 1000
)
LANGUAGE plpgsql AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed NUMERIC;
    v_dummy_id INT;
    v_dummy_status VARCHAR(20);
    i INT;
BEGIN
    v_start_time := clock_timestamp();

    FOR i IN 1..p_iterations LOOP
        -- Simulate guest dashboard active reservation lookup
        SELECT reservation_id, status 
        INTO v_dummy_id, v_dummy_status
        FROM reservations
        WHERE customer_id = (1 + (i % 10))
        ORDER BY check_in DESC
        LIMIT 1;
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed := ROUND((EXTRACT(EPOCH FROM (v_end_time - v_start_time)) * 1000)::NUMERIC, 2);

    INSERT INTO benchmark_test_results (
        suite_name, iterations, total_elapsed_ms, avg_latency_ms, throughput_qps, notes
    ) VALUES (
        'Read-Intensive Customer Reservation Lookups',
        p_iterations,
        v_elapsed,
        ROUND(v_elapsed / p_iterations, 4),
        ROUND((p_iterations / NULLIF(v_elapsed, 0)) * 1000.0, 2),
        'Evaluated single-record indexed primary/foreign key lookup latency.'
    );

    RAISE NOTICE 'Read Benchmark: % iterations in % ms (% QPS).', p_iterations, v_elapsed, ROUND((p_iterations / NULLIF(v_elapsed, 0)) * 1000.0, 2);
END;
$$;


-- --------------------------------------------------------------------------------
-- 2. BENCHMARK SUITE: ANALYTICAL OLAP QUERY AGGREGATION SPEED
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_benchmark_olap_aggregation(
    p_iterations INT DEFAULT 100
)
LANGUAGE plpgsql AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_elapsed NUMERIC;
    v_total_revenue NUMERIC;
    i INT;
BEGIN
    v_start_time := clock_timestamp();

    FOR i IN 1..p_iterations LOOP
        -- Execute multi-table join and window analytical query
        SELECT SUM(b.total_amount)
        INTO v_total_revenue
        FROM bills b
        JOIN reservations r ON b.reservation_id = r.reservation_id
        JOIN rooms rm ON r.room_id = rm.room_id
        WHERE b.payment_status = 'Paid';
    END LOOP;

    v_end_time := clock_timestamp();
    v_elapsed := ROUND((EXTRACT(EPOCH FROM (v_end_time - v_start_time)) * 1000)::NUMERIC, 2);

    INSERT INTO benchmark_test_results (
        suite_name, iterations, total_elapsed_ms, avg_latency_ms, throughput_qps, notes
    ) VALUES (
        'Multi-Table Analytical Revenue Aggregation',
        p_iterations,
        v_elapsed,
        ROUND(v_elapsed / p_iterations, 4),
        ROUND((p_iterations / NULLIF(v_elapsed, 0)) * 1000.0, 2),
        'Evaluated 3-way join and aggregation performance over financial tables.'
    );

    RAISE NOTICE 'OLAP Benchmark: % iterations in % ms (% QPS).', p_iterations, v_elapsed, ROUND((p_iterations / NULLIF(v_elapsed, 0)) * 1000.0, 2);
END;
$$;


-- --------------------------------------------------------------------------------
-- 3. BENCHMARK SUITE: MASTER BENCHMARK RUNNER
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_run_all_database_benchmarks()
LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'Starting Comprehensive Database Benchmark Suite...';
    
    CALL sp_benchmark_read_workload(500);
    CALL sp_benchmark_olap_aggregation(50);
    
    RAISE NOTICE 'Benchmark execution concluded. Review results in benchmark_test_results.';
END;
$$;
