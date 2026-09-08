import os
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

# Force UTF-8 encoding for Windows console output
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

# PostgreSQL configuration matching database.py
DB_HOST = "localhost"
DB_NAME = "hotel_management"
DB_USER = "postgres"
DB_PASS = "200728"
DB_PORT = "5432"

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
        print("   Troubleshooting: Please check if PostgreSQL service is running and password in database.py is correct.")
        return

    # Step 2: Connect to 'hotel_management' and apply schema.sql
    try:
        print("\n2. Applying Database Schema & Column Migration...")
        conn_target = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT
        )
        cur_target = conn_target.cursor()

        # Locate schema.sql
        script_dir = os.path.dirname(os.path.abspath(__file__))
        project_root = os.path.abspath(os.path.join(script_dir, ".."))
        schema_path = os.path.join(project_root, "database", "schema.sql")
        data_path = os.path.join(project_root, "database", "data.sql")

        if os.path.exists(schema_path):
            with open(schema_path, "r", encoding="utf-8") as f:
                schema_sql = f.read()

            # Execute table creation SQL
            cur_target.execute(schema_sql)

            # Ensure phone column width is VARCHAR(30)
            cur_target.execute("ALTER TABLE customers ALTER COLUMN phone TYPE VARCHAR(30);")

            conn_target.commit()
            print("   [OK] Tables (customers, rooms, reservations) verified and schema migration applied!")
        else:
            print(f"   [WARNING] Could not find schema.sql at: {schema_path}")

        # Step 3: Insert seed data if rooms table is empty
        cur_target.execute("SELECT COUNT(*) FROM rooms;")
        room_count = cur_target.fetchone()[0]

        if room_count == 0 and os.path.exists(data_path):
            print("\n3. Populating Initial Seed Data (data.sql)...")
            with open(data_path, "r", encoding="utf-8") as f:
                data_sql = f.read()
            cur_target.execute(data_sql)
            conn_target.commit()
            print("   [OK] Seed rooms and customers populated successfully!")
        else:
            print(f"\n3. Rooms table already populated ({room_count} rooms found).")

        cur_target.close()
        conn_target.close()

        print("\n==================================================")
        print("    DATABASE SETUP COMPLETED SUCCESSFULLY!    ")
        print("==================================================\n")

    except Exception as e:
        print(f"   [ERROR] Error applying schema or seed data: {e}")

if __name__ == "__main__":
    initialize_database()
