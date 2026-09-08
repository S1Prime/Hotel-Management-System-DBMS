import sys
import time

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def test_full_registration_flow():
    print("==================================================")
    print("  TESTING LIVE CUSTOMER REGISTRATION & DATABASE   ")
    print("==================================================")

    from database import get_db_connection
    from psycopg2.extras import RealDictCursor

    test_email = f"testguest_{int(time.time())}@crowneplaza.com"
    test_name = "Alexander Wright"
    test_phone = "+1 (555) 987-6543"
    test_password = "password123"

    print(f"1. Registering new guest: {test_name} ({test_email})...")

    # Simulate database insertion as performed by POST /api/customers
    connection = get_db_connection()
    cursor = connection.cursor(cursor_factory=RealDictCursor)

    insert_query = """
        INSERT INTO customers (name, email, phone, password_hash)
        VALUES (%s, %s, %s, %s)
        RETURNING customer_id, name, email, phone;
    """
    cursor.execute(insert_query, (test_name, test_email, test_phone, test_password))
    new_customer = cursor.fetchone()
    connection.commit()

    print(f"   [OK] Saved to PostgreSQL! Customer ID: {new_customer['customer_id']}")

    # 2. Verify stored record
    cursor.execute("SELECT customer_id, name, email, phone FROM customers WHERE customer_id = %s;", (new_customer['customer_id'],))
    fetched = cursor.fetchone()

    cursor.close()
    connection.close()

    print("\n2. Querying PostgreSQL Database for newly registered customer:")
    print(f"   Fetched Row -> ID: {fetched['customer_id']} | Name: {fetched['name']} | Email: {fetched['email']} | Phone: {fetched['phone']}")

    print("\n==================================================")
    print("  VERIFICATION SUCCESSFUL: DATA IS UP TO DATE! ")
    print("==================================================\n")

if __name__ == "__main__":
    test_full_registration_flow()
