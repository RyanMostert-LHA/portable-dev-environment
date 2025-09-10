#!/bin/bash

# Enhanced Ubuntu Installation Script
# Part of the Portable Development Environment
# Improved with better error handling and optional components

# Fix line endings if needed and source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Fix line endings if needed
fix_line_endings_if_needed

# --- Configuration Variables ---
INSTALL_DOCKER=${INSTALL_DOCKER:-false}
SKIP_DOCKER_PROMPT=${SKIP_DOCKER_PROMPT:-false}

# --- Pre-installation Checks ---
pre_install_checks() {
    log_info "Performing pre-installation checks..."
    
    # Check OS compatibility
    if ! check_os; then
        log_warn "Proceeding with installation but some packages may not be available"
    fi
    
    # Check network connectivity
    if ! check_network; then
        log_error "Network connection required for installation"
        exit 1
    fi
    
    # Display system information
    get_system_info
    
    log_success "Pre-installation checks completed"
}

# --- Installation Functions ---
install_essentials() {
    log_info "Installing essential packages..."
    
    # Update package lists first
    log_info "Updating package lists..."
    if ! sudo apt-get update; then
        log_error "Failed to update package lists"
        exit 1
    fi
    
    # Essential packages
    local essential_packages=(
        "curl" "wget" "git" "vim" "nano" "unzip" "htop" 
        "build-essential" "software-properties-common" 
        "apt-transport-https" "ca-certificates" "gnupg" 
        "lsb-release" "tmux"
    )
    
    log_info "Installing essential packages: ${essential_packages[*]}"
    
    for package in "${essential_packages[@]}"; do
        if ! safe_install "$package"; then
            log_warn "Failed to install $package, trying to continue..."
        fi
    done
    
    log_success "Essential packages installation completed"
}

install_docker() {
    if [[ "$INSTALL_DOCKER" != "true" ]]; then
        log_info "Skipping Docker installation (INSTALL_DOCKER=false)"
        return 0
    fi
    
    log_info "Installing Docker..."
    
    # Remove old Docker installations
    log_info "Removing old Docker installations..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
    
    # Add Docker GPG key
    log_info "Adding Docker GPG key..."
    if ! curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg; then
        log_error "Failed to add Docker GPG key"
        return 1
    fi
    
    # Add Docker repository
    log_info "Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package lists
    if ! sudo apt-get update; then
        log_error "Failed to update package lists after adding Docker repository"
        return 1
    fi
    
    # Install Docker packages
    local docker_packages=(
        "docker-ce" "docker-ce-cli" "containerd.io" 
        "docker-buildx-plugin" "docker-compose-plugin"
    )
    
    for package in "${docker_packages[@]}"; do
        if ! install_with_retry "$package"; then
            log_error "Failed to install Docker package: $package"
            return 1
        fi
    done
    
    # Add user to docker group
    log_info "Adding user to docker group..."
    sudo usermod -aG docker "$USER"
    
    log_success "Docker installed successfully"
    log_warn "Please log out and back in for Docker group changes to take effect"
    return 0
}

prompt_docker_installation() {
    if [[ "$SKIP_DOCKER_PROMPT" == "true" ]]; then
        return 0
    fi
    
    echo ""
    log_info "Docker Installation Option"
    echo "Docker provides containerization capabilities but requires additional system resources."
    echo "You can skip Docker installation if you don't need containerization features."
    echo ""
    
    if ask_yes_no "Would you like to install Docker?" "n"; then
        INSTALL_DOCKER=true
        log_info "Docker will be installed"
    else
        INSTALL_DOCKER=false
        log_info "Docker installation will be skipped"
    fi
    echo ""
}

install_node() {
    log_info "Installing Node.js..."
    
    # Check if Node.js is already installed
    if check_command_silent node; then
        local node_version
        node_version=$(node --version)
        log_info "Node.js is already installed: $node_version"
        return 0
    fi
    
    # Add NodeSource repository
    log_info "Adding NodeSource repository..."
    if ! curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -; then
        log_error "Failed to add NodeSource repository"
        return 1
    fi
    
    # Install Node.js
    if ! install_with_retry "nodejs" "Node.js"; then
        log_error "Failed to install Node.js"
        return 1
    fi
    
    # Verify installation
    if check_command node; then
        local node_version npm_version
        node_version=$(node --version)
        npm_version=$(npm --version)
        log_success "Node.js installed successfully: $node_version"
        log_info "npm version: $npm_version"
        return 0
    else
        log_error "Node.js installation verification failed"
        return 1
    fi
}

