"""
Crowne Plaza Hotel Management System - Lost and Found Service Module
====================================================================
Production-grade service handling guest item registration, staff custody workflows,
status transitions, photographic evidence verification, and audit trail integrations.
"""

import os
import json
import logging
import datetime
from typing import Dict, List, Optional, Any, Tuple
from psycopg2.extras import RealDictCursor

logger = logging.getLogger("LostAndFoundService")
logger.setLevel(logging.INFO)


class LostAndFoundItem:
    """Domain model representing a reported lost or found item with full metadata."""
    def __init__(
        self,
        report_id: Optional[int] = None,
        item_name: str = "",
        category: str = "Personal Belonging",
        location_lost: str = "",
        lost_date: Optional[datetime.datetime] = None,
        description: str = "",
        image_url: Optional[str] = None,
        customer_id: Optional[int] = None,
        reporter_name: str = "Valued Guest",
        reporter_email: str = "",
        reporter_phone: str = "",
        status: str = "Reported",
        found_by_staff_id: Optional[int] = None,
        staff_notes: Optional[str] = None,
        resolved_at: Optional[datetime.datetime] = None,
        created_at: Optional[datetime.datetime] = None,
    ):
        self.report_id = report_id
        self.item_name = item_name
        self.category = category
        self.location_lost = location_lost
        self.lost_date = lost_date or datetime.datetime.now(datetime.timezone.utc)
        self.description = description
        self.image_url = image_url
        self.customer_id = customer_id
        self.reporter_name = reporter_name
        self.reporter_email = reporter_email
        self.reporter_phone = reporter_phone
        self.status = status
        self.found_by_staff_id = found_by_staff_id
        self.staff_notes = staff_notes
        self.resolved_at = resolved_at
        self.created_at = created_at or datetime.datetime.now(datetime.timezone.utc)

    def validate(self) -> Tuple[bool, str]:
        """Validate item data before saving to PostgreSQL."""
        if not self.item_name or len(self.item_name.strip()) < 2:
            return False, "Item name must be at least 2 characters."
        if not self.location_lost or len(self.location_lost.strip()) < 2:
            return False, "Location where item was lost is required."
        if not self.description or len(self.description.strip()) < 5:
            return False, "Detailed description of the item is required."
        return True, ""

    def to_dict(self) -> Dict[str, Any]:
        """Convert domain model into JSON-serializable dictionary."""
        return {
            "report_id": self.report_id,
            "item_id": self.report_id,
            "item_name": self.item_name,
            "category": self.category,
            "location_lost": self.location_lost,
            "location": self.location_lost,
            "lost_date": self.lost_date.isoformat() if isinstance(self.lost_date, datetime.datetime) else str(self.lost_date),
            "lost_at": self.lost_date.isoformat() if isinstance(self.lost_date, datetime.datetime) else str(self.lost_date),
            "description": self.description,
            "image_url": self.image_url,
            "image_data": self.image_url,
            "customer_id": self.customer_id,
            "reporter_name": self.reporter_name,
            "customer_name": self.reporter_name,
            "reporter_email": self.reporter_email,
            "customer_email": self.reporter_email,
            "reporter_phone": self.reporter_phone,
            "customer_phone": self.reporter_phone,
            "status": self.status,
            "found_by_staff_id": self.found_by_staff_id,
            "staff_notes": self.staff_notes,
            "resolution_notes": self.staff_notes,
            "resolved_at": self.resolved_at.isoformat() if isinstance(self.resolved_at, datetime.datetime) else (str(self.resolved_at) if self.resolved_at else None),
            "created_at": self.created_at.isoformat() if isinstance(self.created_at, datetime.datetime) else str(self.created_at),
        }


