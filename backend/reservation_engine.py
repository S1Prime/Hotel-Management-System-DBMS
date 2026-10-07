"""
Crowne Plaza Hotel Management System - Dynamic Reservation & Yield Management Engine
=====================================================================================
Calculates seasonal room tariffs, resolves check-in calendar conflicts, ensures
ACID isolation levels, and synchronizes real-time room statuses with PostgreSQL.
"""

import datetime
from decimal import Decimal
from typing import Dict, List, Optional, Any, Tuple
from psycopg2.extras import RealDictCursor


class DynamicPricingEngine:
    """Computes room rates dynamically based on demand multipliers, days of week, and seasonality."""

    BASE_RATES = {
        "Luxury Suite": Decimal("3500.00"),
        "Standard AC Room": Decimal("1800.00"),
        "AC Room with Balcony": Decimal("2400.00"),
        "Family AC Room": Decimal("2800.00"),
        "Economy Non-AC Room": Decimal("1100.00")
    }

    WEEKEND_SURGE_PERCENT = Decimal("1.15")
    HIGH_OCCUPANCY_SURGE_PERCENT = Decimal("1.25")
    GST_RATE = Decimal("0.18")

    @classmethod
    def calculate_stay_quote(
        cls,
        room_type: str,
        check_in_date: datetime.date,
        check_out_date: datetime.date,
        current_occupancy_ratio: float = 0.5
    ) -> Dict[str, Any]:
        """Generate itemized price breakdown for booking duration."""
        if check_out_date <= check_in_date:
            raise ValueError("Check-out date must be strictly after check-in date.")

        base_rate = cls.BASE_RATES.get(room_type, Decimal("1800.00"))
        nights = (check_out_date - check_in_date).days
        subtotal = Decimal("0.00")
        daily_breakdown = []

        curr = check_in_date
        while curr < check_out_date:
            daily_multiplier = Decimal("1.00")
            if curr.weekday() in (4, 5):  # Friday, Saturday
                daily_multiplier *= cls.WEEKEND_SURGE_PERCENT
            if current_occupancy_ratio >= 0.80:
                daily_multiplier *= cls.HIGH_OCCUPANCY_SURGE_PERCENT

            day_price = (base_rate * daily_multiplier).quantize(Decimal("0.01"))
            daily_breakdown.append({
                "date": curr.isoformat(),
                "base": float(base_rate),
                "multiplier": float(daily_multiplier),
                "price": float(day_price)
            })
            subtotal += day_price
            curr += datetime.timedelta(days=1)

        tax_amount = (subtotal * cls.GST_RATE).quantize(Decimal("0.01"))
        grand_total = (subtotal + tax_amount).quantize(Decimal("0.01"))

        return {
            "room_type": room_type,
            "nights": nights,
            "daily_breakdown": daily_breakdown,
            "subtotal": float(subtotal),
            "gst_tax": float(tax_amount),
            "grand_total": float(grand_total)
        }


class ReservationService:
    """Manages booking lifecycle, date conflict prevention, and PostgreSQL stored procedure calls."""

    def __init__(self, db_conn_factory):
        self.get_conn = db_conn_factory

    def check_room_availability(self, room_id: int, check_in: str, check_out: str) -> bool:
        """Verify that room has no overlapping active or confirmed reservations."""
        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT COUNT(*)
                    FROM reservations
                    WHERE room_id = %s
                      AND status IN ('Confirmed', 'Active')
                      AND check_in_date < %s::date
                      AND check_out_date > %s::date;
                """, (room_id, check_out, check_in))
                count = cur.fetchone()[0]
                return count == 0
        finally:
            conn.close()

    def create_reservation_transaction(
        self,
        customer_id: int,
        room_number: str,
        check_in: str,
        check_out: str,
        guests: int = 1,
        special_requests: str = ""
    ) -> Dict[str, Any]:
        """Atomically create reservation and generate initial invoice via sp_create_reservation."""
        conn = self.get_conn()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                # Find room_id from room_number
                cur.execute("SELECT room_id, room_type, price_per_night, status FROM rooms WHERE room_number = %s;", (room_number,))
                room = cur.fetchone()
                if not room:
                    raise ValueError(f"Room {room_number} does not exist.")

                # Call stored procedure
                cur.execute("""
                    CALL sp_create_reservation(
                        %s, %s, %s::date, %s::date, %s, %s, NULL, NULL
                    );
                """, (customer_id, room['room_id'], check_in, check_out, guests, special_requests))
                row = cur.fetchone()
                conn.commit()

                res_id = row['p_reservation_id'] if (row and 'p_reservation_id' in row) else None
                bill_id = row['p_bill_id'] if (row and 'p_bill_id' in row) else None

                return {
                    "success": True,
                    "reservation_id": res_id,
                    "bill_id": bill_id,
                    "room_number": room_number,
                    "check_in": check_in,
                    "check_out": check_out
                }
        finally:
            conn.close()
