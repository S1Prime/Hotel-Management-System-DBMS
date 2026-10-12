-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — RECURSIVE & HIERARCHICAL SQL (CTEs)
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Recursive Common Table Expressions (WITH RECURSIVE)
-- 2. Hierarchical Staff Reporting & Management Tree Traversal
-- 3. Calendar Date Generator & Room Vacancy Gap Analysis
-- 4. Multi-Leg Reservation Stay Chains & Extension Lineage
-- 5. Bill Ledger Running Balance & Payment Allocation Hierarchy
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: HIERARCHICAL STAFF REPORTING TREE
-- --------------------------------------------------------------------------------

-- Add manager_id foreign key to staff table if not existing (non-breaking alter)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'staff' AND column_name = 'manager_id'
    ) THEN
        ALTER TABLE staff ADD COLUMN manager_id INT REFERENCES staff(staff_id) ON DELETE SET NULL;
        
        -- Establish sample organizational hierarchy
        -- Assuming staff_id 2 (Admin) is top-level General Manager
        -- staff_id 1 (Receptionist) reports to staff_id 2
        UPDATE staff SET manager_id = (SELECT staff_id FROM staff WHERE role = 'Admin' ORDER BY staff_id ASC LIMIT 1)
        WHERE role = 'Receptionist';
    END IF;
END $$;

-- 1.1 Recursive Organizational Chart with Depth, Hierarchy Path, and Subordinate Counts
WITH RECURSIVE staff_hierarchy AS (
    -- Anchor Member: Top-level executives (Staff with no manager)
    SELECT 
        staff_id,
        name,
        role,
        manager_id,
        1 AS management_level,
        CAST(name AS VARCHAR(500)) AS reporting_chain,
        ARRAY[staff_id] AS path_keys
    FROM staff
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive Member: Subordinates reporting to employees in the previous tier
    SELECT 
        s.staff_id,
        s.name,
        s.role,
        s.manager_id,
        sh.management_level + 1 AS management_level,
        CAST(sh.reporting_chain || ' ➔ ' || s.name AS VARCHAR(500)),
        sh.path_keys || s.staff_id
    FROM staff s
    INNER JOIN staff_hierarchy sh ON s.manager_id = sh.staff_id
)
SELECT 
    staff_id,
    REPEAT('   ', management_level - 1) || '👤 ' || name AS visual_org_tree,
    role,
    management_level,
    reporting_chain
FROM staff_hierarchy
ORDER BY path_keys;


-- --------------------------------------------------------------------------------
-- SECTION 2: RECURSIVE CALENDAR GENERATOR & VACANCY GAP ANALYSIS
-- --------------------------------------------------------------------------------

-- 2.1 Pure ANSI-Compliant Recursive Calendar Generator
-- Generates continuous date series for the upcoming 60 days without proprietary functions
WITH RECURSIVE calendar_cte AS (
    -- Anchor: Starting today
    SELECT CURRENT_DATE AS day_date

    UNION ALL

    -- Recursive Member: Increment by 1 day until reaching target date limit
    SELECT (day_date + INTERVAL '1 day')::DATE
    FROM calendar_cte
    WHERE day_date < (CURRENT_DATE + INTERVAL '60 days')::DATE
),
room_availability_matrix AS (
    SELECT 
        c.day_date,
        rm.room_id,
        rm.room_number,
        rm.room_type,
        rm.price_per_night,
        CASE 
            WHEN r.reservation_id IS NOT NULL THEN 'Occupied'
            ELSE 'Available'
        END AS room_day_status
    FROM calendar_cte c
    CROSS JOIN rooms rm
    LEFT JOIN reservations r 
        ON rm.room_id = r.room_id
       AND c.day_date >= r.check_in 
       AND c.day_date < r.check_out 
       AND r.status IN ('Confirmed', 'Checked-in', 'Booked')
    WHERE rm.is_active = TRUE
)
SELECT 
    day_date,
    room_type,
    COUNT(*) AS total_rooms_in_category,
    COUNT(*) FILTER (WHERE room_day_status = 'Available') AS vacant_rooms,
    COUNT(*) FILTER (WHERE room_day_status = 'Occupied') AS booked_rooms,
    ROUND(
        (COUNT(*) FILTER (WHERE room_day_status = 'Occupied')::NUMERIC / COUNT(*)) * 100.0, 
        2
    ) AS daily_projected_occupancy_pct
FROM room_availability_matrix
GROUP BY day_date, room_type
ORDER BY day_date ASC, room_type ASC;


