"""
Crowne Plaza Hotel Management System - Housekeeping Dispatcher & Sanitation Board
================================================================================
Monitors room cleaning cycles, dispatches maintenance tickets, coordinates
with front desk check-outs, and logs housekeeper task completion metrics.
"""

import datetime
from typing import Dict, List, Optional, Any
from psycopg2.extras import RealDictCursor


class HousekeepingDispatcher:
    """Coordinates room cleaning queues and updates room availability statuses."""

    TASK_PRIORITIES = {
        "Deep Sanitization": 1,
        "Checkout Turnover": 2,
        "Routine Daily Cleaning": 3,
        "Maintenance Repair": 4
    }

    def __init__(self, db_conn_factory):
        self.get_conn = db_conn_factory

    def get_pending_tasks(self) -> List[Dict[str, Any]]:
        """Fetch all unassigned or in-progress housekeeping tasks."""
        conn = self.get_conn()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    SELECT h.*, r.room_number, r.room_type, s.name AS assigned_staff_name
                    FROM housekeeping h
                    JOIN rooms r ON h.room_id = r.room_id
                    LEFT JOIN staff s ON h.assigned_staff_id = s.staff_id
                    WHERE h.status IN ('Pending', 'In Progress')
                    ORDER BY h.created_at ASC;
                """)
                return [dict(row) for row in cur.fetchall()]
        finally:
            conn.close()

    def assign_task(self, task_id: int, staff_id: int) -> bool:
        """Assign pending task to designated housekeeping staff member."""
        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    UPDATE housekeeping
                    SET assigned_staff_id = %s, status = 'In Progress', updated_at = CURRENT_TIMESTAMP
                    WHERE task_id = %s;
                """, (staff_id, task_id))
                conn.commit()
                return True
        finally:
            conn.close()

    def complete_task(self, task_id: int, notes: str = "Room sanitization completed") -> bool:
        """Mark task completed and automatically update room status to Vacant / Available."""
        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                # Find target room
                cur.execute("SELECT room_id FROM housekeeping WHERE task_id = %s;", (task_id,))
                row = cur.fetchone()
                if not row:
                    return False
                room_id = row[0]

                # Update housekeeping record
                cur.execute("""
                    UPDATE housekeeping
                    SET status = 'Completed', notes = %s, completed_at = CURRENT_TIMESTAMP
                    WHERE task_id = %s;
                """, (notes, task_id))

                # Update room status to Available
                cur.execute("UPDATE rooms SET status = 'Available' WHERE room_id = %s;", (room_id,))
                conn.commit()
                return True
        finally:
            conn.close()
