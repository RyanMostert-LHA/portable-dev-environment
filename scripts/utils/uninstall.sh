#!/bin/bash

# Source common functions
source "$(dirname "$0")/../install/common.sh"

log_info "Starting uninstallation process..."

# --- Uninstall Functions ---

uninstall_docker() {
    log_info "Uninstalling Docker..."
    sudo apt-get remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm /etc/apt/sources.list.d/docker.list
}

uninstall_node() {
    log_info "Uninstalling Node.js..."
    sudo apt-get remove -y nodejs
    sudo rm -rf /usr/lib/node_modules/npm
}

uninstall_python() {
    log_info "Uninstalling Python 3.11..."
    sudo apt-get remove -y python3.11 python3.11-venv python3.11-dev
}

uninstall_essentials() {
    log_info "Uninstalling essential packages..."
    # This is a bit risky as it might remove packages needed by the system.
    # We will just remove the PPA for now.
    sudo add-apt-repository --remove ppa:deadsnakes/ppa -y
}

# --- Main Function ---
main() {
    log_warn "This script will remove the development environment."
    read -p "Are you sure you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    uninstall_docker
    uninstall_node
    uninstall_python
    uninstall_essentials

    log_info "Uninstallation complete."
}

main
