# Portable Development Environment 🚀

This repository contains everything you need to replicate a complete coding setup on any machine - choose from **Docker**, **WSL**, **Windows installer**, or **Virtual Machine** deployment options.

## 🚀 Installation

This repository now uses a unified installation script. To set up the environment, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/RyanMostert/portable-dev-environment.git
    cd portable-dev-environment
    ```

2.  **Run the installer:**
    ```bash
    bash scripts/install/install.sh
    ```

The script will detect your operating system and guide you through the installation process.

## ⚙️ Configuration

Before you start, you need to configure your environment.

1.  **Create a `.env` file** by copying the example file:
    ```bash
    cp .env.example .env
    ```
2.  **Edit the `.env` file** and fill in the required values for `AI_CHAT_API_KEY`, `DEV_REPO_PATH`, etc.

This file is ignored by Git, so your secrets are safe.



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

## 🐧 WSL Setup (Recommended for Windows)

Follow these steps to set up the environment in any WSL (Windows Subsystem for Linux) distribution.

### Step 1: Open Your WSL Terminal

First, open your WSL terminal on Windows. If you don't have WSL installed, run this command in an **Administrator** PowerShell and follow the prompts:
```powershell
wsl --install
```

### Step 2: Clone the Repository

Clone your repository from GitHub into your WSL home directory.

```bash
git clone https://github.com/RyanMostert/portable-dev-environment.git
```

### Step 3: Navigate to the Project Directory

Change into the newly created directory.

```bash
cd portable-dev-environment
```

### Step 4: Configure Your Environment

Create your personal environment configuration file by copying the example file.

```bash
cp .env.example .env
```

Now, edit the `.env` file with your favorite text editor (like `nano` or `vim`) and fill in the required values. **Important:** Use Linux-style paths (e.g., `/home/user/projects`).

```bash
nano .env
```

### Step 5: Run the Installer

Execute the main installation script. It will automatically detect that you are on Linux and run the correct setup. The script will likely ask for your `sudo` password to install system-wide packages.

```bash
bash scripts/install/install.sh
```

### Step 6: Restart WSL

After the installation is complete, you **must restart your WSL instance** for the Docker permissions to take effect. Close the WSL terminal and run the following command in Windows PowerShell or Command Prompt:

```powershell
wsl --shutdown
```

Then, simply reopen your WSL terminal.

### Step 7: Verify the Installation

Once you've restarted WSL, navigate back to the project directory and run the health check script to ensure everything was installed correctly.

```bash
cd portable-dev-environment
bash scripts/utils/health-check.sh
```

If all checks pass, your portable development environment is ready to use inside WSL!


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
- **Neovim with AstroNvim** (advanced terminal-based editor)
- **tmux** (terminal multiplexer for session management)

### Pre-configured Settings

- **tmux**: Custom configuration with easy controls, mouse support, and developer-friendly keybindings
- **AstroNvim**: User configuration with sensible defaults, LSP settings, and enhanced workflows
- **All configurations**: Automatically applied during installation from repository templates

### Development Packages

- **Node.js**: TypeScript, ESLint, Prettier, Nodemon
- **Python**: **OpenAI SDK**, Black, Flake8, MyPy, Pytest, Jupyter, Requests

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
- ✅ **AI-Ready**: OpenCode AI coding agent pre-installed
- ✅ **Portable**: Bring your dev environment anywhere

## 🚀 AstroNvim - Supercharged Neovim

This environment includes **AstroNvim**, a feature-rich Neovim configuration that provides an IDE-like experience in the terminal.

### Features
- **LSP Support**: Language Server Protocol for intelligent code completion
- **Syntax Highlighting**: Tree-sitter powered syntax highlighting
- **File Explorer**: Built-in file manager with telescope integration
- **Git Integration**: Seamless Git operations within the editor
- **Plugin Management**: Lazy.nvim for fast plugin loading
- **Customizable**: Easily extend with your own configurations

### Quick Start with AstroNvim
```bash
# Open a file with Neovim
nvim myfile.py

# Open file explorer
# Press <Space> + e

# Search files
# Press <Space> + f + f

# Search text in files
# Press <Space> + f + w

