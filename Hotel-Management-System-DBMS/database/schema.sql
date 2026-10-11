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
    special_requests TEXT DEFAULT '',
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

ALTER TABLE services ADD COLUMN IF NOT EXISTS service_category VARCHAR(40) NOT NULL DEFAULT 'Other';
ALTER TABLE services ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE services ADD COLUMN IF NOT EXISTS is_vegetarian BOOLEAN;
UPDATE services SET service_category = 'Food' WHERE service_name = 'Gourmet Breakfast in Bed' AND service_category = 'Other';

-- 6. SERVICE REQUESTS TABLE
CREATE TABLE IF NOT EXISTS service_requests (
    request_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    service_id INT NOT NULL REFERENCES services(service_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Requested' CHECK (status IN ('Requested', 'Processing', 'Completed', 'Cancelled'))
);
ALTER TABLE service_requests ADD COLUMN IF NOT EXISTS unit_price NUMERIC(12,2);
UPDATE service_requests sr SET unit_price=s.price FROM services s WHERE s.service_id=sr.service_id AND sr.unit_price IS NULL;
CREATE OR REPLACE FUNCTION fn_snapshot_service_request_price() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.unit_price IS NULL THEN
        SELECT price INTO NEW.unit_price FROM services WHERE service_id=NEW.service_id;
    END IF;
    IF NEW.unit_price IS NULL THEN RAISE EXCEPTION 'Service price could not be resolved.'; END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_snapshot_service_request_price ON service_requests;
CREATE TRIGGER trg_snapshot_service_request_price BEFORE INSERT ON service_requests
FOR EACH ROW EXECUTE FUNCTION fn_snapshot_service_request_price();
ALTER TABLE service_requests ALTER COLUMN unit_price SET NOT NULL;

CREATE TABLE IF NOT EXISTS reservation_expenses (
    expense_id SERIAL PRIMARY KEY,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    expense_type VARCHAR(60) NOT NULL,
    description VARCHAR(250) NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity BETWEEN 1 AND 100),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    total_amount NUMERIC(14,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INT REFERENCES staff(staff_id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_reservation_expenses_reservation ON reservation_expenses(reservation_id, created_at);


-- 7. BILLS & INVOICES TABLE
CREATE TABLE IF NOT EXISTS bills (
    bill_id SERIAL PRIMARY KEY,
    reservation_id INT UNIQUE NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    room_charge NUMERIC(10,2) DEFAULT 0.00 CHECK (room_charge >= 0),
    service_charge NUMERIC(10,2) DEFAULT 0.00 CHECK (service_charge >= 0),
    food_charge NUMERIC(10,2) DEFAULT 0.00 CHECK (food_charge >= 0),
    additional_charge NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (additional_charge >= 0),
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
ALTER TABLE bills ADD COLUMN IF NOT EXISTS food_charge NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (food_charge >= 0);
ALTER TABLE bills ADD COLUMN IF NOT EXISTS additional_charge NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (additional_charge >= 0);
UPDATE bills b SET food_charge = COALESCE((
    SELECT SUM(sr.quantity * sr.unit_price) FROM service_requests sr JOIN services s ON s.service_id = sr.service_id
    WHERE sr.reservation_id = b.reservation_id AND sr.status = 'Completed'
      AND s.service_category IN ('Food','South Indian','North Indian','Chinese','Thai','Continental')
), 0.00) WHERE b.food_charge = 0;

-- 9. LOST & FOUND REPORTS AND UPDATE HISTORY
CREATE TABLE IF NOT EXISTS lost_found_reports (
    report_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    item_name VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    lost_location VARCHAR(200) NOT NULL,
    lost_at TIMESTAMP NOT NULL,
    image_path TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'Lost' CHECK (status IN ('Lost', 'Found', 'Returned', 'Closed')),
    remarks TEXT DEFAULT '',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lost_found_updates (
    update_id SERIAL PRIMARY KEY,
    report_id INT NOT NULL REFERENCES lost_found_reports(report_id) ON DELETE CASCADE,
    actor_role VARCHAR(20) NOT NULL CHECK (actor_role IN ('Customer', 'Receptionist', 'Admin')),
    message TEXT NOT NULL,
    status VARCHAR(20) CHECK (status IS NULL OR status IN ('Lost', 'Found', 'Returned', 'Closed')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_lost_found_reports_status_created ON lost_found_reports(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_lost_found_updates_report ON lost_found_updates(report_id, created_at);

-- 10. SPECIAL OFFERS AND RESERVATION-SCOPED CLAIMS
CREATE TABLE IF NOT EXISTS special_offers (
    offer_id SERIAL PRIMARY KEY,
    offer_code VARCHAR(40) UNIQUE NOT NULL,
    offer_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    discount_percent NUMERIC(5,2) NOT NULL CHECK (discount_percent > 0 AND discount_percent <= 100),
    applicable_to VARCHAR(30) NOT NULL CHECK (applicable_to IN ('Room Charges', 'Eligible Food Charges')),
    eligibility_rule TEXT NOT NULL,
    requires_evidence BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS special_offer_claims (
    claim_id SERIAL PRIMARY KEY,
    offer_id INT NOT NULL REFERENCES special_offers(offer_id),
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    reservation_id INT NOT NULL REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    evidence_path TEXT,
    status VARCHAR(24) NOT NULL CHECK (status IN ('Eligible', 'Pending Verification', 'Approved', 'Rejected', 'Applied')),
    eligibility_details TEXT NOT NULL DEFAULT '',
    previous_completed_stays INT,
    stay_nights INT,
    remarks TEXT NOT NULL DEFAULT '',
    claimed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP,
    verified_by INT REFERENCES staff(staff_id) ON DELETE SET NULL,
    bill_id INT REFERENCES bills(bill_id) ON DELETE SET NULL,
    applied_charge NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (applied_charge >= 0),
    applied_discount NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (applied_discount >= 0),
    UNIQUE (offer_id, reservation_id)
);
CREATE INDEX IF NOT EXISTS idx_special_offer_claims_reservation ON special_offer_claims(reservation_id, status);
CREATE INDEX IF NOT EXISTS idx_special_offer_claims_status ON special_offer_claims(status, claimed_at DESC);

INSERT INTO special_offers (offer_code, offer_name, description, discount_percent, applicable_to, eligibility_rule, requires_evidence)
VALUES
    ('STUDENT15', 'Student Offer', 'Save 15% on the room tariff after reception verifies a valid college or student ID.', 15, 'Room Charges', 'Guest submits valid student ID evidence; receptionist approval is required.', TRUE),
    ('DINING25', 'Food & Dining Offer', 'Save 25% on completed food menu orders charged to the reservation.', 25, 'Eligible Food Charges', 'Automatically applies at checkout to completed food menu charges only; complimentary breakfast and non-food services are excluded.', FALSE),
    ('FREQUENT10', 'Frequent Visitor Offer', 'Save 10% on room charges after at least three previous completed hotel stays.', 10, 'Room Charges', 'At least 3 earlier reservations with Checked-out status and checkout on or before this stay check-in.', FALSE),
    ('LONGSTAY15', 'Long Stay Offer', 'Save 15% on room charges for stays of five nights or longer.', 15, 'Room Charges', 'Automatically qualifies when this reservation is 5 or more nights.', FALSE)
ON CONFLICT (offer_code) DO UPDATE SET
    offer_name = EXCLUDED.offer_name,
    description = EXCLUDED.description,
    discount_percent = EXCLUDED.discount_percent,
    applicable_to = EXCLUDED.applicable_to,
    eligibility_rule = EXCLUDED.eligibility_rule,
    requires_evidence = EXCLUDED.requires_evidence;

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
    res.special_requests,
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
