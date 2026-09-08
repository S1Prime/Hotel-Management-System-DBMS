from flask import Flask, jsonify, request
from flask_cors import CORS
from database import get_db_connection
from psycopg2.extras import RealDictCursor
import psycopg2

app = Flask(__name__)
CORS(app)


@app.route("/")
def home():
    return jsonify({
        "message": "Crowne Plaza Hotel Management Backend is running!"
    })


# ------------------------------------------------------------------------------
# ROOMS API ENDPOINTS
# ------------------------------------------------------------------------------
@app.route("/api/rooms", methods=["GET"])
def get_rooms():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT * FROM rooms ORDER BY room_id ASC;")
        rooms = cursor.fetchall()

        cursor.close()
        connection.close()

        return jsonify(rooms)
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


@app.route("/api/rooms/<int:room_id>/status", methods=["PUT"])
def update_room_status(room_id):
    data = request.get_json()
    new_status = data.get("status")

    if not new_status:
        return jsonify({"error": "Status is required."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute(
            "UPDATE rooms SET status = %s WHERE room_id = %s RETURNING *;",
            (new_status, room_id)
        )
        updated_room = cursor.fetchone()
        connection.commit()

        cursor.close()
        connection.close()

        if not updated_room:
            return jsonify({"error": "Room not found."}), 404

        return jsonify(updated_room)
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


# ------------------------------------------------------------------------------
# CUSTOMERS API ENDPOINTS
# ------------------------------------------------------------------------------
@app.route("/api/customers", methods=["GET"])
def get_customers():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT customer_id, name, email, phone FROM customers ORDER BY customer_id DESC;")
        customers = cursor.fetchall()

        cursor.close()
        connection.close()

        return jsonify(customers)
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


@app.route("/api/customers", methods=["POST"])
def add_customer():
    data = request.get_json()

    if not data or not data.get("name") or not data.get("email") or not data.get("password"):
        return jsonify({"error": "Name, email, and password are required fields."}), 400

    name = data.get("name").strip()
    email = data.get("email").strip().lower()
    phone = data.get("phone", "").strip()
    password = data.get("password").strip()

    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        # Check if email already exists
        cursor.execute("SELECT customer_id FROM customers WHERE LOWER(email) = %s;", (email,))
        if cursor.fetchone():
            cursor.close()
            connection.close()
            return jsonify({"error": "An account with this email address already exists."}), 409

        # Insert new customer record into PostgreSQL
        insert_query = """
            INSERT INTO customers (name, email, phone, password_hash)
            VALUES (%s, %s, %s, %s)
            RETURNING customer_id, name, email, phone;
        """
        cursor.execute(insert_query, (name, email, phone, password))
        new_customer = cursor.fetchone()

        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({
            "message": "Customer registered successfully!",
            "customer": new_customer
        }), 201

    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


@app.route("/api/login", methods=["POST"])
def login_customer():
    data = request.get_json()

    if not data or not data.get("email") or not data.get("password"):
        return jsonify({"error": "Email and password are required."}), 400

    email = data.get("email").strip().lower()
    password = data.get("password").strip()

    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT customer_id, name, email, phone, password_hash FROM customers WHERE LOWER(email) = %s;", (email,))
        customer = cursor.fetchone()

        cursor.close()
        connection.close()

        if not customer or customer["password_hash"] != password:
            return jsonify({"error": "Invalid email or password."}), 401

        del customer["password_hash"]

        return jsonify({
            "message": "Login successful!",
            "customer": customer
        }), 200

    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


# ------------------------------------------------------------------------------
# RESERVATIONS API ENDPOINTS
# ------------------------------------------------------------------------------
@app.route("/api/reservations", methods=["GET"])
def get_reservations():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        query = """
            SELECT 
                res.reservation_id,
                res.customer_id,
                res.room_id,
                res.check_in,
                res.check_out,
                res.status,
                c.name AS guest_name,
                c.email AS guest_email,
                c.phone AS guest_phone,
                r.room_number,
                r.room_type,
                r.price_per_night
            FROM reservations res
            JOIN customers c ON res.customer_id = c.customer_id
            JOIN rooms r ON res.room_id = r.room_id
            ORDER BY res.reservation_id DESC;
        """
        cursor.execute(query)
        reservations = cursor.fetchall()

        cursor.close()
        connection.close()

        return jsonify(reservations)
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


@app.route("/api/reservations", methods=["POST"])
def create_reservation():
    data = request.get_json()

    customer_id = data.get("customer_id")
    customer_email = data.get("guest_email")
    room_number = data.get("room_number")
    check_in = data.get("check_in")
    check_out = data.get("check_out")

    if not room_number or not check_in or not check_out:
        return jsonify({"error": "Room number, check-in, and check-out dates are required."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        # 1. Resolve Customer ID if not directly provided
        if not customer_id and customer_email:
            cursor.execute("SELECT customer_id FROM customers WHERE LOWER(email) = %s;", (customer_email.lower(),))
            c_row = cursor.fetchone()
            if c_row:
                customer_id = c_row["customer_id"]

        if not customer_id:
            # Create a guest customer row if not exists
            guest_name = data.get("guest_name", "Valued Guest")
            guest_email = customer_email or f"guest_{room_number}@crowneplaza.com"
            guest_phone = data.get("guest_phone", "+1 (555) 000-0000")
            
            cursor.execute("SELECT customer_id FROM customers WHERE LOWER(email) = %s;", (guest_email.lower(),))
            existing_c = cursor.fetchone()
            if existing_c:
                customer_id = existing_c["customer_id"]
            else:
                cursor.execute(
                    "INSERT INTO customers (name, email, phone, password_hash) VALUES (%s, %s, %s, %s) RETURNING customer_id;",
                    (guest_name, guest_email.lower(), guest_phone, "guest123")
                )
                customer_id = cursor.fetchone()["customer_id"]

        # 2. Resolve Room ID by room_number
        cursor.execute("SELECT room_id FROM rooms WHERE room_number = %s;", (str(room_number),))
        r_row = cursor.fetchone()
        if not r_row:
            cursor.close()
            connection.close()
            return jsonify({"error": f"Room #{room_number} not found in database."}), 404

        room_id = r_row["room_id"]

        # 3. Insert reservation into PostgreSQL
        insert_res = """
            INSERT INTO reservations (customer_id, room_id, check_in, check_out, status)
            VALUES (%s, %s, %s, %s, 'Booked')
            RETURNING *;
        """
        cursor.execute(insert_res, (customer_id, room_id, check_in, check_out))
        new_reservation = cursor.fetchone()

        # 4. Update room status to Occupied
        cursor.execute("UPDATE rooms SET status = 'Occupied' WHERE room_id = %s;", (room_id,))

        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({
            "message": "Reservation created successfully in PostgreSQL!",
            "reservation": new_reservation
        }), 201

    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


@app.route("/api/reservations/<int:reservation_id>/status", methods=["PUT"])
def update_reservation_status(reservation_id):
    data = request.get_json()
    new_status = data.get("status")

    if not new_status:
        return jsonify({"error": "Status is required."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute(
            "UPDATE reservations SET status = %s WHERE reservation_id = %s RETURNING *;",
            (new_status, reservation_id)
        )
        res = cursor.fetchone()

        if res and new_status == 'Completed':
            cursor.execute("UPDATE rooms SET status = 'Cleaning' WHERE room_id = %s;", (res["room_id"],))
        elif res and new_status == 'Cancelled':
            cursor.execute("UPDATE rooms SET status = 'Available' WHERE room_id = %s;", (res["room_id"],))

        connection.commit()
        cursor.close()
        connection.close()

        if not res:
            return jsonify({"error": "Reservation not found."}), 404

        return jsonify(res)
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


# ------------------------------------------------------------------------------
# DASHBOARD METRICS API
# ------------------------------------------------------------------------------
@app.route("/api/metrics", methods=["GET"])
def get_metrics():
    try:
        connection = get_db_connection()
        cursor = connection.cursor(cursor_factory=RealDictCursor)

        cursor.execute("SELECT COUNT(*) AS total FROM rooms;")
        total_rooms = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM rooms WHERE status = 'Occupied';")
        occupied = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM rooms WHERE status = 'Available';")
        available = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM rooms WHERE status = 'Cleaning';")
        cleaning = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM rooms WHERE status = 'Maintenance';")
        maintenance = cursor.fetchone()["total"]

        cursor.execute("SELECT COUNT(*) AS total FROM reservations WHERE status IN ('Booked', 'Checked-In');")
        active_bookings = cursor.fetchone()["total"]

        cursor.close()
        connection.close()

        return jsonify({
            "totalRooms": total_rooms,
            "occupied": occupied,
            "available": available,
            "cleaning": cleaning,
            "maintenance": maintenance,
            "activeBookingsCount": active_bookings
        })
    except Exception as e:
        return jsonify({"error": f"Database error: {str(e)}"}), 500


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)