# Git status
# Press <Space> + g + s
```

### AstroNvim Key Bindings
| Action | Keybinding |
|--------|------------|
| File Explorer | `<Space> + e` |
| Find Files | `<Space> + f + f` |
| Find Text | `<Space> + f + w` |
| Git Status | `<Space> + g + s` |
| Terminal | `<Space> + t + f` |
| Command Palette | `<Space> + f + c` |

📖 **Complete Guide**: See [docs/astronvim-setup.md](docs/astronvim-setup.md) for detailed configuration and advanced features.

## 📟 tmux - Terminal Session Management

**tmux** is included for managing multiple terminal sessions, perfect for development workflows.

### Features
- **Session Persistence**: Keep your work sessions alive
- **Multiple Panes**: Split your terminal into multiple sections
- **Window Management**: Organize different projects in separate windows
- **Mouse Support**: Click to select panes and resize
- **Custom Configuration**: Pre-configured with developer-friendly settings

### tmux Quick Start
```bash
# Start a new tmux session
tmux

# Start a named session
tmux new-session -s mysession

# Attach to an existing session
tmux attach -t mysession

# List all sessions
tmux list-sessions
```

### tmux Key Bindings (Prefix: Ctrl-a)
| Action | Keybinding |
|--------|------------|
| Split Horizontally | `Ctrl-a + \|` |
| Split Vertically | `Ctrl-a + -` |
| Switch Panes | `Alt + Arrow Keys` |
| New Window | `Ctrl-a + c` |
| Next Window | `Ctrl-a + n` |
| Previous Window | `Ctrl-a + p` |
| Reload Config | `Ctrl-a + r` |
| Detach Session | `Ctrl-a + d` |

📖 **Complete Guide**: See [docs/tmux-guide.md](docs/tmux-guide.md) for comprehensive tmux documentation and advanced features.

### Sample Development Workflow
```bash
# 1. Start a tmux session for your project
tmux new-session -s myproject

# 2. Split into multiple panes
# Ctrl-a + | (vertical split)
# Ctrl-a + - (horizontal split)

# 3. In different panes:
# - Pane 1: Code editor (nvim)
# - Pane 2: Server/build process
# - Pane 3: Git operations
# - Pane 4: File operations

# 4. Detach when done (keeps everything running)
# Ctrl-a + d

