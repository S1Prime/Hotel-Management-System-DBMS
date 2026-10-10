# 🏨 Hotel Management System — DBMS

A database-driven Hotel Management System developed as a **Database Management Systems (DBMS) project** using a three-tier architecture.

The system combines a web-based frontend, a Python Flask backend, and a PostgreSQL relational database to manage hotel customers, rooms, and reservations.

---

## 📑 Table of Contents

- [1. Project Overview](#1-project-overview)
- [2. System Architecture](#2-system-architecture)
- [3. Technology Stack](#3-technology-stack)
- [4. Main Features](#4-main-features)
- [5. Database Design](#5-database-design)
- [6. Database Tables](#6-database-tables)
- [7. Project Structure](#7-project-structure)
- [8. Backend API](#8-backend-api)
- [9. Database Setup](#9-database-setup)
- [10. Backend Setup](#10-backend-setup)
- [11. Running the Project](#11-running-the-project)
- [12. DBMS Concepts Demonstrated](#12-dbms-concepts-demonstrated)
- [13. Future Enhancements](#13-future-enhancements)
- [14. Contributors](#14-contributors)

---

# 1. Project Overview

The **Hotel Management System** is designed to manage basic hotel operations through a centralized relational database.

The current system focuses on:

- Customer registration
- Customer information management
- Hotel room management
- Room availability
- Room reservations
- Reservation records
- Customer-room relationships
- Backend communication through REST APIs

The project follows a clear separation between the frontend, backend, and database layers.

---

# 2. System Architecture

The system follows a **Three-Tier Architecture**:

```text
┌──────────────────────────────────────────┐
│                FRONTEND                  │
│                                          │
│        HTML + CSS + JavaScript           │
│              Bootstrap 5                 │
└────────────────────┬─────────────────────┘
                     │
                     │ HTTP / JSON
                     ▼
┌──────────────────────────────────────────┐
│                BACKEND                   │
│                                          │
│             Python + Flask              │
│                                          │
│       REST API + Business Logic          │
└────────────────────┬─────────────────────┘
                     │
                     │ SQL
                     ▼
┌──────────────────────────────────────────┐
│               DATABASE                   │
│                                          │
│             PostgreSQL                  │
│                                          │
│       Customers / Rooms / Reservations   │
└──────────────────────────────────────────┘
```

### Data Flow

```text
User
 │
 ▼
HTML/CSS/JavaScript
 │
 ▼
Flask REST API
 │
 ▼
PostgreSQL
 │
 ▼
Database Response
 │
 ▼
Flask
 │
 ▼
Frontend
```

---

# 3. Technology Stack

| Component | Technology |
|---|---|
| Frontend | HTML5 |
| Styling | CSS3 |
| Client-side scripting | JavaScript |
| UI Framework | Bootstrap 5 |
| Icons | Font Awesome |
| Backend | Python |
| Web Framework | Flask |
| API | REST API |
| Database | PostgreSQL |
| PostgreSQL Driver | psycopg2 |
| Database Administration | pgAdmin 4 |
| Version Control | Git / GitHub |

### Codebase Languages Distribution

| Language | Files | Lines of Code | Share (%) |
|:---|:---:|:---:|:---:|
| **SQL (PostgreSQL)** | 52 | 8,533 | **39.75%** |
| **Python** | 20 | 6,384 | **29.74%** |
| **HTML5** | 10 | 4,603 | **21.45%** |
| **JavaScript** | 4 | 1,184 | **5.52%** |
| **CSS3** | 1 | 760 | **3.54%** |

> **GitHub Linguist Language Bar**: All 5 active technology layers detected with **SQL (38.25%)** leading as the #1 greatest segment.

---

# 4. Main Features

## Customer Features

- Guest registration
- Customer login
- Customer information storage
- Room viewing
- Room availability checking
- Room reservation
- Reservation history

## Reception Features

- Receptionist login
- View customer information
- View rooms
- View reservations
- Manage hotel booking information
- Monitor room status

## Database Features

- Relational database design
- Primary keys
- Foreign keys
- Referential integrity
- Unique constraints
- Data validation
- SQL queries
- Table relationships
- Reservation management

---

# 5. Database Design

The current database consists of three core entities:

```text
             ┌─────────────────┐
             │    CUSTOMERS    │
             ├─────────────────┤
             │ PK customer_id  │
             │ name            │
             │ email           │
             │ phone           │
             │ password_hash   │
             └────────┬────────┘
                      │
                      │ 1 : N
                      │
                      ▼
             ┌─────────────────────┐
             │    RESERVATIONS     │
             ├─────────────────────┤
             │ PK reservation_id   │
             │ FK customer_id      │
             │ FK room_id          │
             │ check_in            │
             │ check_out           │
             │ status              │
             └──────────┬──────────┘
                        │
                        │ N : 1
                        │
                        ▼
             ┌─────────────────────┐
             │        ROOMS        │
             ├─────────────────────┤
             │ PK room_id          │
             │ room_number         │
             │ room_type           │
             │ price_per_night     │
             │ status              │
             └─────────────────────┘
```

### Relationships

- One customer can have multiple reservations.
- Each reservation belongs to one customer.
- One room can have multiple reservations over different dates.
- Each reservation belongs to one room.

---

# 6. Database Tables

## 6.1 Customers

The `customers` table stores guest account information.

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    password_hash TEXT NOT NULL
);
```

### Columns

| Column | Type | Description |
|---|---|---|
| customer_id | SERIAL | Primary key |
| name | VARCHAR(100) | Customer name |
| email | VARCHAR(100) | Unique customer email |
| phone | VARCHAR(15) | Customer phone number |
| password_hash | TEXT | Hashed password |

---

## 6.2 Rooms

The `rooms` table stores hotel room information.

```sql
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);
```

### Columns

| Column | Type | Description |
|---|---|---|
| room_id | SERIAL | Primary key |
| room_number | VARCHAR(10) | Hotel room number |
| room_type | VARCHAR(50) | Type of room |
| price_per_night | NUMERIC(10,2) | Room price |
| status | VARCHAR(20) | Current room status |

---

## 6.3 Reservations

The `reservations` table stores booking information.

```sql
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Booked',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
);
```

### Columns

| Column | Type | Description |
|---|---|---|
| reservation_id | SERIAL | Primary key |
| customer_id | INT | Foreign key to customers |
| room_id | INT | Foreign key to rooms |
| check_in | DATE | Check-in date |
| check_out | DATE | Check-out date |
| status | VARCHAR(20) | Reservation status |

---

# 7. Project Structure

```text
Hotel-Management-System-DBMS/
│
├── assets/
│   ├── css/
│   │   └── style.css
│   │
│   └── js/
│       └── auth.js
│
├── backend/
│   ├── venv/
│   ├── app.py
│   ├── database.py
│   ├── requirements.txt
│   └── test_db.py
│
├── database/
│   ├── schema.sql
│   ├── data.sql
│   └── queries.sql
│
├── index.html
├── login.html
├── customer-login.html
├── register.html
├── customer-dashboard.html
├── reception-login.html
├── reception-dashboard.html
├── unauthorized.html
├── .gitignore
└── README.md
```

> `venv/` is a local Python virtual environment and should not be committed to GitHub.

---

# 8. Backend API

The Python Flask backend provides REST endpoints for communication between the frontend and PostgreSQL database.

## Home / Health Check

```http
GET /
```

Example response:

```json
{
    "message": "Hotel Management Backend is running!"
}
```

---

## Get Rooms

```http
GET /api/rooms
```

This endpoint retrieves room information from the PostgreSQL `rooms` table.

Example response:

```json
[
    {
        "room_id": 1,
        "room_number": "101",
        "room_type": "Single",
        "price_per_night": 2000,
        "status": "Available"
    }
]
```

---

## Planned Registration Endpoint

```http
POST /api/register
```

The registration endpoint will receive customer information from the frontend and insert the new customer into the PostgreSQL `customers` table.

Example request:

```json
{
    "first_name": "Rahul",
    "last_name": "Sharma",
    "email": "rahul@gmail.com",
    "phone": "9876543210",
    "password": "example-password"
}
```

The backend combines the first and last name and securely stores the password as a hash.

---

# 9. Database Setup

## Step 1 — Install PostgreSQL

Install PostgreSQL 14 or later and pgAdmin 4.

---

## Step 2 — Create Database

Create a PostgreSQL database named:

```text
hotel_management
```

---

## Step 3 — Create Tables

Open:

```text
database/schema.sql
```

Execute the SQL commands in pgAdmin.

This creates:

```text
customers
rooms
reservations
```

---

## Step 4 — Insert Initial Data

Open:

```text
database/data.sql
```

Execute the SQL commands after creating the tables.

Example room data:

```sql
INSERT INTO rooms
(room_number, room_type, price_per_night, status)
VALUES
('101', 'Single', 2000, 'Available'),
('102', 'Double', 3500, 'Available'),
('103', 'Deluxe', 5000, 'Available'),
('104', 'Deluxe', 5000, 'Available'),
('201', 'Suite', 8000, 'Available'),
('202', 'Suite', 8000, 'Available');
```

---

# 10. Backend Setup

Navigate to the backend:

```bash
cd backend
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate it on Windows:

```bash
venv\Scripts\activate
```

Install the required packages:

```bash
pip install -r requirements.txt
```

The main dependencies are:

```text
Flask
Flask-CORS
psycopg2-binary
Werkzeug
```

---

## Database Configuration

The PostgreSQL connection is configured in:

```text
backend/database.py
```

Example:

```python
import psycopg2


def get_db_connection():
    connection = psycopg2.connect(
        host="localhost",
        database="hotel_management",
        user="postgres",
        password="YOUR_PASSWORD",
        port="5432"
    )

    return connection
```

### Security

Do not commit your real PostgreSQL password to GitHub.

For development, environment variables should eventually be used:

```text
DB_HOST
DB_NAME
DB_USER
DB_PASSWORD
DB_PORT
```

The `.env` file should be added to `.gitignore`.

---

# 11. Running the Project

## Start the Backend

From the `backend` directory:

```bash
python app.py
```

The Flask server runs at:

```text
http://127.0.0.1:5000
```

---

## Test the Backend

Open:

```text
http://127.0.0.1:5000/
```

Expected response:

```json
{
    "message": "Hotel Management Backend is running!"
}
```

---

## Test the Room API

Open:

```text
http://127.0.0.1:5000/api/rooms
```

The endpoint should return the rooms stored in PostgreSQL.

---

# 12. DBMS Concepts Demonstrated

This project demonstrates the following DBMS concepts:

### Relational Database

- Tables
- Rows
- Columns
- Relationships

### Keys

- Primary keys
- Foreign keys

### Constraints

- NOT NULL
- UNIQUE
- DEFAULT
- Referential integrity

### SQL

- CREATE TABLE
- INSERT
- SELECT
- UPDATE
- DELETE
- WHERE
- ORDER BY
- JOIN
- Aggregate functions
- GROUP BY
- HAVING

### Database Design

- Entity Relationship modelling
- Relational schema
- Normalization
- Foreign key relationships

### Backend Integration

- Python Flask
- REST APIs
- JSON
- PostgreSQL connectivity
- Frontend-backend communication

---

# 13. Future Enhancements

The following features can be added as the project develops:

- Customer authentication
- Secure login
- Reservation API
- Booking cancellation
- Check-in and check-out
- Payment management
- Invoice generation
- Room service management
- Employee management
- Housekeeping management
- Reservation history
- Revenue reports
- Occupancy reports
- Advanced SQL views
- Database triggers
- Stored procedures
- Transaction management
- Audit logging
- Role-based access control

---

# 14. Contributors

## Hotel Management System — DBMS Project

**Department of Computer Science and Engineering**

**Amrita School of Computing**

**Amrita Vishwa Vidyapeetham**

---

## 📌 Project Summary

```text
             HOTEL MANAGEMENT SYSTEM
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
     FRONTEND       BACKEND        DATABASE
        │              │              │
   HTML/CSS/JS     Python Flask    PostgreSQL
        │              │              │
        └────── REST API / JSON ──────┘
                       │
                       ▼
             Hotel Management Data
```

The project provides a structured foundation for integrating a web-based hotel management interface with a Python Flask backend and PostgreSQL relational database.
