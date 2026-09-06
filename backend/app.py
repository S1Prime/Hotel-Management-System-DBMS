from flask import Flask, jsonify
from flask_cors import CORS
from database import get_db_connection

app = Flask(__name__)
CORS(app)


@app.route("/")
def home():
    return jsonify({
        "message": "Hotel Management Backend is running!"
    })


@app.route("/api/rooms")
def get_rooms():
    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT * FROM rooms;")

    rooms = cursor.fetchall()

    cursor.close()
    connection.close()

    return jsonify(rooms)


if __name__ == "__main__":
    app.run(debug=True)