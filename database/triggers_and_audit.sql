-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — SQL TRIGGERS, BUSINESS RULES & AUDIT LOGGING
-- PostgreSQL DBMS Specification
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. DEDICATED AUDIT LOG TABLE
-- Captures every INSERT, UPDATE, and DELETE event across critical business tables
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    record_id INT,
    old_data JSONB,
    new_data JSONB,
    changed_by VARCHAR(50) DEFAULT CURRENT_USER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------
-- 2. GENERIC AUDIT TRIGGER FUNCTION
-- Automatically serializes changed rows into JSONB for forensic auditing
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_audit_record_change()
RETURNS TRIGGER AS $$
DECLARE
    v_record_id INT;
BEGIN
    IF (TG_OP = 'DELETE') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING OLD INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), NULL, CURRENT_USER);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING NEW INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), to_jsonb(NEW), CURRENT_USER);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING NEW INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, NULL, to_jsonb(NEW), CURRENT_USER);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply Audit Trigger to Critical Tables
DROP TRIGGER IF EXISTS trg_audit_reservations ON reservations;
CREATE TRIGGER trg_audit_reservations
AFTER INSERT OR UPDATE OR DELETE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_audit_record_change('reservation_id');

DROP TRIGGER IF EXISTS trg_audit_bills ON bills;
CREATE TRIGGER trg_audit_bills
AFTER INSERT OR UPDATE OR DELETE ON bills
FOR EACH ROW EXECUTE FUNCTION fn_audit_record_change('bill_id');

DROP TRIGGER IF EXISTS trg_audit_rooms ON rooms;
CREATE TRIGGER trg_audit_rooms
AFTER UPDATE OR DELETE ON rooms
FOR EACH ROW EXECUTE FUNCTION fn_audit_record_change('room_id');


-- --------------------------------------------------------------------------------
-- 3. BUSINESS TRIGGER: AUTOMATIC ROOM CLEANING ON CHECKOUT
-- When a guest checks out, immediately switch room status to 'Cleaning'
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_checkout_room_cleaning()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Checked-out' AND (OLD.status IS DISTINCT FROM 'Checked-out')) THEN
        UPDATE rooms SET status = 'Cleaning' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_checkout_room_cleaning ON reservations;
CREATE TRIGGER trg_checkout_room_cleaning
AFTER UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION fn_checkout_room_cleaning();


-- --------------------------------------------------------------------------------
-- 4. BUSINESS TRIGGER: REVERT ROOM STATUS ON CANCELLATION
-- When a reservation is cancelled, release room back to 'Available'
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_cancel_room_available()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cancelled' AND (OLD.status IS DISTINCT FROM 'Cancelled')) THEN
        UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cancel_room_available ON reservations;
CREATE TRIGGER trg_cancel_room_available
AFTER UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION fn_cancel_room_available();


-- --------------------------------------------------------------------------------
-- 5. BUSINESS TRIGGER: AUTO-CREATE HOUSEKEEPING TASK
-- Whenever any room enters 'Cleaning' state, dispatch task to cleaning team
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_auto_housekeeping()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cleaning' AND (OLD.status IS DISTINCT FROM 'Cleaning')) THEN
        INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
        VALUES (NEW.room_id, 'Cleaning', 'Pending', 'Dispatched automatically after room status changed to Cleaning');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_housekeeping ON rooms;
CREATE TRIGGER trg_auto_housekeeping
AFTER UPDATE ON rooms
FOR EACH ROW
EXECUTE FUNCTION fn_auto_housekeeping();


-- --------------------------------------------------------------------------------
-- 6. INTEGRITY TRIGGER: PREVENT INVALID RESERVATION DATES
-- Prohibits checkouts that precede checkins or past booking start dates
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validate_reservation_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.check_out <= NEW.check_in) THEN
        RAISE EXCEPTION 'Check-out date (%) must be strictly after check-in date (%).', NEW.check_out, NEW.check_in;
    END IF;

    IF (TG_OP = 'INSERT' AND NEW.check_in < CURRENT_DATE) THEN
        RAISE EXCEPTION 'Cannot book reservations with a check-in date in the past (%).', NEW.check_in;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_reservation_dates ON reservations;
CREATE TRIGGER trg_validate_reservation_dates
BEFORE INSERT OR UPDATE OF check_in, check_out ON reservations
FOR EACH ROW
EXECUTE FUNCTION fn_validate_reservation_dates();
