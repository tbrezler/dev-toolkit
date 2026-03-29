========================================================================================================
SETTING UP A NEW PROJECT - COMPLETE CHECKLIST
========================================================================================================

Two common scenarios:
  A) Cloning an existing repo from GitHub
  B) Starting a project locally, then pushing to GitHub


========================================================================================================
SCENARIO A: CLONING AN EXISTING REPO FROM GITHUB
========================================================================================================

QUICK START (AUTOMATED):

   1. Clone the repo
      git clone <repo-url>
      cd <project-folder>

   2. Run the setup script (automates environment + templates)
      ~/dev-toolkit/scripts/setup/setup-new-project.sh $(pwd)

   3. Follow the printed instructions:
      - Open in VS Code: code .
      - Select interpreter: Cmd + Shift + P → Python: Select Interpreter
      - Save as workspace: File → Save Workspace As

   4. Configure environment variables
      cp .env.example .env
      # Edit .env with your actual credentials

   5. Verify Git connection
      git remote -v
      git status

   6. Start working — follow the daily workflow (see git-workflow.txt)


MANUAL SETUP (if you prefer not to use the script):

   1. Clone the repo
      git clone <repo-url>
      cd <project-folder>

   2. Set Python version
      pyenv local 3.12.12

   3. Create and activate virtual environment
      python -m venv .venv
      source .venv/bin/activate

   4. Upgrade pip
      pip install --upgrade pip

   5. Install project and dependencies
      pip install -e ".[dev]"
      
      IMPORTANT: Include [dev] to get dev tools like pytest. Without it, you'll get
      "pytest: command not found" when trying to run tests.

   6. Copy templates (if not already in repo)
      mkdir -p .vscode
      cp ~/dev-toolkit/templates/configs/.vscode-settings.jsonc .vscode/settings.json
      cp ~/dev-toolkit/templates/configs/.env.example .
      cp ~/dev-toolkit/templates/configs/.editorconfig .
      cp ~/dev-toolkit/templates/configs/.pre-commit-config.yaml .

   7. Install pre-commit hooks
      pip install pre-commit
      pre-commit install

   8. Open in VS Code
      code .

   9. Save as workspace
      File → Save Workspace As → save in project root

   10. Select Python interpreter
       Cmd + Shift + P → Python: Select Interpreter → choose .venv

   11. Verify terminal environment
       Open new terminal (Ctrl + `)
       Confirm (.venv) in prompt
       Run: which python (should point to ./.venv/bin/python)

   12. Verify Git
       git remote -v
       git status

   13. Start working!


========================================================================================================
SCENARIO B: STARTING A PROJECT LOCALLY, THEN PUSHING TO GITHUB
========================================================================================================

Use this when you've been working on a project locally and want to put it on GitHub.

STEP 1: CREATE LOCAL PROJECT DIRECTORY

   mkdir my-project
   cd my-project

STEP 2: SET PYTHON VERSION

   pyenv local 3.12.12

STEP 3: CREATE VIRTUAL ENVIRONMENT AND INSTALL DEPENDENCIES

   python -m venv .venv
   source .venv/bin/activate
   pip install --upgrade pip
   pip install -e ".[dev]"

   (Assuming pyproject.toml exists. If not, install dependencies manually.)

STEP 4: INITIALIZE GIT LOCALLY

   git init
   git branch -M main

STEP 5: COPY TEMPLATES FROM TOOLKIT

   mkdir -p .vscode
   cp ~/dev-toolkit/templates/configs/.vscode-settings.jsonc .vscode/settings.json
   cp ~/dev-toolkit/templates/configs/.gitignore .
   cp ~/dev-toolkit/templates/configs/.env.example .
   cp ~/dev-toolkit/templates/configs/.editorconfig .
   cp ~/dev-toolkit/templates/configs/.pre-commit-config.yaml .

STEP 6: INSTALL PRE-COMMIT HOOKS

   pip install pre-commit
   pre-commit install

STEP 7: CREATE INITIAL COMMIT

   git add .
   git commit -m "Initial project setup"

   This will trigger pre-commit hooks (Black, Ruff, mypy). Fix any issues and commit again.

STEP 8: CREATE THE REPO ON GITHUB

   1. Go to https://github.com/new
   2. Name: my-project
   3. Description: (add brief description)
   4. Make it Private or Public (your choice)
   5. DO NOT initialize with README, .gitignore, or license (you already have these locally)
   6. Click "Create repository"

   GitHub will show you the commands to push an existing repo. Use these:

STEP 9: ADD REMOTE AND PUSH

   git remote add origin https://github.com/your-username/my-project.git
   git branch -M main
   git push -u origin main

STEP 10: VERIFY ON GITHUB

   - Go to your repo on GitHub
   - Confirm all files are there
   - Confirm branch is "main"

STEP 11: OPEN IN VS CODE (if not already)

   code .

STEP 12: SAVE AS WORKSPACE

   File → Save Workspace As → save in project root

STEP 13: SELECT PYTHON INTERPRETER

   Cmd + Shift + P → Python: Select Interpreter → choose .venv

STEP 14: VERIFY SETUP

   Open new terminal (Ctrl + `)
   Confirm (.venv) in prompt
   Run: which python (should point to ./.venv/bin/python)
   Run: git remote -v (should show your GitHub repo)

STEP 15: START WORKING!


========================================================================================================
IMPORTANT NOTES
========================================================================================================

[dev] dependencies:
   Always use pip install -e ".[dev]" to install development dependencies like pytest.
   Without [dev], you'll get "pytest: command not found" errors.

.env files:
   Always use .env.example as the template and create .env locally with actual credentials.
   NEVER commit .env to GitHub (it's in .gitignore).

Pre-commit hooks:
   First commit may take a while as mypy runs type checking on your entire codebase.
   Subsequent commits will be faster.

Python version:
   pyenv local 3.12.12 creates a .python-version file that ensures consistent Python
   across all machines that clone this project.

Workspace files:
   Save as workspace so all project configurations are preserved when you reopen the folder.