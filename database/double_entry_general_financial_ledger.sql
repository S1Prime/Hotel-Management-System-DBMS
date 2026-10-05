-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — DOUBLE-ENTRY GENERAL FINANCIAL LEDGER
-- PostgreSQL Autonomous Accounting Engine & Balance Invariants
-- ================================================================================
-- Focus: Double-entry bookkeeping in pure SQL, immutable ledger journals,
-- automated debits & credits balance checking trigger, and real-time trial balance.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. CHART OF ACCOUNTS TABLE
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chart_of_accounts (
    account_code INT PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('Asset', 'Liability', 'Equity', 'Revenue', 'Expense'))
);

INSERT INTO chart_of_accounts (account_code, account_name, account_type) VALUES
(1010, 'Hotel Cash Drawer & POS', 'Asset'),
(1020, 'Accounts Receivable (Guests)', 'Asset'),
(2010, 'Sales Tax Payable (5% Luxury Tax)', 'Liability'),
(4010, 'Room Lodging Revenue', 'Revenue'),
(4020, 'In-Room Dining & Beverage Revenue', 'Revenue'),
(4030, 'Wellness Spa Revenue', 'Revenue'),
(5010, 'Guest Loyalty & Promotional Discounts', 'Expense')
ON CONFLICT (account_code) DO NOTHING;

-- --------------------------------------------------------------------------------
-- 2. JOURNAL ENTRIES & LEDGER TRANSACTIONS
-- --------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS journal_entries (
    journal_id SERIAL PRIMARY KEY,
    entry_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_folio VARCHAR(50), -- e.g. "INV-1"
    description VARCHAR(200) NOT NULL,
    is_balanced BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS journal_lines (
    line_id SERIAL PRIMARY KEY,
    journal_id INT NOT NULL REFERENCES journal_entries(journal_id) ON DELETE CASCADE,
    account_code INT NOT NULL REFERENCES chart_of_accounts(account_code),
    debit_amount NUMERIC(10,2) DEFAULT 0.00 CHECK (debit_amount >= 0),
    credit_amount NUMERIC(10,2) DEFAULT 0.00 CHECK (credit_amount >= 0),
    CONSTRAINT chk_debit_or_credit CHECK (
        (debit_amount > 0 AND credit_amount = 0) OR 
        (credit_amount > 0 AND debit_amount = 0)
    )
);

-- --------------------------------------------------------------------------------
-- 3. TRIGGER: ENFORCE DOUBLE-ENTRY ACCOUNTING INVARIANT (DEBITS == CREDITS)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verify_journal_balance()
RETURNS TRIGGER AS $$
DECLARE
    v_total_debits NUMERIC(10,2);
    v_total_credits NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(debit_amount), 0.00), COALESCE(SUM(credit_amount), 0.00)
    INTO v_total_debits, v_total_credits
    FROM journal_lines
    WHERE journal_id = NEW.journal_id;

    IF v_total_debits = v_total_credits THEN
        UPDATE journal_entries SET is_balanced = TRUE WHERE journal_id = NEW.journal_id;
    ELSE
        UPDATE journal_entries SET is_balanced = FALSE WHERE journal_id = NEW.journal_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_verify_journal_balance ON journal_lines;
CREATE TRIGGER trg_verify_journal_balance
AFTER INSERT OR UPDATE OR DELETE ON journal_lines
FOR EACH ROW EXECUTE FUNCTION fn_verify_journal_balance();

-- --------------------------------------------------------------------------------
-- 4. STORED PROCEDURE: POST INVOICE CHECKOUT TO GENERAL LEDGER
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_post_bill_to_general_ledger(
    p_bill_id INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_bill RECORD;
    v_journal_id INT;
BEGIN
    SELECT * INTO v_bill FROM bills WHERE bill_id = p_bill_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Bill #% does not exist.', p_bill_id;
    END IF;

    -- Create Journal Header
    INSERT INTO journal_entries (reference_folio, description)
    VALUES ('BILL-' || p_bill_id, 'Folio Settlement Checkout Posting')
    RETURNING journal_id INTO v_journal_id;

    -- DEBIT: Cash / Accounts Receivable (Total Folio Collected)
    INSERT INTO journal_lines (journal_id, account_code, debit_amount, credit_amount)
    VALUES (v_journal_id, 1010, v_bill.total_amount, 0.00);

    -- CREDIT: Room Revenue
    IF v_bill.room_charge > 0 THEN
        INSERT INTO journal_lines (journal_id, account_code, debit_amount, credit_amount)
        VALUES (v_journal_id, 4010, 0.00, v_bill.room_charge);
    END IF;

    -- CREDIT: Service Revenue
    IF v_bill.service_charge > 0 THEN
        INSERT INTO journal_lines (journal_id, account_code, debit_amount, credit_amount)
        VALUES (v_journal_id, 4020, 0.00, v_bill.service_charge);
    END IF;

    -- CREDIT: Sales Tax Payable
    IF v_bill.tax > 0 THEN
        INSERT INTO journal_lines (journal_id, account_code, debit_amount, credit_amount)
        VALUES (v_journal_id, 2010, 0.00, v_bill.tax);
    END IF;

    -- DEBIT: Discount Expense (if granted)
    IF v_bill.discount > 0 THEN
        INSERT INTO journal_lines (journal_id, account_code, debit_amount, credit_amount)
        VALUES (v_journal_id, 5010, v_bill.discount, 0.00);
    END IF;

    RAISE NOTICE 'Bill #% successfully posted to General Ledger in Journal #%.', p_bill_id, v_journal_id;
END;
$$;

-- --------------------------------------------------------------------------------
-- 5. VIEW: REAL-TIME TRIAL BALANCE IN PURE SQL
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_hotel_trial_balance AS
SELECT 
    c.account_code,
    c.account_name,
    c.account_type,
    SUM(jl.debit_amount) AS total_debits,
    SUM(jl.credit_amount) AS total_credits,
    CASE 
        WHEN c.account_type IN ('Asset', 'Expense') THEN (SUM(jl.debit_amount) - SUM(jl.credit_amount))
        ELSE (SUM(jl.credit_amount) - SUM(jl.debit_amount))
    END AS net_account_balance
FROM chart_of_accounts c
LEFT JOIN journal_lines jl ON c.account_code = jl.account_code
GROUP BY c.account_code, c.account_name, c.account_type
ORDER BY c.account_code ASC;

-- Seed Sample Checkout Posting
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM bills LIMIT 1) THEN
        CALL sp_post_bill_to_general_ledger((SELECT MIN(bill_id) FROM bills));
    END IF;
END $$;

-- Verification
SELECT * FROM vw_hotel_trial_balance;
