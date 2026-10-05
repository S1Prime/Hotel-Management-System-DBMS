-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DYNAMIC PRICING & YIELD MANAGEMENT ENGINE
-- PostgreSQL Algorithmic Relational Intelligence
-- ================================================================================
-- Focus: Automated algorithmic yield calculation, occupancy-based dynamic pricing,
-- day-of-week multipliers, and seasonal rate curves implemented natively in PL/pgSQL.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. YIELD MANAGEMENT CONFIGURATION TABLE
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS yield_pricing_rules (
    rule_id SERIAL PRIMARY KEY,
    occupancy_threshold_pct NUMERIC(5,2) NOT NULL, -- e.g., 80.00%
    price_multiplier NUMERIC(4,2) NOT NULL CHECK (price_multiplier > 0), -- e.g., 1.25x
    rule_description VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO yield_pricing_rules (occupancy_threshold_pct, price_multiplier, rule_description)
VALUES
(90.00, 1.40, 'Surge Demand Peak: Occupancy exceeds 90% (+40%)'),
(75.00, 1.25, 'High Demand Yield: Occupancy exceeds 75% (+25%)'),
(50.00, 1.10, 'Moderate Demand Yield: Occupancy exceeds 50% (+10%)'),
(0.00, 1.00, 'Base Off-Peak Rate: Occupancy under 50% (Normal Rate)')
ON CONFLICT DO NOTHING;

-- --------------------------------------------------------------------------------
-- 2. PL/pgSQL FUNCTION: COMPUTE REAL-TIME DYNAMIC RATE FOR ANY DATE
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calculate_dynamic_rate(
    p_room_id INT,
    p_target_date DATE
)
RETURNS NUMERIC AS $$
DECLARE
    v_base_rate NUMERIC(10,2);
    v_total_rooms INT;
    v_booked_rooms INT;
    v_occupancy_pct NUMERIC(5,2);
    v_multiplier NUMERIC(4,2) := 1.00;
    v_is_weekend BOOLEAN;
    v_final_rate NUMERIC(10,2);
BEGIN
    -- 1. Retrieve base room tariff
    SELECT price_per_night INTO v_base_rate
    FROM rooms WHERE room_id = p_room_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room ID % does not exist.', p_room_id;
    END IF;

    -- 2. Calculate hotel occupancy rate for the target date
    SELECT COUNT(*) INTO v_total_rooms FROM rooms WHERE is_active = TRUE;
    
    SELECT COUNT(DISTINCT room_id) INTO v_booked_rooms
    FROM reservations
    WHERE status IN ('Confirmed', 'Checked-in', 'Booked')
      AND p_target_date >= check_in
      AND p_target_date < check_out;

    IF v_total_rooms > 0 THEN
        v_occupancy_pct := ROUND((v_booked_rooms::NUMERIC / v_total_rooms::NUMERIC) * 100.0, 2);
    ELSE
        v_occupancy_pct := 0.00;
    END IF;

    -- 3. Determine multiplier from yield rules
    SELECT price_multiplier INTO v_multiplier
    FROM yield_pricing_rules
    WHERE is_active = TRUE AND v_occupancy_pct >= occupancy_threshold_pct
    ORDER BY occupancy_threshold_pct DESC
    LIMIT 1;

    v_multiplier := COALESCE(v_multiplier, 1.00);

    -- 4. Apply weekend surcharge (+15% on Friday & Saturday nights)
    -- EXTRACT(DOW FROM DATE): 0=Sunday, 5=Friday, 6=Saturday
    IF EXTRACT(DOW FROM p_target_date) IN (5, 6) THEN
        v_multiplier := v_multiplier * 1.15;
    END IF;

    -- 5. Calculate final dynamic price
    v_final_rate := ROUND(v_base_rate * v_multiplier, 2);
    RETURN v_final_rate;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------------
-- 3. VIEW: 7-DAY FORECAST DYNAMIC TARIFFS PER ROOM CATEGORY
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dynamic_pricing_forecast AS
WITH calendar_7days AS (
    SELECT CURRENT_DATE + i AS stay_date
    FROM generate_series(0, 6) i
)
SELECT 
    c.stay_date,
    TO_CHAR(c.stay_date, 'Dy, Mon DD') AS day_label,
    r.room_id,
    r.room_number,
    r.room_type,
    r.price_per_night AS base_rate,
    fn_calculate_dynamic_rate(r.room_id, c.stay_date) AS forecasted_dynamic_rate,
    ROUND(
        ((fn_calculate_dynamic_rate(r.room_id, c.stay_date) - r.price_per_night) / r.price_per_night) * 100.0, 
        1
    ) AS surge_percentage
FROM calendar_7days c
CROSS JOIN rooms r
WHERE r.is_active = TRUE
ORDER BY c.stay_date ASC, r.room_number ASC;

-- Verification
SELECT * FROM vw_dynamic_pricing_forecast LIMIT 10;
