#!/bin/bash
# setup-new-project.sh
# Automates new project setup following the project checklist

# ============================================================
# CONFIGURATION - UPDATE THESE PATHS
# ============================================================
TOOLKIT_DIR="$HOME/repos/dev-toolkit"
VSCODE_SETTINGS_TEMPLATE="$TOOLKIT_DIR/templates/configs/.vscode-settings.jsonc"
GITIGNORE_TEMPLATE="$TOOLKIT_DIR/templates/configs/.gitignore"
ENV_TEMPLATE="$TOOLKIT_DIR/templates/configs/.env.example"
EDITORCONFIG_TEMPLATE="$TOOLKIT_DIR/templates/configs/.editorconfig"
PRECOMMIT_CONFIG_TEMPLATE="$TOOLKIT_DIR/templates/configs/.pre-commit-config.yaml"

# NEW: Python templates
CONFIG_TEMPLATE="$TOOLKIT_DIR/templates/python/config.py.snippet"
CONSTANTS_TEMPLATE="$TOOLKIT_DIR/templates/python/constants.py.snippet"
LOGGING_CONFIG_TEMPLATE="$TOOLKIT_DIR/templates/python/logging_config.py"
AUDIT_LOGGING_TEMPLATE="$TOOLKIT_DIR/templates/python/audit_logging.py"

# ============================================================
# SCRIPT
# ============================================================

# Check if project directory was provided
if [ -z "$1" ]; then
    echo "Usage: ./setup-new-project.sh <project-directory>"
    echo "Example: ./setup-new-project.sh ~/repos/my-project"
    exit 1
fi

PROJECT_DIR="$1"

# Check if directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory '$PROJECT_DIR' does not exist"
    exit 1
fi

# Check if it's a git repo
if [ ! -d "$PROJECT_DIR/.git" ]; then
    echo "Error: '$PROJECT_DIR' is not a git repository"
    echo "Please clone the repo first: git clone <repo-url>"
    exit 1
fi

cd "$PROJECT_DIR"

echo "=================================================="
echo "Setting up project: $PROJECT_DIR"
echo "=================================================="

# Step 1: Create project directories
echo ""
echo "Creating project directories..."
mkdir -p src tests logs
echo "✓ Directories created (src, tests, logs)"

# Step 2: Check if .python-version exists
if [ ! -f ".python-version" ]; then
    echo ""
    echo "⚠️  No .python-version file found"
    echo "Run this manually: pyenv local 3.12.12"
    read -p "Press enter once you've set the Python version..."
else
    PYTHON_VERSION=$(cat .python-version)
    echo "✓ Using Python version: $PYTHON_VERSION"
fi

# Step 3: Create virtual environment
echo ""
echo "Creating virtual environment..."
python -m venv .venv
echo "✓ Virtual environment created"

# Step 4: Activate and upgrade pip
echo ""
echo "Activating .venv and upgrading pip..."
source .venv/bin/activate
pip install --upgrade pip > /dev/null 2>&1
echo "✓ pip upgraded"

# Step 5: Install dependencies
echo ""
echo "Installing project dependencies..."
if [ -f "pyproject.toml" ]; then
    pip install -e ".[dev]" > /dev/null 2>&1
    echo "✓ Dependencies installed from pyproject.toml"
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt > /dev/null 2>&1
    echo "✓ Dependencies installed from requirements.txt"
else
    echo "⚠️  No pyproject.toml or requirements.txt found"
    echo "Skipping dependency installation"
fi

# Step 6: Install pre-commit
echo ""
echo "Installing pre-commit..."
pip install pre-commit > /dev/null 2>&1
echo "✓ pre-commit installed"

# Step 7: Copy templates from toolkit
echo ""
echo "Copying templates from toolkit..."

# Copy VS Code settings
mkdir -p .vscode
if [ -f "$VSCODE_SETTINGS_TEMPLATE" ]; then
    cp "$VSCODE_SETTINGS_TEMPLATE" .vscode/settings.json
    echo "✓ VS Code settings copied"
else
    echo "⚠️  VS Code template not found at: $VSCODE_SETTINGS_TEMPLATE"
fi

# Copy .gitignore (only if it doesn't exist)
if [ ! -f ".gitignore" ]; then
    if [ -f "$GITIGNORE_TEMPLATE" ]; then
        cp "$GITIGNORE_TEMPLATE" .gitignore
        echo "✓ .gitignore copied"
    else
        echo "⚠️  .gitignore template not found at: $GITIGNORE_TEMPLATE"
    fi
