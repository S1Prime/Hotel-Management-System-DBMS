-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — COMPLETE STANDALONE MASTER SQL SETUP SCRIPT
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Usage Instructions:
-- 1. Open pgAdmin 4 or your preferred SQL editor (DBeaver, DataGrip, psql).
-- 2. Connect to your PostgreSQL server and select/create database: 'hotel_management'.
-- 3. Open this script in the Query Tool and press F5 (Execute).
-- ================================================================================

-- --------------------------------------------------------------------------------
-- STEP 0: CLEAN REBUILD OF PUBLIC SCHEMA
-- --------------------------------------------------------------------------------
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;

-- --------------------------------------------------------------------------------
-- STEP 1: CREATE CORE RELATIONAL ENTITY TABLES
-- --------------------------------------------------------------------------------

-- 1. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(30),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ROOMS TABLE
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night > 0),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Cleaning', 'Maintenance')),
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. STAFF TABLE
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Receptionist')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. RESERVATIONS TABLE
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE CASCADE,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    number_of_guests INT DEFAULT 1 CHECK (number_of_guests > 0),
    special_requests TEXT DEFAULT '',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed' CHECK (status IN ('Pending', 'Booked', 'Confirmed', 'Checked-in', 'Checked-out', 'Cancelled')),
    CONSTRAINT chk_dates CHECK (check_out > check_in)
);

-- 5. SERVICES CATALOG TABLE
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE
);

-- 6. SERVICE REQUESTS TABLE
CREATE TABLE service_requests (
    request_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    service_id INT NOT NULL REFERENCES services(service_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Requested' CHECK (status IN ('Requested', 'Processing', 'Completed', 'Cancelled'))
);

-- 7. BILLS & INVOICES TABLE
CREATE TABLE bills (
    bill_id SERIAL PRIMARY KEY,
    reservation_id INT UNIQUE NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    room_charge NUMERIC(10,2) DEFAULT 0.00 CHECK (room_charge >= 0),
    service_charge NUMERIC(10,2) DEFAULT 0.00 CHECK (service_charge >= 0),
    tax NUMERIC(10,2) DEFAULT 0.00 CHECK (tax >= 0),
    discount NUMERIC(10,2) DEFAULT 0.00 CHECK (discount >= 0),
    total_amount NUMERIC(10,2) DEFAULT 0.00 CHECK (total_amount >= 0),
    bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Paid', 'Cancelled'))
);

-- 8. HOUSEKEEPING TASKS TABLE
CREATE TABLE housekeeping_tasks (
    task_id SERIAL PRIMARY KEY,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE CASCADE,
    task_type VARCHAR(50) DEFAULT 'Cleaning',
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    notes TEXT
);

-- 9. AUDIT LOGS TABLE
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    record_id INT,
    old_data JSONB,
    new_data JSONB,
    changed_by VARCHAR(50) DEFAULT CURRENT_USER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- --------------------------------------------------------------------------------
-- STEP 2: PERFORMANCE INDEXES
-- --------------------------------------------------------------------------------
CREATE INDEX idx_reservations_room_dates ON reservations (room_id, check_in, check_out, status);
CREATE INDEX idx_reservations_customer ON reservations (customer_id);
CREATE INDEX idx_rooms_available ON rooms (room_type, price_per_night) WHERE status = 'Available' AND is_active = TRUE;
CREATE INDEX idx_bills_payment_status ON bills (payment_status, bill_date);
CREATE INDEX idx_housekeeping_queue ON housekeeping_tasks (room_id, status) WHERE status != 'Completed';


-- --------------------------------------------------------------------------------
-- STEP 3: TRIGGERS & BUSINESS RULES
-- --------------------------------------------------------------------------------

-- Trigger 1: Room Cleaning on Checkout
CREATE OR REPLACE FUNCTION fn_checkout_room_cleaning()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Checked-out' AND (OLD.status IS DISTINCT FROM 'Checked-out')) THEN
        UPDATE rooms SET status = 'Cleaning' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_checkout_room_cleaning
AFTER UPDATE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_checkout_room_cleaning();

-- Trigger 2: Revert Room to Available on Cancellation
CREATE OR REPLACE FUNCTION fn_cancel_room_available()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cancelled' AND (OLD.status IS DISTINCT FROM 'Cancelled')) THEN
        UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cancel_room_available
AFTER UPDATE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_cancel_room_available();

-- Trigger 3: Dispatch Housekeeping Task when room becomes 'Cleaning'
CREATE OR REPLACE FUNCTION fn_auto_housekeeping()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cleaning' AND (OLD.status IS DISTINCT FROM 'Cleaning')) THEN
        INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
        VALUES (NEW.room_id, 'Cleaning', 'Pending', 'Auto-created after guest checkout');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_housekeeping
AFTER UPDATE ON rooms
FOR EACH ROW EXECUTE FUNCTION fn_auto_housekeeping();

-- Trigger 4: Audit Logging for Reservations
CREATE OR REPLACE FUNCTION fn_audit_record_change()
RETURNS TRIGGER AS $$
DECLARE
    v_record_id INT;
BEGIN
    IF (TG_OP = 'DELETE') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING OLD INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), NULL, CURRENT_USER);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING NEW INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, to_jsonb(OLD), to_jsonb(NEW), CURRENT_USER);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) USING NEW INTO v_record_id;
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, v_record_id, NULL, to_jsonb(NEW), CURRENT_USER);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_reservations
AFTER INSERT OR UPDATE OR DELETE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_audit_record_change('reservation_id');


