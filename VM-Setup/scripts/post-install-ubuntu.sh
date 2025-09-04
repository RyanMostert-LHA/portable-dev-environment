#!/bin/bash
# Post-installation script for Ubuntu VM
# Run this inside the Ubuntu VM after installation

set -e

echo "=== Post-Installation Setup for Development VM ==="
echo "This script will install Docker, development tools, and configure the environment"
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "🔧 Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    unzip \
    htop \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Docker
echo "🐳 Installing Docker..."
# Remove old versions
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose (standalone)
echo "🐙 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Node.js (LTS)
echo "📗 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install Python 3.11
echo "🐍 Installing Python 3.11..."
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3.11-dev

# Install pip for Python 3.11 manually (python3.11-pip not available)
echo "🐍 Installing pip for Python 3.11..."
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11

# Add ~/.local/bin to PATH for pip
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Set python3.11 as alternative
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Install global Node.js packages
echo "📦 Installing Node.js packages..."
sudo npm install -g \
    typescript \
    ts-node \
    nodemon \
    eslint \
    prettier \
    @types/node

# Install Python packages (using python3.11 explicitly)
echo "🐍 Installing Python packages..."
python3.11 -m pip install --user \
    openai \
    black \
    flake8 \
    mypy \
    pytest \
    jupyter \
    requests \
    python-dotenv

# Install VS Code
echo "💻 Installing VS Code..."
# Use snap instead of apt repository (easier and more reliable)
sudo snap install code --classic

# Install VS Code extensions
echo "🔌 Installing VS Code extensions..."
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension bradlc.vscode-tailwindcss
code --install-extension ms-vscode-remote.remote-containers

# Install OpenCode AI
echo "🤖 Installing OpenCode AI..."
curl -fsSL https://opencode.ai/install | bash

# Ensure OpenCode is in PATH (reload bashrc)
echo "🔄 Reloading shell configuration..."
source ~/.bashrc

# Configure Git
echo "📝 Configuring Git..."
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email
git config --global user.name "$git_username"
git config --global user.email "$git_email"
git config --global init.defaultBranch main

# Enable Docker service
echo "🔧 Configuring Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Create development directories
echo "📁 Creating development directories..."
mkdir -p ~/Development/{Projects,Scripts,Learning}

# Clone the portable dev environment repo
echo "📥 Cloning portable development environment..."
cd ~/Development/Projects
git clone https://github.com/RyanMostert/portable-dev-environment.git

# Create desktop shortcut for VS Code
echo "🖥️ Creating desktop shortcuts..."
cat > ~/Desktop/VS-Code.desktop << EOF
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=code
Icon=code
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=code --new-window
Icon=code
EOF

chmod +x ~/Desktop/VS-Code.desktop

# Create test script
cat > ~/Desktop/test-docker.sh << 'EOF'
#!/bin/bash
echo "🐳 Testing Docker installation..."
docker --version
docker-compose --version
echo ""
echo "🧪 Running Docker hello-world test..."
docker run hello-world
echo ""
echo "✅ Docker is working! You can now run:"
echo "   cd ~/Development/Projects/portable-dev-environment"
echo "   docker-compose up -d"
echo "   # Then open browser to http://localhost:8080"
EOF

chmod +x ~/Desktop/test-docker.sh

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "✅ Docker installed and configured"
echo "✅ Development tools installed (Node.js, Python, VS Code)"
echo "✅ VS Code extensions installed"
echo "✅ OpenCode AI installed"
echo "✅ Git configured"
echo "✅ Development directories created"
echo "✅ Portable dev environment cloned"
echo ""
echo "🔄 Please log out and log back in (or restart) for Docker group changes to take effect"
echo ""
echo "📝 Next steps:"
echo "1. Restart the VM or log out/in"
echo "2. Run: ~/Desktop/test-docker.sh"
echo "3. Navigate to: ~/Development/Projects/portable-dev-environment"
echo "4. Run: docker-compose up -d"
echo "5. Open browser to: http://localhost:8080"
echo ""
echo "🎉 Happy coding!"