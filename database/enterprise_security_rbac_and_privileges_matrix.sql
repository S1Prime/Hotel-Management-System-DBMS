-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — RBAC PRIVILEGES & SECURITY MATRIX (DCL SPECIFICATION)
-- PostgreSQL Enterprise Security, Least Privilege & Role Isolation
-- ================================================================================
-- Focus: Production DCL commands, role hierarchies, grant matrices, column-level
-- permissions, and dynamic row-level security policies.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. ROLE HIERARCHY DEFINITION
-- --------------------------------------------------------------------------------
-- Superuser / DBA Role: Full administrative control
-- Hotel General Manager (hotel_gm): Read-only access to all financial and executive datamarts
-- Hotel Front Desk (hotel_receptionist): Operational read/write on reservations and services
-- Hotel Housekeeping (hotel_housekeeper): Task queue operations only
-- Hotel Guest / Public User (hotel_guest_api): Strictly scoped access

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hotel_gm_role') THEN
        CREATE ROLE hotel_gm_role WITH NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hotel_receptionist_role') THEN
        CREATE ROLE hotel_receptionist_role WITH NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hotel_housekeeper_role') THEN
        CREATE ROLE hotel_housekeeper_role WITH NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hotel_guest_api_role') THEN
        CREATE ROLE hotel_guest_api_role WITH NOLOGIN;
    END IF;
END $$;

-- --------------------------------------------------------------------------------
-- 2. SCHEMA & TABLE PRIVILEGE GRANTS (DCL MATRIX)
-- --------------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO hotel_gm_role, hotel_receptionist_role, hotel_housekeeper_role, hotel_guest_api_role;

-- A. Front Desk Staff Grants
GRANT SELECT, INSERT, UPDATE ON reservations TO hotel_receptionist_role;
GRANT SELECT, UPDATE ON rooms TO hotel_receptionist_role;
GRANT SELECT, INSERT ON service_requests TO hotel_receptionist_role;
GRANT SELECT ON services TO hotel_receptionist_role;
GRANT SELECT, INSERT, UPDATE ON bills TO hotel_receptionist_role;
GRANT SELECT, INSERT ON customers TO hotel_receptionist_role;
GRANT SELECT ON vw_active_reservations, vw_available_rooms, vw_revenue_summary TO hotel_receptionist_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hotel_receptionist_role;

-- B. Housekeeping Staff Grants (Least Privilege)
GRANT SELECT ON rooms TO hotel_housekeeper_role;
GRANT SELECT, UPDATE (status, completed_at, notes) ON housekeeping_tasks TO hotel_housekeeper_role;

-- C. General Manager (Executive Read-Only)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hotel_gm_role;

-- D. Customer Guest API Grants (Restricted Column Access)
GRANT SELECT (room_id, room_number, room_type, price_per_night, status) ON rooms TO hotel_guest_api_role;
GRANT SELECT ON services TO hotel_guest_api_role;
GRANT INSERT ON service_requests TO hotel_guest_api_role;

-- --------------------------------------------------------------------------------
-- 3. AUDIT SECURITY COMPLIANCE VIEW: ACCESS CONTROL CATALOG
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_security_privileges_matrix AS
SELECT 
    grantee,
    table_schema,
    table_name,
    string_agg(privilege_type, ', ' ORDER BY privilege_type) AS granted_privileges
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND grantee IN ('hotel_gm_role', 'hotel_receptionist_role', 'hotel_housekeeper_role', 'hotel_guest_api_role')
GROUP BY grantee, table_schema, table_name
ORDER BY grantee, table_name;

-- --------------------------------------------------------------------------------
-- 4. ROW-LEVEL SECURITY (RLS) FOR CUSTOMER RECORD ISOLATION
-- --------------------------------------------------------------------------------
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_customer_self_service_isolation ON customers;
CREATE POLICY p_customer_self_service_isolation ON customers
    FOR ALL
    TO hotel_guest_api_role
    USING (customer_id = NULLIF(current_setting('app.current_customer_id', true), '')::INT);

-- Verification
SELECT * FROM vw_security_privileges_matrix LIMIT 10;
