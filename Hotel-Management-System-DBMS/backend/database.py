import os
import psycopg2


def get_db_connection():
    connection = psycopg2.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        database=os.environ.get("DB_NAME", "hotel_management"),
        user=os.environ.get("DB_USER", "postgres"),
        # Keep the application connection default aligned with init_db.py.
        password=os.environ.get("DB_PASS", "Prathijnampn@2008"),
        port=os.environ.get("DB_PORT", "5432")
    )

    return connection
