-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — GDPR PRIVACY, DATA MASKING & COMPLIANCE
-- PostgreSQL Security, Dynamic Data Masking & Anonymization Engine
-- ================================================================================
-- Focus: Guest privacy protection, dynamic data masking functions, Right to be
-- Forgotten (GDPR Article 17) cascading erasure, and compliance auditing in SQL.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. DYNAMIC DATA MASKING FUNCTIONS
-- --------------------------------------------------------------------------------

-- Mask Email: "customer@gmail.com" -> "c***r@gmail.com"
CREATE OR REPLACE FUNCTION fn_mask_email(p_email VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    v_user_part VARCHAR;
    v_domain_part VARCHAR;
    v_masked_user VARCHAR;
BEGIN
    IF p_email IS NULL OR POSITION('@' IN p_email) = 0 THEN
        RETURN '***@***.***';
    END IF;

    v_user_part := SPLIT_PART(p_email, '@', 1);
    v_domain_part := SPLIT_PART(p_email, '@', 2);

    IF LENGTH(v_user_part) <= 2 THEN
        v_masked_user := SUBSTRING(v_user_part, 1, 1) || '***';
    ELSE
        v_masked_user := SUBSTRING(v_user_part, 1, 1) || '***' || SUBSTRING(v_user_part, LENGTH(v_user_part), 1);
    END IF;

    RETURN v_masked_user || '@' || v_domain_part;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Mask Phone: "+1 (555) 234-5678" -> "+1 (555) ***-5678"
CREATE OR REPLACE FUNCTION fn_mask_phone(p_phone VARCHAR)
RETURNS VARCHAR AS $$
BEGIN
    IF p_phone IS NULL OR LENGTH(p_phone) < 4 THEN
        RETURN '***-***-****';
    END IF;
    RETURN OVERLAY(p_phone PLACING '******' FROM 4 FOR 6);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- --------------------------------------------------------------------------------
-- 2. COMPLIANCE & PRIVACY-COMPLIANT VIEW FOR GENERAL STAFF
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_gdpr_masked_customers AS
SELECT 
    c.customer_id,
    c.name,
    fn_mask_email(c.email) AS masked_email,
    fn_mask_phone(c.phone) AS masked_phone,
    TO_CHAR(c.created_at, 'YYYY-MM-DD') AS member_since,
    COUNT(res.reservation_id) AS total_stays
FROM customers c
LEFT JOIN reservations res ON c.customer_id = res.customer_id
GROUP BY c.customer_id, c.name, c.email, c.phone, c.created_at;

-- --------------------------------------------------------------------------------
-- 3. STORED PROCEDURE: GDPR RIGHT TO BE FORGOTTEN (ANONYMIZATION)
-- Sanitizes PII while preserving financial ledgers and tax records for auditing
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_gdpr_anonymize_customer(
    p_customer_id INT,
    p_consent_confirmation BOOLEAN
)
LANGUAGE plpgsql AS $$
DECLARE
    v_anonymized_email VARCHAR(100);
BEGIN
    IF NOT p_consent_confirmation THEN
        RAISE EXCEPTION 'GDPR erasure requires explicit consent confirmation (p_consent_confirmation = TRUE).';
    END IF;

    v_anonymized_email := 'anonymized_guest_' || p_customer_id || '@crowneplaza-privacy.internal';

    -- Anonymize Customer Record
    UPDATE customers
    SET name = 'Redacted GDPR Guest',
        email = v_anonymized_email,
        phone = '+0 (000) 000-0000',
        password_hash = 'REDACTED_GDPR_COMPLIANCE'
    WHERE customer_id = p_customer_id;

    -- Strip special requests containing personal health / dietary information
    UPDATE reservations
    SET special_requests = '[PERSONAL DATA PURGED UNDER GDPR ARTICLE 17]'
    WHERE customer_id = p_customer_id;

    -- Record the compliance action in the audit log
    INSERT INTO audit_logs (table_name, operation, record_id, changed_by, new_data)
    VALUES (
        'customers', 
        'UPDATE', 
        p_customer_id, 
        CURRENT_USER, 
        jsonb_build_object('gdpr_action', 'right_to_be_forgotten', 'anonymized_at', CURRENT_TIMESTAMP)
    );

    RAISE NOTICE 'Customer #% personal identity has been completely anonymized under GDPR.', p_customer_id;
END;
$$;

-- Verification
SELECT * FROM vw_gdpr_masked_customers;
