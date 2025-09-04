# Portable Development Environment 🚀

This repository contains everything you need to replicate a complete coding setup on any machine - either as a **Windows installer** or a **Docker container**.

## 🐳 Docker Setup (Recommended - Works on Any OS!)

### Quick Start
```bash
docker run -d -p 8080:8080 --name dev-env ryanmostert/portable-dev-environment:latest
```
Then open **http://localhost:8080** for VS Code in your browser!

### With Your Projects
```bash
docker run -d -p 8080:8080 \
  -v /path/to/your/projects:/home/developer/workspace/projects \
  --name dev-env ryanmostert/portable-dev-environment:latest
```

### Using Docker Compose (Best for Development)
```bash
git clone https://github.com/RyanMostert/portable-dev-environment.git
cd portable-dev-environment
docker-compose up -d
```
Access VS Code at: **http://localhost:8080**

## 💻 Windows Native Setup

### Option 1: Clone & Install
```bash
git clone https://github.com/RyanMostert/portable-dev-environment.git E:\devEnv
cd E:\devEnv
# Run as Administrator:
.\install-dev-environment.ps1
```

### Option 2: Manual Setup
1. **Copy this entire `devEnv` folder** to your E: drive  
2. **Run as Administrator**: Right-click PowerShell → "Run as Administrator"
3. **Execute the installer**: `.\install-dev-environment.ps1`
4. **Configure Git**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### Daily Usage
- **Quick access**: Run `setup-dev-env.bat`
- **Open VS Code**: `code E:\devEnv`

## 🛠 What's Included

### Core Tools
- **Git** (version control)
- **Node.js** (JavaScript runtime)  
- **Python 3.11** (programming language)
- **VS Code Server** (web-based IDE)

### Development Packages
- **Node.js**: TypeScript, ESLint, Prettier, Nodemon
- **Python**: OpenAI, Black, Flake8, MyPy, Pytest, Jupyter

### VS Code Extensions
- Python support with Pylance
- TypeScript support  
- Prettier (code formatting)
- ESLint (code linting)
- Tailwind CSS support

## 🌟 Why Use This?

- ✅ **Cross-platform**: Works on Windows, Mac, Linux via Docker
- ✅ **Consistent**: Same environment everywhere
- ✅ **Fast setup**: One command to get started
- ✅ **Web-based IDE**: Access from any browser
- ✅ **Portable**: Bring your dev environment anywhere

## 📁 Repository Structure
```
portable-dev-environment/
├── Dockerfile                      # Docker image definition
├── docker-compose.yml             # Easy Docker setup
├── install-dev-environment.ps1    # Windows installer
├── setup-dev-env.bat             # Quick Windows access
└── README.md                      # This file
```

Happy coding! 🎯