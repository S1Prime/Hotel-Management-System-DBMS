-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — TEMPORAL TABLES & SYSTEM VERSIONING (SQL:2011)
-- PostgreSQL Enterprise Temporal Relational Specification
-- ================================================================================
-- Focus: System-versioned history, bi-temporal modeling, and historical time-travel
-- queries to track room tariff changes and reservation status mutations over time.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. TEMPORAL ROOM TARIFF HISTORY TABLE
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS room_tariffs_history (
    history_id SERIAL PRIMARY KEY,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE CASCADE,
    price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night > 0),
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_to TIMESTAMP WITH TIME ZONE DEFAULT 'infinity'::TIMESTAMP WITH TIME ZONE,
    reason_for_change VARCHAR(150),
    recorded_by VARCHAR(50) DEFAULT CURRENT_USER,
    CONSTRAINT chk_valid_time_interval CHECK (valid_to > valid_from)
);

CREATE INDEX IF NOT EXISTS idx_room_tariffs_temporal ON room_tariffs_history (room_id, valid_from, valid_to);

-- --------------------------------------------------------------------------------
-- 2. TRIGGER: AUTOMATIC BI-TEMPORAL TARIFF VERSIONING
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_track_room_tariff_temporal()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.price_per_night IS DISTINCT FROM NEW.price_per_night) THEN
        -- Close the currently active tariff window
        UPDATE room_tariffs_history
        SET valid_to = CURRENT_TIMESTAMP
        WHERE room_id = NEW.room_id AND valid_to = 'infinity'::TIMESTAMP WITH TIME ZONE;

        -- Open a new tariff window
        INSERT INTO room_tariffs_history (room_id, price_per_night, valid_from, valid_to, reason_for_change)
        VALUES (NEW.room_id, NEW.price_per_night, CURRENT_TIMESTAMP, 'infinity'::TIMESTAMP WITH TIME ZONE, 'Dynamic Rate Update via DBMS');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_track_room_tariff_temporal ON rooms;
CREATE TRIGGER trg_track_room_tariff_temporal
AFTER UPDATE ON rooms
FOR EACH ROW EXECUTE FUNCTION fn_track_room_tariff_temporal();

-- --------------------------------------------------------------------------------
-- 3. TIME-TRAVEL QUERY: AS OF TIMESTAMP IN PURE SQL
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_room_rate_as_of(p_room_id INT, p_as_of_time TIMESTAMP WITH TIME ZONE)
RETURNS TABLE (
    room_id INT,
    room_number VARCHAR(10),
    historical_price NUMERIC(10,2),
    valid_start TIMESTAMP WITH TIME ZONE,
    valid_end TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.room_id,
        r.room_number,
        COALESCE(h.price_per_night, r.price_per_night) AS historical_price,
        h.valid_from,
        h.valid_to
    FROM rooms r
    LEFT JOIN room_tariffs_history h 
      ON r.room_id = h.room_id
     AND p_as_of_time >= h.valid_from
     AND p_as_of_time < h.valid_to
    WHERE r.room_id = p_room_id;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------------
-- 4. SEED SAMPLE HISTORICAL TARIFF LOGS
-- --------------------------------------------------------------------------------
INSERT INTO room_tariffs_history (room_id, price_per_night, valid_from, valid_to, reason_for_change)
VALUES
(1, 2800.00, '2026-01-01 00:00:00+00', '2026-06-30 23:59:59+00', 'Base Low-Season Rate'),
(1, 3000.00, '2026-07-01 00:00:00+00', 'infinity'::TIMESTAMP WITH TIME ZONE, 'Peak Summer Luxury Rate'),
(2, 1350.00, '2026-01-01 00:00:00+00', '2026-05-31 23:59:59+00', 'Standard Promotional Rate'),
(2, 1500.00, '2026-06-01 00:00:00+00', 'infinity'::TIMESTAMP WITH TIME ZONE, 'Standard Current Tariff')
ON CONFLICT DO NOTHING;

-- Verification query
SELECT * FROM fn_get_room_rate_as_of(1, '2026-03-15 12:00:00+00');