install_python() {
    log_info "Installing Python 3.11..."
    
    # Check if Python 3.11 is already installed
    if check_command_silent python3.11; then
        local python_version
        python_version=$(python3.11 --version)
        log_info "Python 3.11 is already installed: $python_version"
        return 0
    fi
    
    # Add deadsnakes PPA
    log_info "Adding deadsnakes PPA for Python 3.11..."
    if ! sudo add-apt-repository ppa:deadsnakes/ppa -y; then
        log_error "Failed to add deadsnakes PPA"
        return 1
    fi
    
    # Update package lists
    if ! sudo apt-get update; then
        log_error "Failed to update package lists after adding PPA"
        return 1
    fi
    
    # Install Python 3.11 and related packages
    local python_packages=("python3.11" "python3.11-venv" "python3.11-dev" "python3.11-pip")
    
    for package in "${python_packages[@]}"; do
        if ! install_with_retry "$package"; then
            log_warn "Failed to install $package, continuing..."
        fi
    done
    
    # Verify installation
    if check_command python3.11; then
        local python_version
        python_version=$(python3.11 --version)
        log_success "Python 3.11 installed successfully: $python_version"
        return 0
    else
        log_error "Python 3.11 installation verification failed"
        return 1
    fi
}

install_neovim() {
    log_info "Installing Neovim..."
    
    # Check if Neovim is already installed
    if check_command_silent nvim; then
        local nvim_version
        nvim_version=$(nvim --version | head -n1)
        log_info "Neovim is already installed: $nvim_version"
        return 0
    fi
    
    # Add Neovim stable PPA
    log_info "Adding Neovim stable PPA..."
    if ! sudo add-apt-repository ppa:neovim-ppa/stable -y; then
        log_error "Failed to add Neovim PPA"
        return 1
    fi
    
    # Update package lists
    if ! sudo apt-get update; then
        log_error "Failed to update package lists after adding PPA"
        return 1
    fi
    
    # Install Neovim
    if ! install_with_retry "neovim" "Neovim"; then
        log_error "Failed to install Neovim"
        return 1
    fi
    
    # Verify installation
    if check_command nvim; then
        local nvim_version
        nvim_version=$(nvim --version | head -n1)
        log_success "Neovim installed successfully: $nvim_version"
        return 0
    else
        log_error "Neovim installation verification failed"
        return 1
    fi
}

