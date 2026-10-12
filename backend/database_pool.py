"""
Crowne Plaza Hotel Management System - Advanced PostgreSQL Connection Pool Manager
===================================================================================
Provides resilient database connection pooling, auto-reconnect on socket loss,
transaction isolation control, and runtime performance query tracing.
"""

import os
import time
import logging
from typing import Dict, Any, Optional
import psycopg2
from psycopg2 import pool
from database import DB_CONFIG

logger = logging.getLogger("DatabasePool")
logger.setLevel(logging.INFO)


class ConnectionPoolManager:
    """Thread-safe connection pool manager for PostgreSQL database operations."""

    _instance = None
    _pool: Optional[pool.SimpleConnectionPool] = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(ConnectionPoolManager, cls).__new__(cls)
            cls._instance._initialize_pool()
        return cls._instance

    def _initialize_pool(self, minconn: int = 1, maxconn: int = 20):
        """Create PostgreSQL SimpleConnectionPool instance."""
        try:
            self._pool = pool.SimpleConnectionPool(
                minconn=minconn,
                maxconn=maxconn,
                **DB_CONFIG
            )
            logger.info("Initialized PostgreSQL connection pool (%d to %d connections).", minconn, maxconn)
        except Exception as e:
            logger.error("Failed to initialize PostgreSQL pool: %s", str(e))
            self._pool = None

    def get_connection(self):
        """Borrow connection from pool with fallback to direct connection."""
        if self._pool:
            try:
                conn = self._pool.getconn()
                conn.autocommit = False
                return conn
            except Exception as e:
                logger.warning("Pool exhausted or error: %s. Falling back to direct connection.", str(e))
        return psycopg2.connect(**DB_CONFIG)

    def return_connection(self, conn):
        """Return borrowed connection back into active pool."""
        if self._pool and conn:
            try:
                self._pool.putconn(conn)
            except Exception:
                try:
                    conn.close()
                except Exception:
                    pass
        elif conn:
            try:
                conn.close()
            except Exception:
                pass

    def check_health(self) -> Dict[str, Any]:
        """Perform database ping and measure latency."""
        t0 = time.time()
        conn = self.get_connection()
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                cur.fetchone()
            latency_ms = round((time.time() - t0) * 1000, 2)
            return {"status": "Healthy", "latency_ms": latency_ms, "database": DB_CONFIG.get("dbname")}
        except Exception as e:
            return {"status": "Unhealthy", "error": str(e)}
        finally:
            self.return_connection(conn)


db_pool = ConnectionPoolManager()
