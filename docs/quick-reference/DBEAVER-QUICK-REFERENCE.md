# DBeaver Quick Reference

SQL IDE for Oracle, Snowflake, Postgres, and more.

## Connection Setup

### Create a New Database Connection

1. **Database** menu → **New Database Connection**
2. Select database type (Oracle, Snowflake, Postgres, etc.)
3. Fill in connection details:
   - **Host:** database server address
   - **Port:** default port for that database
   - **Database/Schema:** database name
   - **Username/Password:** credentials
4. **Test Connection** to verify
5. **Finish** to save

### Connection Details (by database type)

**Oracle:**
- Host: your-oracle-server.com
- Port: 1521
- Database: SID or service name
- Username/Password: your credentials

**Snowflake:**
- Host: your-account.snowflakecomputing.com
- Port: 443
- Database: your database name
- Username/Password: your credentials
- Extra tab: Account = your-account

**Postgres:**
- Host: your-postgres-server.com
- Port: 5432
- Database: your database name
- Username/Password: your credentials

### Switch Between Connections

Click the database dropdown in the top toolbar (shows active connection). Select another connection to switch.

---

## Keyboard Shortcuts (Mac)

### Execution & Navigation

```
Cmd + Enter              Execute query (current statement)
Cmd + Shift + Enter      Execute query (all statements)
Cmd + /                  Toggle line comment
Cmd + Shift + /          Toggle block comment
Cmd + Shift + F          Format SQL (applies your formatting)
Cmd + Alt + Up/Down      Move line up/down
Cmd + D                  Duplicate line
```

### Editor & Navigation

```
Cmd + F                  Find
Cmd + H                  Find & Replace
Cmd + G                  Go to line
Cmd + L                  Show line numbers (toggle)
Cmd + Shift + O          Go to table/object
Cmd + W                  Close tab
Cmd + Tab                Switch tabs
```

### Results & Export

```
Cmd + S                  Save query as script
Cmd + E                  Export results (after query runs)
Cmd + Shift + C          Copy (results)
```

### General

```
F1                       Help/Documentation
Cmd + ,                  Preferences/Settings
Cmd + N                  New SQL script
```

---

## Writing & Executing Queries

### Running Queries

```sql
-- Single statement
SELECT * FROM users;
Cmd + Enter  -- Execute this statement

-- Multiple statements (separate with ;)
SELECT * FROM users;
SELECT * FROM orders;
Cmd + Shift + Enter  -- Execute all statements
```

### Query Results Pane

After running a query:
- Results appear in the lower pane
- Click column headers to sort
- Right-click results for options (copy, export, etc.)

### Formatting Your SQL

```
Cmd + Shift + F          Auto-format (applies DBeaver's formatter)
```

Or set your own formatting preferences:
```
Cmd + ,                  Preferences
SQL Editor → Format      Configure formatting rules
```

**Note:** DBeaver formatting may differ from your Oracle PL/SQL standards. You can disable auto-format and format manually using your standards.

---

## Exporting Data

### Export Query Results

After running a query:

```
Right-click results pane → Export
```

**Or:**
```
Cmd + E after query runs
```

**Export formats:**
- CSV
- Excel
- JSON
- SQL (INSERT statements)
- Other formats

### Export Settings

- **Include column names:** Yes (usually)
- **Encoding:** UTF-8
- **Delimiter:** comma (for CSV)

### Example Workflow

```
1. Write and run query
2. Cmd + E to export
3. Select CSV format
4. Choose location and filename
5. Open in Excel or paste into docs
```

---

## Saved Queries & Scripts

### Save a Query

```
Write your query
Cmd + S
Enter filename
Select location (usually Scripts folder)
```

### Organize Saved Queries

DBeaver creates a **Scripts** folder in the project.

**Best practice (from your workflow):**
```
Git repo: mit-data-warehouse-queries/
├── queries/
│   ├── user-reports/
│   │   ├── daily-active-users.sql
│   │   ├── user-signup-trends.sql
│   ├── financial/
│   │   ├── revenue-summary.sql
│   │   ├── expense-tracking.sql
├── README.md
├── .gitignore
```

### Opening a Saved Query

**In DBeaver:**
- Left sidebar → Scripts
- Find your query file
- Double-click to open

**Or:**
- File → Open → browse to query file

### Your Git Workflow for Queries

```bash
# Create a repo for your MIT Data Warehouse queries
git init mit-data-warehouse-queries
cd mit-data-warehouse-queries

# Organize by topic
mkdir queries/{user-reports,financial,product}

# Save queries in those folders (from DBeaver)
# Example: queries/user-reports/daily-active-users.sql

# Commit and push
git add .
git commit -m "Add daily active users report"
git push origin main
```

**Benefits:**
- Version control for your queries
- Easy to share with team
- Reference old query versions
- Document complex queries in README

---

## Browsing Schemas & Tables

### Navigate Database Schema

Left sidebar shows your connected databases.

```
Expand database
  → Schemas
    → Tables
      → Columns
```

**Right-click table:**
- View data (shows first 200 rows)
- View definition (CREATE statement)
- Generate DDL
- Export data

### View Table Structure

```
Right-click table → View definition
Shows column names, types, constraints
```

### Search for Tables/Objects

```
Cmd + Shift + O          Open object search
Type table name
```

---

