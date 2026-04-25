# Logging Configuration — Design Decisions

## Overview

This document explains the design decisions behind `logging_config.py`, a
reusable template for Python project logging. It covers what's included, what
was intentionally excluded, and why.

The configuration was refined through multiple iterations. Early versions grew
to 180+ lines with features like JSON formatting, timezone conversion, async
queue handlers, and structured log field extraction. Most of that was removed
after evaluating what was actually needed versus what was speculatively added.

---

## What It Does

- **Console handler** — human-readable output at a configurable level
  (default: INFO)
- **File handler** — detailed output (DEBUG+) with daily rotation and
  configurable retention
- **Lambda/container support** — file logging can be disabled with
  `log_dir=None`, leaving only console output (which CloudWatch captures
  automatically)

---

## Decisions and Rationale

### Logger hierarchy (`name` parameter)

The `name` parameter defines the root of the logger hierarchy. Any module
that calls `logging.getLogger(__name__)` inside that package automatically
inherits the configured handlers. This means `setup_logging("my_project")`
covers `my_project.utils`, `my_project.api.routes`, etc. — no additional
configuration needed per module.

### `propagate = False`

Without this, log records propagate up to the root logger. If anything else
in the application (or a third-party library) configures the root logger,
you get duplicate output. This is one of the most common logging bugs in
Python. One line prevents it.

### Level validation

```python
console_level = getattr(logging, level.upper(), None)
if console_level is None:
    raise ValueError(...)
```

Without this, a typo like `level="WARNIING"` silently falls back to a
default. The error is raised at startup rather than manifesting as missing
log output later.

### File handler at DEBUG, console handler configurable

The file captures everything. The console only shows what you set (typically
INFO). This means you can always dig into the log file for debug-level detail
without cluttering your terminal during normal development.

### `logger.setLevel(DEBUG)` vs `console_level`

When a file handler exists, the logger level is set to DEBUG so that debug
records are created and captured to file, even if the console filters them.

When `log_dir=None`, there is no file handler to capture debug records. In
that case, the logger level is set to match the console level. This avoids
creating `LogRecord` objects (which capture frame info, timestamps, etc.)
only to have the console handler immediately discard them.

### `utc=True` on file rotation

`TimedRotatingFileHandler` rotates at midnight. If rotation is based on local
time, DST transitions can cause a missed rotation (23-hour day) or a double
rotation (25-hour day). Rotating on UTC midnight avoids this entirely.

Note: log *timestamps* still use local time (the system default). This means
a file named `my_project.2024-01-15.log` may contain entries showing the
previous local date near the start of the file. This is a known trade-off —
correct rotation matters more than filename/timestamp alignment at day
boundaries.

### Rotated filename format

Python's `TimedRotatingFileHandler` produces filenames like
`my_project.log.2024-01-15`. The custom `namer` rewrites this to
`my_project.2024-01-15.log`. This is purely cosmetic — it sorts correctly in
file browsers and preserves `.log` file association. The function runs once
per day at rotation time, so there is no performance cost.

### Local time (not UTC) for timestamps

Early versions included `ZoneInfo`-based timezone conversion with a
configurable timezone parameter. This was removed.

The stdlib `logging.Formatter` uses local system time by default, which
requires zero configuration. For a solo developer reading their own logs —
both in the terminal and in log files — local time is the most natural
choice.

UTC timestamps are recommended when multiple developers across timezones
share logs, or when logs feed into aggregation systems that normalize
timestamps. If that need arises, it's a one-line change:

```python
import time
logging.Formatter.converter = time.gmtime
```

No custom formatter class needed.

### Returning the logger

`setup_logging()` returns the configured logger. This is a zero-cost
convenience that saves a redundant `logging.getLogger()` call in the entry
point:

```python
logger = setup_logging("my_project")
logger.info("Startup complete")
```

### `log_dir=None` for Lambda

Lambda's filesystem is ephemeral. Log files written during execution are lost
when the container recycles. The `log_dir=None` option disables file logging
entirely, leaving only the console handler. CloudWatch automatically captures
anything written to stdout/stderr in Lambda and ECS/Fargate (via the
`awslogs` driver).

Environment detection can be automatic if desired:

```python
import os
is_lambda = os.environ.get("AWS_LAMBDA_FUNCTION_NAME") is not None
logger = setup_logging("my_project", log_dir=None if is_lambda else "logs")
```

---

## What Was Removed and Why

| Feature | Why it was removed |
|---|---|
| `ZoneInfo` timezone conversion | `logging.Formatter` uses local time by default. The `ZoneInfo` machinery (custom formatter class, `datetime.fromtimestamp`, `local_tz` parameter) solved a problem that didn't exist. |
| `JSONFormatter` class | Not currently used. CloudWatch captures plain text fine for manual log reading. JSON formatting should be added when log volume justifies Logs Insights queries with structured field filtering. |
| `_STANDARD_RECORD_KEYS` set | Only existed to support the JSON formatter's `extra` field extraction. Removed with the JSON formatter. |
| `use_json` parameter | Was always `False` across all projects. |
| `StandardFormatter` class | Only existed to override `formatTime` for timezone conversion. Without timezone conversion, an inline `logging.Formatter()` call does the same thing. |
| `QueueHandler` / `QueueListener` | Moves log I/O to a background thread. Only matters if profiling shows logging as a bottleneck. Adds complexity (queue plumbing, `atexit` shutdown) that isn't justified without evidence of a problem. |
| `capture_root` parameter | Attaches handlers to the root logger to capture third-party library logs. Useful, but should be added when missing third-party logs are actually observed, not preemptively. |
| Millisecond timestamps | Useful for correlating with distributed traces. Not needed for solo development. Easy to add later by changing the `datefmt` string. |
| Split `console_format` / `file_format` | Allowed independent text/JSON per handler. Over-engineered for a setup that doesn't use JSON at all. |

---

## When to Add Things Back

| Situation | What to add |
|---|---|
| Third-party library logs are silently disappearing | Attach handlers to the root logger at WARNING level |
| You're writing CloudWatch Logs Insights queries regularly | Add a JSON formatter for the console handler in Lambda deployments |
| Profiling shows logging as a hot spot | Add `QueueHandler` / `QueueListener` |
| You need to correlate logs with distributed traces | Add milliseconds to `datefmt`: `"%Y-%m-%d %H:%M:%S.%f"` |
| You deploy across timezones and need a specific one | Add `ZoneInfo` back, or use `logging.Formatter.converter = time.gmtime` for UTC |
| You pass `extra={...}` dicts and want them in output | Add `_STANDARD_RECORD_KEYS` and extras extraction to a formatter |

---

## Usage Quick Reference

```python
# ── Local development (file + console) ───────────────────
from logging_config import setup_logging
logger = setup_logging("my_project")

# ── Lambda deployment (console only → CloudWatch) ────────
logger = setup_logging("my_project", log_dir=None)

# ── Automatic detection ──────────────────────────────────
import os
is_lambda = os.environ.get("AWS_LAMBDA_FUNCTION_NAME") is not None
logger = setup_logging("my_project", log_dir=None if is_lambda else "logs")

# ── In any other module ──────────────────────────────────
import logging
logger = logging.getLogger(__name__)
logger.info("Something happened")
```