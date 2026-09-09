import sys
import psycopg2
from psycopg2.extras import RealDictCursor
from database import get_db_connection

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def seed_sample_reservation():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT COUNT(*) FROM reservations;")
        count = cursor.fetchone()['count']

        if count == 0:
            # Fetch Customer ID 1 and Room ID 1
            cursor.execute("SELECT customer_id FROM customers LIMIT 1;")
            cust = cursor.fetchone()
            cursor.execute("SELECT room_id FROM rooms LIMIT 1;")
            room = cursor.fetchone()

            if cust and room:
                c_id = cust['customer_id']
                r_id = room['room_id']

                cursor.execute("""
                    INSERT INTO reservations (customer_id, room_id, check_in, check_out, status)
                    VALUES (%s, %s, '2026-07-28', '2026-08-02', 'Booked')
                    RETURNING *;
                """, (c_id, r_id))

                cursor.execute("UPDATE rooms SET status = 'Occupied' WHERE room_id = %s;", (r_id,))
                connection.commit()
                print("   [OK] Sample reservation inserted into PostgreSQL database!")

        cursor.close()
        connection.close()

    except Exception as e:
        print(f"Error seeding reservation: {e}")

if __name__ == "__main__":
    seed_sample_reservation()
