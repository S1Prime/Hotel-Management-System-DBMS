-- ============================================================================
-- Crowne Plaza Hotel Management System - Lost & Found Database Module
-- Module: Lost and Found Item Tracking, Guest Reporting & Staff Resolution
-- Architecture: Relational PostgreSQL Schema with CDC Audit Logging & Triggers
-- ============================================================================

-- 1. Create Lost and Found Table
CREATE TABLE IF NOT EXISTS public.lost_and_found (
    report_id SERIAL PRIMARY KEY,
    item_name VARCHAR(150) NOT NULL,
    category VARCHAR(60) DEFAULT 'Personal Belonging',
    location_lost VARCHAR(200) NOT NULL,
    lost_date TIMESTAMP WITH TIME ZONE NOT NULL,
    description TEXT NOT NULL,
    image_url TEXT,
    customer_id INT REFERENCES public.customers(customer_id) ON DELETE SET NULL,
    reporter_name VARCHAR(100) NOT NULL,
    reporter_email VARCHAR(100) NOT NULL,
    reporter_phone VARCHAR(30),
    status VARCHAR(30) NOT NULL DEFAULT 'Reported' 
        CHECK (status IN ('Reported', 'Investigating', 'Found', 'Claimed', 'Closed')),
    found_by_staff_id INT REFERENCES public.staff(staff_id) ON DELETE SET NULL,
    staff_notes TEXT,
    resolved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexing for high-performance searches
CREATE INDEX IF NOT EXISTS idx_lost_found_status ON public.lost_and_found (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_lost_found_reporter ON public.lost_and_found (reporter_email);

-- 2. Audit Trail Trigger Integration
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'fn_audit_record_change') THEN
        DROP TRIGGER IF EXISTS trg_audit_lost_and_found ON public.lost_and_found;
        CREATE TRIGGER trg_audit_lost_and_found
            AFTER INSERT OR UPDATE OR DELETE ON public.lost_and_found
            FOR EACH ROW EXECUTE FUNCTION fn_audit_record_change('report_id');
    END IF;
END $$;

-- 3. Stored Procedure: Report a Lost Item
CREATE OR REPLACE PROCEDURE sp_report_lost_item(
    p_customer_id INT,
    p_item_name VARCHAR(150),
    p_category VARCHAR(60),
    p_location VARCHAR(200),
    p_lost_date TIMESTAMP WITH TIME ZONE,
    p_description TEXT,
    p_image_url TEXT,
    p_reporter_name VARCHAR(100),
    p_reporter_email VARCHAR(100),
    p_reporter_phone VARCHAR(30),
    INOUT p_report_id INT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO public.lost_and_found (
        customer_id, item_name, category, location_lost, lost_date,
        description, image_url, reporter_name, reporter_email, reporter_phone, status
    ) VALUES (
        p_customer_id, p_item_name, COALESCE(p_category, 'Personal Belonging'),
        p_location, p_lost_date, p_description, p_image_url,
        p_reporter_name, p_reporter_email, p_reporter_phone, 'Reported'
    ) RETURNING report_id INTO p_report_id;
    
    RAISE NOTICE 'Lost item report #% submitted successfully for %', p_report_id, p_reporter_name;
END;
$$;

-- 4. Stored Procedure: Update Report Status by Front Desk / Admin
CREATE OR REPLACE PROCEDURE sp_update_lost_item_status(
    p_report_id INT,
    p_staff_id INT,
    p_new_status VARCHAR(30),
    p_staff_notes TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_resolved_time TIMESTAMP WITH TIME ZONE := NULL;
BEGIN
    IF p_new_status IN ('Found', 'Claimed', 'Closed') THEN
        v_resolved_time := CURRENT_TIMESTAMP;
    END IF;

    UPDATE public.lost_and_found
    SET 
        status = p_new_status,
        found_by_staff_id = COALESCE(p_staff_id, found_by_staff_id),
        staff_notes = COALESCE(p_staff_notes, staff_notes),
        resolved_at = COALESCE(v_resolved_time, resolved_at)
    WHERE report_id = p_report_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Lost and found report #% not found.', p_report_id;
    END IF;

    RAISE NOTICE 'Lost item report #% updated to status % by staff #%', p_report_id, p_new_status, p_staff_id;
END;
$$;

-- 5. Analytical View: Active Lost & Found Items Summary
CREATE OR REPLACE VIEW public.vw_lost_and_found_summary AS
SELECT 
    lf.report_id,
    lf.item_name,
    lf.category,
    lf.location_lost,
    lf.lost_date,
    lf.description,
    lf.image_url,
    lf.reporter_name,
    lf.reporter_email,
    lf.reporter_phone,
    lf.status,
    s.name AS resolved_by_staff,
    lf.staff_notes,
    lf.created_at,
    lf.resolved_at
FROM public.lost_and_found lf
LEFT JOIN public.staff s ON lf.found_by_staff_id = s.staff_id
ORDER BY lf.created_at DESC;

-- Seed Sample Initial Item for Testing
INSERT INTO public.lost_and_found (
    item_name, category, location_lost, lost_date, description,
    reporter_name, reporter_email, reporter_phone, status
) VALUES (
    'Black Leather Montblanc Wallet', 'Accessories', 'Lobby Lounge / Café',
    CURRENT_TIMESTAMP - INTERVAL '2 days',
    'Left on the velvet armchair near the lobby piano. Contains ID card and room card.',
    'John Doe', 'customer@gmail.com', '9876543210', 'Investigating'
) ON CONFLICT DO NOTHING;
