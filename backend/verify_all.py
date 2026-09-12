import sys
from database import get_db_connection
from psycopg2.extras import RealDictCursor

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def check_all_database_tables():
    print("\n**************************************************")
    print("      FULL POSTGRESQL DATABASE INSPECTION         ")
    print("**************************************************")

    try:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)

        # 1. Customers
        cur.execute("SELECT COUNT(*) AS total FROM customers;")
        print(f"1. Customers Table: {cur.fetchone()['total']} records")

        # 2. Staff
        cur.execute("SELECT COUNT(*) AS total FROM staff;")
        print(f"2. Staff Table: {cur.fetchone()['total']} accounts")

        # 3. Rooms
        cur.execute("SELECT COUNT(*) AS total FROM rooms;")
        print(f"3. Rooms Table: {cur.fetchone()['total']} rooms")

        # 4. Services
        cur.execute("SELECT COUNT(*) AS total FROM services;")
        print(f"4. Services Catalog: {cur.fetchone()['total']} items")

        # 5. Reservations
        cur.execute("SELECT COUNT(*) AS total FROM reservations;")
        print(f"5. Reservations Table: {cur.fetchone()['total']} bookings")

        # 6. Service Requests
        cur.execute("SELECT COUNT(*) AS total FROM service_requests;")
        print(f"6. Service Requests Table: {cur.fetchone()['total']} requests")

        # 7. Bills
        cur.execute("SELECT COUNT(*) AS total FROM bills;")
        print(f"7. Bills Table: {cur.fetchone()['total']} invoices")

        # 8. Housekeeping Tasks
        cur.execute("SELECT COUNT(*) AS total FROM housekeeping_tasks;")
        print(f"8. Housekeeping Tasks Table: {cur.fetchone()['total']} tasks")

        # 9. Views Check
        cur.execute("SELECT COUNT(*) AS total FROM vw_active_reservations;")
        print(f"9. View (vw_active_reservations): {cur.fetchone()['total']} rows")

        cur.execute("SELECT COUNT(*) AS total FROM vw_revenue_summary;")
        print(f"10. View (vw_revenue_summary): {cur.fetchone()['total']} categories")

        cur.close()
        conn.close()
        print("**************************************************\n")
        print("[SUCCESS] All 8 PostgreSQL core tables & views inspected successfully!")

    except Exception as e:
        print(f"[NOTE] Database connection status: {e}")
        print("Run 'python backend/init_db.py' after launching PostgreSQL service.")

if __name__ == "__main__":
    check_all_database_tables()
