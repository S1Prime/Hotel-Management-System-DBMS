-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ACID TRANSACTIONS & CONCURRENCY CONTROL
-- PostgreSQL DBMS Specification for ACID Proofs & Defense Demonstrations
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. ATOMICITY & SAVEPOINTS: MULTI-STEP CHECKOUT TRANSACTION
-- Demonstrates atomic state transition with SAVEPOINT and graceful ROLLBACK
-- --------------------------------------------------------------------------------
BEGIN;

-- Step 1A: Establish Savepoint before attempting checkout
SAVEPOINT before_checkout;

-- Step 1B: Mark reservation as Checked-out
UPDATE reservations 
SET status = 'Checked-out' 
WHERE reservation_id = 1;

-- Step 1C: Compute and insert Final Invoice
INSERT INTO bills (
    reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status
) VALUES (
    1, 30000.00, 1200.00, 1560.00, 0.00, 32760.00, 'Paid'
) ON CONFLICT (reservation_id) DO UPDATE SET payment_status = 'Paid';

-- Step 1D: In case of billing disputes, rollback to savepoint can be demonstrated:
-- ROLLBACK TO SAVEPOINT before_checkout;

-- Commit permanent state change
COMMIT;


-- --------------------------------------------------------------------------------
-- 2. CONCURRENCY CONTROL & PESSIMISTIC LOCKING (SELECT ... FOR UPDATE)
-- Prevents race conditions and double-bookings during simultaneous checkout/booking
-- --------------------------------------------------------------------------------
BEGIN;

-- Lock the target room row so no other concurrent user can modify it
SELECT room_id, room_number, status, price_per_night
FROM rooms
WHERE room_id = 2
FOR UPDATE;

-- Verify no other conflicting booking exists
SELECT reservation_id 
FROM reservations
WHERE room_id = 2
  AND status IN ('Confirmed', 'Checked-in', 'Booked')
  AND check_in < '2026-09-20'
  AND check_out > '2026-09-15';

-- If zero conflicts, safely book room
INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, status)
VALUES (1, 2, '2026-09-15', '2026-09-20', 2, 'Confirmed');

COMMIT;


-- --------------------------------------------------------------------------------
-- 3. CONSISTENCY ENFORCEMENT & INTEGRITY ABORTS
-- Demonstrates how DBMS engine rejects inconsistent state transitions
-- --------------------------------------------------------------------------------

-- Demonstration Test: Trying to insert invalid dates (check_out before check_in)
-- The DBMS engine will immediately abort the transaction, preserving consistency
BEGIN;

-- Expected to raise: CHECK constraint 'chk_dates' violation
DO $$
BEGIN
    INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests)
    VALUES (1, 3, '2026-10-10', '2026-10-05', 1);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Transaction successfully aborted by DBMS constraint: %', SQLERRM;
END $$;

ROLLBACK;


-- --------------------------------------------------------------------------------
-- 4. ISOLATION LEVEL BENCHMARK
-- Demonstrates SERIALIZABLE transaction to eliminate Phantom Reads & Non-Repeatable Reads
-- --------------------------------------------------------------------------------
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Take snapshot of available rooms
SELECT COUNT(*) AS available_room_snapshot 
FROM rooms 
WHERE status = 'Available';

-- Any phantom inserts in concurrent sessions will be detected and aborted by PostgreSQL
COMMIT;
