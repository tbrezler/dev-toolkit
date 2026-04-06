"""
Database audit logging (optional, for future use).

When you need to track data changes, deletions, or sensitive operations,
use this alongside standard logging.

Setup:
    from audit_logging import setup_audit_logging
    audit_logger = setup_audit_logging()

Usage:
    audit_logger.log_data_change(
        user="john",
        table="customers",
        action="DELETE",
        record_id=123,
        details={"reason": "duplicate account"},
    )
"""

import logging
from datetime import datetime
from typing import Any, Dict, Optional


class AuditLogger:
    """Log sensitive operations to database for compliance/audit trails."""

    def __init__(self, db_connection, table_name: str = "audit_log"):
        """
        Args:
            db_connection: Database connection (sqlalchemy, psycopg2, etc.)
            table_name: Name of audit log table
        """
        self.db = db_connection
        self.table_name = table_name
        self.logger = logging.getLogger("audit")

    def log_data_change(
        self,
        user: str,
        table: str,
        action: str,  # CREATE, UPDATE, DELETE, etc.
        record_id: Any,
        details: Optional[Dict] = None,
    ) -> None:
        """
        Log a data change to audit table.

        Args:
            user: User who made the change
            table: Table affected
            action: Type of action (CREATE, UPDATE, DELETE)
            record_id: ID of affected record
            details: Additional context (dict)
        """
        audit_record = {
            "timestamp": datetime.now(),
            "user": user,
            "table": table,
            "action": action,
            "record_id": record_id,
            "details": details or {},
        }

        try:
            # TODO: Insert into audit_log table
            # self.db.execute(f"INSERT INTO {self.table_name} VALUES (...)")
            self.logger.info(f"Audit: {action} on {table} by {user}")
        except Exception as e:
            self.logger.error(f"Failed to log audit record: {e}", exc_info=True)


def setup_audit_logging(db_connection, table_name: str = "audit_log") -> AuditLogger:
    """
    Initialize audit logger.

    Returns:
        AuditLogger instance
    """
    return AuditLogger(db_connection, table_name)
