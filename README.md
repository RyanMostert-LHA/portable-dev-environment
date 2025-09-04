# Portable Development Environment 🚀

This repository contains everything you need to replicate a complete coding setup on any machine - choose from **Windows installer**, **Docker container**, or **Virtual Machine** deployment options.

## 🎯 Choose Your Setup Method

| Method | Best For | Time to Setup |
|--------|----------|---------------|
| **🐳 Docker** | Cross-platform, quick start | 5 minutes |
| **💻 Windows Native** | Windows users, full integration | 15 minutes |
| **🖥️ Virtual Machine** | Isolated environment, Docker support | 30 minutes |

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

## 🤖 AI Coding Assistant Ready

The environment comes with **OpenCode** - an AI coding agent built for the terminal that's 100% open source and provider-agnostic:

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
5. **Start coding** with VS Code + OpenCode AI!

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

### For Windows Users
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
- ✅ **Docker** for containerized development
- ✅ **Git** configured and ready
- ✅ **Node.js & Python** development environments

**Start by opening a terminal and typing**: `opencode --help`

Happy coding! 🎯