-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ENTERPRISE VIVA DEFENSE & ACADEMIC SQL BENCHMARKS
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Tailored specifically for Academic Evaluations, DBMS Vivas & Technical Defense:
-- 1. Relational Algebra in SQL (Selection, Projection, Cartesian Product, Natural Join)
-- 2. The Relational Division Operator ("Find customers who booked EVERY room type")
-- 3. Correlated Subqueries vs Set Operations (EXISTS, IN, UNION, INTERSECT, EXCEPT)
-- 4. Subqueries in SELECT, FROM, WHERE, and HAVING Clauses
-- 5. High-Concurrency Task Queuing (SELECT FOR UPDATE SKIP LOCKED)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: RELATIONAL ALGEBRA OPERATORS MAPPED TO SQL
-- --------------------------------------------------------------------------------

-- 1.1 Pure Selection (σ) & Projection (π)
-- π name, email, phone (σ created_at >= '2025-01-01' (customers))
SELECT name, email, phone
FROM customers
WHERE created_at >= '2025-01-01';

-- 1.2 Cartesian Product (×) vs Theta Join (⋈_θ)
-- Cartesian Product: Cross Join between active services and room categories
SELECT rm.room_type, s.service_name, s.price
FROM (SELECT DISTINCT room_type FROM rooms WHERE is_active = TRUE) rm
CROSS JOIN services s
WHERE s.is_available = TRUE;

-- Theta Join: Match customers to rooms whose price per night is less than their average past bill
SELECT DISTINCT c.name AS guest_name, rm.room_number, rm.room_type, rm.price_per_night
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN bills b ON r.reservation_id = b.reservation_id
JOIN rooms rm ON rm.price_per_night <= (b.total_amount * 0.50)
WHERE b.payment_status = 'Paid';

-- 1.3 Set Operations: UNION, INTERSECT, and EXCEPT (Set Difference)
-- INTERSECT: Find customers who have BOTH stayed in an Executive King AND ordered Room Service
SELECT c.customer_id, c.name, c.email
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN rooms rm ON r.room_id = rm.room_id
WHERE rm.room_type = 'Executive King'

INTERSECT

SELECT c.customer_id, c.name, c.email
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN service_requests sr ON r.reservation_id = sr.reservation_id;

-- EXCEPT (Difference): Find customers who have made reservations but NEVER placed any service requests
SELECT c.customer_id, c.name, c.email
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id

EXCEPT

SELECT c.customer_id, c.name, c.email
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN service_requests sr ON r.reservation_id = sr.reservation_id;


-- --------------------------------------------------------------------------------
-- SECTION 2: THE RELATIONAL DIVISION OPERATOR (VIVA CLASSIC)
-- Question: "Find all customers who have booked EVERY room category offered by the hotel"
-- --------------------------------------------------------------------------------

-- Relational Division formulation via Double Negation (NOT EXISTS ... NOT EXISTS)
SELECT c.customer_id, c.name, c.email
FROM customers c
WHERE NOT EXISTS (
    -- Set of all distinct room categories
    SELECT DISTINCT rm.room_type
    FROM rooms rm
    WHERE rm.is_active = TRUE
    
    EXCEPT
    
    -- Set of room categories this specific customer has booked
    SELECT DISTINCT rm2.room_type
    FROM reservations r2
    JOIN rooms rm2 ON r2.room_id = rm2.room_id
    WHERE r2.customer_id = c.customer_id
);

-- Alternative Relational Division via Exact Count Aggregation
SELECT c.customer_id, c.name, COUNT(DISTINCT rm.room_type) AS categories_stayed
FROM customers c
JOIN reservations r ON c.customer_id = r.customer_id
JOIN rooms rm ON r.room_id = rm.room_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT rm.room_type) = (
    SELECT COUNT(DISTINCT room_type) FROM rooms WHERE is_active = TRUE
);


-- --------------------------------------------------------------------------------
-- SECTION 3: ADVANCED SUBQUERIES (CORRELATED, SCALAR & DERIVED)
-- --------------------------------------------------------------------------------

-- 3.1 Correlated Subquery with EXISTS (Optimal Semi-Join)
-- Find rooms that currently have NO conflicting reservation for the next 7 days
SELECT rm.room_id, rm.room_number, rm.room_type, rm.price_per_night
FROM rooms rm
WHERE rm.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1 
      FROM reservations r
      WHERE r.room_id = rm.room_id
        AND r.status IN ('Confirmed', 'Checked-in', 'Booked')
        AND r.check_in < CURRENT_DATE + 7
        AND r.check_out > CURRENT_DATE
  );

-- 3.2 Scalar Subquery in SELECT Projection
-- Compare each reservation's bill against the global average bill
SELECT 
    r.reservation_id,
    c.name AS guest_name,
    b.total_amount,
    (SELECT ROUND(AVG(total_amount), 2) FROM bills WHERE payment_status = 'Paid') AS global_avg_bill,
    b.total_amount - (SELECT ROUND(AVG(total_amount), 2) FROM bills WHERE payment_status = 'Paid') AS variance_from_average
FROM reservations r
JOIN customers c ON r.customer_id = c.customer_id
JOIN bills b ON r.reservation_id = b.reservation_id
WHERE b.payment_status = 'Paid'
ORDER BY variance_from_average DESC;

-- 3.3 Derived Table in FROM Clause with Aggregation in HAVING Clause
-- Find room types whose average stay duration exceeds 3.5 nights
SELECT 
    stay_summary.room_type,
    ROUND(AVG(stay_summary.duration_nights), 2) AS avg_nights,
    COUNT(stay_summary.reservation_id) AS total_completed_trips
FROM (
    SELECT 
        r.reservation_id,
        rm.room_type,
        (r.check_out - r.check_in) AS duration_nights
    FROM reservations r
    JOIN rooms rm ON r.room_id = rm.room_id
    WHERE r.status = 'Checked-out'
) AS stay_summary
GROUP BY stay_summary.room_type
HAVING AVG(stay_summary.duration_nights) >= 2.0;


-- --------------------------------------------------------------------------------
-- SECTION 4: HIGH-CONCURRENCY WORK QUEUES (SELECT FOR UPDATE SKIP LOCKED)
-- Used in modern microservices to distribute housekeeping tasks without race conditions
-- --------------------------------------------------------------------------------

-- Simulates an autonomous housekeeping staff terminal claiming the next pending task
CREATE OR REPLACE FUNCTION fn_claim_next_housekeeping_task(p_staff_name VARCHAR(100))
RETURNS TABLE (
    claimed_task_id INT,
    assigned_room VARCHAR(10),
    task_instructions TEXT
) AS $$
DECLARE
    v_task_id INT;
    v_room_num VARCHAR(10);
    v_notes TEXT;
BEGIN
    -- Atomically lock and grab the highest priority pending task, skipping rows locked by other workers
    SELECT ht.task_id, rm.room_number, ht.notes
    INTO v_task_id, v_room_num, v_notes
    FROM housekeeping_tasks ht
    JOIN rooms rm ON ht.room_id = rm.room_id
    WHERE ht.status = 'Pending'
    ORDER BY ht.created_at ASC
    LIMIT 1
    FOR UPDATE SKIP LOCKED;

    IF v_task_id IS NOT NULL THEN
        UPDATE housekeeping_tasks
        SET status = 'In Progress',
            notes = COALESCE(notes, '') || ' [Claimed by ' || p_staff_name || ']'
        WHERE task_id = v_task_id;

        RETURN QUERY SELECT v_task_id, v_room_num, v_notes;
    END IF;
END;
$$ LANGUAGE plpgsql;
