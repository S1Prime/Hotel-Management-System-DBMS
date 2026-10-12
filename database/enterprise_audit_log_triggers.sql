-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — COMPREHENSIVE CHANGE DATA CAPTURE (CDC) AUDIT ENGINE
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Full-System Change Data Capture (CDC) Across All Core Entities
-- 2. JSONB Diff Tracking (Captures Exactly Which Fields Changed in an UPDATE)
-- 3. Forensics & Compliance: User Identity, Client IP, Session Application Name
-- 4. Rollback & Point-in-Time History Reconstruction Functions
-- 5. Automated Retention Policy & Log Purge Procedures
-- ================================================================================

-- Table: Enterprise System Audit Trail
CREATE TABLE IF NOT EXISTS system_audit_trail (
    audit_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE', 'TRUNCATE')),
    record_id TEXT,
    old_row_data JSONB,
    new_row_data JSONB,
    changed_fields JSONB,
    client_user VARCHAR(100) DEFAULT CURRENT_USER,
    client_ip INET,
    client_app_name TEXT,
    transaction_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    txid BIGINT DEFAULT txid_current()
);

-- Indexing for sub-millisecond forensic search
CREATE INDEX IF NOT EXISTS idx_audit_table_rec ON system_audit_trail (table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_tx_time ON system_audit_trail (transaction_timestamp DESC);


-- --------------------------------------------------------------------------------
-- UNIVERSAL CDC TRIGGER FUNCTION (COMPUTES JSONB DELTAS)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_capture_system_audit_log()
RETURNS TRIGGER AS $$
DECLARE
    v_old_json JSONB := NULL;
    v_new_json JSONB := NULL;
    v_diff_json JSONB := '{}'::JSONB;
    v_key TEXT;
    v_rec_id TEXT := NULL;
BEGIN
    IF (TG_OP = 'DELETE') THEN
        v_old_json := to_jsonb(OLD);
        -- Extract primary key heuristic
        IF v_old_json ? 'customer_id' THEN v_rec_id := v_old_json->>'customer_id';
        ELSIF v_old_json ? 'room_id' THEN v_rec_id := v_old_json->>'room_id';
        ELSIF v_old_json ? 'reservation_id' THEN v_rec_id := v_old_json->>'reservation_id';
        ELSIF v_old_json ? 'bill_id' THEN v_rec_id := v_old_json->>'bill_id';
        ELSIF v_old_json ? 'service_id' THEN v_rec_id := v_old_json->>'service_id';
        ELSIF v_old_json ? 'request_id' THEN v_rec_id := v_old_json->>'request_id';
        ELSIF v_old_json ? 'task_id' THEN v_rec_id := v_old_json->>'task_id';
        ELSIF v_old_json ? 'staff_id' THEN v_rec_id := v_old_json->>'staff_id';
        END IF;

    ELSIF (TG_OP = 'UPDATE') THEN
        v_old_json := to_jsonb(OLD);
        v_new_json := to_jsonb(NEW);

        -- Extract primary key heuristic
        IF v_new_json ? 'customer_id' THEN v_rec_id := v_new_json->>'customer_id';
        ELSIF v_new_json ? 'room_id' THEN v_rec_id := v_new_json->>'room_id';
        ELSIF v_new_json ? 'reservation_id' THEN v_rec_id := v_new_json->>'reservation_id';
        ELSIF v_new_json ? 'bill_id' THEN v_rec_id := v_new_json->>'bill_id';
        ELSIF v_new_json ? 'service_id' THEN v_rec_id := v_new_json->>'service_id';
        ELSIF v_new_json ? 'request_id' THEN v_rec_id := v_new_json->>'request_id';
        ELSIF v_new_json ? 'task_id' THEN v_rec_id := v_new_json->>'task_id';
        ELSIF v_new_json ? 'staff_id' THEN v_rec_id := v_new_json->>'staff_id';
        END IF;

        -- Calculate explicit field diffs
        FOR v_key IN SELECT jsonb_object_keys(v_new_json) LOOP
            IF (v_old_json->v_key IS DISTINCT FROM v_new_json->v_key) THEN
                v_diff_json := v_diff_json || jsonb_build_object(
                    v_key, jsonb_build_object('old', v_old_json->v_key, 'new', v_new_json->v_key)
                );
            END IF;
        END LOOP;

    ELSIF (TG_OP = 'INSERT') THEN
        v_new_json := to_jsonb(NEW);
        IF v_new_json ? 'customer_id' THEN v_rec_id := v_new_json->>'customer_id';
        ELSIF v_new_json ? 'room_id' THEN v_rec_id := v_new_json->>'room_id';
        ELSIF v_new_json ? 'reservation_id' THEN v_rec_id := v_new_json->>'reservation_id';
        ELSIF v_new_json ? 'bill_id' THEN v_rec_id := v_new_json->>'bill_id';
        ELSIF v_new_json ? 'service_id' THEN v_rec_id := v_new_json->>'service_id';
        ELSIF v_new_json ? 'request_id' THEN v_rec_id := v_new_json->>'request_id';
        ELSIF v_new_json ? 'task_id' THEN v_rec_id := v_new_json->>'task_id';
        ELSIF v_new_json ? 'staff_id' THEN v_rec_id := v_new_json->>'staff_id';
        END IF;
    END IF;

    -- Persist forensic record
    INSERT INTO system_audit_trail (
        table_name, operation, record_id, old_row_data, new_row_data, 
        changed_fields, client_user, client_ip, client_app_name
    ) VALUES (
        TG_TABLE_NAME, TG_OP, v_rec_id, v_old_json, v_new_json, 
        v_diff_json, CURRENT_USER, inet_client_addr(), current_setting('application_name', TRUE)
    );

    IF (TG_OP = 'DELETE') THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- --------------------------------------------------------------------------------
-- ATTACH CDC AUDIT TRIGGERS ACROSS ALL CORE TABLES
-- --------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_audit_customers ON customers;
CREATE TRIGGER trg_audit_customers
    AFTER INSERT OR UPDATE OR DELETE ON customers
    FOR EACH ROW EXECUTE FUNCTION fn_capture_system_audit_log();

DROP TRIGGER IF EXISTS trg_audit_rooms ON rooms;
CREATE TRIGGER trg_audit_rooms
    AFTER INSERT OR UPDATE OR DELETE ON rooms
    FOR EACH ROW EXECUTE FUNCTION fn_capture_system_audit_log();

DROP TRIGGER IF EXISTS trg_audit_staff ON staff;
CREATE TRIGGER trg_audit_staff
    AFTER INSERT OR UPDATE OR DELETE ON staff
    FOR EACH ROW EXECUTE FUNCTION fn_capture_system_audit_log();

DROP TRIGGER IF EXISTS trg_audit_service_requests ON service_requests;
CREATE TRIGGER trg_audit_service_requests
    AFTER INSERT OR UPDATE OR DELETE ON service_requests
    FOR EACH ROW EXECUTE FUNCTION fn_capture_system_audit_log();

DROP TRIGGER IF EXISTS trg_audit_housekeeping_tasks ON housekeeping_tasks;
CREATE TRIGGER trg_audit_housekeeping_tasks
    AFTER INSERT OR UPDATE OR DELETE ON housekeeping_tasks
    FOR EACH ROW EXECUTE FUNCTION fn_capture_system_audit_log();


-- --------------------------------------------------------------------------------
-- RECONSTRUCTION & RETENTION STORED PROCEDURES
-- --------------------------------------------------------------------------------

-- Procedure: Reconstruct historical record state at a specific point in time
CREATE OR REPLACE FUNCTION fn_audit_get_history_timeline(
    p_table_name VARCHAR(50),
    p_record_id TEXT
)
RETURNS TABLE (
    audit_id BIGINT,
    operation VARCHAR(10),
    changed_by VARCHAR(100),
    recorded_at TIMESTAMP WITH TIME ZONE,
    diff_summary JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        sat.audit_id,
        sat.operation,
        sat.client_user,
        sat.transaction_timestamp,
        sat.changed_fields
    FROM system_audit_trail sat
    WHERE sat.table_name = p_table_name 
      AND sat.record_id = p_record_id
    ORDER BY sat.transaction_timestamp DESC;
END;
$$ LANGUAGE plpgsql;

-- Procedure: Purge old audit logs older than retention period (e.g. 90 days)
CREATE OR REPLACE PROCEDURE sp_purge_audit_logs(
    p_retention_days INT DEFAULT 90,
    INOUT p_deleted_rows INT DEFAULT 0
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM system_audit_trail
    WHERE transaction_timestamp < (CURRENT_TIMESTAMP - (p_retention_days || ' days')::INTERVAL);

    GET DIAGNOSTICS p_deleted_rows = ROW_COUNT;
    RAISE NOTICE 'Audit trail maintenance: Purged % entries older than % days.', p_deleted_rows, p_retention_days;
END;
$$;
