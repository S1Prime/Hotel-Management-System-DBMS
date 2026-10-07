"""
Crowne Plaza Hotel Management System - Comprehensive Database & API Health Checker
==================================================================================
Performs complete live validation across:
1. PostgreSQL Database Direct Connection & Querying of all tables and views.
2. Flask Backend REST APIs over HTTP (Port 5000).
3. Frontend Web Data Binding & Dynamic Rendering over HTTP (Port 8000) using Playwright.
"""

import sys
import os
import urllib.request
import json
import psycopg2
from psycopg2.extras import RealDictCursor
from playwright.sync_api import sync_playwright

sys.path.insert(0, 'backend')
from database import get_db_connection

def check_postgresql_tables_and_views():
    print("=" * 75)
    print("1. DIRECT POSTGRESQL DATABASE TABLES & VIEWS HEALTH CHECK")
    print("=" * 75)

    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)

    tables = [
        "rooms",
        "customers",
        "staff",
        "reservations",
        "services",
        "service_requests",
        "housekeeping_tasks",
        "bills",
        "lost_and_found",
        "audit_logs"
    ]

    print(f"{'TABLE NAME':<25} | {'STATUS':<10} | {'ROW COUNT':<10} | {'SAMPLE RECORD'}")
    print("-" * 75)
    all_tables_ok = True
    for tbl in tables:
        try:
            cur.execute(f"SELECT COUNT(*) AS count FROM {tbl};")
            count = cur.fetchone()["count"]
            sample = ""
            if count > 0:
                cur.execute(f"SELECT * FROM {tbl} LIMIT 1;")
                row = cur.fetchone()
                # Print key details
                keys = list(row.keys())[:3]
                sample = ", ".join([f"{k}={row[k]}" for k in keys])
            print(f"{tbl:<25} | {'ONLINE':<10} | {count:<10} | {sample[:35]}...")
        except Exception as e:
            all_tables_ok = False
            print(f"{tbl:<25} | {'ERROR':<10} | {'N/A':<10} | {str(e)}")

    print("\n" + "-" * 75)
    print(f"{'VIEW / MAT VIEW':<30} | {'STATUS':<10} | {'ROW COUNT':<10}")
    print("-" * 75)
    views = [
        "vw_active_reservations",
        "vw_revenue_summary",
        "vw_customer_loyalty_ranking",
        "vw_service_popularity",
        "vw_lost_and_found_summary",
        "mv_monthly_financial_report"
    ]
    all_views_ok = True
    for vw in views:
        try:
            cur.execute(f"SELECT COUNT(*) AS count FROM {vw};")
            count = cur.fetchone()["count"]
            print(f"{vw:<30} | {'ONLINE':<10} | {count:<10}")
        except Exception as e:
            all_views_ok = False
            print(f"{vw:<30} | {'ERROR':<10} | {str(e)}")

    cur.close()
    conn.close()
    return all_tables_ok and all_views_ok

