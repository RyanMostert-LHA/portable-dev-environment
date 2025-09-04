# VM Setup for Docker Development Environment

This directory contains everything you need to set up a virtual machine optimized for Docker development on Windows using Hyper-V.

## 🖥️ Prerequisites

- **Windows 10/11 Pro, Enterprise, or Education** (Hyper-V required)
- **At least 8GB RAM** (4GB will be allocated to VM)
- **At least 60GB free disk space**
- **Administrator privileges**

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)
```batch
# Run as Administrator
E:\devEnv\VM-Setup\scripts\quick-setup.bat
```

### Option 2: Manual PowerShell Setup
```powershell
# Run PowerShell as Administrator
cd E:\devEnv\VM-Setup\scripts
.\setup-vm.ps1
```

## 📋 What the Setup Does

### 1. **VM Creation**
- Creates a Hyper-V VM with 4GB RAM (dynamic)
- 50GB virtual hard disk
- 2 CPU cores with nested virtualization enabled
- Ubuntu 22.04 LTS ready to install

### 2. **Network Configuration**
- Creates internal virtual switch
- Sets up NAT for internet access
- Configures network adapter

### 3. **VM Optimization**
- Enables nested virtualization for Docker
- Configures secure boot for Ubuntu
- Sets up dynamic memory allocation

## 📁 Directory Structure

```
VM-Setup/
├── scripts/
│   ├── setup-vm.ps1           # Main VM creation script
│   ├── post-install-ubuntu.sh # Ubuntu post-install script
│   └── quick-setup.bat        # Quick launcher
├── configs/
│   └── vm-specs.txt           # VM configuration specs
├── docs/
│   └── troubleshooting.md     # Common issues and solutions
├── ISOs/                      # Place Ubuntu ISO here
└── VMs/                       # Created VMs will be stored here
```

## 📝 Step-by-Step Instructions

### Step 1: Download Ubuntu ISO
1. Download Ubuntu 22.04 LTS Desktop from: https://ubuntu.com/download/desktop
2. Place the ISO file at: `E:\devEnv\VM-Setup\ISOs\ubuntu-22.04-desktop-amd64.iso`

### Step 2: Run VM Setup
1. **Right-click Command Prompt → "Run as administrator"**
2. Navigate to: `E:\devEnv\VM-Setup\scripts`
3. Run: `quick-setup.bat`
4. Follow the prompts

### Step 3: Install Ubuntu
1. VM will start automatically
2. Follow Ubuntu installation wizard
3. Choose "Minimal installation" for faster setup
4. Create your user account

### Step 4: Post-Installation Setup
1. Inside the Ubuntu VM, open Terminal
2. Copy the post-install script:
   ```bash
   curl -L https://raw.githubusercontent.com/RyanMostert/portable-dev-environment/main/VM-Setup/scripts/post-install-ubuntu.sh -o ~/post-install.sh
   chmod +x ~/post-install.sh
   ./post-install.sh
   ```

### Step 5: Test Docker Environment
1. Restart the VM after post-install script
2. Run: `~/Desktop/test-docker.sh`
3. Navigate to: `~/Development/Projects/portable-dev-environment`
4. Run: `docker-compose up -d`
5. Open browser to: `http://localhost:8080`

## ⚙️ VM Specifications

| Component | Specification |
|-----------|---------------|
| **OS** | Ubuntu 22.04 LTS Desktop |
| **Memory** | 4GB (Dynamic: 2GB min, 4GB max) |
| **Storage** | 50GB (Dynamic VHD) |
| **CPU** | 2 cores with nested virtualization |
| **Network** | NAT with internal switch |
| **Generation** | Gen 2 with Secure Boot |

## 🛠️ Installed Software

The post-install script installs:
- **Docker CE** + Docker Compose
- **Node.js LTS** + TypeScript, ESLint, Prettier
- **Python 3.11** + development packages
- **VS Code** + essential extensions  
- **OpenCode AI** coding assistant
- **Git** with configuration
- **Development tools** (curl, wget, vim, etc.)

## 🔧 VM Management Commands

```powershell
# Start VM
Start-VM -Name "DevEnv-Docker"

# Stop VM  
Stop-VM -Name "DevEnv-Docker"

# Connect to VM
vmconnect localhost "DevEnv-Docker"

# View VM info
Get-VM -Name "DevEnv-Docker"

# Remove VM (if needed)
Remove-VM -Name "DevEnv-Docker" -Force
Remove-Item "E:\devEnv\VM-Setup\VMs\DevEnv-Docker" -Recurse -Force
```

## 🌐 Network Access

The VM will have internet access through NAT. To access services running in the VM from your host:

1. **Find VM's IP address** (inside VM):
   ```bash
   ip addr show
   ```

2. **Access from host browser**:
   - Replace `localhost` with VM's IP address
   - Example: `http://192.168.100.10:8080`

## 💡 Tips & Best Practices

1. **Allocate enough resources**: Ensure your host has at least 8GB RAM
2. **Use snapshots**: Create VM snapshots before major changes
3. **Shared folders**: Use VS Code Remote Development for seamless development
4. **Performance**: Close unused applications on host while VM is running
5. **Backup**: Regularly backup your VM or export important projects

## 🆘 Troubleshooting

### Common Issues:

**Hyper-V not available:**
```powershell
# Enable Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
# Restart required
```

**VM won't start:**
- Check if virtualization is enabled in BIOS
- Ensure sufficient RAM is available
- Try disabling other virtualization software

**No internet in VM:**
- Check if NAT is configured correctly
- Restart the virtual switch
- Verify Windows firewall settings

**Docker not working:**
- Ensure nested virtualization is enabled
- Check if user is in docker group: `groups $USER`
- Restart Docker service: `sudo systemctl restart docker`

## 🎯 Next Steps

After successful setup:

1. **Clone your repositories** into `~/Development/Projects/`
2. **Configure VS Code** with your preferred settings
3. **Set up OpenCode AI** with your preferred AI provider
4. **Create snapshots** of your configured VM for backup
5. **Start developing** with your portable Docker environment!

Happy coding! 🚀