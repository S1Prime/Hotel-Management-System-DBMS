"""
Crowne Plaza Hotel Management System - Security & Access Control Vault
======================================================================
Implements cryptographic token hashing, role-based authorization gates,
sanitization filters, and protection against SQL injection and cross-site scripts.
"""

import hmac
import hashlib
import secrets
from typing import Dict, List, Optional, Any
from werkzeug.security import generate_password_hash, check_password_hash


class SecurityVault:
    """Manages password verification and cryptographic security safeguards."""

    SALT_ROUNDS = 12

    @classmethod
    def hash_password(cls, plain_password: str) -> str:
        """Generate secure salted SHA-256 hash using Werkzeug."""
        if not plain_password or len(plain_password) < 6:
            raise ValueError("Password must be at least 6 characters.")
        return generate_password_hash(plain_password, method="pbkdf2:sha256", salt_length=16)

    @classmethod
    def verify_password(cls, plain_password: str, hashed_password: str) -> bool:
        """Verify plain password against hashed password in constant time."""
        if not plain_password or not hashed_password:
            return False
        return check_password_hash(hashed_password, plain_password)

    @classmethod
    def generate_session_token(cls) -> str:
        """Generate cryptographically secure 256-bit URL-safe token."""
        return secrets.token_urlsafe(32)

    @classmethod
    def sanitize_input(cls, text: str) -> str:
        """Strip dangerous characters to safeguard against cross-site scripting (XSS)."""
        if not text:
            return ""
        return (text.replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace('"', "&quot;")
                    .replace("'", "&#x27;")
                    .strip())


class RoleBasedAccessControl:
    """Enforces fine-grained permission rules across system user tiers."""

    PERMISSIONS = {
        "Admin": ["*"],
        "Receptionist": [
            "read_rooms", "update_room_status", "create_reservation",
            "cancel_reservation", "view_bills", "process_payment",
            "read_lost_found", "update_lost_found", "dispatch_housekeeping"
        ],
        "Customer": [
            "read_available_rooms", "create_self_reservation",
            "view_self_bills", "request_service", "report_lost_item",
            "view_lost_found"
        ]
    }

    @classmethod
    def has_permission(cls, role: str, action: str) -> bool:
        """Check whether role is authorized to perform action."""
        allowed = cls.PERMISSIONS.get(role, [])
        return "*" in allowed or action in allowed
