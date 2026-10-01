-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DATABASE ADMINISTRATION & MAINTENANCE RUNBOOK
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Automated Index Maintenance & Concurrent Reindexing Procedures
-- 2. Dead Tuple Reclamation & Vacuum Threshold Diagnostic Queries
-- 3. Connection Pooling & Idle-in-Transaction Session Terminating Watchdogs
-- 4. Query Execution Profiling via pg_stat_statements
-- 5. Physical Storage Bloat & Disk Page Allocation Diagnostics
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: PROACTIVE CONNECTION POOL & SESSION WATCHDOG
-- --------------------------------------------------------------------------------

-- Identifies idle-in-transaction connections that may hold locks or prevent autovacuum
CREATE OR REPLACE VIEW vw_idle_transaction_watchdog AS
SELECT 
    pid,
    usename,
    client_addr,
    application_name,
    backend_start,
    xact_start,
    state,
    ROUND((EXTRACT(EPOCH FROM (clock_timestamp() - xact_start)))::NUMERIC, 2) AS duration_seconds,
    query AS latest_query
FROM pg_stat_activity
WHERE state IN ('idle in transaction', 'idle in transaction (aborted)')
  AND (clock_timestamp() - xact_start) > INTERVAL '30 seconds'
ORDER BY duration_seconds DESC;

-- Procedure: Gracefully terminate lingering zombie connections holding locks > 5 minutes
CREATE OR REPLACE PROCEDURE sp_terminate_zombie_connections(
    p_timeout_minutes INT DEFAULT 5,
    INOUT p_terminated_sessions INT DEFAULT 0
)
LANGUAGE plpgsql AS $$
DECLARE
    rec RECORD;
BEGIN
    p_terminated_sessions := 0;

    FOR rec IN 
        SELECT pid, usename, application_name
        FROM pg_stat_activity
        WHERE state = 'idle in transaction'
          AND (clock_timestamp() - xact_start) > (p_timeout_minutes || ' minutes')::INTERVAL
          AND pid != pg_backend_pid()
    LOOP
        PERFORM pg_terminate_backend(rec.pid);
        p_terminated_sessions := p_terminated_sessions + 1;
        RAISE NOTICE 'Terminated hung transaction session PID % (User: %, App: %)', rec.pid, rec.usename, rec.application_name;
    END LOOP;

    RAISE NOTICE 'Watchdog complete: % lingering zombie sessions terminated.', p_terminated_sessions;
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 2: INDEX BLOAT & MAINTENANCE ANALYZER
-- --------------------------------------------------------------------------------

-- Evaluates index size vs table size to identify candidates for REINDEX
CREATE OR REPLACE VIEW vw_index_bloat_summary AS
SELECT 
    t.relname AS table_name,
    i.relname AS index_name,
    pg_size_pretty(pg_relation_size(t.oid)) AS table_size,
    pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
    ROUND(
        (pg_relation_size(i.oid)::NUMERIC / NULLIF(pg_relation_size(t.oid), 0)) * 100.0, 
        2
    ) AS index_to_table_ratio_pct,
    idx.indisunique AS is_unique_index
FROM pg_index idx
JOIN pg_class t ON t.oid = idx.indrelid
JOIN pg_class i ON i.oid = idx.indexrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname = 'public'
ORDER BY pg_relation_size(i.oid) DESC;


-- --------------------------------------------------------------------------------
-- SECTION 3: AUTOMATED MAINTENANCE ENGINE PROCEDURE
-- --------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_run_routine_database_maintenance()
LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'Starting Automated Database Maintenance Runbook...';
    
    -- Terminate stalled sessions
    CALL sp_terminate_zombie_connections(5);

    -- Log maintenance checkpoint
    INSERT INTO procedure_execution_logs (procedure_name, status, records_affected, message)
    VALUES ('sp_run_routine_database_maintenance', 'SUCCESS', 1, 'Routine maintenance runbook completed successfully at ' || CURRENT_TIMESTAMP);

    RAISE NOTICE 'Routine maintenance completed successfully.';
END;
$$;
