-- ============================================================================
-- Crowne Plaza Hotel Management System - Advanced Financial Accounting Engine
-- Module: Double-Entry Bookkeeping, Chart of Accounts, ASC 606 Revenue Recognition
-- Architecture: Enterprise Audited Ledger with Immutable Journal Entries
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS finance;

-- Chart of Accounts Master Table
CREATE TABLE IF NOT EXISTS finance.chart_of_accounts (
    account_code VARCHAR(10) PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('Asset', 'Liability', 'Equity', 'Revenue', 'Expense')),
    normal_balance VARCHAR(10) NOT NULL CHECK (normal_balance IN ('Debit', 'Credit')),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Seed Standard Hospitality Chart of Accounts
INSERT INTO finance.chart_of_accounts (account_code, account_name, account_type, normal_balance, description) VALUES
('1010', 'Cash & Operating Bank Accounts', 'Asset', 'Debit', 'Primary operating liquid funds'),
('1020', 'Guest Accounts Receivable (Guest Ledger)', 'Asset', 'Debit', 'Unsettled folios of in-house guests'),
('1030', 'Credit Card Merchant Clearing', 'Asset', 'Debit', 'Settlements awaiting batch bank deposit'),
('1040', 'City Ledger (Corporate Receivables)', 'Asset', 'Debit', 'B2B corporate contract billings'),
('2010', 'Accounts Payable', 'Liability', 'Credit', 'Vendor and operating bills pending payment'),
('2020', 'Guest Advance Deposits & Prepayments', 'Liability', 'Credit', 'Unearned advance deposits before check-in'),
('2030', 'State & Central GST Payable (18%)', 'Liability', 'Credit', 'Collected goods and services tax liability'),
('2040', 'Hotel Service Gratuity Pool Payable', 'Liability', 'Credit', 'Staff tip pool pending disbursement'),
('3010', 'Owner Capital Equity', 'Equity', 'Credit', 'Capital invested into hotel assets'),
('3020', 'Retained Earnings', 'Equity', 'Credit', 'Accumulated operational net income'),
('4010', 'Room Revenue - Luxury Suites', 'Revenue', 'Credit', 'Earned tariff from suite accommodations'),
('4020', 'Room Revenue - Standard AC', 'Revenue', 'Credit', 'Earned tariff from standard rooms'),
('4030', 'Room Revenue - Family Accommodations', 'Revenue', 'Credit', 'Earned tariff from family multi-bed suites'),
('4110', 'Food & Beverage - In-Room Dining', 'Revenue', 'Credit', 'Room service breakfast, dinner, and wine'),
('4120', 'Spa & Wellness Center Revenue', 'Revenue', 'Credit', 'Massage, sauna, and wellness treatments'),
('4130', 'Transportation & Valet Revenue', 'Revenue', 'Credit', 'Airport chauffeur and valet charges'),
('5010', 'Direct Housekeeping Operating Supplies', 'Expense', 'Debit', 'Linens, amenities, toiletries, disinfectants'),
('5020', 'Front Desk Staff Wages & Salaries', 'Expense', 'Debit', 'Reception and guest services compensation'),
('5030', 'Utilities - Electric, HVAC & Water', 'Expense', 'Debit', 'Central plant electrical and municipal water bills')
ON CONFLICT (account_code) DO NOTHING;

