# Oracle PL/SQL Formatting Standards

Use these standards for consistency across all queries.

## STRUCTURE

- Leading commas for multi-line SELECT, WHERE, ORDER BY
- FROM, WHERE, ORDER BY, GROUP BY on their own line with content indented
- JOINs indented under FROM with ON further indented below the joined table
- No blank lines between CTEs or between last CTE and main query
- CROSS JOIN at end of FROM clause

## NAMING & CONVENTIONS

- Uppercase SQL keywords and column names
- Params CTE aliased as PM (column names match actual table columns)
- AS aliases immediately after expression (no padding)
- LEFT JOIN (not LEFT OUTER JOIN)
- INNER JOIN (explicitly stated, not just JOIN)

## DATA HANDLING

- COALESCE instead of NVL or CASE WHEN NULL
- NULLIF instead of CASE WHEN = 'value' THEN NULL
- TO_CHAR dates as 'YYYY-MM-DD'
- ROUND on numeric values where precision issues exist
- No DISTINCT unless genuinely needed
- No ORDER BY in CTEs

## HEADER TEMPLATE

```sql
/*=================================================================================================

QUERY TITLE

Description
-----------
Freeform description of what this query does, what it's used for, and any important context.

Change Log
----------
YYYY-MM-DD | author | What changed.

=================================================================================================*/