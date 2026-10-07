"""
Crowne Plaza Hotel Management System - Financial Accounting & Invoicing Engine
==============================================================================
Maintains double-entry general ledger consistency, itemized billing breakdowns,
GST compliance, and automated checkout payment reconciliations.
"""

from decimal import Decimal
import datetime
from typing import Dict, List, Optional, Any
from psycopg2.extras import RealDictCursor


class InvoiceCalculator:
    """Calculates tax rates, room charges, and incidental service fees."""

    CGST_RATE = Decimal("0.09")
    SGST_RATE = Decimal("0.09")

    @classmethod
    def compute_bill_totals(cls, room_charge: Decimal, service_charges: Decimal, discount: Decimal = Decimal("0.00")) -> Dict[str, Decimal]:
        """Compute taxable subtotal, GST splits, and final balance."""
        subtotal = max(Decimal("0.00"), room_charge + service_charges - discount)
        cgst = (subtotal * cls.CGST_RATE).quantize(Decimal("0.01"))
        sgst = (subtotal * cls.SGST_RATE).quantize(Decimal("0.01"))
        total_tax = cgst + sgst
        net_payable = (subtotal + total_tax).quantize(Decimal("0.01"))

        return {
            "room_charge": room_charge,
            "service_charges": service_charges,
            "discount": discount,
            "subtotal": subtotal,
            "cgst": cgst,
            "sgst": sgst,
            "total_tax": total_tax,
            "net_payable": net_payable
        }


class FinancialLedgerService:
    """Manages bill generation, payment logging, and double-entry accounting records."""

    def __init__(self, db_conn_factory):
        self.get_conn = db_conn_factory

    def get_bill_details(self, bill_id: int) -> Optional[Dict[str, Any]]:
        """Retrieve full itemized bill with reservation and customer details."""
        conn = self.get_conn()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("""
                    SELECT b.*, r.room_number, r.room_type, c.name AS customer_name,
                           c.email AS customer_email, res.check_in_date, res.check_out_date
                    FROM bills b
                    JOIN reservations res ON b.reservation_id = res.reservation_id
                    JOIN rooms r ON res.room_id = r.room_id
                    JOIN customers c ON res.customer_id = c.customer_id
                    WHERE b.bill_id = %s;
                """, (bill_id,))
                bill = cur.fetchone()
                if not bill:
                    return None

                # Fetch associated service requests
                cur.execute("""
                    SELECT so.order_id, s.service_name, s.price, so.quantity,
                           (s.price * so.quantity) AS total_price, so.ordered_at
                    FROM service_orders so
                    JOIN services s ON so.service_id = s.service_id
                    WHERE so.reservation_id = %s;
                """, (bill['reservation_id'],))
                services = cur.fetchall()

                result = dict(bill)
                result['ordered_services'] = [dict(s) for s in services]
                return result
        finally:
            conn.close()

    def process_payment(self, bill_id: int, payment_method: str = "Credit Card", amount_paid: Optional[Decimal] = None) -> bool:
        """Call sp_process_bill_payment procedure to finalize invoice and record ledger entries."""
        conn = self.get_conn()
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    CALL sp_process_bill_payment(%s, %s, %s);
                """, (bill_id, payment_method, amount_paid))
                conn.commit()
                return True
        finally:
            conn.close()
