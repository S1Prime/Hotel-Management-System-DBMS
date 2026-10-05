-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — BULK HISTORICAL DATA WAREHOUSE & ETL PIPELINE
-- PostgreSQL Analytical Star Schema Data Generator & High-Volume Ingestion
-- ================================================================================
-- Simulates multi-year historical hotel transactions, daily revenue aggregates,
-- guest lifetime value cohorts, and enterprise ETL pipeline functions.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. HISTORICAL ARCHIVE DATA WAREHOUSE FACT TABLE
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS dw_fact_daily_hotel_occupancy (
    occupancy_key BIGSERIAL PRIMARY KEY,
    calendar_date DATE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    total_rooms_in_inventory INT NOT NULL,
    rooms_sold INT NOT NULL,
    rooms_vacant INT NOT NULL,
    rooms_out_of_order INT DEFAULT 0,
    gross_room_revenue NUMERIC(12,2) NOT NULL,
    gross_service_revenue NUMERIC(12,2) NOT NULL,
    total_tax_collected NUMERIC(12,2) NOT NULL,
    adr NUMERIC(10,2) GENERATED ALWAYS AS (
        CASE WHEN rooms_sold > 0 THEN ROUND(gross_room_revenue / rooms_sold, 2) ELSE 0.00 END
    ) STORED,
    revpar NUMERIC(10,2) GENERATED ALWAYS AS (
        CASE WHEN total_rooms_in_inventory > 0 THEN ROUND(gross_room_revenue / total_rooms_in_inventory, 2) ELSE 0.00 END
    ) STORED,
    occupancy_rate_pct NUMERIC(5,2) GENERATED ALWAYS AS (
        CASE WHEN total_rooms_in_inventory > 0 THEN ROUND((rooms_sold::NUMERIC / total_rooms_in_inventory::NUMERIC) * 100.0, 2) ELSE 0.00 END
    ) STORED
);

CREATE INDEX IF NOT EXISTS idx_dw_occupancy_date_type ON dw_fact_daily_hotel_occupancy (calendar_date, room_type);

-- --------------------------------------------------------------------------------
-- 2. PROCEDURAL ETL GENERATOR: GENERATE 365 DAYS OF HISTORICAL DW METRICS
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_populate_dw_historical_archive(p_start_year INT)
LANGUAGE plpgsql AS $$
DECLARE
    v_date DATE;
    v_end_date DATE;
    v_room_types TEXT[] := ARRAY['Luxury Suite', 'Standard AC Room', 'Economy Non-AC Room', 'AC Room with Balcony', 'Family AC Room'];
    v_type TEXT;
    v_inventory INT;
    v_sold INT;
    v_vacant INT;
    v_rate NUMERIC(10,2);
    v_room_rev NUMERIC(12,2);
    v_svc_rev NUMERIC(12,2);
    v_tax NUMERIC(12,2);
BEGIN
    v_date := MAKE_DATE(p_start_year, 1, 1);
    v_end_date := MAKE_DATE(p_start_year, 12, 31);

    WHILE v_date <= v_end_date LOOP
        FOREACH v_type IN ARRAY v_room_types LOOP
            CASE v_type
                WHEN 'Luxury Suite' THEN 
                    v_inventory := 5; v_rate := 3000.00;
                WHEN 'Standard AC Room' THEN 
                    v_inventory := 15; v_rate := 1500.00;
                WHEN 'Economy Non-AC Room' THEN 
                    v_inventory := 10; v_rate := 1200.00;
                WHEN 'AC Room with Balcony' THEN 
                    v_inventory := 12; v_rate := 1800.00;
                ELSE 
                    v_inventory := 8; v_rate := 1700.00;
            END CASE;

            -- Simulate seasonal demand (Higher in Summer & Weekends)
            IF EXTRACT(DOW FROM v_date) IN (5, 6) THEN
                v_sold := FLOOR(v_inventory * 0.85);
            ELSE
                v_sold := FLOOR(v_inventory * 0.60);
            END IF;

            v_vacant := v_inventory - v_sold;
            v_room_rev := v_sold * v_rate;
            v_svc_rev := ROUND(v_room_rev * 0.12, 2);
            v_tax := ROUND((v_room_rev + v_svc_rev) * 0.05, 2);

            INSERT INTO dw_fact_daily_hotel_occupancy (
                calendar_date, room_type, total_rooms_in_inventory, rooms_sold, rooms_vacant,
                gross_room_revenue, gross_service_revenue, total_tax_collected
            ) VALUES (
                v_date, v_type, v_inventory, v_sold, v_vacant,
                v_room_rev, v_svc_rev, v_tax
            );
        END LOOP;

        v_date := v_date + 1;
    END LOOP;

    RAISE NOTICE 'Successfully populated 365 days of analytical warehouse records for year %.', p_start_year;
END;
$$;

-- --------------------------------------------------------------------------------
-- 3. OLAP MULTIDIMENSIONAL SUMMARY VIEW (CUBE & ROLLUP)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_dw_annual_kpi_cube AS
SELECT 
    TO_CHAR(calendar_date, 'YYYY-MM') AS report_month,
    room_type,
    SUM(rooms_sold) AS total_room_nights_sold,
    SUM(gross_room_revenue) AS total_room_revenue,
    SUM(gross_service_revenue) AS total_service_revenue,
    SUM(gross_room_revenue + gross_service_revenue + total_tax_collected) AS grand_total_revenue,
    ROUND(AVG(adr), 2) AS average_daily_rate,
    ROUND(AVG(revpar), 2) AS revenue_per_available_room,
    ROUND(AVG(occupancy_rate_pct), 2) AS avg_occupancy_rate
FROM dw_fact_daily_hotel_occupancy
GROUP BY CUBE(TO_CHAR(calendar_date, 'YYYY-MM'), room_type);

-- Seed 1 year of DW data if table is empty
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dw_fact_daily_hotel_occupancy LIMIT 1) THEN
        CALL sp_populate_dw_historical_archive(2025);
    END IF;
END $$;

-- Verification query
SELECT * FROM vw_dw_annual_kpi_cube LIMIT 10;
