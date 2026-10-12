-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DATA WAREHOUSING STAR SCHEMA & ETL PIPELINE
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Dimensional Modeling: Star Schema Architecture (Fact & Dimension Tables)
-- 2. Slowly Changing Dimensions (SCD Type 2 with valid_from, valid_to, is_current)
-- 3. Surrogate Key Generation & Conformed Dimensions
-- 4. In-Database SQL ETL Pipeline (sp_run_star_schema_etl)
-- 5. OLAP Slicing, Dicing, and Drill-Down Analytical Queries
-- ================================================================================

-- Create dedicated analytical data warehouse schema
CREATE SCHEMA IF NOT EXISTS dw_hotel;

-- --------------------------------------------------------------------------------
-- SECTION 1: DIMENSION TABLES
-- --------------------------------------------------------------------------------

-- 1.1 Conformed Date Dimension (Calendar Attributes)
CREATE TABLE IF NOT EXISTS dw_hotel.dim_date (
    date_key INT PRIMARY KEY, -- e.g. 20260315
    full_date DATE UNIQUE NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(15) NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    calendar_month INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    calendar_quarter INT NOT NULL,
    quarter_name VARCHAR(10) NOT NULL,
    calendar_year INT NOT NULL
);

-- 1.2 Customer Dimension with Slowly Changing Dimensions (SCD Type 2)
CREATE TABLE IF NOT EXISTS dw_hotel.dim_customer (
    customer_dw_key BIGSERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    guest_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    loyalty_tier VARCHAR(20) DEFAULT 'Bronze',
    valid_from TIMESTAMP NOT NULL,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_dim_customer_lookup ON dw_hotel.dim_customer (customer_id, is_current);

-- 1.3 Room Dimension
CREATE TABLE IF NOT EXISTS dw_hotel.dim_room (
    room_dw_key BIGSERIAL PRIMARY KEY,
    room_id INT UNIQUE NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL,
    floor_number INT NOT NULL
);

-- 1.4 Service Catalog Dimension
CREATE TABLE IF NOT EXISTS dw_hotel.dim_service (
    service_dw_key BIGSERIAL PRIMARY KEY,
    service_id INT UNIQUE NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    standard_price NUMERIC(10,2) NOT NULL
);


-- --------------------------------------------------------------------------------
-- SECTION 2: FACT TABLE (GRAIN: ONE COMPLETED RESERVATION STAY)
-- --------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dw_hotel.fact_hotel_stays (
    stay_fact_id BIGSERIAL PRIMARY KEY,
    reservation_id INT UNIQUE NOT NULL,
    customer_dw_key BIGINT REFERENCES dw_hotel.dim_customer(customer_dw_key),
    room_dw_key BIGINT REFERENCES dw_hotel.dim_room(room_dw_key),
    check_in_date_key INT REFERENCES dw_hotel.dim_date(date_key),
    check_out_date_key INT REFERENCES dw_hotel.dim_date(date_key),
    -- Additive Measures
    length_of_stay_nights INT NOT NULL,
    number_of_guests INT NOT NULL,
    gross_room_charge NUMERIC(10,2) NOT NULL,
    gross_services_charge NUMERIC(10,2) NOT NULL,
    statutory_tax_charge NUMERIC(10,2) NOT NULL,
    promotional_discount NUMERIC(10,2) NOT NULL,
    net_total_revenue NUMERIC(10,2) NOT NULL,
    -- Non-Additive Metrics
    profit_margin_pct NUMERIC(5,2) DEFAULT 35.00
);


-- --------------------------------------------------------------------------------
-- SECTION 3: IN-DATABASE ETL PIPELINE PROCEDURE
-- --------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE dw_hotel.sp_populate_star_schema_etl()
LANGUAGE plpgsql AS $$
DECLARE
    v_rows_loaded INT := 0;
BEGIN
    RAISE NOTICE 'Step 1: Populating Date Dimension for the current multi-year horizon...';
    
    INSERT INTO dw_hotel.dim_date (
        date_key, full_date, day_of_week, day_name, is_weekend, 
        calendar_month, month_name, calendar_quarter, quarter_name, calendar_year
    )
    SELECT 
        TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
        d::DATE AS full_date,
        EXTRACT(ISODOW FROM d)::INT AS day_of_week,
        TO_CHAR(d, 'Day') AS day_name,
        CASE WHEN EXTRACT(ISODOW FROM d) IN (6, 7) THEN TRUE ELSE FALSE END AS is_weekend,
        EXTRACT(MONTH FROM d)::INT AS calendar_month,
        TO_CHAR(d, 'Month') AS month_name,
        EXTRACT(QUARTER FROM d)::INT AS calendar_quarter,
        'Q' || EXTRACT(QUARTER FROM d)::TEXT AS quarter_name,
        EXTRACT(YEAR FROM d)::INT AS calendar_year
    FROM generate_series('2024-01-01'::DATE, '2027-12-31'::DATE, '1 day'::INTERVAL) d
    ON CONFLICT (date_key) DO NOTHING;

    RAISE NOTICE 'Step 2: Syncing Room Dimension...';
    INSERT INTO dw_hotel.dim_room (room_id, room_number, room_type, price_per_night, floor_number)
    SELECT 
        room_id,
        room_number,
        room_type,
        price_per_night,
        LEFT(room_number, 1)::INT AS floor_number
    FROM public.rooms
    ON CONFLICT (room_id) DO UPDATE SET
        price_per_night = EXCLUDED.price_per_night,
        room_type = EXCLUDED.room_type;

    RAISE NOTICE 'Step 3: Syncing Customer Dimension (SCD Type 2 snapshot)...';
    INSERT INTO dw_hotel.dim_customer (customer_id, guest_name, email, phone, valid_from, is_current)
    SELECT 
        customer_id, name, email, phone, CURRENT_TIMESTAMP, TRUE
    FROM public.customers
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Step 4: Loading Fact Table from OLTP core ledger...';
    INSERT INTO dw_hotel.fact_hotel_stays (
        reservation_id, customer_dw_key, room_dw_key, check_in_date_key, check_out_date_key,
        length_of_stay_nights, number_of_guests, gross_room_charge, gross_services_charge,
        statutory_tax_charge, promotional_discount, net_total_revenue
    )
    SELECT 
        r.reservation_id,
        dc.customer_dw_key,
        dr.room_dw_key,
        TO_CHAR(r.check_in, 'YYYYMMDD')::INT,
        TO_CHAR(r.check_out, 'YYYYMMDD')::INT,
        (r.check_out - r.check_in),
        r.number_of_guests,
        COALESCE(b.room_charge, 0.00),
        COALESCE(b.service_charge, 0.00),
        COALESCE(b.tax, 0.00),
        COALESCE(b.discount, 0.00),
        COALESCE(b.total_amount, 0.00)
    FROM public.reservations r
    JOIN dw_hotel.dim_customer dc ON r.customer_id = dc.customer_id AND dc.is_current = TRUE
    JOIN dw_hotel.dim_room dr ON r.room_id = dr.room_id
    LEFT JOIN public.bills b ON r.reservation_id = b.reservation_id
    WHERE r.status IN ('Checked-out', 'Checked-in', 'Confirmed')
    ON CONFLICT (reservation_id) DO UPDATE SET
        net_total_revenue = EXCLUDED.net_total_revenue,
        gross_room_charge = EXCLUDED.gross_room_charge;

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;
    RAISE NOTICE 'ETL Execution concluded: % stay facts processed into Star Schema.', v_rows_loaded;
END;
$$;


-- --------------------------------------------------------------------------------
-- SECTION 4: OLAP MULTIDIMENSIONAL SLICE & DICE QUERIES
-- --------------------------------------------------------------------------------

-- Slicing: Revenue across Weekend vs Weekday stays by Room Category
SELECT 
    dr.room_type,
    dd.is_weekend,
    COUNT(f.stay_fact_id) AS total_stays,
    SUM(f.net_total_revenue) AS aggregated_revenue,
    ROUND(AVG(f.net_total_revenue), 2) AS avg_revenue_per_stay
FROM dw_hotel.fact_hotel_stays f
JOIN dw_hotel.dim_room dr ON f.room_dw_key = dr.room_dw_key
JOIN dw_hotel.dim_date dd ON f.check_in_date_key = dd.date_key
GROUP BY dr.room_type, dd.is_weekend
ORDER BY dr.room_type, dd.is_weekend;
