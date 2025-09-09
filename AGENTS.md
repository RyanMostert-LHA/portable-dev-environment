# Agent Development Guidelines

## Tech Stack

- Bash scripts for installation/setup
- Docker for containerization
- Node.js/TypeScript (package.json present but no actual TS files)
- Python 3.11, Git, Docker as dependencies

## Build/Test Commands

- Tests: `cd tests/unit && bash <test_file>.sh` (uses shunit2 framework)
- Health check: `./scripts/utils/health-check.sh`
- Installation: `./scripts/install/install.sh`

## Code Style Guidelines

- **Shell Scripts**: Use `#!/bin/bash` shebang, source common functions via relative paths
- **Functions**: Follow naming pattern `log_info()`, `check_command()`, `show_progress()`
- **Logging**: Use consistent log levels: `log_info`, `log_warn`, `log_error` from common.sh
- **Error Handling**: Check commands with `check_command`, exit with status 1 on errors
- **Variables**: Use `$1` for parameters, local variables for function scope
- **File Structure**: Keep common utilities in scripts/install/common.sh
- **Permissions**: Scripts should be readable (644), use `bash script.sh` to execute
- **Testing**: Each module gets a corresponding `_test.sh` file using shunit2
- **Comments**: Use `# ---` for section headers, `#` for inline comments

## Project Structure

- `scripts/install/` - Installation scripts
- `scripts/utils/` - Utility scripts (health-check, uninstall)
- `tests/unit/` - Unit tests using shunit2
- `configs/` - Configuration files for tools