## Multiple Connections & Switching

### Work with Multiple Databases

You can have multiple connections open simultaneously.

```
Create Connection A (Oracle)
Create Connection B (Snowflake)
Create Connection C (Postgres)
```

**Switch between connections:**
Click the connection dropdown at the top of the editor.

**Example workflow:**
```
-- Query Oracle
SELECT * FROM oracle_connection.schema.table;

-- Switch to Snowflake connection
SELECT * FROM snowflake_connection.schema.table;
```

---

## Query Formatting & Standards

### Your Oracle PL/SQL Standards in DBeaver

DBeaver has built-in formatting, but it may not match your standards exactly.

**Option 1: Use DBeaver's formatter, then adjust manually**
```
Cmd + Shift + F          Format
Then manually adjust to match your standards
```

**Option 2: Disable auto-formatting and format manually**
```
Cmd + ,
SQL Editor → Format
Disable "Format SQL on paste" / "Auto-format"
```

Then format manually to your standards:
```sql
-- Your standard (leading commas, JOINs indented, etc.)
WITH PM AS (
    SELECT column1
        , column2
    FROM table
)
SELECT pm.column1
    , pm.column2
FROM PM pm
    INNER JOIN other_table ot
        ON pm.id = ot.id
```

---

## Tips & Tricks

### Run Query on Different Connection

```
Click connection dropdown at top
Select different connection
Run your query (it runs on that connection)
```

### Copy Query Results as SQL

```
Right-click results
→ Export
→ SQL (INSERT statements)
Generates ready-to-run INSERT statements
```

### View Query Execution Plan

```
Some databases support this:
Right-click query → Explain execution plan
Shows how the database executes your query (useful for optimization)
```

### Save Connection Password

When creating a connection:
- Enable "Save locally" (encrypted)
- Don't need to re-enter password each time

### Group Related Queries

In your Scripts folder, create subfolders:
```
scripts/
├── daily-reports/
├── monthly-analysis/
├── ad-hoc/
```

Keep queries organized by purpose.

---

## Git Workflow for Stored Queries (Your Pattern)

### Setup

```bash
# Create a repo for your queries
mkdir mit-data-warehouse-queries
cd mit-data-warehouse-queries
git init

# Create folder structure
mkdir -p queries/{reports,etl,analysis}

# Create README
touch README.md
```

**README example:**
```markdown
# MIT Data Warehouse Queries

Collection of SQL queries for the MIT Data Warehouse.

## Folder Structure

- `queries/reports/` – Daily/weekly reports
- `queries/etl/` – ETL and data pipeline queries
- `queries/analysis/` – Ad-hoc analysis

## How to Use

1. Open query file in DBeaver
2. Select appropriate connection (MIT Data Warehouse)
3. Run query (Cmd + Enter)
```

### Save Queries to Git

```bash
# From DBeaver, save queries to queries/ folder
# Save a query: Cmd + S → queries/reports/daily-summary.sql

# Commit to git
cd mit-data-warehouse-queries
git add queries/
git commit -m "Add daily summary report query"
git push origin main
```

### Useful .gitignore for Query Repos

```
# .gitignore
.DS_Store
*.swp
*.swo
local-notes.txt
temp/
```

---

## Common Workflows

### Write, Test, and Save a Query

```
1. Cmd + N              Create new SQL script
2. Select connection    Choose database (Oracle, Snowflake, etc.)
3. Write query          Use your SQL standards
4. Cmd + Shift + F      Format (or format manually)
5. Cmd + Enter          Test execute
6. Debug if needed      Fix any errors
7. Cmd + S              Save to Scripts/queries/ folder
8. git commit           Add to your queries repo
```

### Export Report Data

```
1. Run query (Cmd + Enter)
2. Right-click results → Export
3. Choose CSV or Excel
4. Email or share results
```

### Compare Data Across Connections

```
1. Write query for connection A
2. Cmd + Enter to run (results show)
3. Switch connection in dropdown
4. Write similar query for connection B
5. Cmd + Enter to run
6. Compare results side-by-side
```

---

## Troubleshooting

### "Connection refused" or "Connection timeout"

```
Verify connection details:
- Host is correct
- Port is correct
- Credentials are current
- Network access is allowed (firewalls, VPN, etc.)
```

### Query executes but returns no results

```
Check:
- Are you connected to the right database?
- Is the table name correct?
- Do you have permissions to view the table?
- Are your WHERE conditions too restrictive?
```

### Performance: Query running slowly

```
Right-click query → Explain plan
See how database executes query
Look for missing indexes or inefficient joins
Check your Oracle/Snowflake standards (proper JOIN syntax, etc.)
```

### Can't find saved query

```
Check Scripts folder in left sidebar
Or File → Recent Scripts
Or Cmd + Shift + O to search for it
```

---

## Things to Remember

- **Use your SQL standards** – DBeaver formatting may not match your style
- **Organize queries in your git repo** – Makes them reusable and shareable
- **Test on dev before prod** – Make sure you're on the right connection
- **Save frequently** – Cmd + S to save scripts
- **Use keyboard shortcuts** – Cmd + Enter for queries, Cmd + Shift + F for format
- **Export results for sharing** – Cmd + E to export
- **Connection dropdown at top** – Easy way to switch databases
- **Right-click everything** – Most DBeaver features are in context menus