else
    echo "✓ .gitignore already exists (skipped)"
fi

# Copy .env.example (only if it doesn't exist)
if [ ! -f ".env.example" ]; then
    if [ -f "$ENV_TEMPLATE" ]; then
        cp "$ENV_TEMPLATE" .env.example
        echo "✓ .env.example copied"
    else
        echo "⚠️  .env.example template not found at: $ENV_TEMPLATE"
    fi
else
    echo "✓ .env.example already exists (skipped)"
fi

# Copy .editorconfig (only if it doesn't exist)
if [ ! -f ".editorconfig" ]; then
    if [ -f "$EDITORCONFIG_TEMPLATE" ]; then
        cp "$EDITORCONFIG_TEMPLATE" .editorconfig
        echo "✓ .editorconfig copied"
    else
        echo "⚠️  .editorconfig template not found at: $EDITORCONFIG_TEMPLATE"
    fi
else
    echo "✓ .editorconfig already exists (skipped)"
fi

# Copy .pre-commit-config.yaml (only if it doesn't exist)
if [ ! -f ".pre-commit-config.yaml" ]; then
    if [ -f "$PRECOMMIT_CONFIG_TEMPLATE" ]; then
        cp "$PRECOMMIT_CONFIG_TEMPLATE" .pre-commit-config.yaml
        echo "✓ .pre-commit-config.yaml copied"
    else
        echo "⚠️  .pre-commit-config.yaml template not found at: $PRECOMMIT_CONFIG_TEMPLATE"
    fi
else
    echo "✓ .pre-commit-config.yaml already exists (skipped)"
fi

# NEW: Copy Python templates (logging, config, constants)
echo ""
echo "Copying Python templates..."

# Copy config.py (only if it doesn't exist)
if [ ! -f "config.py" ]; then
    if [ -f "$CONFIG_TEMPLATE" ]; then
        cp "$CONFIG_TEMPLATE" config.py
        echo "✓ config.py copied (update LOCAL_TZ as needed)"
    else
        echo "⚠️  config.py template not found at: $CONFIG_TEMPLATE"
    fi
else
    echo "✓ config.py already exists (skipped)"
fi

# Copy constants.py (only if it doesn't exist)
if [ ! -f "constants.py" ]; then
    if [ -f "$CONSTANTS_TEMPLATE" ]; then
        cp "$CONSTANTS_TEMPLATE" constants.py
        echo "✓ constants.py copied"
    else
        echo "⚠️  constants.py template not found at: $CONSTANTS_TEMPLATE"
    fi
else
    echo "✓ constants.py already exists (skipped)"
fi

# Copy logging_config.py (only if it doesn't exist)
if [ ! -f "logging_config.py" ]; then
    if [ -f "$LOGGING_CONFIG_TEMPLATE" ]; then
        cp "$LOGGING_CONFIG_TEMPLATE" logging_config.py
        echo "✓ logging_config.py copied"
    else
        echo "⚠️  logging_config.py template not found at: $LOGGING_CONFIG_TEMPLATE"
    fi
else
    echo "✓ logging_config.py already exists (skipped)"
fi

# Copy audit_logging.py (only if it doesn't exist)
if [ ! -f "audit_logging.py" ]; then
    if [ -f "$AUDIT_LOGGING_TEMPLATE" ]; then
        cp "$AUDIT_LOGGING_TEMPLATE" audit_logging.py
        echo "✓ audit_logging.py copied (for future use)"
    else
        echo "⚠️  audit_logging.py template not found at: $AUDIT_LOGGING_TEMPLATE"
    fi
else
    echo "✓ audit_logging.py already exists (skipped)"
fi

# Step 8: Initialize pre-commit
echo ""
echo "Initializing pre-commit hooks..."
pre-commit install > /dev/null 2>&1
echo "✓ pre-commit hooks installed"

# Step 9: Verify git
echo ""
echo "Verifying git connection..."
git remote -v > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Git remote verified"
else
    echo "⚠️  Could not verify git remote"
fi

# Step 10: Summary
echo ""
echo "=================================================="
echo "✓ Project setup complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo "  1. Edit config.py:     Update LOCAL_TZ to your timezone"
echo "  2. Edit constants.py:  Customize logging if needed (optional)"
echo "  3. code .              Open in VS Code"
echo "  4. Select Python interpreter (Cmd + Shift + P → Python: Select Interpreter)"
echo "  5. Save as workspace   (File → Save Workspace As)"
echo ""
echo "Your .venv is activated in this terminal."
echo "Type 'deactivate' to exit when done."
echo ""