-- Journal Entry Headers (Audit-sealed)
CREATE TABLE IF NOT EXISTS finance.journal_entry_headers (
    journal_entry_id BIGSERIAL PRIMARY KEY,
    entry_number VARCHAR(30) NOT NULL UNIQUE,
    entry_date DATE NOT NULL DEFAULT CURRENT_DATE,
    reference_type VARCHAR(30) NOT NULL, -- Reservation, CheckoutFolio, NightAudit, SupplierBill
    reference_id INT NOT NULL,
    posted_by VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
    narration TEXT NOT NULL,
    is_posted BOOLEAN NOT NULL DEFAULT FALSE,
    posted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Journal Entry Lines (Debit & Credit Balanced Ledger)
CREATE TABLE IF NOT EXISTS finance.journal_entry_lines (
    line_id BIGSERIAL PRIMARY KEY,
    journal_entry_id BIGINT NOT NULL REFERENCES finance.journal_entry_headers(journal_entry_id) ON DELETE CASCADE,
    account_code VARCHAR(10) NOT NULL REFERENCES finance.chart_of_accounts(account_code),
    debit_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (debit_amount >= 0),
    credit_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (credit_amount >= 0),
    line_description VARCHAR(255),
    CONSTRAINT chk_debit_or_credit CHECK (
        (debit_amount > 0 AND credit_amount = 0) OR 
        (credit_amount > 0 AND debit_amount = 0)
    )
);

-- Automated Stored Procedure: Post Checkout Settlement to General Ledger
CREATE OR REPLACE PROCEDURE finance.sp_post_checkout_journal_entry(
    p_reservation_id INT,
    p_bill_id INT,
    p_room_charge NUMERIC,
    p_service_charge NUMERIC,
    p_tax NUMERIC,
    p_total_amount NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_journal_id BIGINT;
    v_entry_num VARCHAR(30);
    v_room_account VARCHAR(10);
    v_room_type VARCHAR(50);
BEGIN
    -- Determine room revenue sub-account
    SELECT r.room_type INTO v_room_type
    FROM public.reservations res
    JOIN public.rooms r ON res.room_id = r.room_id
    WHERE res.reservation_id = p_reservation_id;

    IF v_room_type ILIKE '%Suite%' THEN
        v_room_account := '4010';
    ELSIF v_room_type ILIKE '%Family%' THEN
        v_room_account := '4030';
    ELSE
        v_room_account := '4020';
    END IF;

    v_entry_num := 'JV-CHK-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(p_bill_id::TEXT, 6, '0');

    -- Create Journal Header
    INSERT INTO finance.journal_entry_headers (
        entry_number, entry_date, reference_type, reference_id, narration, is_posted, posted_at
    ) VALUES (
        v_entry_num, CURRENT_DATE, 'CheckoutFolio', p_bill_id,
        'Settlement of reservation #' || p_reservation_id || ' via front desk billing #' || p_bill_id,
        TRUE, CURRENT_TIMESTAMP
    ) RETURNING journal_entry_id INTO v_journal_id;

    -- DEBIT: Cash / Merchant Clearing (Total Bill Paid by Guest)
    INSERT INTO finance.journal_entry_lines (journal_entry_id, account_code, debit_amount, credit_amount, line_description)
    VALUES (v_journal_id, '1030', p_total_amount, 0.00, 'Guest payment received via credit card settlement');

    -- CREDIT: Room Revenue
    IF p_room_charge > 0 THEN
        INSERT INTO finance.journal_entry_lines (journal_entry_id, account_code, debit_amount, credit_amount, line_description)
        VALUES (v_journal_id, v_room_account, 0.00, p_room_charge, 'Room accommodation revenue earned');
    END IF;

    -- CREDIT: In-Room Dining & Amenities Ancillary Revenue
    IF p_service_charge > 0 THEN
        INSERT INTO finance.journal_entry_lines (journal_entry_id, account_code, debit_amount, credit_amount, line_description)
        VALUES (v_journal_id, '4110', 0.00, p_service_charge, 'Ancillary room service and dining charges');
    END IF;

    -- CREDIT: GST Tax Liability (18% Statutory Withholding)
    IF p_tax > 0 THEN
        INSERT INTO finance.journal_entry_lines (journal_entry_id, account_code, debit_amount, credit_amount, line_description)
        VALUES (v_journal_id, '2030', 0.00, p_tax, 'Statutory GST liability payable to treasury');
    END IF;
END;
$$;

-- Verification View: Trial Balance (Verifying Sum(Debits) == Sum(Credits))
CREATE OR REPLACE VIEW finance.vw_trial_balance AS
SELECT 
    coa.account_code,
    coa.account_name,
    coa.account_type,
    coa.normal_balance,
    COALESCE(SUM(jel.debit_amount), 0.00) AS total_debits,
    COALESCE(SUM(jel.credit_amount), 0.00) AS total_credits,
    CASE 
        WHEN coa.normal_balance = 'Debit' THEN COALESCE(SUM(jel.debit_amount), 0.00) - COALESCE(SUM(jel.credit_amount), 0.00)
        ELSE COALESCE(SUM(jel.credit_amount), 0.00) - COALESCE(SUM(jel.debit_amount), 0.00)
    END AS net_ending_balance
FROM finance.chart_of_accounts coa
LEFT JOIN finance.journal_entry_lines jel ON coa.account_code = jel.account_code
GROUP BY coa.account_code, coa.account_name, coa.account_type, coa.normal_balance
ORDER BY coa.account_code;
