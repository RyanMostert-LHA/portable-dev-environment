#!/bin/bash

# Enhanced Terminal Programming & Navigation Tools Installation Script
# Part of the Portable Development Environment
# Improved with better error handling and fallback methods

# Source common functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/install/common.sh" ]]; then
    source "$SCRIPT_DIR/install/common.sh"
else
    # Fallback logging functions if common.sh is not available
    log_info() { echo -e "\033[32m[INFO]\033[0m $1"; }
    log_warn() { echo -e "\033[33m[WARN]\033[0m $1"; }
    log_error() { echo -e "\033[31m[ERROR]\033[0m $1" >&2; }
    log_success() { echo -e "\033[32m[SUCCESS]\033[0m $1"; }
    check_command_silent() { command -v "$1" &> /dev/null; }
    safe_install() {
        local package="$1"
        if sudo apt-get install -y "$package"; then
            log_success "$package installed successfully"
            return 0
        else
            log_error "Failed to install $package"
            return 1
        fi
    }
fi

set -e

echo "🚀 Installing Terminal Programming & Navigation Tools..."
echo "======================================================="
echo ""

# --- Pre-installation Checks ---
pre_install_checks() {
    log_info "Performing pre-installation checks..."
    
    # Check if we're running on a supported system
    if ! command -v apt-get &> /dev/null; then
        log_error "This script requires apt-get (Debian/Ubuntu systems)"
        exit 1
    fi
    
    # Check network connectivity
    if ! ping -c 1 -W 5 google.com &> /dev/null; then
        log_error "Network connection required for installation"
        exit 1
    fi
    
    log_success "Pre-installation checks completed"
    echo ""
}

# --- Installation Functions ---
install_file_navigation_tools() {
    log_info "📁 Installing file navigation tools..."
    
    local tools=("ranger" "nnn" "mc" "eza" "tree")
    local failed_tools=()
    
    for tool in "${tools[@]}"; do
        if check_command_silent "$tool"; then
            log_info "$tool is already installed"
        elif safe_install "$tool"; then
            log_success "$tool installed successfully"
        else
            failed_tools+=("$tool")
            log_warn "Failed to install $tool"
        fi
    done
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        log_warn "Some file navigation tools failed to install: ${failed_tools[*]}"
        return 1
    fi
    
    log_success "File navigation tools installation completed"
    return 0
}

install_search_text_tools() {
    log_info "🔍 Installing search and text processing tools..."
    
    local tools=("ripgrep" "fd-find" "fzf" "bat" "jq")
    local failed_tools=()
    
    for tool in "${tools[@]}"; do
        if check_command_silent "$tool"; then
            log_info "$tool is already installed"
        elif safe_install "$tool"; then
            log_success "$tool installed successfully"
        else
            failed_tools+=("$tool")
            log_warn "Failed to install $tool"
        fi
    done
    
    # Special handling for bat (sometimes packaged as batcat)
    if ! check_command_silent bat && ! check_command_silent batcat; then
        log_warn "Neither bat nor batcat found, some aliases may not work"
    fi
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        log_warn "Some search/text tools failed to install: ${failed_tools[*]}"
        return 1
    fi
    
    log_success "Search and text processing tools installation completed"
    return 0
}

install_starship_prompt() {
    log_info "⭐ Installing Starship prompt..."
    
    if check_command_silent starship; then
        local starship_version
        starship_version=$(starship --version | head -n1)
        log_info "Starship is already installed: $starship_version"
        return 0
    fi
    
    # Try to install Starship
    log_info "Downloading and installing Starship..."
    if curl -fsSL https://starship.rs/install.sh | sh -s -- --yes; then
        # Verify installation
        if check_command_silent starship; then
            local starship_version
            starship_version=$(starship --version | head -n1)
            log_success "Starship installed successfully: $starship_version"
            return 0
        fi
    fi
    
    log_error "Failed to install Starship prompt"
    return 1
}

