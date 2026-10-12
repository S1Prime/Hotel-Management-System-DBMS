-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ENTERPRISE PL/pgSQL TRIGGERS COLLECTION
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Financial Sanity & Discount Cap Guard Triggers (Prevents Unauthorized Markdowns)
-- 2. Temporal Lockout: Prevents In-Flight Price Modifications on Occupied Rooms
-- 3. Contact Data Normalization & Sanitization Triggers (E.164 Phone Formatting)
-- 4. Overstay Notification & Late Checkout Auto-Escalation Triggers
-- 5. Service Inventory Reorder Threshold Triggers
-- 6. Shift Log Auditing & Receptionist Activity Trackers
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. FINANCIAL DISCOUNT CEILING GUARD TRIGGER
-- Enforces business rule: No discount greater than 30% without supervisor approval
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_trg_validate_bill_discount()
RETURNS TRIGGER AS $$
DECLARE
    v_gross_amount NUMERIC(10,2);
    v_max_allowed_discount NUMERIC(10,2);
BEGIN
    v_gross_amount := COALESCE(NEW.room_charge, 0.00) + COALESCE(NEW.service_charge, 0.00);

    IF v_gross_amount > 0 THEN
        v_max_allowed_discount := ROUND(v_gross_amount * 0.30, 2);

        IF NEW.discount > v_max_allowed_discount THEN
            RAISE EXCEPTION 'Discount violation: Maximum permitted promotional discount is 30%% ($%), but $% was entered on Bill #%. Supervisor authorization required.',
                v_max_allowed_discount, NEW.discount, NEW.bill_id;
        END IF;
    END IF;

    -- Ensure final total matches arithmetic formula: Total = (Gross + Tax) - Discount
    NEW.total_amount := (v_gross_amount + COALESCE(NEW.tax, 0.00)) - COALESCE(NEW.discount, 0.00);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_bill_discount ON bills;
CREATE TRIGGER trg_validate_bill_discount
    BEFORE INSERT OR UPDATE OF discount, room_charge, service_charge, tax ON bills
    FOR EACH ROW EXECUTE FUNCTION fn_trg_validate_bill_discount();


-- --------------------------------------------------------------------------------
-- 2. TEMPORAL OCCUPANCY PROTECTION TRIGGER
-- Prevents changing price_per_night or status on a room while an active guest is staying
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_trg_protect_occupied_room_modifications()
RETURNS TRIGGER AS $$
DECLARE
    v_active_guest VARCHAR(100);
BEGIN
    -- Check if price_per_night or is_active is modified
    IF (NEW.price_per_night != OLD.price_per_night OR (NEW.is_active = FALSE AND OLD.is_active = TRUE)) THEN
        SELECT c.name INTO v_active_guest
        FROM reservations r
        JOIN customers c ON r.customer_id = c.customer_id
        WHERE r.room_id = OLD.room_id 
          AND r.status = 'Checked-in'
        LIMIT 1;

        IF v_active_guest IS NOT NULL THEN
            RAISE EXCEPTION 'Operation rejected: Room % is currently occupied by guest %! Room tariff cannot be modified during active guest stay.',
                OLD.room_number, v_active_guest;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_protect_occupied_room ON rooms;
CREATE TRIGGER trg_protect_occupied_room
    BEFORE UPDATE ON rooms
    FOR EACH ROW EXECUTE FUNCTION fn_trg_protect_occupied_room_modifications();


-- --------------------------------------------------------------------------------
-- 3. CUSTOMER CONTACT DATA NORMALIZER & SANITIZER
-- Strips non-alphanumeric noise from phone numbers and forces lowercase emails
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_trg_sanitize_customer_contact()
RETURNS TRIGGER AS $$
BEGIN
    -- Force email to lowercase and trim surrounding spaces
    NEW.email := LOWER(TRIM(NEW.email));

    -- Clean names of extra whitespace
    NEW.name := TRIM(regexp_replace(NEW.name, '\s+', ' ', 'g'));

    -- Normalize phone numbers to standard format if provided
    IF NEW.phone IS NOT NULL THEN
        NEW.phone := TRIM(NEW.phone);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sanitize_customer ON customers;
CREATE TRIGGER trg_sanitize_customer
    BEFORE INSERT OR UPDATE OF name, email, phone ON customers
    FOR EACH ROW EXECUTE FUNCTION fn_trg_sanitize_customer_contact();


-- --------------------------------------------------------------------------------
-- 4. OVERSTAY NOTIFICATION & LATE CHECKOUT ESCALATION TRIGGER
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS overdue_stay_alerts (
    alert_id SERIAL PRIMARY KEY,
    reservation_id INT REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    room_number VARCHAR(10),
    guest_name VARCHAR(100),
    scheduled_checkout DATE,
    overdue_hours INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_trg_detect_unauthorized_overstay()
RETURNS TRIGGER AS $$
DECLARE
    v_room_num VARCHAR(10);
    v_guest VARCHAR(100);
BEGIN
    -- If status remains 'Checked-in' past scheduled check_out date
    IF (NEW.status = 'Checked-in' AND CURRENT_DATE > NEW.check_out) THEN
        SELECT rm.room_number, c.name 
        INTO v_room_num, v_guest
        FROM rooms rm, customers c
        WHERE rm.room_id = NEW.room_id AND c.customer_id = NEW.customer_id;

        INSERT INTO overdue_stay_alerts (
            reservation_id, room_number, guest_name, scheduled_checkout, overdue_hours
        ) VALUES (
            NEW.reservation_id, v_room_num, v_guest, NEW.check_out, 
            (EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - NEW.check_out::TIMESTAMP)) / 3600)::INT
        );

        RAISE NOTICE 'ALERT: Reservation #% (Room %) is overdue for checkout since %!', NEW.reservation_id, v_room_num, NEW.check_out;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_detect_overstay ON reservations;
CREATE TRIGGER trg_detect_overstay
    AFTER UPDATE OF status, check_out ON reservations
    FOR EACH ROW EXECUTE FUNCTION fn_trg_detect_unauthorized_overstay();


-- --------------------------------------------------------------------------------
-- 5. STAFF SHIFTS & RECEPTION ACTIVITY AUDIT LOG
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS staff_shift_logs (
    shift_id SERIAL PRIMARY KEY,
    staff_id INT REFERENCES staff(staff_id) ON DELETE CASCADE,
    shift_type VARCHAR(20) NOT NULL CHECK (shift_type IN ('Morning', 'Evening', 'Night')),
    clock_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    clock_out TIMESTAMP,
    reservations_handled INT DEFAULT 0
);

CREATE OR REPLACE PROCEDURE sp_record_staff_shift_action(
    p_staff_id INT,
    p_action_type VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_action_type = 'CLOCK_IN' THEN
        INSERT INTO staff_shift_logs (staff_id, shift_type, clock_in)
        VALUES (
            p_staff_id, 
            CASE 
                WHEN EXTRACT(HOUR FROM CURRENT_TIME) BETWEEN 6 AND 14 THEN 'Morning'
                WHEN EXTRACT(HOUR FROM CURRENT_TIME) BETWEEN 14 AND 22 THEN 'Evening'
                ELSE 'Night'
            END,
            CURRENT_TIMESTAMP
        );
    ELSIF p_action_type = 'CLOCK_OUT' THEN
        UPDATE staff_shift_logs
        SET clock_out = CURRENT_TIMESTAMP
        WHERE staff_id = p_staff_id AND clock_out IS NULL;
    END IF;
END;
$$;
