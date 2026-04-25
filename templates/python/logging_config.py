"""
Logging configuration. Call setup_logging() once at startup.

    from logging_config import setup_logging
    logger = setup_logging("my_project")

Then in any module:
    import logging
    logger = logging.getLogger(__name__)
"""

from __future__ import annotations

import logging
import logging.handlers
from pathlib import Path


def setup_logging(
    name: str,
    log_dir: str | Path | None = "logs",
    level: str = "INFO",
    retention_days: int = 30,
) -> logging.Logger:
    """
    Configure logging with console output and optional daily file rotation.

    Args:
        name: Logger name and log filename prefix.
        log_dir: Directory for log files. None disables file logging
                 (use this for Lambda / container deployments).
        level: Console log level (file always captures DEBUG).
        retention_days: Number of daily log files to keep.

    Returns:
        Configured logger.
    """
    console_level = getattr(logging, level.upper(), None)
    if console_level is None:
        raise ValueError(
            f"Invalid log level: {level!r}. "
            f"Expected one of: DEBUG, INFO, WARNING, ERROR, CRITICAL"
        )

    logger = logging.getLogger(name)

    if logger.handlers:
        logger.handlers.clear()

    logger.setLevel(logging.DEBUG)
    logger.propagate = False

    # ── File handler (daily rotation) ────────────────────────
    if log_dir is not None:
        log_dir = Path(log_dir)
        log_dir.mkdir(parents=True, exist_ok=True)

        file_handler = logging.handlers.TimedRotatingFileHandler(
            filename=log_dir / f"{name}.log",
            when="midnight",
            interval=1,
            backupCount=retention_days,
            utc=True,
            encoding="utf-8",
        )
        file_handler.suffix = "%Y-%m-%d"
        file_handler.namer = _rotated_filename
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(logging.Formatter(
            fmt="%(asctime)s | %(name)s:%(lineno)d - %(levelname)s: %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        ))
        logger.addHandler(file_handler)
    else:
        # No file handler to capture DEBUG, so don't create
        # debug records just to throw them away at the console
        logger.setLevel(console_level)

    # ── Console handler ──────────────────────────────────────
    console_handler = logging.StreamHandler()
    console_handler.setLevel(console_level)
    console_handler.setFormatter(logging.Formatter(
        fmt="%(asctime)s | %(levelname)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    ))
    logger.addHandler(console_handler)

    return logger


def _rotated_filename(default_name: str) -> str:
    """Rename rotated files: my_project.2024-01-15.log instead of my_project.log.2024-01-15."""
    p = Path(default_name)
    stem_path = Path(p.stem)
    return str(p.parent / f"{stem_path.stem}{p.suffix}{stem_path.suffix}")