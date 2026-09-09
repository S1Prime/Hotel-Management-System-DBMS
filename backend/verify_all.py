import sys
from verify_customers import check_registered_customers
from verify_rooms import check_rooms
from verify_reservations import check_reservations

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

def check_all_database_tables():
    print("\n**************************************************")
    print("      FULL POSTGRESQL DATABASE INSPECTION         ")
    print("**************************************************")
    check_registered_customers()
    check_rooms()
    check_reservations()
    print("**************************************************\n")

if __name__ == "__main__":
    check_all_database_tables()
