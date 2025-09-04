# Complete Development Environment Setup Script
# Run this PowerShell script as Administrator on any Windows PC
# Usage: Run PowerShell as Administrator, then: .\install-dev-environment.ps1

Write-Host "=== Development Environment Installer ===" -ForegroundColor Green
Write-Host "This script will install and configure a complete coding environment"
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Install Chocolatey (package manager for Windows)
Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install essential development tools
Write-Host "Installing essential development tools..." -ForegroundColor Yellow
choco install -y git nodejs python vscode

# Install global Node.js packages
Write-Host "Installing Node.js development packages..." -ForegroundColor Yellow
npm install -g typescript ts-node nodemon eslint prettier

# Install Python packages
Write-Host "Installing Python development packages..." -ForegroundColor Yellow
pip install openai black flake8 mypy pytest jupyter

# Install VS Code extensions
Write-Host "Installing VS Code extensions..." -ForegroundColor Yellow
code --install-extension ms-python.python
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension bradlc.vscode-tailwindcss

# Create development directory structure
Write-Host "Creating development directory structure..." -ForegroundColor Yellow
$devPath = "E:\devEnv"
if (!(Test-Path $devPath\Scripts)) {
    New-Item -ItemType Directory -Path "$devPath\Scripts" -Force
}
if (!(Test-Path $devPath\Learning)) {
    New-Item -ItemType Directory -Path "$devPath\Learning" -Force
}

# Configure Git
Write-Host "Configuring Git..." -ForegroundColor Yellow
Write-Host "Remember to run these commands with your information:"
Write-Host "git config --global user.name 'Your Name'"
Write-Host "git config --global user.email 'your.email@example.com'"
git config --global init.defaultBranch main

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Your development environment is ready at E:\devEnv" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Configure Git with your name and email (see above)"
Write-Host "2. Run E:\devEnv\setup-dev-env.bat to quickly access your dev environment"
Write-Host "3. Use 'code E:\devEnv' to open VS Code in your development folder"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green