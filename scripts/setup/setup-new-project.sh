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

# Step 1: Check if .python-version exists
if [ ! -f ".python-version" ]; then
    echo ""
    echo "⚠️  No .python-version file found"
    echo "Run this manually: pyenv local 3.12.12"
    read -p "Press enter once you've set the Python version..."
else
    PYTHON_VERSION=$(cat .python-version)
    echo "✓ Using Python version: $PYTHON_VERSION"
fi

# Step 2: Create virtual environment
echo ""
echo "Creating virtual environment..."
python -m venv .venv
echo "✓ Virtual environment created"

# Step 3: Activate and upgrade pip
echo ""
echo "Activating .venv and upgrading pip..."
source .venv/bin/activate
pip install --upgrade pip > /dev/null 2>&1
echo "✓ pip upgraded"

# Step 4: Install dependencies
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

# Step 5: Install pre-commit
echo ""
echo "Installing pre-commit..."
pip install pre-commit > /dev/null 2>&1
echo "✓ pre-commit installed"

# Step 6: Copy templates from toolkit
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

# Step 7: Initialize pre-commit
echo ""
echo "Initializing pre-commit hooks..."
pre-commit install > /dev/null 2>&1
echo "✓ pre-commit hooks installed"

# Step 8: Verify git
echo ""
echo "Verifying git connection..."
git remote -v > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Git remote verified"
else
    echo "⚠️  Could not verify git remote"
fi

# Step 9: Summary
echo ""
echo "=================================================="
echo "✓ Project setup complete!"
echo "=================================================="
echo ""
echo "Next steps:"
echo "  1. code .                    (Open in VS Code)"
echo "  2. Select Python interpreter (Cmd + Shift + P → Python: Select Interpreter)"
echo "  3. Save as workspace         (File → Save Workspace As)"
echo ""
echo "Your .venv is activated in this terminal."
echo "Type 'deactivate' to exit when done."
echo ""