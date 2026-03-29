# Developer Toolkit

Personal developer toolkit for Python projects, data engineering, and BI work. Includes templates, configurations, quick references, scripts, and automation.

## What's in Here?

### Quick Start
- **[NEW-PROJECT-CHECKLIST.md](docs/quick-reference/NEW-PROJECT-CHECKLIST.md)** – How to set up a new project or clone an existing one
- **[setup-new-project.sh](scripts/setup/setup-new-project.sh)** – Automated setup script (recommended)

### Quick References (bookmark these)
- **[Git/GitHub](docs/quick-reference/GIT-GITHUB-QUICK-REFERENCE.md)** – Common Git commands, workflows, fixing mistakes
- **[VS Code](docs/quick-reference/VSCODE-QUICK-REFERENCE.md)** – Shortcuts, debugging, extensions
- **[Python/pip/pyproject.toml](docs/quick-reference/PYTHON-PIP-PYPROJECT-QUICK-REFERENCE.md)** – Virtual environments, dependencies, version management
- **[AWS CLI](docs/quick-reference/AWS-CLI-QUICK-REFERENCE.md)** – S3, Lambda, RDS, CloudWatch, EC2, and more
- **[DBeaver](docs/quick-reference/DBEAVER-QUICK-REFERENCE.md)** – SQL IDE shortcuts, queries, exports

### Templates & Configs

**Project Setup:**
- `.vscode-settings.jsonc` – VS Code settings template
- `.gitignore` – Git ignore template
- `.env.example` – Environment variables template
- `.editorconfig` – Editor configuration (formatting across file types)
- `.pre-commit-config.yaml` – Pre-commit hooks (Black, Ruff, mypy)
- `pyproject.toml.snippet` – Python project configuration snippet

**SQL:**
- `ORACLE-PLSQL-TEMPLATE.sql` – Oracle SQL query template
- `ORACLE-PLSQL-STANDARDS.md` – Formatting standards and conventions

**Project Documentation:**
- `README-TEMPLATE.md` – Project README template
- `DEPLOYMENT-TEMPLATE.md` – Deployment documentation template

**Setup Documentation:**
- `SETUP-NEW-PROJECT.md` – Detailed setup script documentation

### Scripts

**Project Automation:**
- `setup-new-project.sh` – Automate new project initialization (copies templates, creates venv, installs pre-commit)

---

## Folder Structure

```
dev-toolkit/
├── README.md                           (this file)
├── docs/
│   └── quick-reference/
│       ├── NEW-PROJECT-CHECKLIST.md
│       ├── GIT-GITHUB-QUICK-REFERENCE.md
│       ├── VSCODE-QUICK-REFERENCE.md
│       ├── PYTHON-PIP-PYPROJECT-QUICK-REFERENCE.md
│       ├── AWS-CLI-QUICK-REFERENCE.md
│       └── DBEAVER-QUICK-REFERENCE.md
├── templates/
│   ├── configs/
│   │   ├── .vscode-settings.jsonc
│   │   ├── .gitignore
│   │   ├── .env.example
│   │   ├── .editorconfig
│   │   ├── .pre-commit-config.yaml
│   │   └── pyproject.toml.snippet
│   ├── sql/
│   │   ├── ORACLE-PLSQL-TEMPLATE.sql
│   │   └── ORACLE-PLSQL-STANDARDS.md
│   └── README-TEMPLATE.md
│       DEPLOYMENT-TEMPLATE.md
└── scripts/
    └── setup/
        ├── setup-new-project.sh
        └── SETUP-NEW-PROJECT.md
```

---

## Getting Started

### First Time Setup

1. **Clone this toolkit:**
   ```bash
   git clone https://github.com/your-username/dev-toolkit.git ~/dev-toolkit
   ```

2. **Update the toolkit path in the setup script:**
   ```bash
   vim ~/dev-toolkit/scripts/setup/setup-new-project.sh
   
   Find: TOOLKIT_DIR="$HOME/path/to/your/dev-toolkit"
   Change to: TOOLKIT_DIR="$HOME/dev-toolkit"
   ```

3. **(Optional) Create an alias for quick access:**
   ```bash
   # Add to your .zshrc or .bashrc
   alias setup-project='~/dev-toolkit/scripts/setup/setup-new-project.sh'
   ```

4. **Bookmark the quick references** – You'll use these constantly

### Setting Up a New Project

**Quick way (automated):**
```bash
git clone <repo-url>
cd project
~/dev-toolkit/scripts/setup/setup-new-project.sh $(pwd)
```

**Or manually:**
See [NEW-PROJECT-CHECKLIST.md](docs/quick-reference/NEW-PROJECT-CHECKLIST.md)

---

## What's Automated by setup-new-project.sh

✓ Creates Python virtual environment (.venv)
✓ Installs dependencies from pyproject.toml
✓ Copies all config templates (.vscode, .gitignore, .env.example, .editorconfig, .pre-commit-config.yaml)
✓ Installs and initializes pre-commit hooks
✓ Activates the virtual environment
✓ Verifies Git configuration

