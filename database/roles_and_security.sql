-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DATABASE SECURITY, ROLES (RBAC) & ROW-LEVEL SECURITY (RLS)
-- PostgreSQL DBMS Specification for Access Control & Least Privilege
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. ROLE-BASED ACCESS CONTROL (RBAC) DEFINITIONS
-- --------------------------------------------------------------------------------

-- Create Roles if they do not exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hotel_admin') THEN
        CREATE ROLE hotel_admin WITH LOGIN PASSWORD 'Admin@Sec2026';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hotel_receptionist') THEN
        CREATE ROLE hotel_receptionist WITH LOGIN PASSWORD 'Recept@Sec2026';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hotel_guest_role') THEN
        CREATE ROLE hotel_guest_role WITH LOGIN PASSWORD 'Guest@Sec2026';
    END IF;

    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hotel_housekeeper') THEN
        CREATE ROLE hotel_housekeeper WITH LOGIN PASSWORD 'Clean@Sec2026';
    END IF;
END $$;


-- --------------------------------------------------------------------------------
-- 2. DCL PERMISSIONS MATRIX (GRANT & REVOKE)
-- --------------------------------------------------------------------------------

-- Step 2A: Revoke default public access on schema
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO hotel_admin, hotel_receptionist, hotel_guest_role, hotel_housekeeper;

-- Step 2B: Permissions for hotel_admin (Full Operational Control)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hotel_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hotel_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO hotel_admin;

-- Step 2C: Permissions for hotel_receptionist (Front Desk Operations)
-- Can manage reservations, view rooms, generate bills, dispatch services
GRANT SELECT, INSERT, UPDATE ON customers TO hotel_receptionist;
GRANT SELECT, UPDATE ON rooms TO hotel_receptionist;
GRANT SELECT, INSERT, UPDATE ON reservations TO hotel_receptionist;
GRANT SELECT, INSERT, UPDATE ON bills TO hotel_receptionist;
GRANT SELECT, INSERT, UPDATE ON service_requests TO hotel_receptionist;
GRANT SELECT ON services TO hotel_receptionist;
GRANT SELECT, UPDATE ON housekeeping_tasks TO hotel_receptionist;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hotel_receptionist;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hotel_receptionist;

-- Step 2D: Permissions for hotel_guest_role (Self-Service Customer Portal)
-- Read rooms & catalog, insert new reservations, place service orders
GRANT SELECT ON rooms, services TO hotel_guest_role;
GRANT SELECT, INSERT, UPDATE ON customers TO hotel_guest_role;
GRANT SELECT, INSERT ON reservations TO hotel_guest_role;
GRANT SELECT, INSERT ON service_requests TO hotel_guest_role;
GRANT SELECT ON bills TO hotel_guest_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hotel_guest_role;

-- Step 2E: Permissions for hotel_housekeeper (Housekeeping Staff)
GRANT SELECT ON rooms TO hotel_housekeeper;
GRANT SELECT, UPDATE (status, completed_at, notes) ON housekeeping_tasks TO hotel_housekeeper;


-- --------------------------------------------------------------------------------
-- 3. ROW-LEVEL SECURITY (RLS) POLICIES
-- Ensures that Guests can strictly view ONLY their own reservation and billing records
-- --------------------------------------------------------------------------------

-- Enable RLS on reservations & bills
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE bills ENABLE ROW LEVEL SECURITY;

-- Policy 1: Admin and Receptionists can view and modify all reservations
DROP POLICY IF EXISTS pol_staff_reservations ON reservations;
CREATE POLICY pol_staff_reservations ON reservations
    FOR ALL
    TO hotel_admin, hotel_receptionist
    USING (TRUE)
    WITH CHECK (TRUE);

-- Policy 2: Guests can strictly access only their own reservations
-- Uses session variable 'app.current_customer_id' passed by the application layer
DROP POLICY IF EXISTS pol_guest_own_reservations ON reservations;
CREATE POLICY pol_guest_own_reservations ON reservations
    FOR ALL
    TO hotel_guest_role
    USING (customer_id = NULLIF(current_setting('app.current_customer_id', TRUE), '')::INT)
    WITH CHECK (customer_id = NULLIF(current_setting('app.current_customer_id', TRUE), '')::INT);

-- Policy 3: Staff can access all bills
DROP POLICY IF EXISTS pol_staff_bills ON bills;
CREATE POLICY pol_staff_bills ON bills
    FOR ALL
    TO hotel_admin, hotel_receptionist
    USING (TRUE)
    WITH CHECK (TRUE);

-- Policy 4: Guests can view only their own bills
DROP POLICY IF EXISTS pol_guest_own_bills ON bills;
CREATE POLICY pol_guest_own_bills ON bills
    FOR SELECT
    TO hotel_guest_role
    USING (
        reservation_id IN (
            SELECT reservation_id 
            FROM reservations 
            WHERE customer_id = NULLIF(current_setting('app.current_customer_id', TRUE), '')::INT
        )
    );
