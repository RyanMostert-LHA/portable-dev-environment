#!/bin/bash

# Source common functions
source "$(dirname "$0")/common.sh"

# --- Installation Functions ---

install_essentials() {
    log_info "Installing essential packages..."
    (sudo apt-get update && sudo apt-get install -y \
        curl wget git vim nano unzip htop build-essential \
        software-properties-common apt-transport-https ca-certificates \
        gnupg lsb-release tmux) &
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

install_neovim() {
    log_info "Installing Neovim..."
    # Install Neovim from the stable PPA for latest version
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt-get update
    sudo apt-get install -y neovim
    if [ $? -ne 0 ]; then
        log_error "Failed to install Neovim."
        exit 1
    fi
    check_command nvim
    log_info "Neovim installed successfully."
}

install_astronvim() {
    log_info "Installing AstroNvim..."
    # Backup existing Neovim configuration if it exists
    if [ -d "$HOME/.config/nvim" ]; then
        log_info "Backing up existing Neovim configuration..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Clone AstroNvim configuration
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
    if [ $? -ne 0 ]; then
        log_error "Failed to clone AstroNvim configuration."
        exit 1
    fi
    
    # Install additional dependencies for AstroNvim
    sudo apt-get install -y ripgrep fd-find
    
    # Create symbolic link for fdfind (required by some AstroNvim plugins)
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
    
    log_info "AstroNvim installed successfully."
    log_info "Run 'nvim' to complete the setup and install plugins."
}

configure_tmux() {
    log_info "Configuring tmux..."
    # Create a basic tmux configuration
    cat > "$HOME/.tmux.conf" << 'EOF'
# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind-key C-a send-prefix

# Enable mouse mode
set -g mouse on

# Set default terminal mode to 256color mode
set -g default-terminal "screen-256color"

# Enable vi mode
setw -g mode-keys vi

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Reload config file
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Status bar customization
set -g status-bg black
set -g status-fg white
set -g status-left '#[fg=green]#S '
set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M'
EOF
    
    log_info "tmux configuration created at ~/.tmux.conf"
}

# --- Main Function ---
main() {
    log_info "Starting Ubuntu setup..."
    check_network
    
    install_essentials
    install_docker
    install_node
    install_python
    install_neovim
    install_astronvim
    configure_tmux

    log_info "Installing global Node.js packages..."
    npm install -g --prefix /usr/local
    
    log_info "Installing Python packages..."
    python3.11 -m pip install --user -r requirements.txt

    log_info "Ubuntu setup complete!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Log out and back in for Docker group changes to take effect"
    log_info "2. Run 'nvim' to complete AstroNvim plugin installation"
    log_info "3. Start tmux with 'tmux' command"
}

main
