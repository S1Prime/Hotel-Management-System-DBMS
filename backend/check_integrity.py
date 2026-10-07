"""
Crowne Plaza Hotel Management System - Comprehensive Program & Browser Integrity Inspector
============================================================================================
Checks:
1. Duplicate / repeated files in the project.
2. HTML link validity (CSS, JS, internal hyperlinks).
3. Browser runtime testing of all pages using Playwright (capturing console errors, 404 network errors, button states).
"""

import os
import re
import hashlib
from collections import defaultdict
from playwright.sync_api import sync_playwright

def find_repeated_files():
    print("=" * 70)
    print("STEP 1: SCANNING FOR REPEATED / DUPLICATE FILES")
    print("=" * 70)
    
    file_hashes = defaultdict(list)
    file_names = defaultdict(list)
    
    for root, dirs, files in os.walk('.'):
        if any(x in root for x in ['.git', '.venv', '__pycache__']):
            continue
        for f in files:
            fp = os.path.join(root, f)
            try:
                with open(fp, 'rb') as fp_obj:
                    h = hashlib.md5(fp_obj.read()).hexdigest()
                file_hashes[h].append(fp)
            except Exception:
                pass
            file_names[f.lower()].append(fp)
            
    exact_duplicates = []
    for h, paths in file_hashes.items():
        if len(paths) > 1:
            exact_duplicates.append(paths)
            print(f"[DUPLICATE CONTENT] Hash {h[:8]}:")
            for p in paths:
                print(f"   -> {p}")

    name_duplicates = []
    for name, paths in file_names.items():
        if len(paths) > 1:
            name_duplicates.append((name, paths))
            print(f"[REPEATED FILENAME] '{name}':")
            for p in paths:
                print(f"   -> {p}")

    return exact_duplicates, name_duplicates

def check_html_links():
    print("\n" + "=" * 70)
    print("STEP 2: CHECKING HTML ASSET LINKS AND INTERNAL HYPERLINKS")
    print("=" * 70)
    
    html_files = [f for f in os.listdir('.') if f.endswith('.html')]
    broken_assets = []
    broken_links = []
    
    for hf in sorted(html_files):
        with open(hf, 'r', encoding='utf-8', errors='ignore') as fp:
            content = fp.read()
            
        # Check stylesheets
        css_hrefs = re.findall(r'<link[^>]+href=["\']([^"\']+)["\']', content)
        for href in css_hrefs:
            if not href.startswith('http') and not href.startswith('//'):
                # clean anchors or queries
                clean = href.split('?')[0].split('#')[0]
                if not os.path.exists(clean):
                    broken_assets.append((hf, 'CSS', href))
                    print(f"[{hf}] Broken CSS link: {href}")

        # Check script tags
        js_srcs = re.findall(r'<script[^>]+src=["\']([^"\']+)["\']', content)
        for src in js_srcs:
            if not src.startswith('http') and not src.startswith('//'):
                clean = src.split('?')[0].split('#')[0]
                if not os.path.exists(clean):
                    broken_assets.append((hf, 'JS', src))
                    print(f"[{hf}] Broken JS link: {src}")

        # Check a href links to other local HTML pages
        a_hrefs = re.findall(r'<a[^>]+href=["\']([^"\']+)["\']', content)
        for href in a_hrefs:
            if href.endswith('.html') and not href.startswith('http'):
                clean = href.split('?')[0].split('#')[0]
                if not os.path.exists(clean):
                    broken_links.append((hf, href))
                    print(f"[{hf}] Broken internal page link: {href}")

    if not broken_assets and not broken_links:
        print("[OK] All stylesheet, script, and internal page links point to existing files.")
    return broken_assets, broken_links

def browser_crawl_pages():
    print("\n" + "=" * 70)
    print("STEP 3: PLAYWRIGHT BROWSER CRAWL ACROSS ALL PAGES")
    print("=" * 70)
    
    html_files = [f for f in os.listdir('.') if f.endswith('.html')]
    page_reports = {}
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1366, "height": 768})
        
        for hf in sorted(html_files):
            url = f"http://localhost:8000/{hf}"
            page = context.new_page()
            
            console_errors = []
            failed_requests = []
            
            page.on("console", lambda msg: console_errors.append(msg.text) if msg.type in ["error"] else None)
            page.on("requestfailed", lambda req: failed_requests.append(f"{req.method} {req.url} - {req.failure}"))
            
            # Dismiss alerts/prompts automatically
            page.on("dialog", lambda dialog: dialog.accept("Automated test prompt answer"))
            
            try:
                res = page.goto(url, timeout=10000, wait_until="load")
                page.wait_for_timeout(500)
                status = res.status if res else "Unknown"
                
                # Check for critical elements
                title = page.title()
                buttons = page.locator("button").count()
                inputs = page.locator("input, select, textarea").count()
                
                page_reports[hf] = {
                    "status": status,
                    "title": title,
                    "buttons": buttons,
                    "inputs": inputs,
                    "console_errors": console_errors,
                    "failed_requests": failed_requests
                }
                
                print(f"[BROWSER] {hf:<25} | HTTP {status} | Title: '{title[:30]}' | Errors: {len(console_errors)} | Failed Net: {len(failed_requests)}")
                if console_errors:
                    for ce in console_errors[:3]:
                        print(f"   ! Console Error: {ce}")
                if failed_requests:
                    for fr in failed_requests[:3]:
                        print(f"   ! Failed Request: {fr}")
                        
            except Exception as e:
                page_reports[hf] = {"error": str(e)}
                print(f"[BROWSER ERROR] {hf}: {e}")
            finally:
                page.close()
                
        browser.close()
        
    return page_reports

if __name__ == '__main__':
    find_repeated_files()
    check_html_links()
    browser_crawl_pages()
