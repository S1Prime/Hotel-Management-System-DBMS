import psycopg2


def get_db_connection():
    connection = psycopg2.connect(
        host="localhost",
        database="hotel_management",
        user="postgres",
        password="200728",
        port="5432"
    )

    return connection