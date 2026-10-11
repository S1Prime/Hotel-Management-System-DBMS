-- Keep eight rooms in each seeded category, numbered by category:
-- 101-108 Luxury Suite, 201-208 Standard AC, 301-308 Economy Non-AC,
-- 401-408 AC with Balcony, and 501-508 Family AC.
-- Room IDs and statuses are preserved so reservations and housekeeping remain linked.

UPDATE rooms
SET room_number = 'TMP' || room_id::TEXT
WHERE room_type IN (
    'Luxury Suite',
    'Standard AC Room',
    'Economy Non-AC Room',
    'AC Room with Balcony',
    'Family AC Room'
);

WITH numbered_rooms AS (
    SELECT room_id,
           CASE room_type
               WHEN 'Luxury Suite' THEN '1'
               WHEN 'Standard AC Room' THEN '2'
               WHEN 'Economy Non-AC Room' THEN '3'
               WHEN 'AC Room with Balcony' THEN '4'
               WHEN 'Family AC Room' THEN '5'
           END || LPAD(ROW_NUMBER() OVER (PARTITION BY room_type ORDER BY room_id)::TEXT, 2, '0') AS new_room_number
    FROM rooms
    WHERE room_type IN (
        'Luxury Suite',
        'Standard AC Room',
        'Economy Non-AC Room',
        'AC Room with Balcony',
        'Family AC Room'
    )
)
UPDATE rooms r
SET room_number = n.new_room_number
FROM numbered_rooms n
WHERE r.room_id = n.room_id;

WITH room_types (prefix, room_type, price_per_night) AS (
    VALUES
        ('1', 'Luxury Suite', 3000.00::NUMERIC),
        ('2', 'Standard AC Room', 1500.00::NUMERIC),
        ('3', 'Economy Non-AC Room', 1200.00::NUMERIC),
        ('4', 'AC Room with Balcony', 1800.00::NUMERIC),
        ('5', 'Family AC Room', 1700.00::NUMERIC)
), desired_rooms AS (
    SELECT types.room_type,
           types.price_per_night,
           types.prefix || LPAD(room_index::TEXT, 2, '0') AS room_number
    FROM room_types types
    CROSS JOIN GENERATE_SERIES(1, 8) AS generated(room_index)
)
INSERT INTO rooms (room_number, room_type, price_per_night, status)
SELECT desired.room_number, desired.room_type, desired.price_per_night, 'Available'
FROM desired_rooms desired
WHERE NOT EXISTS (
    SELECT 1 FROM rooms existing WHERE existing.room_number = desired.room_number
)
ON CONFLICT (room_number) DO NOTHING;