-- --------------------------------------------------------------------------------
-- STEP 4: DATABASE VIEWS & MATERIALIZED VIEWS
-- --------------------------------------------------------------------------------

-- View 1: Active Reservations
CREATE OR REPLACE VIEW vw_active_reservations AS
SELECT 
    res.reservation_id,
    c.customer_id,
    c.name AS guest_name,
    c.email AS guest_email,
    c.phone AS guest_phone,
    r.room_id,
    r.room_number,
    r.room_type,
    r.price_per_night,
    res.check_in,
    res.check_out,
    (res.check_out - res.check_in) AS total_nights,
    res.number_of_guests,
    res.special_requests,
    res.status AS reservation_status,
    res.booking_date
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
WHERE res.status IN ('Confirmed', 'Checked-in', 'Booked');

-- View 2: Available Rooms
CREATE OR REPLACE VIEW vw_available_rooms AS
SELECT room_id, room_number, room_type, price_per_night, status
FROM rooms
WHERE status = 'Available' AND is_active = TRUE;

-- View 3: Financial Revenue Breakdown
CREATE OR REPLACE VIEW vw_revenue_summary AS
SELECT 
    r.room_type,
    COUNT(res.reservation_id) AS total_bookings,
    COALESCE(SUM(b.room_charge), 0.00) AS total_room_revenue,
    COALESCE(SUM(b.service_charge), 0.00) AS total_service_revenue,
    COALESCE(SUM(b.tax), 0.00) AS total_tax_collected,
    COALESCE(SUM(b.total_amount), 0.00) AS grand_total_revenue
FROM rooms r
LEFT JOIN reservations res ON r.room_id = res.room_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY r.room_type;

-- View 4: Customer Loyalty Ranking
CREATE OR REPLACE VIEW vw_customer_loyalty_ranking AS
SELECT 
    c.customer_id,
    c.name AS guest_name,
    c.email AS guest_email,
    COUNT(DISTINCT res.reservation_id) AS lifetime_reservations,
    COALESCE(SUM(b.total_amount), 0.00) AS lifetime_expenditure,
    CASE 
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 50000 THEN 'Platinum VIP'
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 25000 THEN 'Gold Preferred'
        WHEN COALESCE(SUM(b.total_amount), 0.00) >= 10000 THEN 'Silver Member'
        ELSE 'Standard Guest'
    END AS loyalty_tier
