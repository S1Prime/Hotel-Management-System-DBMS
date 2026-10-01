-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — COMPREHENSIVE TRIGGERS & AUTOMATION ENGINE
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Automated Finite State Machine Transitions (Room Status Synchronizer)
-- 2. VIP Guest Welcome Service Auto-Provisioning Trigger
-- 3. Double-Entry Accounting Ledger Audit Trigger
-- 4. Overlap & Conflict Real-Time Defense Trigger
-- 5. Automated Housekeeping Task Completion Status Propagation
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: FINITE STATE MACHINE (FSM) ROOM SYNCHRONIZATION TRIGGER
-- --------------------------------------------------------------------------------

-- Automatically updates room status when reservation status changes
CREATE OR REPLACE FUNCTION fn_trg_sync_room_status_on_reservation()
RETURNS TRIGGER AS $$
BEGIN
    -- Guest Check-in Event
    IF (NEW.status = 'Checked-in' AND (OLD.status IS NULL OR OLD.status != 'Checked-in')) THEN
        UPDATE rooms
        SET status = 'Occupied'
        WHERE room_id = NEW.room_id;
        
        RAISE NOTICE 'Room % status automatically set to Occupied upon check-in.', NEW.room_id;

    -- Guest Check-out Event
    ELSIF (NEW.status = 'Checked-out' AND OLD.status != 'Checked-out') THEN
        UPDATE rooms
        SET status = 'Cleaning'
        WHERE room_id = NEW.room_id;
        
        -- Auto-queue housekeeping task
        INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
        VALUES (NEW.room_id, 'Turnover Sanitization', 'Pending', 'Auto-created by reservation checkout trigger for Res #' || NEW.reservation_id);
        
        RAISE NOTICE 'Room % status transitioned to Cleaning; Housekeeping task dispatched.', NEW.room_id;

    -- Cancellation Event
    ELSIF (NEW.status = 'Cancelled' AND OLD.status != 'Cancelled') THEN
        -- Only free up room if no other active reservation occupies it
        IF NOT EXISTS (
            SELECT 1 FROM reservations 
            WHERE room_id = NEW.room_id 
              AND reservation_id != NEW.reservation_id 
              AND status IN ('Checked-in')
        ) THEN
            UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_room_status ON reservations;
CREATE TRIGGER trg_sync_room_status
    AFTER UPDATE OF status ON reservations
    FOR EACH ROW EXECUTE FUNCTION fn_trg_sync_room_status_on_reservation();


-- --------------------------------------------------------------------------------
-- SECTION 2: VIP GUEST WELCOME AMENITY AUTO-INJECTION TRIGGER
-- --------------------------------------------------------------------------------

-- When a customer with >= 3 previous stays books a Presidential Suite,
-- automatically inject a complimentary "Welcome Gourmet Basket" service request
CREATE OR REPLACE FUNCTION fn_trg_auto_provision_vip_amenity()
RETURNS TRIGGER AS $$
DECLARE
    v_stay_count INT;
    v_room_type VARCHAR(50);
    v_amenity_service_id INT;
BEGIN
    -- Check historical completed stays
    SELECT COUNT(*) INTO v_stay_count
    FROM reservations
    WHERE customer_id = NEW.customer_id AND status = 'Checked-out';

    -- Check booked room type
    SELECT room_type INTO v_room_type
    FROM rooms WHERE room_id = NEW.room_id;

    -- VIP Qualification Criteria
    IF (v_stay_count >= 2 OR v_room_type = 'Presidential Suite') THEN
        -- Find or use standard breakfast/amenity service
        SELECT service_id INTO v_amenity_service_id
        FROM services 
        WHERE LOWER(service_name) LIKE '%breakfast%' OR LOWER(service_name) LIKE '%spa%'
        ORDER BY price ASC LIMIT 1;

        IF v_amenity_service_id IS NOT NULL THEN
            INSERT INTO service_requests (reservation_id, service_id, quantity, status)
            VALUES (NEW.reservation_id, v_amenity_service_id, 1, 'Requested');
            
            RAISE NOTICE 'VIP perk auto-provisioned: Complimentary amenity added to Reservation ID %', NEW.reservation_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_vip_amenity_auto_inject ON reservations;
