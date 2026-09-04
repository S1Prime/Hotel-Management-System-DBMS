from database import get_db_connection

try:
    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT * FROM customers;")
    customers = cursor.fetchall()

    print("\nCUSTOMERS:")
    for customer in customers:
        print(customer)

    cursor.execute("SELECT * FROM rooms;")
    rooms = cursor.fetchall()

    print("\nROOMS:")
    for room in rooms:
        print(room)

    cursor.execute("SELECT * FROM reservations;")
    reservations = cursor.fetchall()

    print("\nRESERVATIONS:")
    for reservation in reservations:
        print(reservation)

    cursor.close()
    connection.close()

except Exception as e:
    print("❌ Error:")
    print(e)