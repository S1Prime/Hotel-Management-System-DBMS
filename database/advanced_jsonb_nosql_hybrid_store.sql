-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ADVANCED JSONB & HYBRID DOCUMENT STORE IN SQL
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Semi-Structured JSONB Storage for IoT Smart Room Sensors & Guest Preferences
-- 2. Generalized Inverted Indexes (GIN) on Nested JSONB Objects
-- 3. SQL/JSON Path Language Expressions (jsonb_path_query, jsonb_path_exists)
-- 4. In-Database JSON Schema Check Constraints
-- 5. High-Performance JSON Aggregations (jsonb_agg, jsonb_object_agg)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: HYBRID SEMI-STRUCTURED STORAGE FOR IOT ROOM AUTOMATION
-- --------------------------------------------------------------------------------

-- Table: Smart Room IoT Telemetry & Environmental Sensors
CREATE TABLE IF NOT EXISTS room_iot_telemetry (
    telemetry_id BIGSERIAL PRIMARY KEY,
    room_id INT REFERENCES rooms(room_id) ON DELETE CASCADE,
    recorded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    environmental_data JSONB NOT NULL,
    CONSTRAINT chk_valid_iot_payload CHECK (
        environmental_data ? 'temperature_celsius' AND 
        environmental_data ? 'humidity_pct' AND
        environmental_data ? 'occupancy_detected'
    )
);

-- Generalized Inverted Index (GIN) using jsonb_path_ops for lightning fast existence/containment lookups
CREATE INDEX IF NOT EXISTS idx_gin_iot_telemetry 
    ON room_iot_telemetry USING GIN (environmental_data jsonb_path_ops);

-- Seed sample telemetry records
INSERT INTO room_iot_telemetry (room_id, environmental_data)
SELECT 
    rm.room_id,
    jsonb_build_object(
        'temperature_celsius', ROUND((21.0 + (random() * 4.0))::NUMERIC, 1),
        'humidity_pct', ROUND((40.0 + (random() * 20.0))::NUMERIC, 1),
        'occupancy_detected', CASE WHEN rm.status = 'Occupied' THEN TRUE ELSE FALSE END,
        'smart_hvac_mode', 'ECO_AUTO',
        'connected_devices', jsonb_build_array('AirConditioner_V3', 'SmartLock_Pro', 'AmbientLights')
    )
FROM rooms rm
LIMIT 20;


-- --------------------------------------------------------------------------------
-- SECTION 2: ADVANCED SQL/JSON PATH EXPRESSIONS & QUERIES
-- --------------------------------------------------------------------------------

-- 2.1 Containment Operator (@>) Lookup
-- Find all rooms where the temperature exceeds 23°C or occupancy is actively detected
SELECT 
    t.telemetry_id,
    rm.room_number,
    rm.room_type,
    t.environmental_data->>'temperature_celsius' AS room_temp,
    t.environmental_data->>'humidity_pct' AS humidity,
    t.recorded_at
FROM room_iot_telemetry t
JOIN rooms rm ON t.room_id = rm.room_id
WHERE t.environmental_data @> '{"occupancy_detected": true}';

-- 2.2 Modern SQL/JSON Path Engine (jsonb_path_query)
SELECT 
    t.telemetry_id,
    rm.room_number,
    jsonb_path_query(t.environmental_data, '$.connected_devices[*]') AS device_id
FROM room_iot_telemetry t
JOIN rooms rm ON t.room_id = rm.room_id;


-- --------------------------------------------------------------------------------
-- SECTION 3: JSON AGGREGATION & API PAYLOAD GENERATION ENGINES
-- Transforms relational tabular rows directly into nested JSON REST API responses in SQL!
-- --------------------------------------------------------------------------------

-- Query: Produces complete hierarchical guest reservation portfolio as a single JSON document
CREATE OR REPLACE VIEW vw_guest_portfolio_json AS
SELECT 
    c.customer_id,
    c.name AS guest_name,
    c.email,
    jsonb_build_object(
        'customer_id', c.customer_id,
        'profile', jsonb_build_object('name', c.name, 'email', c.email, 'phone', c.phone),
        'reservation_history', COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'reservation_id', r.reservation_id,
                    'room_number', rm.room_number,
                    'room_type', rm.room_type,
                    'check_in', r.check_in,
                    'check_out', r.check_out,
                    'status', r.status,
                    'folio_total', b.total_amount,
                    'payment_status', b.payment_status
                )
            ) FILTER (WHERE r.reservation_id IS NOT NULL), 
            '[]'::jsonb
        )
    ) AS full_guest_dossier_json
FROM customers c
LEFT JOIN reservations r ON c.customer_id = r.customer_id
LEFT JOIN rooms rm ON r.room_id = rm.room_id
LEFT JOIN bills b ON r.reservation_id = b.reservation_id
GROUP BY c.customer_id, c.name, c.email;
