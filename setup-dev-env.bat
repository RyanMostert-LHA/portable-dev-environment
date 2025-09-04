@echo off
REM Development Environment Setup Script
REM Run this to quickly access your development environment

echo Setting up development environment on E: drive...
cd /d E:\devEnv
echo.
echo Current location: %CD%
echo.
echo Available projects:
dir Projects /b 2>nul
echo.
echo Development environment ready!
echo - Use 'code .' to open VS Code in current directory
echo - Use 'cd Projects' to navigate to your projects
echo - Use 'git status' to check git repositories
echo.