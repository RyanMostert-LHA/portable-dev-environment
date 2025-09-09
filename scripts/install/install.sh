#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

log_info "Starting the installation process..."

# Detect OS and run the appropriate installer
case "$(uname -s)" in
    Linux*)
        log_info "Linux detected. Running Linux installer..."
        ./scripts/install/ubuntu.sh
        ;;
    Darwin*)
        log_info "macOS detected. Running macOS installer..."
        # ./scripts/install/macos.sh # Placeholder for now
        log_warn "macOS installer is not yet implemented."
        ;;
    CYGWIN*|MINGW*|MSYS*)
        log_info "Windows detected. Running Windows installer..."
        # powershell.exe -File scripts/install/windows.ps1 # Placeholder for now
        log_warn "Windows installer should be run directly."
        ;;
    *)
        log_error "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac

log_info "Installation process finished."
