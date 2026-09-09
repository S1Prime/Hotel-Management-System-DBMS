-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM - INITIAL SEED DATA FOR POSTGRESQL
-- ================================================================================

-- 1. Insert Initial Customer Records
INSERT INTO customers (name, email, phone, password_hash)
VALUES
('Test Customer', 'customer@gmail.com', '9876543210', 'guest123'),
('Eleanor Vance', 'eleanor@crowneplaza.com', '+1 (555) 234-5678', 'guest123')
ON CONFLICT (email) DO NOTHING;


-- 2. Insert Initial Room Inventory
INSERT INTO rooms (room_number, room_type, price_per_night, status)
VALUES
('101', 'Luxury Suite', 6000.00, 'Occupied'),
('102', 'Standard AC Room', 3500.00, 'Available'),
('103', 'Economy Non-AC Room', 2000.00, 'Cleaning'),
('201', 'AC Room with Balcony', 4500.00, 'Occupied'),
('202', 'Family AC Room', 4000.00, 'Available')
ON CONFLICT (room_number) DO NOTHING;


-- 3. Insert Initial Reservation Link (Customer -> Room)
INSERT INTO reservations (customer_id, room_id, check_in, check_out, status)
VALUES
(1, 1, '2026-07-28', '2026-08-02', 'Booked')
ON CONFLICT DO NOTHING;
