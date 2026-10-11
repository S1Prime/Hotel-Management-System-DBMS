-- Add reservation-scoped receptionist expenses and an explicit bill breakdown.
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
ALTER TABLE bills ADD COLUMN IF NOT EXISTS additional_charge NUMERIC(10,2) NOT NULL DEFAULT 0.00 CHECK (additional_charge >= 0);
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
