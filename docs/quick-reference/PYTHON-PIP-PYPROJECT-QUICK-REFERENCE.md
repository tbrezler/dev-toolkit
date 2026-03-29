# Python/pip/pyproject.toml Quick Reference

Managing Python environments, dependencies, and project configuration.

## Virtual Environment Setup

### Using pyenv + .venv (your workflow)

**Set Python version for the project:**
```bash
pyenv local 3.12.12
# Creates .python-version file (commit this)
```

**Create virtual environment:**
```bash
python -m venv .venv
activate              # Your alias (equivalent to: source .venv/bin/activate)
```

**Switching between projects:**
```bash
cd project1
# .python-version automatically switches Python version
activate              # Your zshrc alias

cd ../project2
# Different .python-version loads different Python
activate              # Your zshrc alias
```

**Deactivate venv:**
```bash
deactivate
```

**Your zshrc alias:**
If you haven't set it up yet, add this to your `.zshrc`:
```bash
alias activate='source .venv/bin/activate'
```

## pip Commands

### Installing Your Project (for development)

```bash
pip install -e .
# Installs your project in editable mode
# Changes you make to code are immediately available
# Good for development
```

### Installing with Dev Dependencies

```bash
pip install -e ".[dev]"
# Installs your project + dev dependencies (pytest, ruff, etc.)
# Use this when setting up a project
```

### Installing Production Only

```bash
pip install .
# Installs just your project (no dev dependencies)
# Use this for production deployments
```

### Adding a New Package

```bash
# Install it
pip install package-name

# Then manually add to pyproject.toml:
# In [project] dependencies section:
dependencies = [
    "requests>=2.25.0",
    "new-package>=1.0.0",  # Add here
]

# For dev-only packages, add to [project.optional-dependencies] dev:
[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "new-dev-package>=1.0.0",  # Add here
]
```

### Updating a Package

```bash
pip install --upgrade package-name
# or
pip install -U package-name

# Then update the version in pyproject.toml
```

### Listing Installed Packages

```bash
pip list
pip show package-name    # Details about a specific package
```

### Reinstalling Dependencies (useful after switching branches)

```bash
pip install -e ".[dev]" --force-reinstall
```

## pyproject.toml Structure

### Minimal Example

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "project-name"
dynamic = ["version"]
description = "What your project does"
requires-python = ">=3.12"
dependencies = [
    "requests>=2.25.0",
    "pandas>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "ruff",
]

[tool.hatch.version]
path = "src/project_name/__init__.py"
```

### Each Section Explained

**[build-system]**
```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
# How your project gets built for distribution
```

**[project]**
```toml
[project]
name = "project-name"              # Package name (used on PyPI)
dynamic = ["version"]              # Version loaded from elsewhere
description = "Description"        # Short description
requires-python = ">=3.12"         # Minimum Python version
dependencies = [...]               # Core dependencies (always installed)

[project.optional-dependencies]
dev = [...]                        # Dev dependencies (optional, installed with [dev])
test = [...]                       # Test dependencies (optional, if you have them)
```

**[tool.hatch.version]**
```toml
[tool.hatch.version]
path = "src/project_name/__init__.py"
# Tells hatch where to read version from
# Your __init__.py should have: __version__ = "0.1.0"
```

## Version Syntax

### Version Constraints (use these)

```toml
"package>=1.0.0"        # At least 1.0.0, any newer
"package==1.0.0"        # Exactly 1.0.0 (restrictive)
"package>=1.0.0,<2.0"   # Between 1.0.0 and 2.0 (recommended)
"package~=1.4.2"        # Compatible release (~= 1.4.2 means >=1.4.2, <1.5)
"package[extra]"        # Package with optional extra dependencies
```

### What You Probably Want

```toml
dependencies = [
    "requests>=2.25.0",     # Use >= for flexible versions
    "pandas>=2.0.0",
]
```

This lets newer minor/patch versions in automatically (good for bug fixes).

## Common Workflows

### Setting Up a New Project

**Quick way (automated):**
```bash
git clone <repo>
cd project
~/dev-toolkit/scripts/setup/setup-new-project.sh $(pwd)
```
The script handles all of this automatically (see SETUP-NEW-PROJECT.md).

**Manual way:**
```bash
git clone <repo>
cd project

pyenv local 3.12.12
python -m venv .venv
activate                    # Your zshrc alias
pip install -e ".[dev]"
```

### Adding a Development Dependency

```bash
# Install it
pip install pytest-cov

