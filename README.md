# Development Environment Setup

This folder contains everything you need to replicate your complete coding setup on any Windows PC.

## Quick Setup on New PC

1. **Copy this entire `devEnv` folder** to the E: drive of your new PC
2. **Run as Administrator**: Right-click PowerShell → "Run as Administrator"
3. **Execute the installer**: `.\install-dev-environment.ps1`
4. **Configure Git with your info**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Daily Usage

- **Quick access**: Run `setup-dev-env.bat` to navigate to your dev environment
- **Open in VS Code**: `code E:\devEnv`
- **Your projects**: Located in `E:\devEnv\Projects\`

## Current Projects
- ai-gaming-assistant-workspace
- Docker_MCP

## What Gets Installed

### Core Tools
- Git (version control)
- Node.js (JavaScript runtime)
- Python (programming language) 
- VS Code (code editor)

### Development Packages
- **Node.js**: TypeScript, ESLint, Prettier, Nodemon
- **Python**: OpenAI, Black, Flake8, MyPy, Pytest, Jupyter

### VS Code Extensions
- Python support with Pylance
- TypeScript support
- Prettier (code formatting)
- ESLint (code linting)
- Tailwind CSS support

Happy coding! 🚀