FROM customers c
LEFT JOIN reservations res ON c.customer_id = res.customer_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY c.customer_id, c.name, c.email;

-- Materialized View: Monthly Financial Performance
CREATE MATERIALIZED VIEW mv_monthly_financial_report AS
SELECT 
    TO_CHAR(b.bill_date, 'YYYY-MM') AS billing_month,
    COUNT(b.bill_id) AS total_invoices,
    SUM(b.room_charge) AS gross_room_revenue,
    SUM(b.service_charge) AS gross_service_revenue,
    SUM(b.tax) AS gross_tax_collected,
    SUM(b.discount) AS total_discounts_granted,
    SUM(b.total_amount) AS net_revenue
FROM bills b
WHERE b.payment_status = 'Paid'
GROUP BY TO_CHAR(b.bill_date, 'YYYY-MM')
ORDER BY billing_month DESC;


-- --------------------------------------------------------------------------------
-- STEP 5: STORED PROCEDURES & FUNCTIONS (PL/pgSQL)
-- --------------------------------------------------------------------------------

-- Function: Calculate Stay Cost
CREATE OR REPLACE FUNCTION fn_calculate_stay_cost(p_room_id INT, p_check_in DATE, p_check_out DATE)
RETURNS NUMERIC AS $$
DECLARE
    v_rate NUMERIC(10,2);
BEGIN
    SELECT price_per_night INTO v_rate FROM rooms WHERE room_id = p_room_id;
    RETURN ROUND(v_rate * (p_check_out - p_check_in), 2);
END;
$$ LANGUAGE plpgsql;

-- Procedure: Atomic Room Reservation with Overlap Validation
CREATE OR REPLACE PROCEDURE sp_create_reservation(
    p_customer_id INT,
    p_room_id INT,
    p_check_in DATE,
    p_check_out DATE,
    p_number_of_guests INT,
    INOUT p_reservation_id INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_conflict_count INT;
BEGIN
    SELECT COUNT(*) INTO v_conflict_count
    FROM reservations
    WHERE room_id = p_room_id
      AND status IN ('Confirmed', 'Checked-in', 'Booked')
      AND check_in < p_check_out
      AND check_out > p_check_in;

    IF v_conflict_count > 0 THEN
        RAISE EXCEPTION 'Room % is already booked for dates % to %', p_room_id, p_check_in, p_check_out;
    END IF;

    INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, status)
    VALUES (p_customer_id, p_room_id, p_check_in, p_check_out, p_number_of_guests, 'Confirmed')
    RETURNING reservation_id INTO p_reservation_id;
END;
$$;

-- Procedure: Checkout and Automated Invoice Generation
CREATE OR REPLACE PROCEDURE sp_process_checkout(
    p_reservation_id INT,
    p_discount_rate NUMERIC DEFAULT 0.00,
    INOUT p_bill_id INT DEFAULT NULL,
    INOUT p_final_total NUMERIC DEFAULT 0.00
)
LANGUAGE plpgsql AS $$
DECLARE
    v_room_id INT;
    v_check_in DATE;
    v_check_out DATE;
    v_rate NUMERIC(10,2);
    v_room_charge NUMERIC(10,2);
    v_service_charge NUMERIC(10,2);
    v_tax NUMERIC(10,2);
    v_discount NUMERIC(10,2);
    v_subtotal NUMERIC(10,2);
