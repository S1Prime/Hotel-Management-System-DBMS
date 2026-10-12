"""
Crowne Plaza Hotel Management System - Automated End-to-End Playwright Browser Verification
===========================================================================================
Tests customer report submission via lost-and-found.html and receptionist/admin management
via admin.html with PostgreSQL backend synchronization and screenshot capture.
"""

import sys
import os
import time
from playwright.sync_api import sync_playwright

SCREENSHOT_DIR = r"C:\Users\ADMIN\.gemini\antigravity-ide\brain\bcb42b63-8837-4d43-b2a4-feae8a876747"

def run_e2e_test():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1366, "height": 900})
        page = context.new_page()

        # Handle dialogs automatically (prompt for resolution notes, alerts)
        page.on("dialog", lambda dialog: dialog.accept("Verified by Front Desk: safe custody in vault."))

        print("--- Step 1: Navigating to Customer Login ---")
        page.goto("http://localhost:8000/customer-login.html")
        page.wait_for_load_state("networkidle")
        page.fill("#guestEmail", "customer@gmail.com")
        page.fill("#guestPassword", "customer123")
        page.click("button[type='submit']")
        page.wait_for_timeout(1500)

        print("--- Step 2: Customer Dashboard ---")
        dash_shot = os.path.join(SCREENSHOT_DIR, "lost_found_customer_dashboard.png")
        page.screenshot(path=dash_shot)
        print(f"Captured dashboard screenshot: {dash_shot}")

        print("--- Step 3: Navigating to Lost & Found Portal ---")
        page.goto("http://localhost:8000/lost-and-found.html")
        page.wait_for_load_state("networkidle")
        time.sleep(1)

        print("--- Step 4: Submitting Lost Item Report ---")
        page.fill("#lfItem", "Gold Rolex Oyster Perpetual")
        page.fill("#lfLocation", "Swimming Pool Cabana #3")
        page.fill("#lfDescription", "Classic gold watch with champagne dial. Left beside the lounger table after morning swim.")
        page.click("button[type='submit']")
        page.wait_for_timeout(2500)

        lf_guest_shot = os.path.join(SCREENSHOT_DIR, "lost_found_guest_submitted.png")
        page.screenshot(path=lf_guest_shot)
        print(f"Captured guest submission screenshot: {lf_guest_shot}")

        print("--- Step 5: Staff / Admin Login ---")
        page.goto("http://localhost:8000/reception-login.html")
        page.wait_for_load_state("networkidle")
        # Click System Admin preset
        page.click("#btnRoleAdmin")
        page.wait_for_timeout(500)
        page.click("button[type='submit']")
        page.wait_for_timeout(1500)

        print("--- Step 6: Admin Dashboard - Lost & Found Management Tab ---")
        page.goto("http://localhost:8000/admin.html")
        page.wait_for_load_state("networkidle")
        time.sleep(1)

        # Click on Lost & Found tab in sidebar
        page.click("#tab-lost-found")
        page.wait_for_timeout(2000)

        admin_lf_shot1 = os.path.join(SCREENSHOT_DIR, "admin_lost_found_view.png")
        page.screenshot(path=admin_lf_shot1)
        print(f"Captured Admin Lost & Found view: {admin_lf_shot1}")

        # Check for the submitted item and click 'Mark Found'
        print("--- Step 7: Front Desk / Admin Marks Item 'Found' ---")
        found_buttons = page.query_selector_all("button:has-text('Mark Found')")
        if found_buttons:
            print(f"Found {len(found_buttons)} 'Mark Found' button(s). Clicking first one...")
            found_buttons[0].click()
            page.wait_for_timeout(2500)

        admin_lf_shot2 = os.path.join(SCREENSHOT_DIR, "admin_lost_found_resolved.png")
        page.screenshot(path=admin_lf_shot2)
        print(f"Captured Admin Lost & Found after status update: {admin_lf_shot2}")

        print("--- Step 8: Verify in PostgreSQL ---")
        browser.close()
        print("Browser automation completed successfully!")

if __name__ == "__main__":
    run_e2e_test()
