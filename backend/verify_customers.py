import psycopg2
from psycopg2.extras import RealDictCursor
from database import get_db_connection

def check_registered_customers():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT customer_id, name, email, phone FROM customers ORDER BY customer_id DESC;")
        customers = cursor.fetchall()

        cursor.close()
        connection.close()

        print("\n==================================================")
        print("          POSTGRESQL CUSTOMERS TABLE              ")
        print("==================================================")
        if not customers:
            print("No customers found in database.")
        else:
            print(f"Total Registered Customers: {len(customers)}\n")
            for c in customers:
                print(f"ID: {c['customer_id']} | Name: {c['name']} | Email: {c['email']} | Phone: {c['phone']}")
        print("==================================================\n")

    except Exception as e:
        print(f"Error connecting to database: {e}")

if __name__ == "__main__":
    check_registered_customers()
