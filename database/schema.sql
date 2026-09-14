-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM - DATABASE SCHEMA (POSTGRESQL)
-- ================================================================================

-- 1. CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(30),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ROOMS TABLE
CREATE TABLE IF NOT EXISTS rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night > 0),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Cleaning', 'Maintenance')),
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. STAFF TABLE
CREATE TABLE IF NOT EXISTS staff (
    staff_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Receptionist')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. RESERVATIONS TABLE
CREATE TABLE IF NOT EXISTS reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE CASCADE,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    number_of_guests INT DEFAULT 1 CHECK (number_of_guests > 0),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Confirmed' CHECK (status IN ('Pending', 'Booked', 'Confirmed', 'Checked-in', 'Checked-out', 'Cancelled')),
    CONSTRAINT chk_dates CHECK (check_out > check_in)
);

-- 5. HOTEL SERVICES CATALOG
CREATE TABLE IF NOT EXISTS services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE
);

-- 6. SERVICE REQUESTS TABLE
CREATE TABLE IF NOT EXISTS service_requests (
    request_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    service_id INT NOT NULL REFERENCES services(service_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Requested' CHECK (status IN ('Requested', 'Processing', 'Completed', 'Cancelled'))
);

-- 7. BILLS & INVOICES TABLE
CREATE TABLE IF NOT EXISTS bills (
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
CREATE TABLE IF NOT EXISTS housekeeping_tasks (
    task_id SERIAL PRIMARY KEY,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE CASCADE,
    task_type VARCHAR(50) DEFAULT 'Cleaning',
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'In Progress', 'Completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    notes TEXT
);

-- ================================================================================
-- DATABASE VIEWS
-- ================================================================================

-- View 1: Active Reservations with Guest & Room Details
DROP VIEW IF EXISTS vw_active_reservations CASCADE;
CREATE VIEW vw_active_reservations AS
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
    res.status AS reservation_status,
    res.booking_date
FROM reservations res
JOIN customers c ON res.customer_id = c.customer_id
JOIN rooms r ON res.room_id = r.room_id
WHERE res.status IN ('Confirmed', 'Checked-in', 'Booked');

-- View 2: Available Rooms Catalog
DROP VIEW IF EXISTS vw_available_rooms CASCADE;
CREATE VIEW vw_available_rooms AS
SELECT 
    room_id,
    room_number,
    room_type,
    price_per_night,
    status
FROM rooms
WHERE status = 'Available' AND is_active = TRUE;

-- View 3: Financial & Revenue Summary per Room Category
DROP VIEW IF EXISTS vw_revenue_summary CASCADE;
CREATE VIEW vw_revenue_summary AS
SELECT 
    r.room_type,
    COUNT(res.reservation_id) AS total_bookings,
    COALESCE(SUM(b.room_charge), 0.00) AS total_room_revenue,
    COALESCE(SUM(b.service_charge), 0.00) AS total_service_revenue,
    COALESCE(SUM(b.total_amount), 0.00) AS grand_total_revenue
FROM rooms r
LEFT JOIN reservations res ON r.room_id = res.room_id
LEFT JOIN bills b ON res.reservation_id = b.reservation_id AND b.payment_status = 'Paid'
GROUP BY r.room_type;

-- ================================================================================
-- POSTGRESQL TRIGGERS & TRIGGER FUNCTIONS
-- ================================================================================

-- Trigger Function 1: Set Room status to 'Cleaning' when Guest Checks Out
CREATE OR REPLACE FUNCTION fn_checkout_room_cleaning()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Checked-out' AND OLD.status != 'Checked-out') THEN
        UPDATE rooms SET status = 'Cleaning' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_checkout_room_cleaning ON reservations;
CREATE TRIGGER trg_checkout_room_cleaning
AFTER UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION fn_checkout_room_cleaning();


-- Trigger Function 2: Revert Room status to 'Available' when Reservation Cancelled
CREATE OR REPLACE FUNCTION fn_cancel_room_available()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cancelled' AND OLD.status != 'Cancelled') THEN
        UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cancel_room_available ON reservations;
CREATE TRIGGER trg_cancel_room_available
AFTER UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION fn_cancel_room_available();


-- Trigger Function 3: Automatically create Housekeeping Task when Room becomes 'Cleaning'
CREATE OR REPLACE FUNCTION fn_auto_housekeeping()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cleaning' AND OLD.status != 'Cleaning') THEN
        INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
        VALUES (NEW.room_id, 'Cleaning', 'Pending', 'Auto-created after guest checkout');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_housekeeping ON rooms;
CREATE TRIGGER trg_auto_housekeeping
AFTER UPDATE ON rooms
FOR EACH ROW
EXECUTE FUNCTION fn_auto_housekeeping();