install_astronvim() {
    log_info "Installing AstroNvim..."
    
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Backup existing Neovim configuration if it exists
    if [[ -d "$HOME/.config/nvim" ]]; then
        log_info "Backing up existing Neovim configuration..."
        if ! create_backup "$HOME/.config/nvim"; then
            log_error "Failed to backup existing Neovim configuration"
            return 1
        fi
        rm -rf "$HOME/.config/nvim"
    fi
    
    # Clone AstroNvim template (not the main repository)
    log_info "Cloning AstroNvim template..."
    if ! git clone --depth 1 https://github.com/AstroNvim/template "$HOME/.config/nvim"; then
        log_error "Failed to clone AstroNvim template"
        return 1
    fi
    
    # Remove git metadata from template
    rm -rf "$HOME/.config/nvim/.git"
    
    # Install additional dependencies for AstroNvim
    log_info "Installing AstroNvim dependencies..."
    local dependencies=("ripgrep" "fd-find")
    
    for dep in "${dependencies[@]}"; do
        if ! safe_install "$dep"; then
            log_warn "Failed to install $dep, AstroNvim may have limited functionality"
        fi
    done
    
    # Create symbolic link for fdfind (required by some AstroNvim plugins)
    if command -v fdfind &> /dev/null; then
        sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true
        log_info "Created fd symlink for fdfind"
    fi
    
    # Copy user configuration from repository if available
    local config_path="configs/astronvim"
    if [[ -d "$config_path" ]]; then
        log_info "Copying AstroNvim user configuration from repository..."
        
        # Copy configuration files to the template structure
        if cp -r "$config_path"/lua/* "$HOME/.config/nvim/lua/"; then
            log_success "AstroNvim user configuration merged with template"
            
            # Also copy any top-level files
            for file in "$config_path"/*.{lua,md,json} 2>/dev/null; do
                if [[ -f "$file" ]]; then
                    cp "$file" "$HOME/.config/nvim/"
                fi
            done
        else
            log_warn "Failed to copy user configuration, using defaults"
        fi
    else
        log_info "No custom AstroNvim configuration found, using defaults"
    fi
    
    log_success "AstroNvim installed successfully"
    log_info "Run 'nvim' to complete the setup and install plugins"
    return 0
}

configure_tmux() {
    log_info "Configuring tmux..."
    
    # Backup existing tmux configuration if it exists
    if [[ -f "$HOME/.tmux.conf" ]]; then
        if ! create_backup "$HOME/.tmux.conf"; then
            log_warn "Failed to backup existing tmux configuration"
        fi
    fi
    
    # Copy tmux configuration from repository
    local tmux_config_path="configs/.tmux.conf"
    if [[ -f "$tmux_config_path" ]]; then
        log_info "Copying tmux configuration from repository..."
        if cp "$tmux_config_path" "$HOME/.tmux.conf"; then
            log_success "tmux configuration copied from repository"
        else
            log_error "Failed to copy tmux configuration"
            return 1
        fi
    else
        # Fallback: create basic tmux configuration inline
        log_info "Creating basic tmux configuration..."
        cat > "$HOME/.tmux.conf" << 'EOF'
# Enhanced tmux configuration for Portable Development Environment

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

# Automatically renumber windows
set -g renumber-windows on

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

# Resize panes with prefix + arrow keys
bind Left resize-pane -L 5
bind Right resize-pane -R 5
bind Up resize-pane -U 5
bind Down resize-pane -D 5

# Status bar customization
set -g status-bg black
set -g status-fg white
set -g status-left-length 20
set -g status-left '#[fg=green]#S #[fg=blue]#I:#P '
set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M'
set -g status-interval 60

# Window status
set -g window-status-current-style 'fg=black bg=green'
set -g window-status-style 'fg=white'

# Pane borders
set -g pane-border-style 'fg=colour8'
set -g pane-active-border-style 'fg=colour2'
EOF
        log_success "Basic tmux configuration created"
    fi
    
    log_success "tmux configuration setup complete"
    return 0
}

# --- Package Installation Functions ---
install_packages() {
    log_info "Installing Node.js and Python packages..."
    
    # Install global Node.js packages if package.json exists
    if [[ -f "package.json" ]] && check_command_silent npm; then
        log_info "Installing Node.js packages from package.json..."
        if npm install -g --prefix /usr/local; then
            log_success "Node.js packages installed successfully"
        else
            log_warn "Failed to install some Node.js packages"
        fi
    fi
    
    # Install Python packages if requirements.txt exists
    if [[ -f "requirements.txt" ]] && check_command_silent python3.11; then
        log_info "Installing Python packages from requirements.txt..."
        if python3.11 -m pip install --user -r requirements.txt; then
            log_success "Python packages installed successfully"
        else
            log_warn "Failed to install some Python packages"
        fi
    fi
}

# --- Post Installation ---
post_installation_summary() {
    echo ""
    log_success "Ubuntu setup complete!"
    echo ""
    
    # Show installation summary
    log_info "Installation Summary:"
    echo "  ✅ Essential packages: curl, wget, git, vim, nano, tmux, etc."
    
    if check_command_silent docker; then
        echo "  ✅ Docker: $(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1)"
    else
        echo "  ⏭️  Docker: Skipped"
    fi
    
    if check_command_silent node; then
        echo "  ✅ Node.js: $(node --version)"
    fi
    
    if check_command_silent python3.11; then
        echo "  ✅ Python: $(python3.11 --version)"
    fi
    
    if check_command_silent nvim; then
        echo "  ✅ Neovim: $(nvim --version | head -n1)"
        echo "  ✅ AstroNvim: Configuration installed"
    fi
    
    echo "  ✅ tmux: Configuration applied"
    echo ""
    
    log_info "Next Steps:"
    if [[ "$INSTALL_DOCKER" == "true" ]]; then
        echo "  1. Log out and back in for Docker group changes to take effect"
        echo "  2. Run 'nvim' to complete AstroNvim plugin installation"
        echo "  3. Start tmux with 'tmux' command"
        echo "  4. Run terminal enhancements script: ./scripts/install-tools.sh"
    else
        echo "  1. Run 'nvim' to complete AstroNvim plugin installation"
        echo "  2. Start tmux with 'tmux' command"  
        echo "  3. Run terminal enhancements script: ./scripts/install-tools.sh"
    fi
    echo "  5. Run configuration script: ./scripts/configure-tools.sh"
    echo ""
}

# --- Main Function ---
main() {
    echo "🚀 Portable Development Environment - Ubuntu Setup"
    echo "================================================="
    echo ""
    
    # Pre-installation checks
    pre_install_checks
    
    # Prompt for Docker installation
    prompt_docker_installation
    
    # Core installations
    log_info "Starting core component installation..."
    
    install_essentials || { log_error "Essential packages installation failed"; exit 1; }
    install_docker || { log_error "Docker installation failed"; exit 1; }
    install_node || { log_error "Node.js installation failed"; exit 1; }
    install_python || { log_error "Python installation failed"; exit 1; }
    install_neovim || { log_error "Neovim installation failed"; exit 1; }
    install_astronvim || { log_error "AstroNvim installation failed"; exit 1; }
    configure_tmux || { log_error "tmux configuration failed"; exit 1; }
    
    # Install additional packages
    install_packages
    
    # Show completion summary
    post_installation_summary
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
