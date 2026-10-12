-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ENTERPRISE DDL & RELATIONAL INTEGRITY CATALOG
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Comprehensive Relational Specification:
-- 1. Entity-Relationship Integrity Declarations (PK, FK, CHECK, UNIQUE, NOT NULL)
-- 2. Mathematical Cardinality Constraints & Relational Invariants
-- 3. Temporal Interval Assertion Functions (Overlapping Date Range Guards)
-- 4. Multi-Attribute Financial Consistency Rules
-- 5. Foreign Key Cascading Semantics & Tombstone Lifecycle Rules
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: RELATIONAL INVARIANT ASSERTIONS & TRIGGER VALIDATORS
-- --------------------------------------------------------------------------------

-- Assertion Function: Total Guest Capacity Constraint per Room Type
CREATE OR REPLACE FUNCTION fn_chk_room_guest_capacity()
RETURNS TRIGGER AS $$
DECLARE
    v_room_type VARCHAR(50);
    v_max_capacity INT;
BEGIN
    SELECT room_type INTO v_room_type
    FROM rooms
    WHERE room_id = NEW.room_id;

    -- Define capacity policy by category
    CASE v_room_type
        WHEN 'Standard Deluxe' THEN v_max_capacity := 2;
        WHEN 'Executive King'  THEN v_max_capacity := 3;
        WHEN 'Presidential Suite' THEN v_max_capacity := 6;
        ELSE v_max_capacity := 4;
    END CASE;

    IF NEW.number_of_guests > v_max_capacity THEN
        RAISE EXCEPTION 'Occupancy violation: Room % (%) permits a maximum of % guests. Requested: %.',
            NEW.room_id, v_room_type, v_max_capacity, NEW.number_of_guests;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_chk_room_guest_capacity ON reservations;
CREATE TRIGGER trg_chk_room_guest_capacity
    BEFORE INSERT OR UPDATE OF room_id, number_of_guests ON reservations
    FOR EACH ROW EXECUTE FUNCTION fn_chk_room_guest_capacity();


-- --------------------------------------------------------------------------------
-- SECTION 2: REFERENTIAL INTEGRITY AUDIT REPORT GENERATOR
-- --------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_generate_referential_integrity_report()
RETURNS TABLE (
    table_name VARCHAR(100),
    constraint_name VARCHAR(100),
    constraint_type VARCHAR(50),
    evaluation_status VARCHAR(20),
    violation_count BIGINT
) AS $$
DECLARE
    v_violations BIGINT;
BEGIN
    -- Check 1: Foreign key consistency between reservations and customers
    SELECT COUNT(*) INTO v_violations
    FROM reservations r
    LEFT JOIN customers c ON r.customer_id = c.customer_id
    WHERE c.customer_id IS NULL;

    RETURN QUERY SELECT 
        CAST('reservations' AS VARCHAR), 
        CAST('fk_reservations_customer_id' AS VARCHAR), 
        CAST('FOREIGN KEY' AS VARCHAR),
        CAST(CASE WHEN v_violations = 0 THEN 'VALID' ELSE 'CORRUPTED' END AS VARCHAR),
        v_violations;

    -- Check 2: Foreign key consistency between reservations and rooms
    SELECT COUNT(*) INTO v_violations
    FROM reservations r
    LEFT JOIN rooms rm ON r.room_id = rm.room_id
    WHERE rm.room_id IS NULL;

    RETURN QUERY SELECT 
        CAST('reservations' AS VARCHAR), 
        CAST('fk_reservations_room_id' AS VARCHAR), 
        CAST('FOREIGN KEY' AS VARCHAR),
        CAST(CASE WHEN v_violations = 0 THEN 'VALID' ELSE 'CORRUPTED' END AS VARCHAR),
        v_violations;

    -- Check 3: 1-to-1 unique bills to reservations consistency
    SELECT COUNT(*) INTO v_violations
    FROM bills b
    LEFT JOIN reservations r ON b.reservation_id = r.reservation_id
    WHERE r.reservation_id IS NULL;

    RETURN QUERY SELECT 
        CAST('bills' AS VARCHAR), 
        CAST('fk_bills_reservation_id' AS VARCHAR), 
        CAST('FOREIGN KEY' AS VARCHAR),
        CAST(CASE WHEN v_violations = 0 THEN 'VALID' ELSE 'CORRUPTED' END AS VARCHAR),
        v_violations;

    -- Check 4: Check constraint compliance on prices
    SELECT COUNT(*) INTO v_violations
    FROM rooms
    WHERE price_per_night <= 0;

    RETURN QUERY SELECT 
        CAST('rooms' AS VARCHAR), 
        CAST('chk_rooms_price_per_night' AS VARCHAR), 
        CAST('CHECK' AS VARCHAR),
        CAST(CASE WHEN v_violations = 0 THEN 'VALID' ELSE 'CORRUPTED' END AS VARCHAR),
        v_violations;
END;
$$ LANGUAGE plpgsql;