# Add to pyproject.toml
[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0.0",  # Add here
]

# Reinstall to make sure it's available
pip install -e ".[dev]"
```

### Checking What's Installed

```bash
pip list                # Everything installed
pip show requests       # Details about specific package
pip freeze              # Full dependency tree (useful for debugging)
```

### Upgrading All Packages

```bash
# To see what would be upgraded
pip list --outdated

# Upgrade specific package
pip install --upgrade package-name

# Update pyproject.toml with new version
```

## .python-version File

**What it is:**
```
3.12.12
```

Just a version number. `pyenv` automatically uses this version when you `cd` into the project.

**Benefits:**
- Ensures everyone working on the project uses the same Python
- Commit `.python-version` to Git
- New team members automatically get the right Python

**How pyenv uses it:**
```bash
cd project-with-3.12.12
python --version           # Shows 3.12.12
cd ../other-project-with-3.11.5
python --version           # Shows 3.11.5 (automatically switched)
```

## Shared Credentials Across Projects

If you use the same credentials across multiple projects (e.g., Quickbase token, MIT Warehouse credentials), store them in your shell profile instead of duplicating in each `.env`.

### Setup (One time)

Add shared credentials to your `~/.zshrc`:

```bash
# ~/.zshrc
export QUICKBASE_TOKEN="your_token_from_bitwarden"
export MIT_WAREHOUSE_USER="your_username"
export MIT_WAREHOUSE_PASSWORD="your_password"
```

Reload your shell:
```bash
source ~/.zshrc
```

### Use in Projects

In each project's `.env.example`:
```env
# Shared credentials (from ~/.zshrc)
QUICKBASE_TOKEN=${QUICKBASE_TOKEN}
MIT_WAREHOUSE_USER=${MIT_WAREHOUSE_USER}
MIT_WAREHOUSE_PASSWORD=${MIT_WAREHOUSE_PASSWORD}

# Project-specific values
PROJECT_API_KEY=your_api_key
DB_HOST=localhost
```

In each project's `.env`:
```env
# These source from ~/.zshrc automatically
QUICKBASE_TOKEN=${QUICKBASE_TOKEN}
MIT_WAREHOUSE_USER=${MIT_WAREHOUSE_USER}
MIT_WAREHOUSE_PASSWORD=${MIT_WAREHOUSE_PASSWORD}

# Add project-specific values
PROJECT_API_KEY=actual_key
DB_HOST=actual_host
```

### VS Code Integration

When you activate your venv in VS Code, these environment variables are automatically available:

```bash
activate  # Your alias
# Now $QUICKBASE_TOKEN, $MIT_WAREHOUSE_USER, etc. are all available
```

Python can access them:
```python
import os
quickbase_token = os.getenv('QUICKBASE_TOKEN')
```

### BitWarden Integration

Keep your credentials in BitWarden, then:
1. Copy credential from BitWarden
2. Paste into `~/.zshrc` (keep this file private, don't commit to git)
3. Source your shell profile: `source ~/.zshrc`
4. Credentials available everywhere

**Security note:** Never commit `.zshrc` with credentials to git. Keep it local only.

## Troubleshooting

### "ModuleNotFoundError" when running code

```bash
# Check if venv is activated
which python            # Should show .venv/bin/python

# If not, activate it
source .venv/bin/activate

# Reinstall dependencies
pip install -e ".[dev]"
```

### "pytest: command not found"

```bash
# You installed with pip install -e . instead of pip install -e ".[dev]"
pip install -e ".[dev]"
```

### Package conflicts or weird dependency issues

```bash
# Reinstall from scratch
pip uninstall -r <(pip freeze) -y   # Remove everything
pip install -e ".[dev]"              # Start fresh
```

### "ImportError: No module named 'package'"

```bash
# Make sure you're using the right venv
which python

# Check if package is installed
pip show package-name

# If not installed:
pip install package-name
```

## Things to Remember

- **Always use `pip install -e ".[dev]"`** when setting up a project (note the [dev])
- **Update pyproject.toml manually** – pip doesn't do it automatically
- **Use >= for versions** – allows flexibility for bug fixes
- **Commit .python-version and pyproject.toml** – ensures reproducibility
- **Don't commit .venv** – it's in .gitignore
- **Check which python** when things go wrong – you might have the wrong venv activated