install_development_tools() {
    log_info "💻 Installing development tools..."
    
    local tools=("git-delta" "htop" "btop" "ncdu")
    local failed_tools=()
    
    for tool in "${tools[@]}"; do
        if check_command_silent "$tool"; then
            log_info "$tool is already installed"
        elif safe_install "$tool"; then
            log_success "$tool installed successfully"
        else
            failed_tools+=("$tool")
            log_warn "Failed to install $tool"
        fi
    done
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        log_warn "Some development tools failed to install: ${failed_tools[*]}"
        return 1
    fi
    
    log_success "Development tools installation completed"
    return 0
}

install_lazygit() {
    log_info "📊 Installing lazygit..."
    
    if check_command_silent lazygit; then
        local lazygit_version
        lazygit_version=$(lazygit --version | head -n1)
        log_info "lazygit is already installed: $lazygit_version"
        return 0
    fi
    
    # Create temporary directory for download
    local temp_dir
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    log_info "Downloading lazygit..."
    if ! LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'); then
        log_error "Failed to get lazygit version information"
        rm -rf "$temp_dir"
        return 1
    fi
    
    if ! curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; then
        log_error "Failed to download lazygit"
        rm -rf "$temp_dir"
        return 1
    fi
    
    if ! tar xf lazygit.tar.gz lazygit; then
        log_error "Failed to extract lazygit"
        rm -rf "$temp_dir"
        return 1
    fi
    
    if ! sudo install lazygit /usr/local/bin; then
        log_error "Failed to install lazygit to /usr/local/bin"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Clean up
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    # Verify installation
    if check_command_silent lazygit; then
        local lazygit_version
        lazygit_version=$(lazygit --version | head -n1)
        log_success "lazygit installed successfully: $lazygit_version"
        return 0
    else
        log_error "lazygit installation verification failed"
        return 1
    fi
}

install_quality_of_life_tools() {
    log_info "🎨 Installing quality of life utilities..."
    
    # Install trash-cli
    if check_command_silent trash-put; then
        log_info "trash-cli is already installed"
    elif safe_install "trash-cli"; then
        log_success "trash-cli installed successfully"
    else
        log_warn "Failed to install trash-cli"
    fi
    
    # Install pipx (for Python tools)
    if check_command_silent pipx; then
        log_info "pipx is already installed"
    elif safe_install "pipx"; then
        log_success "pipx installed successfully"
    else
        log_warn "Failed to install pipx"
    fi
    
    # Try to install thefuck
    log_info "🔧 Installing thefuck..."
    if check_command_silent thefuck; then
        log_info "thefuck is already installed"
    else
        # Try multiple installation methods
        if check_command_silent pipx; then
            log_info "Trying to install thefuck via pipx..."
            if pipx install thefuck 2>/dev/null; then
                log_success "thefuck installed via pipx"
            else
                log_warn "Failed to install thefuck via pipx"
            fi
        elif check_command_silent pip3; then
            log_info "Trying to install thefuck via pip3..."
            if pip3 install --user thefuck 2>/dev/null; then
                log_success "thefuck installed via pip3"
            else
                log_warn "Failed to install thefuck via pip3"
            fi
        else
            log_warn "Cannot install thefuck - no suitable Python package manager found"
        fi
    fi
    
    log_success "Quality of life tools installation completed"
    return 0
}

install_rust_toolchain() {
    log_info "🦀 Installing Rust toolchain..."
    
    if check_command_silent rustc; then
        local rust_version
        rust_version=$(rustc --version)
        log_info "Rust is already installed: $rust_version"
        return 0
    fi
    
    log_info "Downloading and installing Rust toolchain..."
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        # Source Rust environment
        if [[ -f "$HOME/.cargo/env" ]]; then
            source "$HOME/.cargo/env"
        fi
        
        # Verify installation
        if check_command_silent rustc; then
            local rust_version
            rust_version=$(rustc --version)
            log_success "Rust installed successfully: $rust_version"
            return 0
        fi
    fi
    
    log_error "Failed to install Rust toolchain"
    return 1
}

