-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — GEOSPATIAL & CONCIERGE PROXIMITY ANALYTICS IN SQL
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Pure SQL Great-Circle Distance Calculation (Haversine & Spherical Law of Cosines)
-- 2. Local Tourist Attraction Proximity & Shuttle Dispatch Routing
-- 3. Geo-Fenced Guest Transportation Cost Estimation Engine
-- 4. Concierge VIP Tour Recommendation Ranking Queries
-- ================================================================================

-- Table: Nearby City Attractions & Transit Hubs
CREATE TABLE IF NOT EXISTS local_attractions (
    attraction_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    estimated_visit_hours NUMERIC(3,1) DEFAULT 2.0,
    is_shuttle_accessible BOOLEAN DEFAULT TRUE
);

-- Hotel coordinates (Reference Point: Crowne Plaza Central Hub)
-- Lat: 40.7580, Lon: -73.9855 (Times Square / Central NYC benchmark)
INSERT INTO local_attractions (name, category, latitude, longitude, estimated_visit_hours, is_shuttle_accessible)
VALUES 
    ('International Airport Terminal 1', 'Airport Hub', 40.6413, -73.7781, 1.0, TRUE),
    ('Grand Central Railway Station', 'Transit Hub', 40.7527, -73.9772, 0.5, TRUE),
    ('Metropolitan Museum of Art', 'Culture & Art', 40.7794, -73.9632, 3.5, TRUE),
    ('Broadway Theatre District', 'Entertainment', 40.7590, -73.9845, 2.5, TRUE),
    ('Central Park Conservatory', 'Nature & Leisure', 40.7925, -73.9535, 2.0, FALSE)
ON CONFLICT DO NOTHING;

-- --------------------------------------------------------------------------------
-- 1. HAVERSINE FORMULA IN PURE ANSI SQL (KM DISTANCE COMPUTATION)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calculate_haversine_distance(
    lat1 NUMERIC, lon1 NUMERIC,
    lat2 NUMERIC, lon2 NUMERIC
)
RETURNS NUMERIC AS $$
DECLARE
    r CONSTANT NUMERIC := 6371.0; -- Earth mean radius in kilometers
    dlat NUMERIC;
    dlon NUMERIC;
    a NUMERIC;
    c NUMERIC;
BEGIN
    dlat := radians(lat2 - lat1);
    dlon := radians(lon2 - lon1);

    a := sin(dlat / 2.0)^2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon / 2.0)^2;
    c := 2.0 * atan2(sqrt(a), sqrt(1.0 - a));

    RETURN ROUND(r * c, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- --------------------------------------------------------------------------------
-- 2. CONCIERGE PROXIMITY & SHUTTLE DISPATCH REPORT VIEW
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_concierge_attraction_matrix AS
SELECT 
    attraction_id,
    name AS attraction_name,
    category,
    fn_calculate_haversine_distance(40.7580, -73.9855, latitude, longitude) AS distance_km_from_hotel,
    ROUND(fn_calculate_haversine_distance(40.7580, -73.9855, latitude, longitude) * 0.621371, 2) AS distance_miles,
    ROUND(
        (fn_calculate_haversine_distance(40.7580, -73.9855, latitude, longitude) * 2.50) + 10.00, 
        2
    ) AS estimated_hotel_shuttle_fare,
    is_shuttle_accessible
FROM local_attractions
ORDER BY distance_km_from_hotel ASC;
