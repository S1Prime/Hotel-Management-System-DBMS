import sys
import psycopg2
from psycopg2.extras import RealDictCursor
from database import get_db_connection

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def check_rooms():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT room_id, room_number, room_type, price_per_night, status FROM rooms ORDER BY room_number ASC;")
        rooms = cursor.fetchall()

        cursor.close()
        connection.close()

        print("\n==================================================")
        print("          POSTGRESQL ROOMS INVENTORY              ")
        print("==================================================")
        if not rooms:
            print("No rooms found in database.")
        else:
            print(f"Total Rooms: {len(rooms)}\n")
            for r in rooms:
                print(f"Room #{r['room_number']} | Category: {r['room_type']} | Price: Rs. {r['price_per_night']} | Status: {r['status']}")
        print("==================================================\n")

    except Exception as e:
        print(f"Error connecting to database: {e}")

if __name__ == "__main__":
    check_rooms()
