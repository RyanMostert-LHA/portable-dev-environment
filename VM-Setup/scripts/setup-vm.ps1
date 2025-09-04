# VM Setup Script for Development Environment with Docker
# Run this PowerShell script as Administrator to set up a VM for Docker development

param(
    [string]$VMName = "DevEnv-Docker",
    [int]$MemoryGB = 4,
    [int]$DiskSizeGB = 50,
    [string]$ISOPath = ""
)

Write-Host "=== VM Setup for Development Environment ===" -ForegroundColor Green
Write-Host "This script will create a VM optimized for Docker development"
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Hyper-V is available
Write-Host "Checking Hyper-V availability..." -ForegroundColor Yellow
$hypervFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
if ($hypervFeature.State -ne "Enabled") {
    Write-Host "Enabling Hyper-V..." -ForegroundColor Yellow
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
    Write-Host "Hyper-V enabled. Please restart your computer and run this script again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Create VM directory
$VMPath = "E:\devEnv\VM-Setup\VMs\$VMName"
if (!(Test-Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath -Force
}

# Check for Ubuntu ISO
if ([string]::IsNullOrEmpty($ISOPath)) {
    $ISOPath = "E:\devEnv\VM-Setup\ISOs\ubuntu-22.04-desktop-amd64.iso"
    if (!(Test-Path $ISOPath)) {
        Write-Host "Ubuntu ISO not found at: $ISOPath" -ForegroundColor Red
        Write-Host "Please download Ubuntu 22.04 LTS Desktop ISO from:" -ForegroundColor Yellow
        Write-Host "https://ubuntu.com/download/desktop" -ForegroundColor Cyan
        Write-Host "And place it at: $ISOPath" -ForegroundColor Yellow
        
        # Create ISOs directory
        $ISODir = Split-Path $ISOPath
        if (!(Test-Path $ISODir)) {
            New-Item -ItemType Directory -Path $ISODir -Force
        }
        
        Read-Host "Press Enter after downloading the ISO"
        if (!(Test-Path $ISOPath)) {
            Write-Host "ISO still not found. Exiting." -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host "Creating VM: $VMName" -ForegroundColor Yellow
Write-Host "Memory: $MemoryGB GB" -ForegroundColor Yellow
Write-Host "Disk: $DiskSizeGB GB" -ForegroundColor Yellow
Write-Host "Location: $VMPath" -ForegroundColor Yellow
Write-Host ""

# Create the VM
try {
    # Create VM
    New-VM -Name $VMName -Path $VMPath -MemoryStartupBytes ($MemoryGB * 1GB) -Generation 2
    
    # Create and attach VHD
    $VHDPath = "$VMPath\$VMName\Virtual Hard Disks\$VMName.vhdx"
    New-VHD -Path $VHDPath -SizeBytes ($DiskSizeGB * 1GB) -Dynamic
    Add-VMHardDiskDrive -VMName $VMName -Path $VHDPath
    
    # Configure VM settings
    Set-VMProcessor -VMName $VMName -Count 2
    Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes (2GB) -MaximumBytes ($MemoryGB * 1GB)
    
    # Enable nested virtualization for Docker
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
    
    # Add DVD drive and mount ISO
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
    
    # Set boot order (DVD first)
    $dvd = Get-VMDvdDrive -VMName $VMName
    $hdd = Get-VMHardDiskDrive -VMName $VMName
    Set-VMFirmware -VMName $VMName -BootOrder $dvd, $hdd
    
    # Enable secure boot for Ubuntu
    Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftUEFICertificateAuthority
    
    # Create and configure network switch if needed
    $switchName = "DevEnv-Switch"
    $switch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue
    if (!$switch) {
        Write-Host "Creating virtual network switch..." -ForegroundColor Yellow
        New-VMSwitch -Name $switchName -SwitchType Internal
        
        # Get the network adapter and configure NAT
        $adapter = Get-NetAdapter -Name "vEthernet ($switchName)"
        New-NetIPAddress -IPAddress 192.168.100.1 -PrefixLength 24 -InterfaceIndex $adapter.InterfaceIndex
        New-NetNat -Name "DevEnv-NAT" -InternalIPInterfaceAddressPrefix 192.168.100.0/24
    }
    
    # Connect VM to switch
    Connect-VMNetworkAdapter -VMName $VMName -SwitchName $switchName
    
    Write-Host ""
    Write-Host "=== VM Created Successfully! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "VM Name: $VMName" -ForegroundColor Cyan
    Write-Host "Memory: $MemoryGB GB (Dynamic)" -ForegroundColor Cyan
    Write-Host "Disk: $DiskSizeGB GB" -ForegroundColor Cyan
    Write-Host "Location: $VMPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Start the VM: Start-VM -Name '$VMName'" -ForegroundColor White
    Write-Host "2. Connect to VM: vmconnect localhost '$VMName'" -ForegroundColor White
    Write-Host "3. Install Ubuntu (follow the installation wizard)" -ForegroundColor White
    Write-Host "4. After Ubuntu installation, run the post-install script" -ForegroundColor White
    Write-Host ""
    Write-Host "Starting VM now..." -ForegroundColor Yellow
    Start-VM -Name $VMName
    
    Write-Host "Opening VM connection..." -ForegroundColor Yellow
    vmconnect localhost $VMName
    
} catch {
    Write-Host "Error creating VM: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}