import os
import psycopg2


DB_CONFIG = {
    "host": os.environ.get("DB_HOST", "localhost"),
    "database": os.environ.get("DB_NAME", "hotel_management"),
    "user": os.environ.get("DB_USER", "postgres"),
    "password": os.environ.get("DB_PASS", "200728"),
    "port": os.environ.get("DB_PORT", "5432")
}


def get_db_connection():
    return psycopg2.connect(**DB_CONFIG)