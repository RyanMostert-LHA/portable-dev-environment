# VM Setup Troubleshooting Guide

## 🚨 Common Issues and Solutions

### 1. Hyper-V Not Available

**Error:** "Hyper-V is not enabled" or "Microsoft-Hyper-V feature not found"

**Solutions:**
```powershell
# Check Windows edition
Get-ComputerInfo | Select-Object WindowsProductName

# Enable Hyper-V (requires Pro/Enterprise/Education)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All

# Alternative: Use DISM
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```

**Requirements:**
- Windows 10/11 Pro, Enterprise, or Education
- CPU with virtualization support (Intel VT-x or AMD-V)
- At least 4GB RAM
- 64-bit processor

### 2. Virtualization Not Enabled in BIOS

**Error:** VM fails to start or runs very slowly

**Solution:**
1. Restart computer and enter BIOS/UEFI
2. Look for virtualization settings:
   - Intel: "Intel VT-x", "Virtualization Technology"  
   - AMD: "AMD-V", "SVM Mode"
3. Enable the setting and save/exit BIOS

### 3. Insufficient Resources

**Error:** "Not enough memory" or system becomes unresponsive

**Solutions:**
```powershell
# Check available memory
Get-ComputerInfo | Select-Object TotalPhysicalMemory

# Reduce VM memory allocation
Set-VMMemory -VMName "DevEnv-Docker" -StartupBytes 2GB -MaximumBytes 3GB

# Check running VMs
Get-VM | Where-Object State -eq Running
```

### 4. Network Issues in VM

**Problem:** VM has no internet access

**Solutions:**

#### Check Virtual Switch:
```powershell
# List virtual switches
Get-VMSwitch

# Recreate switch if needed
Remove-VMSwitch -Name "DevEnv-Switch" -Force
New-VMSwitch -Name "DevEnv-Switch" -SwitchType Internal

# Configure NAT
New-NetIPAddress -IPAddress 192.168.100.1 -PrefixLength 24 -InterfaceAlias "vEthernet (DevEnv-Switch)"
New-NetNat -Name "DevEnv-NAT" -InternalIPInterfaceAddressPrefix 192.168.100.0/24
```

#### Inside VM (Ubuntu):
```bash
# Check network interface
ip addr show

# Configure network (if DHCP fails)
sudo netplan --debug generate
sudo netplan apply

# Test connectivity
ping 8.8.8.8
```

### 5. Docker Installation Issues

**Problem:** Docker doesn't install or start properly in Ubuntu VM

**Solutions:**

#### Remove old Docker versions:
```bash
sudo apt remove docker docker-engine docker.io containerd runc
```

#### Clean install:
```bash
# Update packages
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl enable docker
sudo systemctl start docker
```

### 6. VM Performance Issues

**Problem:** VM runs slowly or becomes unresponsive

**Solutions:**

#### Optimize VM settings:
```powershell
# Increase CPU cores (if available)
Set-VMProcessor -VMName "DevEnv-Docker" -Count 4

# Enable dynamic memory
Set-VMMemory -VMName "DevEnv-Docker" -DynamicMemoryEnabled $true

# Disable checkpoints for better performance
Set-VM -VMName "DevEnv-Docker" -CheckpointType Disabled
```

#### Inside Ubuntu VM:
```bash
# Install VM integration services
sudo apt install linux-virtual linux-cloud-tools-virtual

# Disable unnecessary services
sudo systemctl disable snapd
sudo systemctl disable bluetooth
```

### 7. ISO Download/Mount Issues

**Problem:** Ubuntu ISO not found or corrupt

**Solutions:**

#### Download Ubuntu 22.04 LTS:
- Official URL: https://ubuntu.com/download/desktop
- Verify SHA256 checksum after download
- Ensure filename is exactly: `ubuntu-22.04-desktop-amd64.iso`
- Place in: `E:\devEnv\VM-Setup\ISOs\`

#### Alternative ISOs:
```powershell
# Use different Ubuntu version
.\setup-vm.ps1 -ISOPath "E:\devEnv\VM-Setup\ISOs\ubuntu-20.04-desktop-amd64.iso"
```

### 8. Secure Boot Issues

**Problem:** Ubuntu won't boot or install

**Solutions:**
```powershell
# Try different secure boot template
Set-VMFirmware -VMName "DevEnv-Docker" -SecureBootTemplate MicrosoftUEFICertificateAuthority

# Or disable secure boot temporarily
Set-VMFirmware -VMName "DevEnv-Docker" -EnableSecureBoot Off

# Re-enable after installation
Set-VMFirmware -VMName "DevEnv-Docker" -EnableSecureBoot On
```

### 9. OpenCode AI Installation Issues

**Problem:** OpenCode AI doesn't install or work properly

**Solutions:**
```bash
# Manual installation
curl -fsSL https://opencode.ai/install | bash

# Check if installed
which opencode

# Add to PATH if needed
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Test installation
opencode --version
```

### 10. VS Code Remote Development

**Problem:** Can't connect to VM from host VS Code

**Solutions:**

#### Install Remote Development extensions:
- Remote - SSH
- Remote - Containers  
- Remote - WSL

#### Set up SSH access to VM:
```bash
# Inside VM
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Find VM IP
ip addr show
```

#### Connect from host:
```powershell
# Add VM to SSH config
# File: %USERPROFILE%\.ssh\config
Host devenv-vm
  HostName 192.168.100.10
  User your-username
  Port 22
```

### 11. Docker Compose Issues

**Problem:** Docker Compose commands fail

**Solutions:**
```bash
# Install latest Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version

# Use docker compose (new syntax) instead
docker compose up -d
```

## 🔍 Diagnostic Commands

### Check VM Status:
```powershell
Get-VM -Name "DevEnv-Docker" | Format-List
Get-VMMemory -VMName "DevEnv-Docker"
Get-VMProcessor -VMName "DevEnv-Docker"
Get-VMNetworkAdapter -VMName "DevEnv-Docker"
```

### Check Hyper-V Features:
```powershell
Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "*Hyper-V*"}
```

### Check System Resources:
```powershell
Get-ComputerInfo | Select-Object TotalPhysicalMemory, CsProcessors
Get-WmiObject -Class Win32_Processor | Select-Object Name, VirtualizationFirmwareEnabled
```

### Inside VM Diagnostics:
```bash
# System info
uname -a
cat /proc/cpuinfo | grep -E "(vmx|svm)"
free -h
df -h

# Docker status
sudo systemctl status docker
docker info
docker --version
docker-compose --version

# Network status
ip addr show
ping -c 4 8.8.8.8
```

## 📞 Getting Help

If you're still experiencing issues:

1. **Check the main repository**: https://github.com/RyanMostert/portable-dev-environment
2. **Create an issue** with:
   - Your Windows version and edition
   - Error messages (exact text)
   - Steps you've tried
   - System specifications
3. **Include diagnostic output** from the commands above

## 🛡️ Safety Tips

- **Always backup** your VMs before making changes
- **Create checkpoints** before installing new software
- **Monitor resource usage** to avoid system overload
- **Keep your VM updated** with latest security patches