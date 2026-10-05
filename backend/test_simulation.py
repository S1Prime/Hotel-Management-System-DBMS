import os
import sys
import psycopg2
from psycopg2.extras import RealDictCursor

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from backend.app import app
from backend.database import get_db_connection

def run_simulation():
    print("=================================================================")
    print("   HOTEL MANAGEMENT SYSTEM — COMPLETE END-TO-END SIMULATION     ")
    print("=================================================================")

    client = app.test_client()
    passed = 0
    total = 0

    def check(test_name, condition, details=""):
        nonlocal passed, total
        total += 1
        if condition:
            passed += 1
            print(f" [PASS] Test {total:02d}: {test_name}")
            if details:
                print(f"         -> {details}")
        else:
            print(f" [FAIL] Test {total:02d}: {test_name}")
            if details:
                print(f"         -> Error: {details}")

    # TEST 1: Database Connectivity
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        pg_ver = cur.fetchone()[0]
        cur.close()
        conn.close()
        check("PostgreSQL Engine Connectivity", True, pg_ver.split(",")[0])
    except Exception as e:
        check("PostgreSQL Engine Connectivity", False, str(e))

    # TEST 2: Customer Authentication
    res = client.post('/api/login', json={
        "email": "customer@gmail.com",
        "password": "guest123"
    })
    c_name = res.json.get("customer", {}).get("name") if res.json else "N/A"
    check("Customer Login API (/api/login)", res.status_code == 200 and "customer" in (res.json or {}), f"Logged in as: {c_name}")

    # TEST 3: Staff Authentication
    res_rec = client.post('/api/staff/login', json={
        "email": "reception@crowneplaza.com",
        "password": "staff123"
    })
    s_role = res_rec.json.get("staff", {}).get("role") if res_rec.json else "N/A"
    check("Receptionist Staff Login (/api/staff/login)", res_rec.status_code == 200 and "staff" in (res_rec.json or {}), f"Role: {s_role}")

    # TEST 4: Fetch Rooms Inventory
    res_rooms = client.get('/api/rooms')
    rooms = res_rooms.json if res_rooms.status_code == 200 else []
    room_map = {r['room_number']: r['status'] for r in rooms}
    check("Fetch Rooms Inventory (/api/rooms)", len(rooms) >= 5, f"Found {len(rooms)} rooms: {room_map}")

    # TEST 5: Verify Specific Room Statuses
    expected_statuses = {
        '101': 'Occupied',
        '102': 'Available',
        '103': 'Cleaning',
        '201': 'Occupied',
        '202': 'Available'
    }
    all_match = all(room_map.get(k) == v for k, v in expected_statuses.items())
    check("Verify Expected Room Statuses", all_match, f"Current: {room_map}")

    # TEST 6: Double-Booking Conflict Prevention
    # Room 101 has an active reservation for 2026-07-28 to 2026-08-02
    conflict_res = client.post('/api/reservations', json={
        "room_number": "101",
        "customer_id": 1,
        "check_in": "2026-07-30",
        "check_out": "2026-08-01",
        "number_of_guests": 2
    })
    err_msg = conflict_res.json.get("error") if conflict_res.json else "N/A"
    check("Double-Booking Prevention (Date Overlap Check)", conflict_res.status_code == 409, f"HTTP {conflict_res.status_code} - {err_msg}")

    # TEST 7: Successful Booking Creation on Available Room 202
    book_res = client.post('/api/reservations', json={
        "room_number": "202",
        "customer_id": 1,
        "check_in": "2026-11-20",
        "check_out": "2026-11-23",
        "number_of_guests": 2,
        "special_requests": "Simulation Stay - High Floor"
    })
    new_res_id = book_res.json.get("reservation", {}).get("reservation_id") if (book_res.json and book_res.status_code == 201) else None
    check("Create Valid Reservation (/api/reservations)", book_res.status_code == 201, f"Reservation #{new_res_id} created successfully")

    if new_res_id:
        # TEST 8: Check-In Workflow
        ci_res = client.post(f"/api/reservations/{new_res_id}/check-in")
        msg = ci_res.json.get("message") if ci_res.json else ""
        check("Guest Check-In (/api/reservations/<id>/check-in)", ci_res.status_code == 200, msg)

        res_r202 = client.get('/api/rooms')
        status_202 = next((r['status'] for r in res_r202.json if r['room_number'] == '202'), None)
        check("Room Status Updated to 'Occupied' after Check-In", status_202 == 'Occupied', f"Room 202 status = {status_202}")

        # TEST 9: Order Room Service
        srv_res = client.post('/api/service-requests', json={
            "reservation_id": new_res_id,
            "service_id": 1,
            "quantity": 2
        })
        msg_srv = srv_res.json.get("message") if srv_res.json else ""
        check("Order Room Service (/api/service-requests)", srv_res.status_code == 201, msg_srv)

        # TEST 10: Check-Out Workflow & Automated Billing
        co_res = client.post(f"/api/reservations/{new_res_id}/check-out", json={"discount": 0})
        total_bill = co_res.json.get("bill", {}).get("total_amount") if co_res.json else "0"
        check("Guest Check-Out & Bill Generation (/api/reservations/<id>/check-out)", co_res.status_code == 200, f"Bill Total: Rs. {total_bill}")

        # TEST 11: PostgreSQL Trigger 1 Check - Room Status Auto-Updated to 'Cleaning'
        res_r202_after = client.get('/api/rooms')
        status_after_co = next((r['status'] for r in res_r202_after.json if r['room_number'] == '202'), None)
        check("Trigger 1: Room Status Auto-Set to 'Cleaning' on Checkout", status_after_co == 'Cleaning', f"Room 202 status = {status_after_co}")

        # TEST 12: PostgreSQL Trigger 3 Check - Housekeeping Task Auto-Created
        hk_res = client.get('/api/housekeeping')
        hk_tasks = hk_res.json if hk_res.status_code == 200 else []
        r202_task = next((t for t in hk_tasks if str(t.get('room_number')) == '202' and t.get('status') == 'Pending'), None)
        task_id = r202_task['task_id'] if r202_task else None
        check("Trigger 3: Housekeeping Task Auto-Created in Queue", r202_task is not None, f"Task ID: {task_id}")

        # TEST 13: Housekeeping Completion & Revert to Available
        if r202_task:
            hk_done = client.put(f"/api/housekeeping/{task_id}/status", json={"status": "Completed"})
            msg_hk = hk_done.json.get("message") if hk_done.json else ""
            check("Complete Housekeeping Task (/api/housekeeping/<id>/status)", hk_done.status_code == 200, msg_hk)

            res_r202_ready = client.get('/api/rooms')
            status_ready = next((r['status'] for r in res_r202_ready.json if r['room_number'] == '202'), None)
            check("Room Status Automatically Restored to 'Available'", status_ready == 'Available', f"Room 202 status = {status_ready}")

    # TEST 14: Audit Logs Verification
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT COUNT(*) AS total FROM audit_logs;")
    audit_count = cur.fetchone()['total']
    cur.close()
    conn.close()
    check("Change Data Capture Audit Logs Recorded", audit_count > 0, f"Total Audit Entries in PostgreSQL: {audit_count}")

    print("=================================================================")
    print(f"   SIMULATION RESULT: {passed}/{total} TESTS PASSED ({int((passed/total)*100)}%)")
    print("=================================================================")

if __name__ == '__main__':
    run_simulation()
