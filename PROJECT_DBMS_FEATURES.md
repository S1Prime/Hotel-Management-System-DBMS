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

To establish this project as a flagship, academic, enterprise-grade **PostgreSQL DBMS project** where **SQL is the predominant core technology (>50% of the entire codebase)**, the `database/` directory provides specialized, standalone SQL modules covering the full spectrum of advanced database engineering:

| SQL File | DBMS Paradigm | Core Concepts Demonstrated |
| :--- | :--- | :--- |
| **`database/00_master_advanced_dbms_suite.sql`** | **Master Suite Registry** | Master orchestrator indexing all 25 advanced modules with system readiness views and step-by-step presentation execution runner. |
| **`database/analytics_olap_reporting.sql`** | **Advanced OLAP & BI Metrics** | Window Functions (`NTILE(4)`, `LAG()`, `LEAD()`, running totals), Multidimensional `ROLLUP`, `CUBE`, `GROUPING SETS`, RevPAR, and ADR calculations. |
| **`database/recursive_and_hierarchical_queries.sql`** | **Recursive CTEs (`WITH RECURSIVE`)** | Hierarchical organizational staff tree traversal, 60-day calendar occupancy projection, and consecutive vacancy island detection. |
| **`database/stored_procedures_suite.sql`** | **PL/pgSQL Business Engine** | Explicit cursors, nightly audit batch posting, dynamic pricing yield engine, and atomic checkout with automated housekeeping dispatch. |
| **`database/security_rls_and_audit_vault.sql`** | **RLS & Blockchain-Style Vault** | Row-Level Security tenant isolation policies and tamper-evident SHA-256 hash chaining audit vault with integrity verification. |
| **`database/partitioning_and_archival.sql`** | **Declarative Table Partitioning** | Range partitioning by year and quarter, automated partition provisioning procedure, and partition pruning demonstration (`EXPLAIN ANALYZE`). |
| **`database/synthetic_data_generator.sql`** | **100% Pure SQL Mock Generator** | Pure SQL data generation using `generate_series()` simulating 500+ guests, 50 rooms, 1,000+ bookings, and realistic billing folios. |
| **`database/performance_tuning_benchmarks.sql`** | **Covering Indexes & Profiling** | Partial indexes, covering indexes with `INCLUDE` clause for zero-heap Index-Only Scans, and buffer cache hit ratio diagnostics. |
| **`database/triggers_and_automation_engine.sql`** | **FSM State Triggers & Ledger** | Finite State Machine room status synchronizer, VIP amenity injection triggers, and double-entry general financial ledger audit triggers. |
| **`database/materialized_views_and_reporting_datamart.sql`** | **Concurrent Datamart Refresh** | Executive monthly KPIs, room performance matrices, and zero-downtime non-blocking concurrent refresh procedures. |
| **`database/relational_integrity_and_business_rules.sql`** | **Custom Domains & GiST Guards** | Custom Regex DOMAIN types, temporal exclusion constraints (`btree_gist`), and system-wide integrity healthcheck functions. |
| **`database/enterprise_viva_defense_queries.sql`** | **Viva Voce & Relational Algebra** | Relational Algebra operations, Relational Division (`NOT EXISTS ... NOT EXISTS`), and high-concurrency worker queues (`SELECT FOR UPDATE SKIP LOCKED`). |
| **`database/enterprise_viva_defense_handbook.sql`** | **100-Point Theory & Defense Guide** | Runnable SQL demonstrations of Normalization (1NF to BCNF), MVCC tuple inspection (`xmin`, `xmax`, `ctid`), Updatable Views (`WITH CHECK OPTION`), and VACUUM mechanics. |
| **`database/full_text_search_and_tsvector.sql`** | **PostgreSQL Full-Text Search** | Lexeme stemming with `to_tsvector`, GIN inverted indexes, search ranking (`ts_rank`), and snippet highlighting (`ts_headline`). |
| **`database/advanced_transactions_concurrency.sql`** | **ACID & Concurrency Guards** | Transaction savepoints, row-level pessimistic locking (`NOWAIT`, `FOR UPDATE`), and PostgreSQL distributed advisory locks (`pg_advisory_xact_lock`). |
| **`database/schema_definitions_and_data_dictionary.sql`** | **Automated Data Dictionary** | System catalog introspection querying `information_schema` and `pg_catalog`, unindexed foreign keys detector, and referential dependency trees. |
| **`database/enterprise_data_warehouse_star_schema.sql`** | **Dimensional Star Schema & ETL** | Fact & Dimension tables, Slowly Changing Dimensions (SCD Type 2), in-database SQL ETL pipeline, and OLAP multidimensional slicing and dicing. |
| **`database/enterprise_plpgsql_triggers_collection.sql`** | **Constraint & Protection Triggers** | Financial discount ceiling validators, active occupancy price lockouts, and overdue stay detection alerts. |
| **`database/advanced_relational_calculus_and_queries.sql`** | **Relational Calculus & Pivots** | TRC/DRC translations, 12-month cross-tabulation revenue pivot matrices, dynamic unpivoting, and recursive graph adjacency for connecting suites. |
| **`database/geospatial_and_concierge_analytics.sql`** | **Pure SQL Geospatial Analytics** | Spherical Great-Circle Haversine distance calculations in pure SQL, shuttle fare estimation, and local attraction proximity matrices. |
| **`database/database_administration_and_maintenance.sql`** | **DBA Maintenance Runbook** | Idle-in-transaction session watchdog, zombie connection termination procedure, and index bloat diagnostic views. |
| **`database/advanced_jsonb_nosql_hybrid_store.sql`** | **JSONB NoSQL Hybrid Engine** | Semi-structured IoT smart room telemetry, JSON path expressions (`jsonb_path_query`), GIN indexing, and in-database JSON REST API generators. |
| **`database/stress_test_benchmark_workload.sql`** | **Workload & Latency Benchmarks** | High-throughput read/write workload simulators measuring execution latency in milliseconds and queries-per-second (QPS). |
| **`database/complex_analytical_window_queries.sql`** | **Market Basket & Aging Analysis** | Amenity cross-sell market basket analysis, accounts receivable aging buckets (0-30, 31-60, 90+ days), and housekeeping turnaround analytics. |
| **`database/enterprise_audit_log_triggers.sql`** | **Universal CDC Audit Trail** | Universal JSONB delta tracking across all core entity mutations with client IP, username, and point-in-time state reconstruction. |
| **`database/master_setup.sql`** | **One-Click Pure SQL Setup** | Complete build script executable directly in **pgAdmin 4** or **psql**. |
| **`database/schema.sql` & `data.sql`** | **Core Tables & Seed Records** | Foundation OLTP relational tables and initial seed data. |