class LostAndFoundService:
    """Business service orchestrating lost and found operations across customer & staff portals."""
    VALID_STATUSES = ["Reported", "Pending", "Investigating", "Found", "Claimed", "Closed", "Discarded"]

    def __init__(self, db_conn_factory):
        self.get_conn = db_conn_factory

    def get_all_reports(self, status_filter: Optional[str] = None, search_query: Optional[str] = None) -> List[Dict[str, Any]]:
        """Retrieve reports with optional status filtering and full-text keyword search."""
        conn = self.get_conn()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                query = """
                    SELECT lf.*, s.name AS resolved_by_staff
                    FROM lost_and_found lf
                    LEFT JOIN staff s ON lf.found_by_staff_id = s.staff_id
                """
                params = []
                clauses = []
                if status_filter and status_filter != "All":
                    clauses.append("lf.status = %s")
                    params.append(status_filter)
                if search_query:
                    clauses.append("(lf.item_name ILIKE %s OR lf.location_lost ILIKE %s OR lf.reporter_name ILIKE %s OR lf.description ILIKE %s)")
                    pattern = f"%{search_query.strip()}%"
                    params.extend([pattern, pattern, pattern, pattern])

                if clauses:
                    query += " WHERE " + " AND ".join(clauses)
                query += " ORDER BY lf.created_at DESC;"

                cur.execute(query, tuple(params))
                rows = cur.fetchall()
                results = []
                for r in rows:
                    item = dict(r)
                    item["item_id"] = item["report_id"]
                    item["location"] = item["location_lost"]
                    item["lost_at"] = item["lost_date"]
                    item["image_data"] = item["image_url"]
                    item["customer_name"] = item["reporter_name"]
                    item["customer_email"] = item["reporter_email"]
                    item["customer_phone"] = item["reporter_phone"]
                    item["resolution_notes"] = item["staff_notes"]
                    results.append(item)
                return results
        finally:
            conn.close()

    def submit_lost_report(self, data: Dict[str, Any]) -> int:
        """Call sp_report_lost_item procedure to insert new record with transaction safety."""
        item = LostAndFoundItem(
            customer_id=data.get("customer_id"),
            item_name=(data.get("item_name") or data.get("item") or "").strip(),
            category=(data.get("category") or "Personal Belonging").strip(),
            location_lost=(data.get("location") or data.get("location_lost") or "").strip(),
            lost_date=data.get("lost_date") or data.get("lost_at"),
            description=(data.get("description") or "").strip(),
            image_url=data.get("image_url") or data.get("image_data"),
            reporter_name=(data.get("reporter_name") or data.get("customer_name") or "Valued Guest").strip(),
            reporter_email=(data.get("reporter_email") or data.get("customer_email") or "customer@gmail.com").strip(),
            reporter_phone=(data.get("reporter_phone") or data.get("customer_phone") or "").strip(),
        )
        is_valid, err_msg = item.validate()
        if not is_valid:
            raise ValueError(err_msg)

        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    CALL sp_report_lost_item(
                        %s, %s, %s, %s, %s::timestamptz, %s, %s, %s, %s, %s, NULL
                    );
                """, (
                    item.customer_id, item.item_name, item.category, item.location_lost,
                    item.lost_date, item.description, item.image_url,
                    item.reporter_name, item.reporter_email, item.reporter_phone
                ))
                row = cur.fetchone()
                conn.commit()
                report_id = row[0] if row else None
                logger.info("Successfully filed lost item report #%s for %s", report_id, item.reporter_name)
                return report_id
        finally:
            conn.close()

    def update_item_status(self, report_id: int, new_status: str, staff_id: int = 1, notes: str = "") -> bool:
        """Call sp_update_lost_item_status procedure and ensure audit trigger capture."""
        if new_status not in self.VALID_STATUSES:
            raise ValueError(f"Invalid status '{new_status}'. Allowed: {self.VALID_STATUSES}")

        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    CALL sp_update_lost_item_status(%s, %s, %s, %s);
                """, (report_id, staff_id, new_status, notes))
                conn.commit()
                logger.info("Report #%s status updated to '%s' by staff #%s", report_id, new_status, staff_id)
                return True
        finally:
            conn.close()

    def get_dashboard_metrics(self) -> Dict[str, int]:
        """Aggregate summary metrics for executive and front desk dashboards."""
        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT
                        COUNT(*) AS total,
                        COUNT(*) FILTER (WHERE status IN ('Reported', 'Pending', 'Investigating')) AS pending,
                        COUNT(*) FILTER (WHERE status = 'Found') AS found,
                        COUNT(*) FILTER (WHERE status = 'Claimed') AS claimed,
                        COUNT(*) FILTER (WHERE status IN ('Closed', 'Discarded')) AS closed
                    FROM lost_and_found;
                """)
                row = cur.fetchone()
                return {
                    "total": row[0] or 0,
                    "pending": row[1] or 0,
                    "found": row[2] or 0,
                    "claimed": row[3] or 0,
                    "closed": row[4] or 0,
                }
        finally:
            conn.close()