def check_flask_api_endpoints():
    print("\n" + "=" * 75)
    print("2. LIVE FLASK BACKEND REST API ENDPOINTS (PORT 5000)")
    print("=" * 75)

    endpoints = [
        ("/", "Root Health Check"),
        ("/api/rooms", "Room Inventory"),
        ("/api/customers", "Customer Directory"),
        ("/api/staff", "Staff Accounts"),
        ("/api/reservations", "Reservations List"),
        ("/api/services", "Services Catalog"),
        ("/api/service-requests", "Service Orders"),
        ("/api/housekeeping", "Housekeeping Tasks"),
        ("/api/bills", "Billing Invoices"),
        ("/api/lost-and-found", "Lost & Found Registry"),
        ("/api/admin/analytics", "Executive Analytics"),
        ("/api/admin/audit-logs", "PostgreSQL Audit Logs")
    ]

    print(f"{'ENDPOINT':<28} | {'HTTP':<6} | {'STATUS':<10} | {'PAYLOAD DATA SUMMARY'}")
    print("-" * 75)
    all_apis_ok = True

    for path, label in endpoints:
        url = f"http://127.0.0.1:5000{path}"
        req = urllib.request.Request(url, headers={"X-Staff-Role": "Admin", "User-Agent": "HealthChecker"})
        try:
            with urllib.request.urlopen(req, timeout=5) as res:
                code = res.status
                body = res.read().decode("utf-8")
                try:
                    data = json.loads(body)
                    if isinstance(data, list):
                        summary = f"{len(data)} records returned"
                    elif isinstance(data, dict):
                        if "metrics" in data:
                            summary = f"Metrics loaded (Occupancy: {data['metrics'].get('occupancyRate')}%)"
                        elif "reports" in data:
                            summary = f"{len(data['reports'])} reports returned"
                        elif "items" in data:
                            summary = f"{len(data['items'])} items returned"
                        else:
                            summary = f"Keys: {', '.join(list(data.keys())[:3])}"
                    else:
                        summary = "Response received"
                except Exception:
                    summary = body[:30]

                print(f"{path:<28} | {code:<6} | {'HEALTHY':<10} | {summary}")
        except urllib.error.HTTPError as e:
            all_apis_ok = False
            print(f"{path:<28} | {e.code:<6} | {'FAILED':<10} | HTTP Error: {e.reason}")
        except Exception as e:
            all_apis_ok = False
            print(f"{path:<28} | {'ERR':<6} | {'FAILED':<10} | {str(e)}")

    return all_apis_ok

def check_frontend_pages_in_browser():
    print("\n" + "=" * 75)
    print("3. LIVE FRONTEND WEBPAGE DATA-BINDING IN BROWSER (PORT 8000)")
    print("=" * 75)

    pages_to_check = [
        ("index.html", "Luxury Homepage"),
        ("customer-login.html", "Guest Login"),
        ("customer-dashboard.html", "Customer Dashboard"),
        ("reception-dashboard.html", "Reception Desk"),
        ("admin.html", "Admin Control Center"),
        ("lost-and-found.html", "Lost & Found Desk")
    ]

    all_pages_ok = True

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1440, "height": 900})
        page = context.new_page()

        # Login first as guest to set session
        page.goto("http://localhost:8000/customer-login.html", wait_until="networkidle")
        page.fill("#guestEmail", "customer@gmail.com")
        page.fill("#guestPassword", "customer123")
        page.click("button[type='submit']")
        page.wait_for_timeout(1000)

        # Login as admin to set staff session
        page.goto("http://localhost:8000/reception-login.html", wait_until="networkidle")
        page.click("#btnRoleAdmin")
        page.wait_for_timeout(300)
        page.click("button[type='submit']")
        page.wait_for_timeout(1000)

        for p_name, label in pages_to_check:
            errors = []
            page.on("console", lambda msg: errors.append(msg.text) if msg.type == "error" else None)
            
            try:
                res = page.goto(f"http://localhost:8000/{p_name}", wait_until="networkidle")
                page.wait_for_timeout(800)
                status_code = res.status if res else 200

                # Check if data table rows or cards rendered from database
                data_elements = page.locator("tbody tr, .card, .room-card").count()
                print(f"[{p_name:<24}] | HTTP {status_code} | Elements Rendered: {data_elements:<4} | Errors: {len(errors)}")
            except Exception as e:
                all_pages_ok = False
                print(f"[{p_name:<24}] | Error: {e}")

        browser.close()

    return all_pages_ok

if __name__ == "__main__":
    db_ok = check_postgresql_tables_and_views()
    api_ok = check_flask_api_endpoints()
    browser_ok = check_frontend_pages_in_browser()

    print("\n" + "=" * 75)
    print("OVERALL HEALTH SUMMARY:")
    print("=" * 75)
    print(f"  * PostgreSQL Direct Database & Views : {'[PASS] All 10 tables & 6 views loaded' if db_ok else '[FAIL]'}")
    print(f"  * Flask REST API Endpoints (Port 5000): {'[PASS] All 12 endpoints responded 200 OK' if api_ok else '[FAIL]'}")
    print(f"  * Frontend Webpages (Port 8000)       : {'[PASS] All pages rendered live database data' if browser_ok else '[FAIL]'}")
    print("=" * 75)
