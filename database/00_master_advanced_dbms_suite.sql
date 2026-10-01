-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — ENTERPRISE DBMS MASTER ADVANCED SUITE ORCHESTRATOR
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Comprehensive Academic & Production Suite Registry
--
-- This catalog indexes all advanced SQL modules created to demonstrate state-of-the-art
-- relational database capabilities without altering existing backend tables or APIs.
--
-- Module Catalog:
-- 01. analytics_olap_reporting.sql              - Window functions (NTILE, LAG, LEAD), ROLLUP, CUBE, RevPAR/ADR
-- 02. recursive_and_hierarchical_queries.sql    - WITH RECURSIVE CTEs, Org Chart, Calendar Series, Vacancy Islands
-- 03. stored_procedures_suite.sql               - Explicit cursors, Nightly Audit, Dynamic Pricing, Checkout FSM
-- 04. security_rls_and_audit_vault.sql          - Row Level Security (RLS) & SHA-256 Hash Chaining Audit Vault
-- 05. partitioning_and_archival.sql             - Declarative Range Partitioning by Year & Quarter, Dynamic DDL
-- 06. synthetic_data_generator.sql              - 100% Pure SQL Enterprise Mock Data Generator (generate_series)
-- 07. performance_tuning_benchmarks.sql         - Partial & Covering Indexes (INCLUDE), EXPLAIN (ANALYZE, BUFFERS)
-- 08. triggers_and_automation_engine.sql        - FSM Room Sync, VIP Auto-Perks, Double-Entry General Ledger
-- 09. materialized_views_and_reporting_datamart.sql - Concurrent zero-downtime refresh, Executive Datamarts
-- 10. relational_integrity_and_business_rules.sql - Custom Regex Domains, btree_gist Temporal Exclusion Guards
-- 11. enterprise_viva_defense_queries.sql       - Relational Algebra, Relational Division (Double Negation), Concurrency
-- 12. full_text_search_and_tsvector.sql         - PostgreSQL FTS, GIN Indexes, ts_rank, ts_headline highlighting
-- 13. advanced_transactions_concurrency.sql     - ACID Isolation anomalies, Advisory Locks (pg_advisory_xact_lock)
-- 14. schema_definitions_and_data_dictionary.sql - Automated Markdown Data Dictionary, Unindexed FK detector
-- 15. enterprise_viva_defense_handbook.sql      - 100-Point DBMS Theory and Viva Voce runnable SQL demonstrations
-- 16. stress_test_benchmark_workload.sql        - High-throughput read/write latency benchmarking and QPS profiling
-- 17. complex_analytical_window_queries.sql     - Market basket analysis in SQL, Accounts Receivable aging buckets
-- 18. enterprise_audit_log_triggers.sql         - Change Data Capture (CDC) JSONB diff triggers on all tables
-- 19. stored_procedure_business_workflows.sql   - Atomic group reservations, early checkout proration, room upgrades
-- 20. enterprise_data_warehouse_star_schema.sql - Dimensional Star Schema, SCD Type 2, in-database SQL ETL
-- 21. enterprise_plpgsql_triggers_collection.sql - Discount validation, occupancy protection, overstay alerts
-- 22. advanced_relational_calculus_and_queries.sql - TRC/DRC translations, 12-month revenue pivot matrix, graph search
-- 23. geospatial_and_concierge_analytics.sql    - Pure SQL Haversine spherical distance calculation & shuttle dispatch
-- 24. database_administration_and_maintenance.sql - Session watchdog, zombie termination, index bloat inspection
-- 25. advanced_jsonb_nosql_hybrid_store.sql     - IoT telemetry, JSON schema checks, JSON REST API generator in SQL
-- ================================================================================

-- Master System Diagnostic & Readiness Probe
CREATE OR REPLACE VIEW vw_master_dbms_suite_inventory AS
SELECT 
    'Hotel Management System' AS project_name,
    'PostgreSQL 14+ / Enterprise RDBMS' AS target_rdbms,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public') AS total_public_tables,
    (SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public') AS total_relational_views,
    (SELECT COUNT(*) FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid WHERE n.nspname = 'public') AS total_procedures_and_udfs,
    (SELECT COUNT(*) FROM pg_trigger) AS total_active_triggers,
    (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public') AS total_active_indexes,
    CURRENT_TIMESTAMP AS telemetry_timestamp;

-- --------------------------------------------------------------------------------
-- COMPREHENSIVE SUITE TEST RUNNER & VIVA EXECUTION GUIDE
-- --------------------------------------------------------------------------------
-- When presenting to an examiner, professor, or technical lead, follow this step-by-step
-- execution roadmap to demonstrate the advanced capabilities of the database engine:
--
-- STEP 1: Basic Relational & Schema Verification
--   Run: SELECT * FROM vw_master_dbms_suite_inventory;
--   Shows the full count of tables, relational views, stored procedures, and triggers.
--
-- STEP 2: Execute Analytical Window Functions & Industry KPIs
--   Run queries from: analytics_olap_reporting.sql
--   Demonstrates:
--     - Customer spending quartiles using NTILE(4)
--     - Day-over-day revenue velocity with LAG() and LEAD()
--     - 7-day trailing moving average revenue
--     - Multidimensional aggregation drilldown using ROLLUP and CUBE
--     - RevPAR (Revenue Per Available Room) & ADR (Average Daily Rate)
--
-- STEP 3: Hierarchical Recursive Common Table Expressions (CTEs)
--   Run queries from: recursive_and_hierarchical_queries.sql
--   Demonstrates:
--     - Staff organizational management tree traversal with depth levels
--     - 60-day calendar occupancy projection matrix
--     - Consecutive vacancy islands & gaps detection
--
-- STEP 4: Concurrency & Cryptographic Audit Trail Verification
--   Run queries from: security_rls_and_audit_vault.sql
--   Demonstrates:
--     - Row Level Security (RLS) tenant isolation
--     - Blockchain-style SHA-256 hash chaining on financial records
--     - CALL fn_verify_audit_integrity(); (proves zero tampering)
--
-- STEP 5: Declarative Table Partitioning & Performance Optimization
--   Run queries from: partitioning_and_archival.sql & performance_tuning_benchmarks.sql
--   Demonstrates:
--     - Range partitioning by year and quarter
--     - EXPLAIN (ANALYZE, BUFFERS) showing partition pruning
--     - Covering index-only scans (zero heap visits)
--     - Partial indexes filtering active records
--
-- STEP 6: In-Database Pure SQL Data Warehouse & ETL Engine
--   Run queries from: enterprise_data_warehouse_star_schema.sql
--   Demonstrates:
--     - Dimensional modeling (Fact and Dimension tables)
--     - Slowly Changing Dimensions (SCD Type 2)
--     - CALL dw_hotel.sp_populate_star_schema_etl();
-- ================================================================================

-- Execution Verification
SELECT * FROM vw_master_dbms_suite_inventory;