See [SETUP-NEW-PROJECT.md](scripts/setup/SETUP-NEW-PROJECT.md) for full details.

---

## Using Templates

### For a New Project

Copy templates from `templates/`:

```bash
# VS Code settings
cp ~/dev-toolkit/templates/configs/.vscode-settings.jsonc .vscode/settings.json

# Python config
cp ~/dev-toolkit/templates/configs/pyproject.toml.snippet pyproject.toml
# Edit pyproject.toml with your project-specific info

# Git ignore
cp ~/dev-toolkit/templates/configs/.gitignore .

# Pre-commit hooks
cp ~/dev-toolkit/templates/configs/.pre-commit-config.yaml .
pre-commit install
```

Or use the setup script to do all this automatically.

### For SQL Projects

Use the Oracle PL/SQL template and standards:

- **[ORACLE-PLSQL-TEMPLATE.sql](templates/sql/ORACLE-PLSQL-TEMPLATE.sql)** – Copy this structure for new queries
- **[ORACLE-PLSQL-STANDARDS.md](templates/sql/ORACLE-PLSQL-STANDARDS.md)** – Reference for formatting conventions

### For Project Documentation

- **[README-TEMPLATE.md](templates/README-TEMPLATE.md)** – Start with this for project READMEs
- **[DEPLOYMENT-TEMPLATE.md](templates/DEPLOYMENT-TEMPLATE.md)** – Use for deployment documentation

---

## Tech Stack

**Development:**
- Python 3.12+
- VS Code
- Git / GitHub Enterprise

**Databases:**
- Oracle
- Snowflake
- Postgres
- RDS (AWS)

**Tools & Services:**
- AWS (S3, Lambda, RDS, CloudWatch, API Gateway, EventBridge, IAM, EC2)
- DBeaver (SQL IDE)
- Docker (learning)
- pre-commit (code quality)
- Black, Ruff, mypy (Python code quality)

**Focus Areas:**
- Business Intelligence
- Data Engineering
- Backend Development
- Web Applications (learning)

---

## Quick Tips

**Before committing:**
- Pre-commit hooks run automatically
- Fix any issues Black, Ruff, or mypy flag
- Commit again after fixes

**Terminal workflow:**
```bash
activate              # Your alias to activate .venv
deactivate            # Exit venv
```

**VS Code:**
- `Cmd + Shift + P` to search anything
- `Cmd + P` to search files
- Your pre-commit hooks run automatically on commit

**Git:**
- `git pull` before you push
- Use branches for features
- Commit frequently with clear messages

**Quick references:**
- Bookmark the quick reference docs in this toolkit
- They're in `docs/quick-reference/`

---

## Updating the Toolkit

As you develop your workflow, update templates and docs:

```bash
cd ~/dev-toolkit

# Make changes to templates, scripts, docs
vim templates/configs/.env.example

# Commit and push
git add .
git commit -m "Update: .env.example with new fields"
git push origin main
```

New projects will use the latest templates.

---

## Troubleshooting

**Setup script says "template not found"**
→ Update `TOOLKIT_DIR` at the top of the script

**Virtual environment isn't activating**
→ Run `source .venv/bin/activate` or use your alias: `activate`

**Pre-commit hooks failing on first commit**
→ Normal. Fix the issues (usually formatting or type errors) and commit again

**Can't find a quick reference doc**
→ All quick references are in `docs/quick-reference/`

**Need help with a specific tool?**
→ Check the relevant quick reference:
- Git: [GIT-GITHUB-QUICK-REFERENCE.md](docs/quick-reference/GIT-GITHUB-QUICK-REFERENCE.md)
- VS Code: [VSCODE-QUICK-REFERENCE.md](docs/quick-reference/VSCODE-QUICK-REFERENCE.md)
- Python: [PYTHON-PIP-PYPROJECT-QUICK-REFERENCE.md](docs/quick-reference/PYTHON-PIP-PYPROJECT-QUICK-REFERENCE.md)
- AWS: [AWS-CLI-QUICK-REFERENCE.md](docs/quick-reference/AWS-CLI-QUICK-REFERENCE.md)
- DBeaver: [DBEAVER-QUICK-REFERENCE.md](docs/quick-reference/DBEAVER-QUICK-REFERENCE.md)

---

## Version & Changelog

**Current Version:** 1.0

**Last Updated:** 2026-03-28

**Includes:**
- Project setup automation
- Config templates (Black, Ruff, mypy, pre-commit, VS Code, Git)
- SQL templates and standards (Oracle PL/SQL)
- Quick reference guides (Git, VS Code, Python, AWS, DBeaver)
- Project documentation templates

---

## Next Steps

1. **Bookmark the quick references** – You'll refer to them frequently
2. **Use the setup script** for new projects
3. **Keep this toolkit updated** as your workflow evolves
4. **Add to your VS Code workspace** for quick access

---

**Happy coding!**