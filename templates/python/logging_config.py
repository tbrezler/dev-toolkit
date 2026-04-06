"""
Standard logging configuration for Python projects.

Setup (call once at app startup):
    from config import LOCAL_TZ
    from constants import LOG_RETENTION_DAYS, LOG_LEVEL, USE_JSON_LOGGING
    from logging_config import setup_logging

    setup_logging(
        name="my_project",
        local_tz=LOCAL_TZ,
        level=LOG_LEVEL,
        retention_days=LOG_RETENTION_DAYS,
        use_json=USE_JSON_LOGGING,
    )

Then in any module:
    import logging
    logger = logging.getLogger(__name__)
    logger.info("Something happened")
"""

import json
import logging
import logging.handlers
from datetime import datetime
from pathlib import Path

import pytz


def setup_logging(
    name: str,
    local_tz: pytz.timezone,
    log_dir: str = "logs",
    level: str = "INFO",
    retention_days: int = 30,
    use_json: bool = False,
) -> None:
    """
    Configure logging with daily file rotation and timezone support.

    Should be called once at application startup (e.g., in main.py or __init__.py).

    Args:
        name: Project/logger name (e.g., "my_project")
        local_tz: Timezone object (e.g., pytz.timezone("America/Chicago"))
        log_dir: Directory for log files (default: "logs")
        level: Logging level as string (default: "INFO")
        retention_days: Number of days to keep log files (default: 30)
        use_json: Whether to use JSON formatting for structured logging (default: False)

    Example:
        from config import LOCAL_TZ
        from constants import LOG_RETENTION_DAYS, LOG_LEVEL, USE_JSON_LOGGING

        setup_logging(
            name="my_project",
            local_tz=LOCAL_TZ,
            level=LOG_LEVEL,
            retention_days=LOG_RETENTION_DAYS,
            use_json=USE_JSON_LOGGING,
        )
    """
    # Create logs directory
    Path(log_dir).mkdir(parents=True, exist_ok=True)

    logger = logging.getLogger(name)
    logger.setLevel(level.upper())

    # Prevent duplicate handlers if called multiple times
    if logger.handlers:
        return

    # Choose formatter
    if use_json:
        formatter = JSONFormatter(local_tz=local_tz)
    else:
        formatter = StandardFormatter(local_tz=local_tz)

    # ── File Handler (detailed, daily rotation) ──────────────
    file_handler = logging.handlers.TimedRotatingFileHandler(
        filename=f"{log_dir}/{name}.log",
        when="midnight",
        interval=1,
        backupCount=retention_days,
        utc=False,
    )
    file_handler.setLevel(logging.DEBUG)  # File captures everything
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    # ── Console Handler (clean, concise output) ──────────────
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)  # Console shows INFO and above
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)


class StandardFormatter(logging.Formatter):
    """Standard formatter with timezone-aware timestamps."""

    def __init__(self, local_tz: pytz.timezone):
        self.local_tz = local_tz
        super().__init__()

    def format(self, record: logging.LogRecord) -> str:
        """Format log record with local timezone."""
        # Convert UTC timestamp to local timezone
        dt = datetime.fromtimestamp(record.created, tz=self.local_tz)
        record.asctime = dt.strftime("%Y-%m-%d %H:%M:%S")

        # Different format for console vs file based on levelno
        # File gets full details, console gets just level and message
        if record.levelno >= logging.WARNING or isinstance(
            logging.getLogger(record.name).handlers[0], logging.StreamHandler
        ):
            # Simpler format for console
            fmt = "%(levelname)s: %(message)s"
        else:
            # Detailed format for file
            fmt = "%(asctime)s | %(name)s:%(lineno)d - %(levelname)s: %(message)s"

        formatter = logging.Formatter(fmt)
        return formatter.format(record)


class JSONFormatter(logging.Formatter):
    """JSON formatter for structured logging (CloudWatch, log aggregation, etc.)."""

    def __init__(self, local_tz: pytz.timezone):
        self.local_tz = local_tz
        super().__init__()

    def format(self, record: logging.LogRecord) -> str:
        """Format log record as JSON."""
        # Convert to local timezone
        dt = datetime.fromtimestamp(record.created, tz=self.local_tz)

        log_data = {
            "timestamp": dt.isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "module": record.module,
            "function": record.funcName,
            "line": record.lineno,
        }

        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)

        return json.dumps(log_data)
