# Database files

## Application schema

The application connects to the PostgreSQL database `hotel_management`. Its source schema is [`schema.sql`](schema.sql), installed by `backend/init_db.py`. The setup also applies `food_menu.sql` and `reservation_expenses.sql` as feature migrations. These files are the database definitions used by the running application.

The schema keeps the ER model's eight main entities and names:

| ER entity | Table |
| --- | --- |
| Customers | `customers` |
| Staff | `staff` |
| Rooms | `rooms` |
| Services | `services` |
| Reservations | `reservations` |
| Service requests | `service_requests` |
| Bills | `bills` |
| Housekeeping tasks | `housekeeping_tasks` |

The application also uses extra attributes and tables for existing features such as food ordering, reservation expenses, offers, and lost-and-found. Keep those extensions when modifying the schema; application queries depend on them. The ER diagram is the core model, while these extensions support the working product. The app schema contains no JSON/JSONB columns.

The core schema has a small set of PL/pgSQL trigger functions: one snapshots a service's price when a request is inserted, one marks a room as cleaning after checkout, one makes a room available after cancellation, and one creates the associated housekeeping task. They run automatically as part of existing app behavior.

## PostgreSQL syntax

The project uses PostgreSQL through `psycopg2`. `SERIAL`, `ON CONFLICT`, `RETURNING`, `JSONB`, `DO $$ ... $$`, `RAISE NOTICE`, PL/pgSQL functions and procedures, triggers, row-level security policies, and `::type` casts are PostgreSQL syntax/features. They are not portable MySQL syntax. Blocks containing `IF`, `FOR`, or `LOOP` are procedural code executed by PostgreSQL's PL/pgSQL language, not loops required for ordinary SQL queries.

Files such as `sample_operations.sql`, `roles_and_security.sql`, `security_rls_and_audit_vault.sql`, `advanced_jsonb_nosql_hybrid_store.sql`, and the `enterprise_*`, `analytics_*`, and `*_benchmark*` files are optional coursework demonstrations. Their tables and names (for example `room_iot_telemetry`, `audit_vault`, and `dw_hotel`) are examples for topics such as sensor data, auditing, and analytics; they are not the app's hotel schema and are not loaded at startup. `backend/init_db.py` does not execute these files. In particular, `master_setup.sql` drops and recreates the `public` schema; do not run it against an existing database unless you intend to erase its objects.
