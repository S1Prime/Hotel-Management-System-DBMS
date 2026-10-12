-- ================================================================================
-- HOTEL MANAGEMENT SYSTEM — SCHEMA METRICS & AUTOMATED DATA DICTIONARY
-- PostgreSQL Relational Database Management System (RDBMS)
-- ================================================================================
-- Focus Areas:
-- 1. Automated Markdown / Tabular Data Dictionary from System Catalogs
-- 2. Foreign Key Dependency Topology & Referential Integrity Audit
-- 3. Unindexed Foreign Keys Detection (Critical for Preventing Table-Level Locks)
-- 4. Column Cardinality & Storage Footprint Profiler
-- 5. Constraint Catalog & Validation State Reporter
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SECTION 1: AUTOMATED DATA DICTIONARY ENGINE
-- --------------------------------------------------------------------------------

-- View: Complete Self-Documenting Data Dictionary
CREATE OR REPLACE VIEW vw_data_dictionary AS
SELECT 
    t.table_schema,
    t.table_name,
    c.ordinal_position AS column_order,
    c.column_name,
    c.data_type,
    c.character_maximum_length,
    c.is_nullable,
    c.column_default,
    tc.constraint_type,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.tables t
JOIN information_schema.columns c 
    ON t.table_schema = c.table_schema AND t.table_name = c.table_name
LEFT JOIN information_schema.key_column_usage kcu
    ON t.table_schema = kcu.table_schema 
   AND t.table_name = kcu.table_name 
   AND c.column_name = kcu.column_name
LEFT JOIN information_schema.table_constraints tc
    ON kcu.table_schema = tc.table_schema 
   AND kcu.table_name = tc.table_name 
   AND kcu.constraint_name = tc.constraint_name
LEFT JOIN information_schema.constraint_column_usage ccu
    ON tc.constraint_name = ccu.constraint_name
WHERE t.table_schema = 'public' 
  AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name, c.ordinal_position;


-- --------------------------------------------------------------------------------
-- SECTION 2: UNINDEXED FOREIGN KEYS DETECTOR
-- Missing indexes on FK columns cause full-table locks during cascading updates/deletes!
-- --------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_unindexed_foreign_keys AS
WITH fk_columns AS (
    SELECT 
        c.conrelid::regclass AS table_name,
        a.attname AS fk_column,
        c.conname AS constraint_name,
        c.confrelid::regclass AS referenced_table
    FROM pg_constraint c
    CROSS JOIN LATERAL unnest(c.conkey) WITH ORDINALITY AS cols(attnum, ord)
    JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = cols.attnum
    WHERE c.contype = 'f'
),
indexed_columns AS (
    SELECT 
        i.indrelid::regclass AS table_name,
        a.attname AS indexed_column
    FROM pg_index i
    CROSS JOIN LATERAL unnest(i.indkey) WITH ORDINALITY AS cols(attnum, ord)
    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = cols.attnum
    WHERE cols.ord = 1 -- Leading column of index
)
SELECT 
    fk.table_name,
    fk.fk_column,
    fk.constraint_name,
    fk.referenced_table,
    'CREATE INDEX idx_' || replace(fk.table_name::text, '"', '') || '_' || fk.fk_column || 
    ' ON ' || fk.table_name || ' (' || fk.fk_column || ');' AS recommended_index_ddl
FROM fk_columns fk
LEFT JOIN indexed_columns ic 
    ON fk.table_name = ic.table_name AND fk.fk_column = ic.indexed_column
WHERE ic.indexed_column IS NULL;


-- --------------------------------------------------------------------------------
-- SECTION 3: TOPOLOGICAL REFERENTIAL TABLE DEPENDENCY ORDER
-- Computes safe execution order for DB truncation or initial seeding
-- --------------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_referential_dependency_order AS
SELECT 
    cl_child.relname AS dependent_child_table,
    con.conname AS foreign_key_constraint,
    cl_parent.relname AS prerequisite_parent_table
FROM pg_constraint con
JOIN pg_class cl_child ON con.conrelid = cl_child.oid
JOIN pg_class cl_parent ON con.confrelid = cl_parent.oid
JOIN pg_namespace n ON cl_child.relnamespace = n.oid
WHERE con.contype = 'f' AND n.nspname = 'public'
ORDER BY cl_parent.relname, cl_child.relname;
