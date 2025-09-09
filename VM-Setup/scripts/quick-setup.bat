@echo off
REM Quick VM Setup Launcher
REM This script provides an easy way to launch the VM setup

echo ========================================
echo   VM Setup for Development Environment
echo ========================================
echo.
echo This will create a VM optimized for Docker development
echo.
echo Requirements:
echo - Windows 10/11 Pro, Enterprise, or Education
echo - Hyper-V support
echo - At least 8GB RAM (4GB will be allocated to VM)
echo - At least 60GB free disk space
echo.

set /p continue=Continue with VM setup? (y/n): 
if /i "%continue%" neq "y" (
    echo Setup cancelled.
    pause
    exit /b
)

echo.
echo Starting VM setup...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator!
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

REM Run the PowerShell setup script
powershell -ExecutionPolicy Bypass -File "%~dp0setup-vm.ps1"

echo.
echo VM setup process completed!
pause