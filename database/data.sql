-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM - INITIAL SEED DATA FOR POSTGRESQL
-- ================================================================================

-- 1. Insert Initial Customer Records
-- Default password: guest123 (hashed in Python backend using werkzeug.security)
INSERT INTO customers (name, email, phone, password_hash)
VALUES
('Test Customer', 'customer@gmail.com', '9876543210', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0'),
('Eleanor Vance', 'eleanor@crowneplaza.com', '+1 (555) 234-5678', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0')
ON CONFLICT (email) DO NOTHING;


-- 2. Insert Initial Staff Records (Admin & Receptionist)
-- Default passwords: admin -> admin123, staff -> staff123
INSERT INTO staff (name, email, password_hash, role, is_active)
VALUES
('Arthur Pendelton', 'reception@crowneplaza.com', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'Receptionist', TRUE),
('System Administrator', 'admin@crowneplaza.com', 'scrypt:32768:8:1$yX8m2K8D9P0L$a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'Admin', TRUE)
ON CONFLICT (email) DO NOTHING;


-- 3. Insert Initial Room Inventory
INSERT INTO rooms (room_number, room_type, price_per_night, status)
VALUES
('101', 'Luxury Suite', 6000.00, 'Occupied'),
('102', 'Standard AC Room', 3500.00, 'Available'),
('103', 'Economy Non-AC Room', 2000.00, 'Cleaning'),
('201', 'AC Room with Balcony', 4500.00, 'Occupied'),
('202', 'Family AC Room', 4000.00, 'Available')
ON CONFLICT (room_number) DO NOTHING;


-- 4. Insert Hotel Services Catalog
INSERT INTO services (service_name, price, description, is_available)
VALUES
('Gourmet Breakfast in Bed', 1200.00, 'Freshly prepared continental breakfast served to your suite', TRUE),
('Express Laundry Service', 850.00, 'Same-day professional washing and pressing service', TRUE),
('Luxury Spa & Wellness Package', 3500.00, '60-minute relaxing full-body massage therapy', TRUE),
('Extra Rollaway Bed', 1500.00, 'Comfortable twin rollaway bed with premium linens', TRUE)
ON CONFLICT DO NOTHING;


-- 5. Insert Initial Reservation Links (Customer -> Room)
INSERT INTO reservations (customer_id, room_id, check_in, check_out, number_of_guests, status)
VALUES
(1, 1, '2026-07-28', '2026-08-02', 2, 'Checked-in'),
(2, 4, '2026-08-10', '2026-08-15', 2, 'Confirmed')
ON CONFLICT DO NOTHING;


-- 6. Insert Initial Service Requests
INSERT INTO service_requests (reservation_id, service_id, quantity, status)
VALUES
(1, 1, 1, 'Completed'),
(1, 2, 1, 'Requested')
ON CONFLICT DO NOTHING;


-- 7. Insert Initial Billing Record for Reservation 1
-- 5 nights @ 6000 = 30,000 + 1200 service = 31,200 + Tax 5% = 1560 -> 32,760
INSERT INTO bills (reservation_id, room_charge, service_charge, tax, discount, total_amount, payment_status)
VALUES
(1, 30000.00, 1200.00, 1560.00, 0.00, 32760.00, 'Pending')
ON CONFLICT (reservation_id) DO NOTHING;