-- --------------------------------------------------------------------------------
-- SECTION 3: RECURSIVE CONSECUTIVE VACANCY STREAKS (ISLANDS & GAPS)
-- --------------------------------------------------------------------------------

-- 3.1 Identifies longest contiguous available date spans for each room
-- Classic DBMS Gaps and Islands problem solved with Recursive SQL
WITH RECURSIVE date_range AS (
    SELECT CURRENT_DATE AS cal_date
    UNION ALL
    SELECT (cal_date + 1)::DATE
    FROM date_range
    WHERE cal_date < CURRENT_DATE + 30
),
unoccupied_days AS (
    SELECT 
        dr.cal_date,
        rm.room_id,
        rm.room_number,
        rm.room_type,
        ROW_NUMBER() OVER (PARTITION BY rm.room_id ORDER BY dr.cal_date) AS seq_num,
        dr.cal_date - (ROW_NUMBER() OVER (PARTITION BY rm.room_id ORDER BY dr.cal_date) * INTERVAL '1 day')::INTERVAL AS island_group
    FROM date_range dr
    CROSS JOIN rooms rm
    LEFT JOIN reservations r 
        ON rm.room_id = r.room_id
       AND dr.cal_date >= r.check_in 
       AND dr.cal_date < r.check_out 
       AND r.status NOT IN ('Cancelled')
    WHERE r.reservation_id IS NULL AND rm.is_active = TRUE
)
SELECT 
    room_id,
    room_number,
    room_type,
    MIN(cal_date) AS vacancy_window_start,
    MAX(cal_date) AS vacancy_window_end,
    (MAX(cal_date) - MIN(cal_date) + 1) AS consecutive_unoccupied_days
FROM unoccupied_days
GROUP BY room_id, room_number, room_type, island_group
HAVING (MAX(cal_date) - MIN(cal_date) + 1) >= 3
ORDER BY consecutive_unoccupied_days DESC, room_number;


-- --------------------------------------------------------------------------------
-- SECTION 4: RECURSIVE BILL AMORTIZATION & SETTLEMENT BREAKDOWN
-- --------------------------------------------------------------------------------

-- 4.1 Simulates installment payment allocation against multi-item guest folio
-- Recursively deducts partial payments across Room Charges -> Service Charges -> Taxes
CREATE OR REPLACE FUNCTION fn_simulate_installment_settlement(
    p_reservation_id INT,
    p_installment_amount NUMERIC
)
RETURNS TABLE (
    ledger_step INT,
    component_name VARCHAR(50),
    charged_amount NUMERIC,
    amount_paid NUMERIC,
    remaining_balance NUMERIC
) AS $$
DECLARE
    v_room_charge NUMERIC;
    v_service_charge NUMERIC;
    v_tax NUMERIC;
    v_rem_payment NUMERIC;
BEGIN
    SELECT room_charge, service_charge, tax
    INTO v_room_charge, v_service_charge, v_tax
    FROM bills
    WHERE reservation_id = p_reservation_id;

    v_rem_payment := p_installment_amount;

    -- Step 1: Pay Room Charge
    ledger_step := 1;
    component_name := 'Room Base Charge';
    charged_amount := v_room_charge;
    IF v_rem_payment >= v_room_charge THEN
        amount_paid := v_room_charge;
        v_rem_payment := v_rem_payment - v_room_charge;
        remaining_balance := 0;
    ELSE
        amount_paid := v_rem_payment;
        remaining_balance := v_room_charge - v_rem_payment;
        v_rem_payment := 0;
    END IF;
    RETURN NEXT;

    -- Step 2: Pay Service Charge
    ledger_step := 2;
    component_name := 'Hotel Amenities & Services';
    charged_amount := v_service_charge;
    IF v_rem_payment >= v_service_charge THEN
        amount_paid := v_service_charge;
        v_rem_payment := v_rem_payment - v_service_charge;
        remaining_balance := 0;
    ELSE
        amount_paid := v_rem_payment;
        remaining_balance := v_service_charge - v_rem_payment;
        v_rem_payment := 0;
    END IF;
    RETURN NEXT;

    -- Step 3: Pay Government Tax
    ledger_step := 3;
    component_name := 'Luxury Goods & Services Tax (GST)';
    charged_amount := v_tax;
    IF v_rem_payment >= v_tax THEN
        amount_paid := v_tax;
        v_rem_payment := v_rem_payment - v_tax;
        remaining_balance := 0;
    ELSE
        amount_paid := v_rem_payment;
        remaining_balance := v_tax - v_rem_payment;
        v_rem_payment := 0;
    END IF;
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;
