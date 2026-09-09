import sys
import psycopg2
from psycopg2.extras import RealDictCursor
from database import get_db_connection

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def check_reservations():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        query = """
            SELECT 
                res.reservation_id,
                c.name AS guest_name,
                c.email AS guest_email,
                r.room_number,
                r.room_type,
                res.check_in,
                res.check_out,
                res.status
            FROM reservations res
            JOIN customers c ON res.customer_id = c.customer_id
            JOIN rooms r ON res.room_id = r.room_id
            ORDER BY res.reservation_id DESC;
        """
        cursor.execute(query)
        reservations = cursor.fetchall()

        cursor.close()
        connection.close()

        print("\n==================================================")
        print("         POSTGRESQL BOOKINGS & RESERVATIONS       ")
        print("==================================================")
        if not reservations:
            print("No active reservations found in database.")
        else:
            print(f"Total Reservations: {len(reservations)}\n")
            for res in reservations:
                print(f"ID: #{res['reservation_id']} | Guest: {res['guest_name']} ({res['guest_email']}) | Room #{res['room_number']} ({res['room_type']}) | Dates: {res['check_in']} to {res['check_out']} | Status: {res['status']}")
        print("==================================================\n")

    except Exception as e:
        print(f"Error connecting to database: {e}")

if __name__ == "__main__":
    check_reservations()
