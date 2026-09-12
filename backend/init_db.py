import os
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from werkzeug.security import generate_password_hash

# Force UTF-8 encoding for Windows console output
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

# PostgreSQL configuration matching database.py
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_NAME = os.environ.get("DB_NAME", "hotel_management")
DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASS = os.environ.get("DB_PASS", "92lnen70")
DB_PORT = os.environ.get("DB_PORT", "5432")

def initialize_database():
    print("==================================================")
    print("      AUTOMATED POSTGRESQL DATABASE SETUP         ")
    print("==================================================")

    # Step 1: Connect to default postgres DB and create 'hotel_management' if it doesn't exist
    try:
        print("1. Connecting to PostgreSQL server...")
        conn_init = psycopg2.connect(
            host=DB_HOST,
            database="postgres",
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT
        )
        conn_init.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cur_init = conn_init.cursor()

        cur_init.execute("SELECT 1 FROM pg_catalog.pg_database WHERE datname = %s;", (DB_NAME,))
        exists = cur_init.fetchone()

        if not exists:
            print(f"   Database '{DB_NAME}' not found. Creating database...")
            cur_init.execute(f'CREATE DATABASE "{DB_NAME}";')
            print(f"   [OK] Database '{DB_NAME}' created successfully!")
        else:
            print(f"   [OK] Database '{DB_NAME}' already exists.")

        cur_init.close()
        conn_init.close()

    except Exception as e:
        print(f"   [ERROR] Failed to connect to PostgreSQL server: {e}")
        print("   Troubleshooting: Please check if PostgreSQL service is running and credentials in database.py are correct.")
        return

    # Step 2: Connect to 'hotel_management' and apply schema.sql
    try:
        print("\n2. Applying Database Schema, Triggers, Views & Migrations...")
        conn_target = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT
        )
        cur_target = conn_target.cursor()

        # Locate schema.sql & data.sql
        script_dir = os.path.dirname(os.path.abspath(__file__))
        project_root = os.path.abspath(os.path.join(script_dir, ".."))
        schema_path = os.path.join(project_root, "database", "schema.sql")
        data_path = os.path.join(project_root, "database", "data.sql")

        if os.path.exists(schema_path):
            with open(schema_path, "r", encoding="utf-8") as f:
                schema_sql = f.read()

            # Execute table, view, and trigger creation SQL
            cur_target.execute(schema_sql)
            conn_target.commit()
            print("   [OK] Tables, Constraints, Views, and Triggers verified and schema migration applied!")
        else:
            print(f"   [WARNING] Could not find schema.sql at: {schema_path}")

        # Step 3: Insert seed data if tables are empty
        cur_target.execute("SELECT COUNT(*) FROM rooms;")
        room_count = cur_target.fetchone()[0]

        if room_count == 0 and os.path.exists(data_path):
            print("\n3. Populating Initial Seed Data (data.sql)...")
            with open(data_path, "r", encoding="utf-8") as f:
                data_sql = f.read()
            cur_target.execute(data_sql)
            conn_target.commit()
            print("   [OK] Seed data populated successfully!")
        else:
            print(f"\n3. Rooms table already populated ({room_count} rooms found).")

        # Step 4: Ensure Hashed Passwords for Default Demo Users
        print("\n4. Verifying Default Account Password Hashes...")
        default_guest_hash = generate_password_hash("guest123")
        default_staff_hash = generate_password_hash("staff123")
        default_admin_hash = generate_password_hash("admin123")

        # Upsert default staff accounts
        cur_target.execute(
            """
            INSERT INTO staff (name, email, password_hash, role, is_active)
            VALUES (%s, %s, %s, %s, TRUE)
            ON CONFLICT (email) DO UPDATE SET password_hash = %s;
            """,
            ("Arthur Pendelton", "reception@crowneplaza.com", default_staff_hash, "Receptionist", default_staff_hash)
        )
        cur_target.execute(
            """
            INSERT INTO staff (name, email, password_hash, role, is_active)
            VALUES (%s, %s, %s, %s, TRUE)
            ON CONFLICT (email) DO UPDATE SET password_hash = %s;
            """,
            ("System Administrator", "admin@crowneplaza.com", default_admin_hash, "Admin", default_admin_hash)
        )

        # Update customer hashes if legacy plain text
        cur_target.execute("SELECT customer_id, password_hash FROM customers;")
        customers = cur_target.fetchall()
        for cid, phash in customers:
            if not phash.startswith("scrypt:") and not phash.startswith("pbkdf2:"):
                new_hash = generate_password_hash(phash if phash else "guest123")
                cur_target.execute("UPDATE customers SET password_hash = %s WHERE customer_id = %s;", (new_hash, cid))

        conn_target.commit()
        print("   [OK] Default accounts & password hashes updated!")
        print("   -> Receptionist: reception@crowneplaza.com / staff123")
        print("   -> Admin: admin@crowneplaza.com / admin123")
        print("   -> Guest: customer@gmail.com / guest123")

        cur_target.close()
        conn_target.close()

        print("\n==================================================")
        print("    DATABASE SETUP COMPLETED SUCCESSFULLY!    ")
        print("==================================================\n")

    except Exception as e:
        print(f"   [ERROR] Error applying schema or seed data: {e}")

if __name__ == "__main__":
    initialize_database()
