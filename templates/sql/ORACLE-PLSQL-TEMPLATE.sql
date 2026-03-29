/*=================================================================================================

QUERY TITLE

Description
-----------
Freeform description of what this query does, what it's used for, and any important context.

Change Log
----------
YYYY-MM-DD | author | What changed.

=================================================================================================*/

-- Example CTE structure following your standards
WITH PM AS (
    -- Params CTE: column names match actual table columns
    SELECT
        value1 AS column_name
        , value2 AS another_column
    FROM some_table
)
, summary_data AS (
    -- Additional CTEs as needed
    SELECT
        column1
        , column2
        , COUNT(*) AS record_count
    FROM another_table
    GROUP BY column1, column2
)
SELECT
    pd.column_name
    , sd.column2
    , COALESCE(pd.value1, 'N/A') AS display_value
    , TO_CHAR(pd.date_column, 'YYYY-MM-DD') AS formatted_date
    , ROUND(sd.numeric_value, 2) AS rounded_value
FROM summary_data sd
    INNER JOIN PM pd
        ON sd.column1 = pd.column_name
    LEFT JOIN another_table at
        ON sd.column2 = at.id
    CROSS JOIN cross_ref_table crt
WHERE
    sd.record_count > 0
    AND pd.column_name IS NOT NULL
ORDER BY
    pd.column_name
    , sd.column2
;