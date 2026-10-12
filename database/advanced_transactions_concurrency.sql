-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED TRANSACTIONS, CONCURRENCY & ACID GUARDS
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. ACID Transaction Integrity (Atomicity, Consistency, Isolation, Durability)
-- 2. Concurrency Isolation Levels (READ COMMITTED, REPEATABLE READ, SERIALIZABLE)
-- 3. Row-Level Pessimistic Locking (FOR UPDATE, FOR SHARE, NOWAIT, SKIP LOCKED)
-- 4. PostgreSQL Advisory Locks for Critical Business Workflows (pg_advisory_xact_lock)
-- 5. Deadlock Detection, Lock Contention Profiling & Resolution Recipes
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: ATOMIC COMPOSITE TRANSACTIONS WITH SAVEPOINTS
-- --------------------------------------------------------------------------------

-- Demonstrates partial rollback via SAVEPOINTS inside a multi-step booking
CREATE OR REPLACE PROCEDURE sp_atomic_booking_with_savepoint(
    p_customer_id INT,
    p_room_id INT,
    p_check_in DATE,
    p_check_out DATE,
    p_optional_service_id INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_new_res_id INT;
    v_base_rate NUMERIC(10,2);
    v_nights INT;
BEGIN
    -- STEP 1: Verify and lock target room
    SELECT price_per_night INTO v_base_rate
    FROM rooms
    WHERE room_id = p_room_id AND is_active = TRUE
    FOR UPDATE; -- Prevents concurrent modification during calculation

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room % is not valid or active.', p_room_id;
    END IF;

    -- STEP 2: Create primary reservation
    INSERT INTO reservations (customer_id, room_id, check_in, check_out, status)
    VALUES (p_customer_id, p_room_id, p_check_in, p_check_out, 'Confirmed')
    RETURNING reservation_id INTO v_new_res_id;

    v_nights := (p_check_out - p_check_in);

    -- Initialize initial bill
    INSERT INTO bills (reservation_id, room_charge, service_charge, tax, total_amount, payment_status)
    VALUES (v_new_res_id, v_base_rate * v_nights, 0.00, ROUND((v_base_rate * v_nights) * 0.12, 2), (v_base_rate * v_nights) * 1.12, 'Pending');

    -- STEP 3: Sub-transaction Savepoint for optional amenity attachment
    BEGIN
        IF p_optional_service_id IS NOT NULL THEN
            IF EXISTS (SELECT 1 FROM services WHERE service_id = p_optional_service_id AND is_available = TRUE) THEN
                INSERT INTO service_requests (reservation_id, service_id, quantity, status)
                VALUES (v_new_res_id, p_optional_service_id, 1, 'Requested');
            ELSE
                RAISE EXCEPTION 'Requested service is currently discontinued.';
            END IF;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        -- Catch optional service failure without discarding the core room booking!
        RAISE NOTICE 'Optional service could not be provisioned: %. Core booking remains intact.', SQLERRM;
    END;

    RAISE NOTICE 'Atomic reservation #% committed successfully.', v_new_res_id;
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 2: ROW-LEVEL CONCURRENCY LOCK MODES
-- --------------------------------------------------------------------------------

-- 2.1 Pessimistic Non-Blocking Lock (NOWAIT)
-- Throws an immediate error if another transaction is modifying the target reservation
CREATE OR REPLACE FUNCTION fn_secure_lock_reservation(p_reservation_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    v_status VARCHAR(20);
BEGIN
    SELECT status INTO v_status
    FROM reservations
    WHERE reservation_id = p_reservation_id
    FOR UPDATE NOWAIT;

    RETURN TRUE;
EXCEPTION
    WHEN lock_not_available THEN
        RAISE NOTICE 'Resource conflict: Reservation #% is locked by another active session.', p_reservation_id;
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- 2.2 Application-Level Transaction Advisory Locking
-- Guarantees single-threaded checkout settlement per customer ID across distributed cluster nodes
CREATE OR REPLACE PROCEDURE sp_guarded_customer_checkout(
    p_reservation_id INT,
    p_customer_id INT
)
LANGUAGE plpgsql AS $$
BEGIN
    -- Acquire exclusive transaction-scoped advisory lock based on customer_id hash
    PERFORM pg_advisory_xact_lock(hashtext('CHECKOUT_LOCK_' || p_customer_id));

    RAISE NOTICE 'Acquired distributed transaction advisory lock for Customer %', p_customer_id;

    -- Execute checkout settlement safely
    CALL sp_complete_checkout(p_reservation_id);

    -- Advisory lock is automatically released upon COMMIT of transaction
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 3: SYSTEM CONCURRENCY & ACTIVE LOCK MONITORS
-- --------------------------------------------------------------------------------

-- Diagnostic Query: Active Transaction Locks and Blocked Waiting Sessions
CREATE OR REPLACE VIEW vw_active_lock_contention AS
SELECT 
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement,
    blocking_activity.query AS blocking_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
   AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
   AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
   AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
   AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
   AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
   AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
   AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
   AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
   AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
   AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