# --- Installation Summary ---
show_installation_summary() {
    echo ""
    log_success "Terminal tools installation completed!"
    echo ""
    
    log_info "Installation Summary:"
    
    # File Navigation Tools
    local nav_tools=("ranger" "nnn" "mc" "eza" "tree")
    echo -n "  📁 File Navigation: "
    for tool in "${nav_tools[@]}"; do
        if check_command_silent "$tool"; then
            echo -n "✅ $tool "
        else
            echo -n "❌ $tool "
        fi
    done
    echo ""
    
    # Search & Text Tools
    local search_tools=("rg" "fzf" "jq")
    echo -n "  🔍 Search & Text: "
    for tool in "${search_tools[@]}"; do
        if check_command_silent "$tool"; then
            echo -n "✅ $tool "
        else
            echo -n "❌ $tool "
        fi
    done
    if check_command_silent bat || check_command_silent batcat; then
        echo -n "✅ bat "
    else
        echo -n "❌ bat "
    fi
    if check_command_silent fd || check_command_silent fdfind; then
        echo -n "✅ fd "
    else
        echo -n "❌ fd "
    fi
    echo ""
    
    # Terminal & Development Tools
    local dev_tools=("starship" "lazygit" "htop" "btop" "ncdu" "delta")
    echo -n "  💻 Development: "
    for tool in "${dev_tools[@]}"; do
        if check_command_silent "$tool"; then
            echo -n "✅ $tool "
        else
            echo -n "❌ $tool "
        fi
    done
    echo ""
    
    # Quality of Life
    echo -n "  🎨 Quality of Life: "
    if check_command_silent trash-put; then
        echo -n "✅ trash-cli "
    else
        echo -n "❌ trash-cli "
    fi
    if check_command_silent thefuck; then
        echo -n "✅ thefuck "
    else
        echo -n "❌ thefuck "
    fi
    echo ""
    
    # Programming Languages
    echo -n "  🛠️  Languages: "
    if check_command_silent rustc; then
        echo -n "✅ Rust "
    else
        echo -n "❌ Rust "
    fi
    if check_command_silent node; then
        echo -n "✅ Node.js "
    else
        echo -n "❌ Node.js "
    fi
    echo ""
    echo ""
    
    log_info "Next Steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    echo "  2. Run configuration script: ./scripts/configure-tools.sh"
    echo "  3. Check usage examples: docs/tools-guide.md"
    echo ""
}

# --- Main Installation Function ---
main() {
    echo "🚀 Terminal Programming & Navigation Tools Installation"
    echo "======================================================"
    echo ""
    
    # Pre-installation checks
    pre_install_checks
    
    # Update package lists
    log_info "📦 Updating package lists..."
    if sudo apt update; then
        log_success "Package lists updated successfully"
    else
        log_warn "Failed to update package lists, continuing anyway..."
    fi
    echo ""
    
    # Install tools (continue on individual failures)
    local overall_success=true
    
    install_file_navigation_tools || overall_success=false
    echo ""
    
    install_search_text_tools || overall_success=false
    echo ""
    
    install_starship_prompt || overall_success=false
    echo ""
    
    install_development_tools || overall_success=false
    echo ""
    
    install_lazygit || overall_success=false
    echo ""
    
    install_quality_of_life_tools || overall_success=false
    echo ""
    
    install_rust_toolchain || overall_success=false
    echo ""
    
    # Show summary
    show_installation_summary
    
    if [[ "$overall_success" == "true" ]]; then
        log_success "All tools installed successfully!"
        exit 0
    else
        log_warn "Some tools failed to install, but installation completed"
        log_info "Check the summary above to see which tools are available"
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
