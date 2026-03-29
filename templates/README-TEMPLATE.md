# Project Name

Brief description of what this project does.

## Overview

More detailed overview. What problem does it solve? Who uses it? Any important context.

## Getting Started

### Prerequisites

- Python 3.12.12
- [Other requirements if applicable]

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/your-username/project-name.git
   cd project-name
   ```

2. Run the setup script
   ```bash
   ~/dev-toolkit/scripts/setup/setup-new-project.sh $(pwd)
   ```

3. Configure environment variables
   ```bash
   cp .env.example .env
   # Edit .env with your actual credentials
   ```

4. Verify setup
   ```bash
   which python  # should point to ./.venv/bin/python
   ```

## Usage

### Running the Application

[How to run the main application/script]

### Examples

[Code examples or common use cases]

## Development

### Project Structure

```
project-name/
├── src/
│   └── [module name]/
├── tests/
├── docs/
└── pyproject.toml
```

### Running Tests

```bash
pytest
pytest -v  # verbose
pytest --cov  # with coverage
```

### Code Quality

This project uses:
- **Black** – code formatting
- **Ruff** – linting
- **mypy** – type checking
- **pre-commit** – automated checks on commit

Pre-commit hooks run automatically on `git commit`. To run manually:
```bash
pre-commit run --all-files
```

## Deployment

[Deployment instructions specific to this project, if applicable]

## Contributing

[Guidelines for contributing, if this is collaborative]

## Troubleshooting

### Common Issues

**Issue:** pytest: command not found
- **Solution:** Make sure you installed with `pip install -e ".[dev]"` (note the [dev])

**Issue:** ModuleNotFoundError
- **Solution:** Ensure .venv is activated and dependencies are installed

## License

[License info if applicable]

## Author

[Your name/email or team info]

## Changelog

See CHANGELOG.md for version history.