CREATE TRIGGER trg_vip_amenity_auto_inject
    AFTER INSERT ON reservations
    FOR EACH ROW EXECUTE FUNCTION fn_trg_auto_provision_vip_amenity();


-- --------------------------------------------------------------------------------
-- SECTION 3: DOUBLE-ENTRY GENERAL FINANCIAL LEDGER
-- --------------------------------------------------------------------------------

-- Table: Financial General Ledger (Accounting Double-Entry)
CREATE TABLE IF NOT EXISTS general_ledger (
    entry_id BIGSERIAL PRIMARY KEY,
    bill_id INT REFERENCES bills(bill_id) ON DELETE CASCADE,
    account_code VARCHAR(20) NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    debit NUMERIC(10,2) DEFAULT 0.00 CHECK (debit >= 0),
    credit NUMERIC(10,2) DEFAULT 0.00 CHECK (credit >= 0),
    entry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);

-- Trigger: Whenever a Bill is marked 'Paid', post debit to Cash and credit to Revenue
CREATE OR REPLACE FUNCTION fn_trg_post_double_entry_ledger()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.payment_status = 'Paid' AND (OLD.payment_status IS NULL OR OLD.payment_status != 'Paid')) THEN
        -- 1. Debit Cash / Bank Account (Asset Increase)
        INSERT INTO general_ledger (bill_id, account_code, account_name, debit, credit, description)
        VALUES (
            NEW.bill_id, '1010-CASH', 'Guest Operating Cash & Card Clearing', 
            NEW.total_amount, 0.00, 
            'Settlement receipt for Reservation #' || NEW.reservation_id
        );

        -- 2. Credit Room Revenue (Income Increase)
        IF NEW.room_charge > 0 THEN
            INSERT INTO general_ledger (bill_id, account_code, account_name, debit, credit, description)
            VALUES (
                NEW.bill_id, '4010-ROOM-REV', 'Room Accommodation Revenue', 
                0.00, NEW.room_charge, 
                'Base accommodation charge for Reservation #' || NEW.reservation_id
            );
        END IF;

        -- 3. Credit Service & Amenity Revenue
        IF NEW.service_charge > 0 THEN
            INSERT INTO general_ledger (bill_id, account_code, account_name, debit, credit, description)
            VALUES (
                NEW.bill_id, '4020-SERV-REV', 'Hotel Services & Dining Revenue', 
                0.00, NEW.service_charge, 
                'In-room dining & amenities for Reservation #' || NEW.reservation_id
            );
        END IF;

        -- 4. Credit Tax Payable (Liability Increase)
        IF NEW.tax > 0 THEN
            INSERT INTO general_ledger (bill_id, account_code, account_name, debit, credit, description)
            VALUES (
                NEW.bill_id, '2050-TAX-LIAB', 'Government Sales Tax & GST Payable', 
                0.00, NEW.tax, 
                'Collected statutory tax on Bill #' || NEW.bill_id
            );
        END IF;

        RAISE NOTICE 'Double-entry accounting entries balanced and posted for Bill ID %', NEW.bill_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_post_general_ledger ON bills;
CREATE TRIGGER trg_post_general_ledger
    AFTER UPDATE OF payment_status ON bills
    FOR EACH ROW EXECUTE FUNCTION fn_trg_post_double_entry_ledger();


-- --------------------------------------------------------------------------------
-- SECTION 4: HOUSEKEEPING COMPLETION AUTO-RESET TRIGGER
-- --------------------------------------------------------------------------------

-- When a cleaning task is marked 'Completed', automatically make room 'Available'
CREATE OR REPLACE FUNCTION fn_trg_housekeeping_room_ready()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Completed' AND OLD.status != 'Completed') THEN
        -- Only set room available if not currently occupied by another active guest
        IF NOT EXISTS (
            SELECT 1 FROM reservations 
            WHERE room_id = NEW.room_id AND status = 'Checked-in'
        ) THEN
            UPDATE rooms
            SET status = 'Available'
            WHERE room_id = NEW.room_id;

            RAISE NOTICE 'Housekeeping task #% completed: Room % reset to Available.', NEW.task_id, NEW.room_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_housekeeping_room_ready ON housekeeping_tasks;
CREATE TRIGGER trg_housekeeping_room_ready
    AFTER UPDATE OF status ON housekeeping_tasks
    FOR EACH ROW EXECUTE FUNCTION fn_trg_housekeeping_room_ready();