BEGIN
    SELECT res.room_id, res.check_in, res.check_out, r.price_per_night
    INTO v_room_id, v_check_in, v_check_out, v_rate
    FROM reservations res
    JOIN rooms r ON res.room_id = r.room_id
    WHERE res.reservation_id = p_reservation_id;

    v_room_charge := ROUND(v_rate * (v_check_out - v_check_in), 2);

    SELECT COALESCE(SUM(s.price * sr.quantity), 0.00)
    INTO v_service_charge
    FROM service_requests sr
    JOIN services s ON sr.service_id = s.service_id
    WHERE sr.reservation_id = p_reservation_id AND sr.status != 'Cancelled';

    v_subtotal := v_room_charge + v_service_charge;
    v_discount := ROUND(v_subtotal * (COALESCE(p_discount_rate, 0.0) / 100.0), 2);
    v_tax := ROUND((v_subtotal - v_discount) * 0.05, 2);
    p_final_total := ROUND((v_subtotal - v_discount) + v_tax, 2);

    INSERT INTO bills (reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status)
    VALUES (p_reservation_id, v_room_charge, v_service_charge, v_tax, v_discount, p_final_total, 'Paid')
    ON CONFLICT (reservation_id) DO UPDATE SET payment_status = 'Paid'
    RETURNING bill_id INTO p_bill_id;

    UPDATE reservations SET status = 'Checked-out' WHERE reservation_id = p_reservation_id;
END;
$$;


-- --------------------------------------------------------------------------------
-- STEP 6: SEED DEMONSTRATION DATA
-- --------------------------------------------------------------------------------

-- Customers
INSERT INTO customers (name, email, phone, password_hash) VALUES
('Test Customer', 'customer@gmail.com', '9876543210', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0'),
('Eleanor Vance', 'eleanor@crowneplaza.com', '+1 (555) 234-5678', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0');

-- Staff
INSERT INTO staff (name, email, password_hash, role, is_active) VALUES
('Arthur Pendelton', 'reception@crowneplaza.com', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'Receptionist', TRUE),
('System Administrator', 'admin@crowneplaza.com', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'Admin', TRUE);

-- Rooms
INSERT INTO rooms (room_number, room_type, price_per_night, status) VALUES
('101', 'Luxury Suite', 3000.00, 'Occupied'),
('102', 'Standard AC Room', 1500.00, 'Available'),
('103', 'Economy Non-AC Room', 1200.00, 'Cleaning'),
('201', 'AC Room with Balcony', 1800.00, 'Occupied'),
('202', 'Family AC Room', 1700.00, 'Available');

-- Services
INSERT INTO services (service_name, price, description, is_available) VALUES
('Gourmet Breakfast in Bed', 1200.00, 'Freshly prepared continental breakfast served to your suite', TRUE),
('Express Laundry Service', 850.00, 'Same-day professional washing and pressing service', TRUE),
('Luxury Spa & Wellness Package', 3500.00, '60-minute relaxing full-body massage therapy', TRUE),
('Extra Rollaway Bed', 1500.00, 'Comfortable twin rollaway bed with premium linens', TRUE);

-- Reservations
INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, status) VALUES
(1, 1, '2026-07-28', '2026-08-02', 2, 'Checked-in'),
(2, 4, '2026-08-10', '2026-08-15', 2, 'Confirmed');

-- Service Requests
INSERT INTO service_requests (reservation_id, service_id, quantity, status) VALUES
(1, 1, 1, 'Completed'),
(1, 2, 1, 'Requested');

-- Bills
INSERT INTO bills (reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status) VALUES
(1, 15000.00, 1200.00, 810.00, 0.00, 17010.00, 'Paid');

-- Refresh materialized view with initial data
REFRESH MATERIALIZED VIEW mv_monthly_financial_report;

-- --------------------------------------------------------------------------------
-- STEP 7: VERIFICATION QUERY
-- --------------------------------------------------------------------------------
SELECT 'Hotel Management System Database setup completed successfully!' AS status,
       (SELECT COUNT(*) FROM customers) AS customers,
       (SELECT COUNT(*) FROM rooms) AS rooms,
       (SELECT COUNT(*) FROM reservations) AS reservations,
       (SELECT COUNT(*) FROM bills) AS bills,
       (SELECT COUNT(*) FROM audit_logs) AS audit_entries;