# 5. Reattach later
tmux attach -t myproject
```

## 🤖 AI Coding Assistant Ready
 
 This environment comes with **OpenCode** - an AI coding agent built for the terminal that's 100% open source and provider-agnostic:
 
 - Works with **Anthropic Claude**, **OpenAI**, **Google**, and **local models**
 - Terminal-focused interface
 - Flexible and customizable
 
 ```bash
 # Start using OpenCode in your terminal
 opencode
 
 # Or use it with specific files
 opencode src/main.py
 
 # Configure your preferred AI provider
 opencode config
 ```
 
 Perfect for AI-assisted development right from the command line!

## 🔄 Continuous Integration & Deployment

This repository is equipped with GitHub Actions for automated CI/CD:

*   **Continuous Integration (CI)**: On every push or pull request to `main`, a workflow builds the Docker image, scans it for vulnerabilities, and runs tests.
*   **Continuous Deployment (CD)**: When changes are merged to `main`, the Docker image is automatically published to the GitHub Container Registry.

This ensures that the `latest` tag of the Docker image is always up-to-date with the latest secure and tested version of the environment.

## 🧪 Automated Testing

This repository includes a testing framework to ensure the reliability and correctness of the environment. The tests are located in the `tests/` directory and are divided into two types:

*   **Unit Tests**: These tests verify the functionality of individual scripts. They use the `shunit2` framework and can be found in `tests/unit/`.
*   **Integration Tests**: These tests verify that the entire environment works as expected. They build a test Docker image and run checks inside it. These are located in `tests/integration/`.

**To run the tests:**

```bash
# Run all unit tests
for test in tests/unit/*_test.sh; do bash "$test"; done

# Run integration tests
docker build -f tests/integration/Dockerfile.test .
```

The tests are also run automatically as part of the CI/CD pipeline.
 
 ## Enhanced AI Capabilities with MCP Servers


This environment is pre-configured with several Model-centric Communication Protocol (MCP) servers to supercharge your AI-assisted development workflow. These servers allow the OpenCode AI agent to perform a wide range of tasks automatically:

| MCP Server       | Purpose                                                                                   |
| :--------------- | :---------------------------------------------------------------------------------------- |
| **`filesystem`** | Provides access to the local filesystem for reading, writing, and modifying files.        |
| **`git`**        | Enables interaction with Git repositories for committing, pushing, and managing branches. |
| **`fetch`**      | Allows the agent to access and retrieve information from the web.                         |
| **`context7`**   | Provides up-to-date documentation for various libraries and frameworks.                   |
| **`github`**     | Interacts with the GitHub CLI to manage repositories, issues, and pull requests.          |
| **`testing`**    | Automatically runs your project's test suite to ensure code quality.                      |
| **`linter`**     | Formats code and checks for linting errors to maintain a consistent style.                |
| **`docker`**     | Manages your Docker environment, including building images and running containers.        |
| **`database`**   | Interacts with your project's database for querying data and managing schemas.            |

### Development and Production Profiles

This environment comes with two pre-configured profiles for the OpenCode AI agent:

*   `opencode.development.json`: Enables **all** MCP servers, including experimental ones. Ideal for testing new features and working on the environment itself.
*   `opencode.production.json`: Enables only the core, stable MCP servers. Optimized for performance and reliability in your daily coding tasks.

**To switch between profiles, simply copy the one you want to use to `opencode.json`:**

```bash
# To use the production profile (recommended for daily use)
cp opencode.production.json opencode.json

# To use the development profile
cp opencode.development.json opencode.json
```

The `opencode.json` file is what the OpenCode agent will load. This file is in `.gitignore`, so your choice of profile won't be committed.


## 🖥️ Virtual Machine Setup (Complete Isolation)

Perfect for running Docker in a dedicated VM with full Ubuntu desktop environment.

### Quick Start

1. **Download Ubuntu 22.04 LTS ISO**: Place at `VM-Setup/ISOs/ubuntu-22.04-desktop-amd64.iso`
2. **Run as Administrator**: `VM-Setup/scripts/quick-setup.bat`
3. **Install Ubuntu**: Follow the VM installation wizard
4. **Post-install setup**: Run the provided script inside Ubuntu VM

### What You Get

- **Ubuntu 22.04 LTS** desktop environment
- **4GB RAM**, 50GB storage with dynamic allocation
- **Docker** + Docker Compose pre-configured
- **VS Code** + development extensions
- **OpenCode AI** coding assistant
- **AstroNvim** - Advanced Neovim configuration
- **tmux** - Terminal session management
- **Network access** via NAT configuration

### Requirements

- Windows 10/11 Pro, Enterprise, or Education
- Hyper-V support enabled
- At least 8GB RAM on host
- 60GB free disk space

**📖 Complete VM Guide**: See `VM-Setup/README.md`

## 📁 Repository Structure

```
portable-dev-environment/
├── Dockerfile                      # Docker image definition
├── docker-compose.yml             # Easy Docker setup
├── install-dev-environment.ps1    # Windows installer
├── setup-dev-env.bat             # Quick Windows access
├── VM-Setup/                       # Virtual machine setup
│   ├── scripts/
│   │   ├── setup-vm.ps1           # VM creation script
│   │   ├── post-install-ubuntu.sh # Ubuntu post-install
│   │   └── quick-setup.bat        # Easy launcher
│   ├── configs/vm-specs.txt       # VM configuration
│   ├── docs/troubleshooting.md    # Common issues
│   └── README.md                  # VM setup guide
└── README.md                      # This file
```

## 🐳 **Complete Docker Guide**

### **Docker Basics**

Docker lets you run applications in isolated containers. Think of it like lightweight virtual machines.

- **Image** = Blueprint (like a recipe)
- **Container** = Running instance (like the actual meal)
- **Dockerfile** = Instructions to build an image
- **Docker Hub** = Online library of images

### **Essential Docker Commands**

#### **Working with Images**

```bash
# Download an image
docker pull ubuntu

# List downloaded images
docker images

# Build an image from Dockerfile
docker build -t my-app .

# Remove an image
docker rmi image-name
```

#### **Working with Containers**

```bash
# Run a container (creates and starts)
docker run hello-world

# List running containers
docker ps

# List all containers (running and stopped)
docker ps -a

# Stop a container
docker stop container-name

# Remove a container
docker rm container-name

# Run container in background (-d = detached)
docker run -d nginx

# Run with port mapping (host:container)
docker run -p 8080:80 nginx

# Run with volume mount (persist data)
docker run -v /host/path:/container/path nginx
```

### **Using This Development Environment**

#### **Option A: Docker Compose (Recommended)**

```bash
# Clone this repo
git clone https://github.com/RyanMostert/portable-dev-environment.git
cd portable-dev-environment

# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# View logs
docker-compose logs

# Rebuild after changes
docker-compose up -d --build
```

#### **Option B: Manual Docker Commands**

```bash
# Build the image
docker build -t my-dev-env .

# Run with port mapping and volume
docker run -d -p 8080:8080 \
  -v ./projects:/home/developer/workspace/projects \
  --name dev-container my-dev-env

# Access the running container
docker exec -it dev-container bash

# Stop and remove
docker stop dev-container && docker rm dev-container
```

### **Common Docker Flags**

```bash
-d          # Run in background (detached)
-p 8080:80  # Map ports (host:container)
-v path:path # Mount volumes (data persistence)
--name      # Give container a name
-it         # Interactive terminal
--rm        # Auto-remove when stopped
-e VAR=val  # Set environment variables
```

### **Troubleshooting**

```bash
# Check if Docker is running
docker --version

# See what's running
docker ps

# Check logs if something fails
docker logs container-name

# Clean up everything
docker system prune -a

# Remove all stopped containers
docker container prune

# Get into a running container
docker exec -it container-name bash
```

### **Quick Start Steps**

1. **Test Docker**: `docker run hello-world`
2. **Clone repo**: `git clone https://github.com/RyanMostert/portable-dev-environment.git`
3. **Start environment**: `docker-compose up -d`
4. **Open browser**: http://localhost:8080
5. **Start by opening a terminal and typing**: `opencode --help`

**Or try the new tools:**
- `nvim` - Launch AstroNvim (advanced Neovim configuration)  
- `tmux` - Start a terminal multiplexer session

**Start coding** with VS Code + OpenCode AI!

## 🚀 Getting Started Guide

### For Beginners (Docker Recommended)

```bash
# 1. Install Docker Desktop from docker.com
# 2. Clone this repository
git clone https://github.com/RyanMostert/portable-dev-environment.git
cd portable-dev-environment

# 3. Start your development environment
docker-compose up -d

# 4. Open VS Code in your browser
# Navigate to: http://localhost:8080
```

### For Windows Users (WSL Recommended)

```powershell
# 1. Install WSL2 + Ubuntu (run as Administrator)
wsl --install

# 2. Restart computer, then inside WSL:
curl -L https://raw.githubusercontent.com/RyanMostert/portable-dev-environment/main/VM-Setup/scripts/post-install-ubuntu.sh -o ~/post-install.sh
chmod +x ~/post-install.sh
./post-install.sh

# 3. Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 4. Start coding with VS Code + WSL!
code .
```

### For Windows Native Installation

```powershell
# 1. Clone to E: drive (recommended)
git clone https://github.com/RyanMostert/portable-dev-environment.git E:\devEnv
cd E:\devEnv

# 2. Run installer as Administrator
.\install-dev-environment.ps1

# 3. Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 4. Start coding!
code .
```

### For Advanced Users (VM Setup)

```batch
# 1. Download Ubuntu 22.04 LTS ISO
# 2. Place at: VM-Setup\ISOs\ubuntu-22.04-desktop-amd64.iso
# 3. Run as Administrator:
VM-Setup\scripts\quick-setup.bat

# 4. Follow Ubuntu installation
# 5. Run post-install script inside Ubuntu VM
```

## 🎉 What's Next?

After setup, you'll have:

- ✅ **VS Code** ready for development
- ✅ **OpenCode AI** for AI-assisted coding
- ✅ **AstroNvim** for advanced terminal-based editing
- ✅ **tmux** for session management and terminal multiplexing
- ✅ **Docker** for containerized development
- ✅ **Git** configured and ready
- ✅ **Node.js & Python** development environments

**Start by opening a terminal and typing**: `opencode --help`

**Or try the new tools:**
- `nvim` - Launch AstroNvim (advanced Neovim configuration)
- `tmux` - Start a terminal multiplexer session

Happy coding! 🎯
