# SETUP-NEW-PROJECT.SH - AUTOMATE NEW PROJECT INITIALIZATION

**Last updated:** 2026-03-28  
**Toolkit version:** 1.0

---

## WHAT IS THIS SCRIPT?

`setup-new-project.sh` automates the initial setup steps for new Python projects. Instead of manually running 10+ commands and copying multiple files, run one script and it handles everything.

It follows your project checklist and configures your project with all templates, configurations, and pre-commit hooks from your dev-toolkit.

---

## INSTALLATION

### 1. Clone your dev-toolkit (if you haven't already)

```bash
git clone https://github.com/your-username/dev-toolkit.git ~/dev-toolkit
```

(Adjust the path if you store it elsewhere.)

### 2. The script is already executable

The script lives at: `~/dev-toolkit/scripts/setup/setup-new-project.sh`

### 3. Update the TOOLKIT_DIR path (ONE TIME SETUP)

Open the script:
```bash
vim ~/dev-toolkit/scripts/setup/setup-new-project.sh
```

Find this line near the top:
```bash
TOOLKIT_DIR="$HOME/path/to/your/dev-toolkit"
```

Replace it with your actual toolkit path. Example:
```bash
TOOLKIT_DIR="$HOME/dev-toolkit"
```

Save and exit. You only need to do this once.

---

## USAGE

Run the script with a project directory path:

```bash
~/dev-toolkit/scripts/setup/setup-new-project.sh ~/repos/my-new-project
```

Or create an alias for easier access:
```bash
alias setup-project='~/dev-toolkit/scripts/setup/setup-new-project.sh'
```

Then:
```bash
setup-project ~/repos/my-new-project
```

---

## WHAT THE SCRIPT AUTOMATES

### Environment Setup
- ✓ Creates `.venv` (python -m venv .venv)
- ✓ Upgrades pip
- ✓ Installs dependencies from `pyproject.toml` or `requirements.txt`

### Configuration & Templates
- ✓ Creates `.vscode/` directory
- ✓ Copies VS Code settings template (`.vscode/settings.json`)
- ✓ Copies `.gitignore` template
- ✓ Copies `.env.example` template
- ✓ Copies `.editorconfig` template
- ✓ Copies `.pre-commit-config.yaml` template

### Development Tools
- ✓ Installs `pre-commit` package
- ✓ Initializes pre-commit hooks (`.git/hooks/pre-commit`)
- ✓ Verifies git remote is configured
- ✓ Activates the virtual environment

---

## WHAT STILL REQUIRES MANUAL STEPS

These require VS Code UI interaction:

1. **Open the project in VS Code**
   ```bash
   code .
   ```

2. **Select the Python interpreter**
   ```
   Cmd + Shift + P → Python: Select Interpreter → choose .venv
   ```

3. **Save as a workspace**
   ```
   File → Save Workspace As → save in project root
   ```

The script prints instructions at the end as a reminder.

---

## EXAMPLE WORKFLOW

### 1. Clone a new project
```bash
git clone https://github.com/user/my-project.git
cd my-project
```

### 2. Run the setup script
```bash
~/dev-toolkit/scripts/setup/setup-new-project.sh ~/repos/my-project
```

### 3. Follow the printed instructions
- Open in VS Code: `code .`
- Select interpreter: `Cmd + Shift + P`
- Save as workspace: `File → Save Workspace As`

### 4. Start working!

Your `.venv` is active, pre-commit is installed, and all templates are in place.

---

## TEMPLATE FILES COPIED

The script copies these from your toolkit:

| File | Source | Destination | Notes |
|------|--------|-------------|-------|
| VS Code settings | `templates/configs/.vscode-settings.jsonc` | `.vscode/settings.json` | Always copied |
| .gitignore | `templates/configs/.gitignore` | `.gitignore` | Skipped if exists |
| .env.example | `templates/configs/.env.example` | `.env.example` | Skipped if exists |
| .editorconfig | `templates/configs/.editorconfig` | `.editorconfig` | Skipped if exists |
| pre-commit config | `templates/configs/.pre-commit-config.yaml` | `.pre-commit-config.yaml` | Skipped if exists |

**Skipped files** preserve any custom configurations you may have already added to the project.

---

## TROUBLESHOOTING

### ERROR: "Directory does not exist"
→ Make sure the project directory path is correct and the directory has been created

### ERROR: "Not a git repository"
→ Clone the project first before running the script:
```bash
git clone <repo-url> ~/repos/my-project
~/dev-toolkit/scripts/setup/setup-new-project.sh ~/repos/my-project
```

### ERROR: "Template not found at..."
→ Update the `TOOLKIT_DIR` path at the top of the script to match where you store your toolkit:
```bash
TOOLKIT_DIR="$HOME/dev-toolkit"
```

### Script activates .venv but then exits?
→ This is normal. The script runs in a subshell. Open a new terminal in the project directory and activate manually:
```bash
source .venv/bin/activate
```

Or simply open the project in VS Code and select the interpreter (VS Code will handle activation).

### Pre-commit hooks aren't running on commit
→ Verify hooks are installed:
```bash
pre-commit install
```

If you get errors on first commit, it may be running mypy or ruff for the first time on your codebase. Fix any issues and commit again.

---

## THINGS I'VE LEARNED THE HARD WAY

- **Always clone the repo first.** The script checks for `.git` and will fail if it's not a git repository.

- **Update the TOOLKIT_DIR path once.** Do this immediately after installation so the script can find your templates.

- **The script creates and activates .venv in a subshell.** If you want to work in that activated environment after the script finishes, open a new terminal in the project directory or use VS Code's Python interpreter selector.

- **Don't worry about existing files.** The script skips `.gitignore`, `.env.example`, and `.editorconfig` if they already exist, so it won't overwrite custom configurations. It will always overwrite `.vscode/settings.json` with the template (which is usually what you want).

- **For projects using requirements.txt,** the script automatically detects and installs from `requirements.txt` instead of `pyproject.toml`. Make sure your dependencies file exists before running the script.

- **First commit with pre-commit hooks** may take a while if mypy is running type checking on your entire codebase for the first time. This is normal. Subsequent commits will be faster.

- **If you update your toolkit templates,** they won't affect existing projects (good!). New projects will use the updated templates.

---

## NEXT STEPS AFTER SETUP

Once the script finishes and you've completed the manual steps in VS Code:

1. **Configure your environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your actual credentials
   ```

2. **Run your first commit to test pre-commit hooks**
   ```bash
   git add .
   git commit -m "Initial project setup"
   ```
   This will run Black, Ruff, and mypy for the first time. Fix any issues and commit again.

3. **Start building!**