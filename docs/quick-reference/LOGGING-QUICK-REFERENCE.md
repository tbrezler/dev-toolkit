# Logging Quick Reference

## One-Time Setup (in main.py or __init__.py)

```python
from config import LOCAL_TZ
from constants import LOG_RETENTION_DAYS, LOG_LEVEL, USE_JSON_LOGGING, LOG_DIR
from logging_config import setup_logging

setup_logging(
    name="my_project",
    local_tz=LOCAL_TZ,
    log_dir=LOG_DIR,
    level=LOG_LEVEL,
    retention_days=LOG_RETENTION_DAYS,
    use_json=USE_JSON_LOGGING,
)
```

## Use Anywhere (replaces print statements)

```python
import logging

logger = logging.getLogger(__name__)

logger.debug("Detailed troubleshooting info")
logger.info("Normal application events")
logger.warning("Something unexpected but handled")
logger.error("Something failed")
logger.critical("System failure")
```

## What You Get

✓ **Daily log files** – `logs/my_project.log`, rotates at midnight  
✓ **Auto cleanup** – Old logs deleted after `LOG_RETENTION_DAYS`  
✓ **Timezone-aware** – All timestamps in your `LOCAL_TZ`  
✓ **File logging** – DEBUG level (all messages, detailed)  
✓ **Console logging** – INFO level (user-facing, clean output)  
✓ **Optional JSON** – Set `USE_JSON_LOGGING=True` for structured logs  

## Common Patterns

### Log process flow

```python
logger.info("Processing batch starting")
try:
    for item in items:
        logger.debug(f"Processing item {item.id}")
        process(item)
    logger.info("Processing batch complete")
except Exception as e:
    logger.error(f"Processing failed: {e}", exc_info=True)
    raise
```

### Debug queries/API calls

```python
logger.debug(f"Executing SQL: {query}")
result = db.execute(query)
logger.debug(f"Query returned {len(result)} rows")
```

### Log with extra context

```python
logger.info(
    "Data import complete",
    extra={
        "rows_imported": 1000,
        "duration_sec": 45,
        "source": "s3://bucket/file.csv",
    }
)
```

## Environment-Specific Setup

### Development

In `constants.py`:
```python
LOG_LEVEL = "DEBUG"
LOG_RETENTION_DAYS = 7
USE_JSON_LOGGING = False
```

### Production

In `constants.py`:
```python
LOG_LEVEL = "INFO"
LOG_RETENTION_DAYS = 90
USE_JSON_LOGGING = True  # For AWS CloudWatch
```

## Switching to JSON Logging (for CloudWatch, ELK, etc.)

Just change one constant:

```python
# In constants.py
USE_JSON_LOGGING = True
```

Logs now output as JSON. No code changes needed. Tools like CloudWatch, DataDog, and Splunk parse the JSON automatically.

Example JSON output:
```json
{
  "timestamp": "2024-03-28T14:35:22-05:00",
  "level": "INFO",
  "logger": "my_project",
  "message": "Processing batch complete",
  "module": "processor",
  "function": "process_batch",
  "line": 42
}
```

## Troubleshooting

**Why don't I see my debug logs in the console?**
→ Console shows INFO and above by default. Set `LOG_LEVEL = "DEBUG"` in constants.py to see debug messages.

**Where are my log files?**
→ They're in the `logs/` directory. Check `logs/my_project.log` for today's logs.

**I want JSON logs but only in production.**
→ Set `USE_JSON_LOGGING = False` in constants.py for dev, then override in your production deployment.

**How do I use logging in different modules?**
→ Just import logging at the top:
```python
import logging
logger = logging.getLogger(__name__)
logger.info("Your message")
```
The logger name will automatically be the module name, making logs easy to track.

**Can I log exceptions with full traceback?**
→ Yes, use `exc_info=True`:
```python
try:
    something_risky()
except Exception as e:
    logger.error(f"Failed: {e}", exc_info=True)
```

**How often are logs rotated?**
→ Daily at midnight. Old logs are automatically deleted after `LOG_RETENTION_DAYS`.