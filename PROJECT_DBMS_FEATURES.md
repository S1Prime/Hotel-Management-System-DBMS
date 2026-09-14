# 🏨 Hotel Management System — DBMS Project Documentation

> **Course Project**: Database Management System (DBMS)  
> **Technologies**: PostgreSQL, Python Flask, HTML5/CSS3, Bootstrap 5, Vanilla JavaScript  

---

## 📑 Table of Contents
1. [System Architecture](#1-system-architecture)
2. [Database Schema & ER Structure](#2-database-schema--er-structure)
3. [Tables & Relationships Summary](#3-tables--relationships-summary)
4. [Keys & Relational Constraints](#4-keys--relational-constraints)
5. [SQL Triggers & Automation](#5-sql-triggers--automation)
6. [SQL Database Views](#6-sql-database-views)
7. [Flask RESTful API Endpoints](#7-flask-restful-api-endpoints)
8. [Dedicated Admin Dashboard & Role Security](#8-dedicated-admin-dashboard--role-security)
9. [Authentication & Security](#9-authentication--security)
10. [Key Workflows & Double-Booking Prevention](#10-key-workflows--double-booking-prevention)
11. [Viva Defense SQL Demonstration Queries](#11-viva-defense-sql-demonstration-queries)

---

## 1. System Architecture

The application implements a classic **Three-Tier Architecture**:

```text
┌──────────────────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER (Frontend)                    │
│  HTML5, CSS3 (Luxury Navy/Gold Theme), Bootstrap 5, JS            │
│  (index.html, customer-dashboard.html, reception-dashboard.html, │
│   admin.html)                                                    │
└───────────────────────────────┬──────────────────────────────────┘
                                │ REST APIs (JSON over HTTP)
┌───────────────────────────────▼──────────────────────────────────┐
│                  APPLICATION LAYER (Backend)                     │
│  Python Flask REST Engine (backend/app.py)                        │
│  Werkzeug Password Hashing, Psycopg2 Driver                      │
└───────────────────────────────┬──────────────────────────────────┘
                                │ Parameterized SQL Queries
┌───────────────────────────────▼──────────────────────────────────┐
│                    DATABASE LAYER (RDBMS)                        │
│  PostgreSQL Database (hotel_management)                           │
│  Triggers, Views, Foreign Keys, Check Constraints                │
└──────────────────────────────────────────────────────────────────┘
```

---

## 2. Database Schema & ER Structure

The database consists of **8 Core Tables**:

1. `customers` — Registered guest accounts.
2. `rooms` — Room inventory & current statuses.
3. `staff` — Receptionist & Admin staff credentials.
4. `reservations` — Guest stay bookings & check-in/out dates.
5. `services` — Hotel amenity catalog (Breakfast, Laundry, Spa, Extra Bed).
6. `service_requests` — In-room service orders placed by guests.
7. `bills` — Invoices generated upon checkout.
8. `housekeeping_tasks` — Cleaning task queue for staff.

---

## 3. Tables & Relationships Summary

| Table Name | Primary Key | Foreign Keys | Relationship |
| :--- | :--- | :--- | :--- |
| `customers` | `customer_id` | *None* | 1 Customer → Many `reservations` |
| `rooms` | `room_id` | *None* | 1 Room → Many `reservations`, Many `housekeeping_tasks` |
| `staff` | `staff_id` | *None* | Independent Staff Table |
| `reservations` | `reservation_id` | `customer_id`, `room_id` | 1 Reservation → 1 `bills`, Many `service_requests` |
| `services` | `service_id` | *None* | 1 Service → Many `service_requests` |
| `service_requests` | `request_id` | `reservation_id`, `service_id` | Links Reservation & Service Catalog |
| `bills` | `bill_id` | `reservation_id` (UNIQUE) | 1-to-1 link with Reservation |
| `housekeeping_tasks`| `task_id` | `room_id` | Links Room to Cleaning Workflow |

---

## 4. Keys & Relational Constraints

* **PRIMARY KEY Constraints**: Every table has an auto-incrementing `SERIAL PRIMARY KEY`.
* **FOREIGN KEY Constraints**:
  * `reservations.customer_id` → `customers.customer_id` (`ON DELETE CASCADE`)
  * `reservations.room_id` → `rooms.room_id` (`ON DELETE CASCADE`)
  * `service_requests.reservation_id` → `reservations.reservation_id` (`ON DELETE CASCADE`)
  * `service_requests.service_id` → `services.service_id` (`ON DELETE CASCADE`)
  * `bills.reservation_id` → `reservations.reservation_id` (`ON DELETE CASCADE`)
  * `housekeeping_tasks.room_id` → `rooms.room_id` (`ON DELETE CASCADE`)
* **CHECK Constraints**:
  * `rooms.price_per_night > 0`
  * `rooms.status IN ('Available', 'Occupied', 'Cleaning', 'Maintenance')`
  * `reservations.check_out > check_in`
  * `reservations.number_of_guests > 0`
  * `services.price >= 0`
  * `service_requests.quantity > 0`
  * `bills.total_amount >= 0`
  * `bills.payment_status IN ('Pending', 'Paid', 'Cancelled')`
  * `staff.role IN ('Admin', 'Receptionist')`
* **UNIQUE Constraints**:
  * `customers.email UNIQUE`
  * `staff.email UNIQUE`
  * `rooms.room_number UNIQUE`
  * `bills.reservation_id UNIQUE`

---

## 5. SQL Triggers & Automation

The project incorporates 3 PostgreSQL triggers to demonstrate automated database business logic:

### Trigger 1: Auto-Set Room Status to 'Cleaning' on Checkout
```sql
CREATE OR REPLACE FUNCTION fn_checkout_room_cleaning()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Checked-out' AND OLD.status != 'Checked-out') THEN
        UPDATE rooms SET status = 'Cleaning' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_checkout_room_cleaning
AFTER UPDATE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_checkout_room_cleaning();
```

### Trigger 2: Auto-Revert Room Status to 'Available' on Cancellation
```sql
CREATE OR REPLACE FUNCTION fn_cancel_room_available()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cancelled' AND OLD.status != 'Cancelled') THEN
        UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_cancel_room_available
AFTER UPDATE ON reservations
FOR EACH ROW EXECUTE FUNCTION fn_cancel_room_available();
```

### Trigger 3: Auto-Create Housekeeping Task when Room becomes 'Cleaning'
```sql
CREATE OR REPLACE FUNCTION fn_auto_housekeeping()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'Cleaning' AND OLD.status != 'Cleaning') THEN
        INSERT INTO housekeeping_tasks (room_id, task_type, status, notes)
        VALUES (NEW.room_id, 'Cleaning', 'Pending', 'Auto-created after guest checkout');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_housekeeping
AFTER UPDATE ON rooms
FOR EACH ROW EXECUTE FUNCTION fn_auto_housekeeping();
```

---

## 6. SQL Database Views

### View 1: `vw_active_reservations`
Joins `reservations`, `customers`, and `rooms` to provide front desk staff with guest stay details.

### View 2: `vw_available_rooms`
Returns room inventory currently vacant and ready for booking.

### View 3: `vw_revenue_summary`
Aggregates financial performance per room category using `SUM` and `GROUP BY`.

---

## 7. Flask RESTful API Endpoints

* **Staff Auth**: `POST /api/staff/login`, `GET /api/staff`
* **Customer Auth**: `POST /api/login`, `POST /api/customers`, `GET/PUT /api/customers/<id>/profile`
* **Rooms**: `GET /api/rooms`, `POST /api/rooms`, `PUT /api/rooms/<id>`, `DELETE /api/rooms/<id>`
* **Reservations**: `GET /api/reservations`, `POST /api/reservations`, `POST /api/reservations/<id>/check-in`, `POST /api/reservations/<id>/check-out`
* **Room Services**: `GET /api/services`, `GET/POST /api/service-requests`, `PUT /api/service-requests/<id>/status`
* **Bills**: `GET /api/bills`, `PUT /api/bills/<id>/pay`
* **Housekeeping**: `GET /api/housekeeping`, `PUT /api/housekeeping/<id>/status`
* **Reports**: `GET /api/reports`
* **Dedicated Admin APIs**:
  * `GET /api/admin/metrics`
  * `GET /api/admin/customers` & `GET /api/admin/customers/<id>/history`
  * `GET/POST /api/admin/staff` & `PUT /api/admin/staff/<id>`
  * `PUT /api/admin/services/<id>`

---

## 8. Dedicated Admin Dashboard & Role Security

The dedicated **Admin Dashboard** (`admin.html`) provides a centralized management interface with sidebar navigation:

```text
ADMIN CONTROL CENTER
├── 📊 Overview (Live metrics & system status)
├── 🏨 Room Management (Add rooms, edit price/type, status, deactivation)
├── 👥 Customer Records (Guest list, stay history lookup, password protection)
├── 📅 Reservations (Master booking list, search, status filter, cancel)
├── 🛎️ Hotel Services (Service catalog CRUD, pricing, availability, order fulfillment)
├── 💳 Bills & Invoices (Billing table, payment status, revenue audit)
├── 👨‍💼 Staff Management (Add Receptionists/Admins, toggle active status, assign role)
└── 📈 DBMS Reports (Occupancy %, revenue summary view, reservation stats)
```

### Role Routing Flow
```text
Staff Login (/api/staff/login)
           │
           ├─► role == 'Admin' ────────► Redirect to admin.html
           └─► role == 'Receptionist' ─► Redirect to reception-dashboard.html
```

---

## 9. Authentication & Security

* **Password Hashing**: Passwords stored using `werkzeug.security.generate_password_hash` (`scrypt`/`pbkdf2:sha256`).
* **SQL Injection Protection**: All Flask API SQL statements use **parameterized queries** (`%s` placeholders).
* **Role Guards**: Frontend `checkAuth('Admin')` redirects non-admins attempting to open `admin.html` to `unauthorized.html`.
* **Default Credentials for Testing**:
  * **Admin**: `admin@crowneplaza.com` / `admin123`
  * **Receptionist**: `reception@crowneplaza.com` / `staff123`
  * **Guest**: `customer@gmail.com` / `guest123`

---

## 10. Key Workflows & Double-Booking Prevention

### Double-Booking Prevention Logic
Before creating any reservation, Flask runs an SQL date overlap query:
```sql
SELECT reservation_id FROM reservations
WHERE room_id = %s
  AND status NOT IN ('Cancelled', 'Checked-out')
  AND check_in < %s   -- new_check_out
  AND check_out > %s; -- new_check_in
```
If a conflicting row exists, HTTP `409 Conflict` is returned with a clear error message.

### Check-Out & Billing Workflow
```text
Receptionist / Admin clicks Check-Out
           │
           ▼
UPDATE reservations SET status = 'Checked-out'
           │
           ├─► Trigger 1 sets rooms.status = 'Cleaning'
           │      └─► Trigger 3 inserts row in housekeeping_tasks
           │
           └─► API calculates (Nights × Price) + Services + 5% Tax
                  └─► INSERT INTO bills (payment_status = 'Pending')
```

---

## 11. Viva Defense SQL Demonstration Queries

All 19 standard viva queries are available in [database/queries.sql](file:///database/queries.sql) demonstrating `INNER JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `SUBQUERIES`, Date Filters, and Views.

---

## 12. Complete Dedicated SQL Modules Directory

To establish this project as an academic, enterprise-grade **PostgreSQL DBMS project**, the `database/` directory provides specialized, standalone SQL files covering the full spectrum of advanced database engineering:

| SQL File | DBMS Paradigm | Core Concepts Demonstrated |
| :--- | :--- | :--- |
| **`database/master_setup.sql`** | **One-Click Pure SQL Setup** | Complete build script executable directly in **pgAdmin 4** or **psql**. Builds all tables, constraints, indexes, triggers, views, stored procedures, and seed records without needing Python. |
| **`database/procedures.sql`** | **Stored Procedures & UDFs** | PL/pgSQL routines: `sp_create_reservation` (atomic booking with overlap checks), `sp_check_in_guest`, `sp_process_checkout` (computes nights + services + tax/discounts), `fn_calculate_stay_cost` (scalar UDF), and `fn_customer_stay_history` (table-valued UDF). |
| **`database/triggers_and_audit.sql`** | **Event-Condition-Action (ECA) & Auditing** | Dedicated `audit_logs` table tracking mutations with `JSONB` serialization; automated room status transitions (`Cleaning` on checkout, `Available` on cancellation), housekeeping task dispatch, and reservation date validation triggers. |
| **`database/views.sql`** | **Views & Materialized Views** | Operational views (`vw_active_reservations`, `vw_available_rooms`, `vw_housekeeping_queue`, `vw_service_popularity`), analytical customer loyalty tier view (`vw_customer_loyalty_ranking`), and `mv_monthly_financial_report` materialized view with concurrent refresh procedure. |
| **`database/advanced_queries.sql`** | **Advanced Analytics & Window Functions** | `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, cumulative running totals (`SUM(...) OVER(...)`), `LAG()`/`LEAD()` visitor comparisons, Multi-level CTEs, Recursive CTE for date series, Correlated subqueries (`EXISTS`/`NOT EXISTS`), `ALL`/`ANY`, and Set Operations (`UNION ALL`, `EXCEPT`). |
| **`database/indexes_and_performance.sql`** | **Index Strategies & EXPLAIN ANALYZE** | Composite B-Tree indexes, Partial Indexes (indexing only `Available` rooms), Foreign Key indexes, `EXPLAIN (ANALYZE, BUFFERS)` execution plans comparing Sequential Scans vs Index Scans, and index catalog size diagnostic queries. |
| **`database/roles_and_security.sql`** | **DCL, RBAC & Row-Level Security (RLS)** | PostgreSQL Roles (`hotel_admin`, `hotel_receptionist`, `hotel_guest_role`, `hotel_housekeeper`), Least-Privilege `GRANT`/`REVOKE` statements, and Row-Level Security policies restricting customer access strictly to their own reservations and bills. |
| **`database/transactions_acid.sql`** | **ACID Proofs & Concurrency Control** | Multi-statement transactional blocks demonstrating **Atomicity**, **Consistency** (constraint rejection), **Isolation** (`SERIALIZABLE` level), **Durability**, `SAVEPOINT` / partial rollback, and Pessimistic Locking (`SELECT ... FOR UPDATE`) to prevent race condition double-bookings. |
| **`database/schema.sql`** | **Relational DDL & Constraints** | The 8 fundamental entity tables with primary keys, foreign keys (`ON DELETE CASCADE`), unique constraints, and check constraints. |
| **`database/data.sql`** | **Relational DML & Seed Records** | Complete initial seed data for customers, staff, rooms, services, reservations, service requests, and bills. |

