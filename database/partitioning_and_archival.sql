-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DECLARATIVE TABLE PARTITIONING & DATA ARCHIVAL
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Declarative Range Partitioning by Time/Calendar Quarters
-- 2. Partition Pruning & Query Optimization Demonstration
-- 3. Dynamic Partition Provisioning Procedure (Dynamic DDL via EXECUTE)
-- 4. High-Volume Historical Data Archival Engine
-- 5. Sub-Partitioning / Multi-Level Partitioning Architecture
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: DECLARATIVE RANGE-PARTITIONED ARCHIVE TABLES
-- --------------------------------------------------------------------------------

-- 1.1 Master Partitioned Reservations Archive Table
CREATE TABLE IF NOT EXISTS reservations_archive (
    reservation_id INT NOT NULL,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    number_of_guests INT DEFAULT 1,
    special_requests TEXT,
    booking_date TIMESTAMP,
    status VARCHAR(20),
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_reservations_archive PRIMARY KEY (reservation_id, check_in)
) PARTITION BY RANGE (check_in);

-- 1.2 Concrete Annual Partitions
CREATE TABLE IF NOT EXISTS reservations_archive_2023 
    PARTITION OF reservations_archive
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE IF NOT EXISTS reservations_archive_2024 
    PARTITION OF reservations_archive
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE IF NOT EXISTS reservations_archive_2025 
    PARTITION OF reservations_archive
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE IF NOT EXISTS reservations_archive_2026 
    PARTITION OF reservations_archive
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

CREATE TABLE IF NOT EXISTS reservations_archive_future 
    PARTITION OF reservations_archive
    DEFAULT;


-- --------------------------------------------------------------------------------
-- SECTION 2: QUARTERLY-PARTITIONED AUDIT EVENT LOGS
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit_logs_partitioned (
    log_id BIGSERIAL,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    changed_by VARCHAR(50) DEFAULT CURRENT_USER,
    changed_at DATE NOT NULL DEFAULT CURRENT_DATE,
    details JSONB,
    CONSTRAINT pk_audit_partitioned PRIMARY KEY (log_id, changed_at)
) PARTITION BY RANGE (changed_at);

-- Quarterly Child Partitions for Year 2026
CREATE TABLE IF NOT EXISTS audit_logs_2026_q1 
    PARTITION OF audit_logs_partitioned
    FOR VALUES FROM ('2026-01-01') TO ('2026-04-01');

CREATE TABLE IF NOT EXISTS audit_logs_2026_q2 
    PARTITION OF audit_logs_partitioned
    FOR VALUES FROM ('2026-04-01') TO ('2026-07-01');

CREATE TABLE IF NOT EXISTS audit_logs_2026_q3 
    PARTITION OF audit_logs_partitioned
    FOR VALUES FROM ('2026-07-01') TO ('2026-10-01');

CREATE TABLE IF NOT EXISTS audit_logs_2026_q4 
    PARTITION OF audit_logs_partitioned
    FOR VALUES FROM ('2026-10-01') TO ('2027-01-01');


-- --------------------------------------------------------------------------------
-- SECTION 3: AUTOMATED DYNAMIC PARTITION CREATOR PROCEDURE
-- --------------------------------------------------------------------------------

-- Automatically detects upcoming year and provisions partitioned DDL tables
CREATE OR REPLACE PROCEDURE sp_create_annual_partition(p_year INT)
LANGUAGE plpgsql AS $$
DECLARE
    v_table_name TEXT;
    v_start_date TEXT;
    v_end_date TEXT;
    v_sql TEXT;
BEGIN
    v_table_name := 'reservations_archive_' || p_year;
    v_start_date := p_year || '-01-01';
    v_end_date := (p_year + 1) || '-01-01';

    -- Check if partition already exists in pg_class
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = v_table_name) THEN
        v_sql := format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF reservations_archive FOR VALUES FROM (%L) TO (%L);',
            v_table_name, v_start_date, v_end_date
        );
        EXECUTE v_sql;
        RAISE NOTICE 'Partition table % successfully created for range [% to %].', v_table_name, v_start_date, v_end_date;
    ELSE
        RAISE NOTICE 'Partition table % already exists. Skipping.', v_table_name;
    END IF;
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 4: HISTORICAL DATA ARCHIVAL BATCH PROCEDURE
-- --------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_archive_old_reservations(
    p_cutoff_date DATE DEFAULT (CURRENT_DATE - INTERVAL '365 days')::DATE,
    INOUT p_archived_count INT DEFAULT 0
)
LANGUAGE plpgsql AS $$
DECLARE
    rec RECORD;
BEGIN
    p_archived_count := 0;

    -- Copy historical records into partitioned archive
    INSERT INTO reservations_archive (
        reservation_id, customer_id, room_id, check_in, check_out, 
        number_of_guests, special_requests, booking_date, status
    )
    SELECT 
        reservation_id, customer_id, room_id, check_in, check_out, 
        number_of_guests, special_requests, booking_date, status
    FROM reservations
    WHERE check_out < p_cutoff_date 
      AND status IN ('Checked-out', 'Cancelled')
    ON CONFLICT (reservation_id, check_in) DO NOTHING;

    GET DIAGNOSTICS p_archived_count = ROW_COUNT;

    RAISE NOTICE 'Archival complete: % records transferred into partitioned tables.', p_archived_count;
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 5: PARTITION PRUNING DEMONSTRATION QUERIES (EXPLAIN ANALYZE)
-- --------------------------------------------------------------------------------

-- Demonstrates PostgreSQL query planner excluding irrelevant physical partition tables
-- Note: Check execution plan in pgAdmin (F7) to observe 'Partitions Filtered'
EXPLAIN (COSTS FALSE, BUFFERS FALSE)
SELECT * 
FROM reservations_archive
WHERE check_in >= '2026-03-01' AND check_in < '2026-06-01';
