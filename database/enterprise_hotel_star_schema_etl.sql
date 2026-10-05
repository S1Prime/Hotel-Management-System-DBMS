-- ============================================================================
-- Crowne Plaza Hotel Management System - Enterprise Star Schema & ETL Pipeline
-- Module: Data Warehouse Modeling, Fact Tables, SCD Type 2 Dimensions, and ETL
-- Architecture: Kimball Dimensional Modeling for Hospitality Business Intelligence
-- ============================================================================

-- SCHEMA DECLARATION
CREATE SCHEMA IF NOT EXISTS dwh;

-- ============================================================================
-- 1. DIMENSION TABLES (Slowly Changing Dimensions - SCD Type 2)
-- ============================================================================

-- Date Dimension (Standard Hospitality Calendar)
CREATE TABLE IF NOT EXISTS dwh.dim_date (
    date_key INT PRIMARY KEY,               -- Format: YYYYMMDD
    full_date DATE NOT NULL UNIQUE,
    day_of_week INT NOT NULL,               -- 1 = Monday, 7 = Sunday
    day_name VARCHAR(15) NOT NULL,
    day_of_month INT NOT NULL,
    day_of_year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN DEFAULT FALSE,
    week_of_year INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    calendar_quarter INT NOT NULL,
    calendar_year INT NOT NULL,
    fiscal_year INT NOT NULL,
    season VARCHAR(15) NOT NULL             -- High, Shoulder, Low
);

