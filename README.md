# 🏨 Hotel Management System — DBMS Enterprise Engine

An enterprise-grade, relational Hotel Management System powered by **PostgreSQL 14+** and a **Python Flask REST API**. 

Unlike conventional web systems where the database is treated merely as a passive storage silo, this architecture leverages PostgreSQL as an **autonomous, active relational engine**. Critical business logic, concurrency isolation, audit logging, state-machine lifecycles, and analytical calculations are executed directly within the database tier via PL/pgSQL routines, triggers, engine-level constraints, and views.

---

## 📑 Table of Contents
- [1. System Architecture](#1-system-architecture)
- [2. Relational Schema & ER Design](#2-relational-schema--er-design)
- [3. Core SQL & DBMS Implementation Details](#3-core-sql--dbms-implementation-details)
  - [A. DDL & Engine-Level Data Integrity](#a-ddl--engine-level-data-integrity)
  - [B. Indexing Strategy & Performance Tuning](#b-indexing-strategy--performance-tuning)
  - [C. Concurrency Control & Race Condition Prevention](#c-concurrency-control--race-condition-prevention)
  - [D. PL/pgSQL Triggers (Automated State Transitions)](#d-plpgsql-triggers-automated-state-transitions)
  - [E. Stored Procedures & Business Routines](#e-stored-procedures--business-routines)
  - [F. DCL, RBAC & Row-Level Security (RLS)](#f-dcl-rbac--row-level-security-rls)
  - [G. OLAP Analytics, Window Functions & Hospitality KPIs](#g-olap-analytics-window-functions--hospitality-kpis)
- [4. Primary Business Workflows](#4-primary-business-workflows)
- [5. Project Directory Structure](#5-project-directory-structure)
- [6. Setup and Installation](#6-setup-and-installation)

---

## 1. System Architecture

The application is structured according to the classic **Three-Tier Enterprise Architecture**:
# 📜 License

This project was developed for educational purposes as part of a **Database Management System (DBMS)** course and is intended for learning, academic demonstration, and portfolio use.
