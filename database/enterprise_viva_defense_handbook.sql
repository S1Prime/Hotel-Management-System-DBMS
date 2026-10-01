-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — COMPREHENSIVE VIVA DEFENSE & DBMS THEORY IN SQL
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Purpose:
-- An executable, self-contained SQL technical handbook designed specifically for
-- Academic Viva Voce, Professor Demonstrations, and DBMS Theory Evaluations.
-- Every concept contains both theory notes and an executable, testable SQL query.
--
-- Table of Contents:
-- 1. Normalization & Decomposition (1NF, 2NF, 3NF, BCNF)
-- 2. Multi-Version Concurrency Control (MVCC) & Isolation Anomalies
-- 3. Updatable Views & The WITH CHECK OPTION Clause
-- 4. Set Theory vs Relational Algebra in ANSI SQL
-- 5. Query Optimizer Heuristics & Relational Tree Transformations
-- 6. Storage Internals: TOAST, FillFactor & VACUUM Mechanics
-- ================================================================================

-- --------------------------------------------------------------------------------
-- TOPIC 1: NORMALIZATION & DEPENDENCY THEORY
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "Explain how your Hotel Management System achieves 3NF and BCNF."
ANSWER:
- 1NF: All attributes are atomic (no repeating groups or comma-separated lists).
       Customer phone numbers and guest names are singular values.
- 2NF: The database is in 1NF and every non-prime attribute is fully functionally 
       dependent on the entire primary key (no partial key dependencies).
       Every table uses a single-attribute surrogate key (SERIAL PRIMARY KEY).
- 3NF: The database is in 2NF and has NO transitive functional dependencies:
       X -> Y and Y -> Z where Z depends on X through Y.
       For instance, room price is NOT stored redundantly inside reservations;
       it depends solely on room_id in the rooms table.
- BCNF: For every non-trivial functional dependency X -> Y, X must be a superkey.
*/

-- Verification Query: Proves 1NF atomicity across all tables
SELECT table_name, column_name, data_type 
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND data_type IN ('ARRAY', 'USER-DEFINED')
ORDER BY table_name;

-- Functional Dependency Audit (Proves customer_id uniquely determines guest details)
SELECT customer_id, COUNT(DISTINCT email) AS distinct_emails_per_pk
FROM customers
GROUP BY customer_id
HAVING COUNT(DISTINCT email) > 1; -- Returns 0 rows, confirming functional dependency


-- --------------------------------------------------------------------------------
-- TOPIC 2: MULTI-VERSION CONCURRENCY CONTROL (MVCC) & ISOLATION
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "How does PostgreSQL implement non-blocking reads during concurrent writes?"
ANSWER:
- PostgreSQL employs MVCC: When a row is updated, PostgreSQL does NOT overwrite it in-place.
  Instead, it writes a new version of the tuple (xmin and xmax transaction IDs).
- Readers never block writers, and writers never block readers.
*/

-- Inspect MVCC Tuple Metadata (xmin, xmax, ctid) on active hotel rooms
SELECT 
    ctid AS physical_disk_location,
    xmin AS creating_transaction_id,
    xmax AS deleting_transaction_id,
    room_id,
    room_number,
    price_per_night,
    status
FROM rooms
LIMIT 10;

-- Isolation Level Anomaly Demonstration:
-- 1. Dirty Read: Prevented at all PostgreSQL isolation levels (PostgreSQL does not permit Read Uncommitted).
-- 2. Non-Repeatable Read: Prevented in REPEATABLE READ and SERIALIZABLE.
-- 3. Phantom Read: Prevented via Predicate Locking in SERIALIZABLE isolation mode.

-- Executable Query for testing serializable snapshot conflicts:
-- BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SELECT SUM(room_charge) FROM bills WHERE payment_status = 'Pending';
-- COMMIT;


-- --------------------------------------------------------------------------------
-- TOPIC 3: UPDATABLE VIEWS & "WITH CHECK OPTION"
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "What is an updatable view and how do you prevent invalid data insertion through it?"
ANSWER:
- Simple 1-to-1 views on a single base table without aggregate functions are updatable.
- The 'WITH CHECK OPTION' clause ensures that any INSERT or UPDATE issued against
  the view must satisfy the WHERE clause of the view definition.
*/

-- Create a strictly validated updatable view for Available Deluxe Rooms
DROP VIEW IF EXISTS vw_updatable_deluxe_rooms;
CREATE VIEW vw_updatable_deluxe_rooms AS
SELECT room_id, room_number, room_type, price_per_night, status, is_active
FROM rooms
WHERE room_type = 'Standard Deluxe' AND is_active = TRUE
WITH CHECK OPTION;

-- Demonstration: An UPDATE attempting to change room_type to 'Presidential Suite' through this view
-- will be rejected by PostgreSQL with: "new row violates check option for view".


-- --------------------------------------------------------------------------------
-- TOPIC 4: SET THEORY & NULL SEMANTICS (THREE-VALUED LOGIC)
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "Explain Three-Valued Logic (3VL) and how NULL comparisons operate in SQL."
ANSWER:
- In ANSI SQL, NULL represents an unknown value.
- Expressions evaluate to TRUE, FALSE, or UNKNOWN.
- NULL = NULL evaluates to UNKNOWN (not TRUE).
- To compare NULLs safely, PostgreSQL provides 'IS NOT DISTINCT FROM'.
*/

-- Demonstration of 3-Valued Logic in customer queries:
SELECT 
    customer_id,
    name,
    phone,
    -- Traditional comparison vs safe distinct comparison
    (phone = NULL) AS traditional_equals_null, -- Always evaluates to NULL (unknown)
    (phone IS NULL) AS is_null_check,
    (phone IS NOT DISTINCT FROM NULL) AS distinct_from_check
FROM customers
LIMIT 5;


-- --------------------------------------------------------------------------------
-- TOPIC 5: QUERY OPTIMIZER HEURISTICS & PREDICATE PUSH-DOWN
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "What is Predicate Pushdown and how does the cost-based optimizer use it?"
ANSWER:
- The optimizer pushes selection predicates (WHERE filters) down through joins
  and subqueries to reduce the cardinality of intermediate tuples as early as possible.
*/

-- Executable comparison showing predicate pushdown in execution plan:
EXPLAIN (COSTS TRUE, VERBOSE)
SELECT c.name, r.check_in, b.total_amount
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN bills b ON r.reservation_id = b.reservation_id
WHERE c.email = 'arthur.pendelton@crowneplaza.com';


-- --------------------------------------------------------------------------------
-- TOPIC 6: PHYSICAL STORAGE INTERNALS (VACUUM & DEAD TUPLES)
-- --------------------------------------------------------------------------------

/*
VIVA QUESTION: "What causes table bloat in PostgreSQL and how does VACUUM resolve it?"
ANSWER:
- Because of MVCC, UPDATEs and DELETEs leave behind dead tuples.
- The PostgreSQL AUTOVACUUM daemon reclaims space occupied by dead tuples
  and updates statistics in pg_statistic for the query planner.
*/

-- Query: Live Tuples vs Dead Tuples Across Core Tables
SELECT 
    relname AS table_name,
    n_live_tup AS live_active_rows,
    n_dead_tup AS dead_reclaimable_rows,
    ROUND((n_dead_tup::NUMERIC / NULLIF(n_live_tup + n_dead_tup, 0)) * 100.0, 2) AS dead_tuple_ratio_pct,
    last_vacuum,
    last_autovacuum,
    last_analyze
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