-- Guest Dimension with SCD Type 2 (Historical Tracking of Loyalty Tier Changes)
CREATE TABLE IF NOT EXISTS dwh.dim_guest_scd2 (
    guest_dim_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'India',
    loyalty_tier VARCHAR(20) NOT NULL DEFAULT 'Silver',
    preferred_room_type VARCHAR(50),
    vip_status BOOLEAN DEFAULT FALSE,
    valid_from TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP WITH TIME ZONE DEFAULT '9999-12-31 23:59:59+00',
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_dim_guest_lookup ON dwh.dim_guest_scd2 (customer_id, is_current);

-- Room Dimension
CREATE TABLE IF NOT EXISTS dwh.dim_room (
    room_dim_id SERIAL PRIMARY KEY,
    room_id INT NOT NULL UNIQUE,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    floor_number INT NOT NULL,
    bed_configuration VARCHAR(50) NOT NULL,
    view_type VARCHAR(50) NOT NULL,
    base_tariff NUMERIC(10, 2) NOT NULL,
    square_meters INT NOT NULL DEFAULT 40,
    has_balcony BOOLEAN DEFAULT FALSE,
    is_accessible BOOLEAN DEFAULT TRUE
);

-- Service Dimension
CREATE TABLE IF NOT EXISTS dwh.dim_service (
    service_dim_id SERIAL PRIMARY KEY,
    service_id INT NOT NULL UNIQUE,
    service_code VARCHAR(20) NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    service_category VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    is_taxable BOOLEAN DEFAULT TRUE
);

-- ============================================================================
-- 2. FACT TABLES (Grain: Single Reservation, Single Transaction, Daily Occupancy)
-- ============================================================================

-- Fact 1: Daily Room Inventory & Occupancy Snapshot (Periodic Snapshot Fact)
CREATE TABLE IF NOT EXISTS dwh.fact_daily_occupancy (
    snapshot_id BIGSERIAL PRIMARY KEY,
    date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    room_dim_id INT NOT NULL REFERENCES dwh.dim_room(room_dim_id),
    occupancy_status VARCHAR(20) NOT NULL,  -- Occupied, Vacant, Out of Order, Cleaning
    is_occupied INT NOT NULL DEFAULT 0,
    is_available INT NOT NULL DEFAULT 1,
    actual_rate_charged NUMERIC(10, 2) DEFAULT 0.00,
    revpar_contribution NUMERIC(10, 2) DEFAULT 0.00,
    adr_contribution NUMERIC(10, 2) DEFAULT 0.00,
    UNIQUE (date_key, room_dim_id)
);

-- Fact 2: Reservation Lifecycle Fact (Accumulating Snapshot Fact)
CREATE TABLE IF NOT EXISTS dwh.fact_reservation_lifecycle (
    reservation_fact_id BIGSERIAL PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    guest_dim_id INT NOT NULL REFERENCES dwh.dim_guest_scd2(guest_dim_id),
    room_dim_id INT NOT NULL REFERENCES dwh.dim_room(room_dim_id),
    booking_date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    check_in_date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    check_out_date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    actual_checkout_date_key INT REFERENCES dwh.dim_date(date_key),
    lead_time_days INT NOT NULL,
    length_of_stay_nights INT NOT NULL,
    number_of_guests INT NOT NULL DEFAULT 1,
    gross_room_revenue NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    ancillary_services_revenue NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    total_tax_paid NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    discounts_given NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    net_hotel_revenue NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    cancellation_status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

-- Fact 3: Folio Charges Fact (Transactional Fact Table)
CREATE TABLE IF NOT EXISTS dwh.fact_folio_transactions (
    transaction_fact_id BIGSERIAL PRIMARY KEY,
    bill_id INT NOT NULL,
    reservation_id INT NOT NULL,
    guest_dim_id INT NOT NULL REFERENCES dwh.dim_guest_scd2(guest_dim_id),
    transaction_date_key INT NOT NULL REFERENCES dwh.dim_date(date_key),
    service_dim_id INT REFERENCES dwh.dim_service(service_dim_id),
    department VARCHAR(50) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10, 2) NOT NULL,
    line_total NUMERIC(10, 2) NOT NULL,
    tax_amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(30) DEFAULT 'Credit Card'
);

-- ============================================================================
-- 3. ETL POPULATION PROCEDURES (ELT Architecture inside PostgreSQL)
-- ============================================================================

-- Date Dimension Populator
CREATE OR REPLACE PROCEDURE dwh.sp_populate_date_dimension(p_start_year INT, p_end_year INT)
LANGUAGE plpgsql AS $$
DECLARE
    v_curr_date DATE := (p_start_year || '-01-01')::DATE;
    v_end_date DATE := (p_end_year || '-12-31')::DATE;
BEGIN
    WHILE v_curr_date <= v_end_date LOOP
        INSERT INTO dwh.dim_date (
            date_key, full_date, day_of_week, day_name, day_of_month, day_of_year,
            is_weekend, is_holiday, week_of_year, month_number, month_name,
            calendar_quarter, calendar_year, fiscal_year, season
        ) VALUES (
            TO_CHAR(v_curr_date, 'YYYYMMDD')::INT,
            v_curr_date,
            EXTRACT(ISODOW FROM v_curr_date)::INT,
            TO_CHAR(v_curr_date, 'Day'),
            EXTRACT(DAY FROM v_curr_date)::INT,
            EXTRACT(DOY FROM v_curr_date)::INT,
            CASE WHEN EXTRACT(ISODOW FROM v_curr_date) IN (6, 7) THEN TRUE ELSE FALSE END,
            CASE WHEN (EXTRACT(MONTH FROM v_curr_date) = 1 AND EXTRACT(DAY FROM v_curr_date) = 1) OR
                      (EXTRACT(MONTH FROM v_curr_date) = 12 AND EXTRACT(DAY FROM v_curr_date) = 25)
                 THEN TRUE ELSE FALSE END,
            EXTRACT(WEEK FROM v_curr_date)::INT,
            EXTRACT(MONTH FROM v_curr_date)::INT,
            TO_CHAR(v_curr_date, 'Month'),
            EXTRACT(QUARTER FROM v_curr_date)::INT,
            EXTRACT(YEAR FROM v_curr_date)::INT,
            EXTRACT(YEAR FROM v_curr_date)::INT,
            CASE 
                WHEN EXTRACT(MONTH FROM v_curr_date) IN (11, 12, 1, 2) THEN 'High/Peak'
                WHEN EXTRACT(MONTH FROM v_curr_date) IN (3, 4, 9, 10) THEN 'Shoulder'
                ELSE 'Monsoon/Low'
            END
        ) ON CONFLICT (date_key) DO NOTHING;
        
        v_curr_date := v_curr_date + INTERVAL '1 day';
    END LOOP;
END;
$$;

-- Initializing standard hospitality calendar
CALL dwh.sp_populate_date_dimension(2025, 2028);

-- Dimension Synchronizer Procedure
CREATE OR REPLACE PROCEDURE dwh.sp_sync_dimensions()
LANGUAGE plpgsql AS $$
BEGIN
    -- Synchronize Rooms
    INSERT INTO dwh.dim_room (room_id, room_number, room_type, floor_number, bed_configuration, view_type, base_tariff)
    SELECT 
        r.room_id,
        r.room_number,
        r.room_type,
        CASE WHEN r.room_number LIKE '1%' THEN 1 ELSE 2 END,
        CASE WHEN r.room_type ILIKE '%Suite%' THEN 'King Size Bed' ELSE 'Queen Size Bed' END,
        CASE WHEN r.room_type ILIKE '%Balcony%' THEN 'Ocean / Garden View' ELSE 'City View' END,
        r.price_per_night
    FROM public.rooms r
    ON CONFLICT (room_id) DO UPDATE SET
        base_tariff = EXCLUDED.base_tariff,
        room_type = EXCLUDED.room_type;

    -- Synchronize Services
    INSERT INTO dwh.dim_service (service_id, service_code, service_name, service_category, department, unit_price)
    SELECT 
        s.service_id,
        'SVC-' || LPAD(s.service_id::TEXT, 4, '0'),
        s.service_name,
        'Hospitality Amenity',
        'Guest Services',
        s.price
    FROM public.services s
    ON CONFLICT (service_id) DO UPDATE SET
        unit_price = EXCLUDED.unit_price,
        service_name = EXCLUDED.service_name;

    -- Synchronize Guests with SCD Type 2 logic
    INSERT INTO dwh.dim_guest_scd2 (customer_id, full_name, email, phone, loyalty_tier, is_current)
    SELECT 
        c.customer_id,
        c.name,
        c.email,
        c.phone,
        'Gold Elite',
        TRUE
    FROM public.customers c
    WHERE NOT EXISTS (
        SELECT 1 FROM dwh.dim_guest_scd2 g WHERE g.customer_id = c.customer_id AND g.is_current = TRUE
    );
END;
$$;

CALL dwh.sp_sync_dimensions();

-- Fact ETL Pipeline: Sync Reservation Lifecycle
CREATE OR REPLACE PROCEDURE dwh.sp_etl_reservation_lifecycle()
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO dwh.fact_reservation_lifecycle (
        reservation_id, guest_dim_id, room_dim_id,
        booking_date_key, check_in_date_key, check_out_date_key,
        lead_time_days, length_of_stay_nights, number_of_guests,
        gross_room_revenue, ancillary_services_revenue, total_tax_paid,
        discounts_given, net_hotel_revenue, cancellation_status
    )
    SELECT 
        res.reservation_id,
        COALESCE(g.guest_dim_id, 1),
        COALESCE(rm.room_dim_id, 1),
        TO_CHAR(COALESCE(res.booking_date, CURRENT_DATE), 'YYYYMMDD')::INT,
        TO_CHAR(res.check_in, 'YYYYMMDD')::INT,
        TO_CHAR(res.check_out, 'YYYYMMDD')::INT,
        GREATEST(0, (res.check_in - COALESCE(res.booking_date::DATE, CURRENT_DATE))),
        GREATEST(1, (res.check_out - res.check_in)),
        res.number_of_guests,
        COALESCE(b.room_charge, (res.check_out - res.check_in) * r.price_per_night),
        COALESCE(b.service_charge, 0.00),
        COALESCE(b.tax, 0.00),
        COALESCE(b.discount, 0.00),
        COALESCE(b.total_amount, (res.check_out - res.check_in) * r.price_per_night),
        res.status
    FROM public.reservations res
    JOIN public.rooms r ON res.room_id = r.room_id
    LEFT JOIN public.bills b ON res.reservation_id = b.reservation_id
    LEFT JOIN dwh.dim_guest_scd2 g ON res.customer_id = g.customer_id AND g.is_current = TRUE
    LEFT JOIN dwh.dim_room rm ON res.room_id = rm.room_id
    ON CONFLICT (reservation_id) DO UPDATE SET
        gross_room_revenue = EXCLUDED.gross_room_revenue,
        ancillary_services_revenue = EXCLUDED.ancillary_services_revenue,
        total_tax_paid = EXCLUDED.total_tax_paid,
        discounts_given = EXCLUDED.discounts_given,
        net_hotel_revenue = EXCLUDED.net_hotel_revenue,
        cancellation_status = EXCLUDED.cancellation_status;
END;
$$;

CALL dwh.sp_etl_reservation_lifecycle();

-- ============================================================================
-- 4. ANALYTICAL OLAP MARTS (Materialized Views with Automated Refresh)
-- ============================================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS dwh.mv_monthly_hotel_kpis AS
SELECT 
    d.calendar_year,
    d.month_number,
    d.month_name,
    COUNT(f.reservation_fact_id) AS total_bookings,
    SUM(f.length_of_stay_nights) AS total_room_nights_sold,
    ROUND(AVG(f.length_of_stay_nights), 2) AS avg_length_of_stay_alos,
    ROUND(AVG(f.lead_time_days), 1) AS avg_booking_lead_time,
    SUM(f.gross_room_revenue) AS total_room_revenue,
    SUM(f.ancillary_services_revenue) AS total_ancillary_revenue,
    SUM(f.net_hotel_revenue) AS gross_operating_revenue,
    ROUND(SUM(f.gross_room_revenue) / NULLIF(SUM(f.length_of_stay_nights), 0), 2) AS adr_average_daily_rate
FROM dwh.fact_reservation_lifecycle f
JOIN dwh.dim_date d ON f.check_in_date_key = d.date_key
WHERE f.cancellation_status <> 'Cancelled'
GROUP BY d.calendar_year, d.month_number, d.month_name
ORDER BY d.calendar_year DESC, d.month_number DESC;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_monthly_kpis ON dwh.mv_monthly_hotel_kpis (calendar_year, month_number);

-- Refresh procedure
CREATE OR REPLACE PROCEDURE dwh.sp_refresh_olap_marts()
LANGUAGE plpgsql AS $$
BEGIN
    CALL dwh.sp_sync_dimensions();
    CALL dwh.sp_etl_reservation_lifecycle();
    REFRESH MATERIALIZED VIEW CONCURRENTLY dwh.mv_monthly_hotel_kpis;
END;
$$;
