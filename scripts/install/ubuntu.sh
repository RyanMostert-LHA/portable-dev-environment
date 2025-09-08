#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# --- Installation Functions ---

install_essentials() {
    log_info "Installing essential packages..."
    (sudo apt-get update && sudo apt-get install -y \
        curl wget git vim nano unzip htop build-essential \
        software-properties-common apt-transport-https ca-certificates \
        gnupg lsb-release) &
    show_progress $!
    wait $!
    if [ $? -ne 0 ]; then
        log_error "Failed to install essential packages."
        exit 1
    fi
}

install_docker() {
    log_info "Installing Docker..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    if [ $? -ne 0 ]; then
        log_error "Failed to install Docker."
        exit 1
    fi
    sudo usermod -aG docker $USER
    log_info "Docker installed successfully. Please log out and back in for group changes to take effect."
}

install_node() {
    log_info "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    if [ $? -ne 0 ]; then
        log_error "Failed to install Node.js."
        exit 1
    fi
    check_command node
    log_info "Node.js installed successfully."
}

install_python() {
    log_info "Installing Python 3.11..."
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt-get update
    sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
    if [ $? -ne 0 ]; then
        log_error "Failed to install Python 3.11."
        exit 1
    fi
    check_command python3.11
    log_info "Python 3.11 installed successfully."
}

# --- Main Function ---
main() {
    log_info "Starting Ubuntu setup..."
    check_network
    
    install_essentials
    install_docker
    install_node
    install_python

    log_info "Installing global Node.js packages..."
    npm install -g --prefix /usr/local
    
    log_info "Installing Python packages..."
    python3.11 -m pip install --user -r requirements.txt

    log_info "Ubuntu setup complete!"
}

main
