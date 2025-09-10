#!/bin/bash

# --- Logging Functions ---
log_info() {
    echo "[INFO] $1"
}

log_warn() {
    echo "[WARN] $1"
}

log_error() {
    echo "[ERROR] $1"
}

log_success() {
    echo "[SUCCESS] $1"
}

# --- Validation Functions ---
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_error "$1 could not be found"
        return 1
    fi
    return 0
}

check_command_silent() {
    command -v $1 &> /dev/null
}

check_network() {
    if ! ping -c 1 google.com &> /dev/null; then
        log_error "No network connection"
        return 1
    fi
    return 0
}

# --- Installation Helper Functions ---
install_package() {
    local package="$1"
    local description="$2"
    
    log_info "Installing $description..."
    if sudo apt-get install -y "$package"; then
        log_success "$description installed successfully"
        return 0
    else
        log_error "Failed to install $description"
        return 1
    fi
}

install_package_optional() {
    local package="$1"
    local description="$2"
    
    log_info "Installing $description (optional)..."
    if sudo apt-get install -y "$package" 2>/dev/null; then
        log_success "$description installed successfully"
        return 0
    else
        log_warn "$description installation failed, continuing..."
        return 1
    fi
}

# --- User Interaction Functions ---
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    
    while true; do
        if [[ "$default" == "y" ]]; then
            read -p "$question [Y/n]: " yn
            yn=${yn:-y}
        else
            read -p "$question [y/N]: " yn
            yn=${yn:-n}
        fi
        
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# --- System Detection Functions ---
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*)    echo "windows";;
        MINGW*)     echo "windows";;
        MSYS*)      echo "windows";;
        *)          echo "unknown";;
    esac
}

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# --- Path Management Functions ---
add_to_path() {
    local new_path="$1"
    if [[ ":$PATH:" != *":$new_path:"* ]]; then
        export PATH="$new_path:$PATH"
        log_info "Added $new_path to PATH"
    fi
}

update_bashrc_path() {
    local new_path="$1"
    local bashrc="$HOME/.bashrc"
    
    if ! grep -q "export PATH=\"$new_path:\$PATH\"" "$bashrc" 2>/dev/null; then
        echo "export PATH=\"$new_path:\$PATH\"" >> "$bashrc"
        log_info "Added $new_path to .bashrc PATH"
    fi
}

# --- UI Functions ---
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- Cleanup Functions ---
cleanup_temp_files() {
    local temp_dir="${1:-/tmp}"
    log_info "Cleaning up temporary files in $temp_dir..."
    find "$temp_dir" -name "*.tmp" -mtime +1 -delete 2>/dev/null || true
    find "$temp_dir" -name "*.log" -mtime +1 -delete 2>/dev/null || true
}

# --- Error Handling ---
set_error_handling() {
    set -e
    set -o pipefail
    trap 'log_error "Script failed at line $LINENO"' ERR
}

# --- Version Checking ---
check_min_version() {
    local current="$1"
    local required="$2"
    
    if [[ "$(printf '%s\n' "$required" "$current" | sort -V | head -n1)" = "$required" ]]; then
        return 0
    else
        return 1
    fi
}

log_warn() {
    echo -e "\033[33m[WARN]\033[0m $1"
}

log_error() {
    echo -e "\033[31m[ERROR]\033[0m $1" >&2
}

log_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# --- Enhanced Validation Functions ---
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_error "$1 could not be found"
        return 1
    fi
    return 0
}

check_command_silent() {
    command -v "$1" &> /dev/null
}

check_network() {
    if ! ping -c 1 -W 5 google.com &> /dev/null; then
        log_error "No network connection available"
        return 1
    fi
    return 0
}

check_os() {
    case "$(uname -s)" in
        Linux*)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]]; then
                    return 0
                fi
            fi
            log_warn "This script is optimized for Ubuntu/Debian systems"
            ;;
        *)
            log_error "Unsupported operating system: $(uname -s)"
            return 1
            ;;
    esac
}

# --- Installation Helper Functions ---
safe_install() {
    local package="$1"
    local description="${2:-$package}"
    
    log_info "Installing $description..."
    
    if sudo apt-get install -y "$package"; then
        log_success "$description installed successfully"
        return 0
    else
        log_error "Failed to install $description"
        return 1
    fi
}

install_with_retry() {
    local package="$1"
    local description="${2:-$package}"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        log_info "Installing $description (attempt $attempt/$max_attempts)..."
        
        if sudo apt-get install -y "$package"; then
            log_success "$description installed successfully"
            return 0
        else
            log_warn "Installation attempt $attempt failed"
            if [ $attempt -lt $max_attempts ]; then
                log_info "Retrying in 5 seconds..."
                sleep 5
                sudo apt-get update
            fi
        fi
        
        ((attempt++))
    done
    
    log_error "Failed to install $description after $max_attempts attempts"
    return 1
}

# --- PATH Management ---
add_to_path() {
    local new_path="$1"
    if [[ ":$PATH:" != *":$new_path:"* ]]; then
        export PATH="$new_path:$PATH"
        log_info "Added $new_path to PATH"
    fi
}

verify_path() {
    local tool="$1"
    local expected_path="$2"
    
    if check_command_silent "$tool"; then
        local actual_path
        actual_path=$(which "$tool")
        log_info "$tool found at: $actual_path"
        return 0
    else
        log_warn "$tool not found in PATH"
        if [[ -n "$expected_path" ]] && [[ -x "$expected_path/$tool" ]]; then
            add_to_path "$expected_path"
            log_info "Added $expected_path to PATH for $tool"
            return 0
        fi
        return 1
    fi
}

# --- Backup Functions ---
create_backup() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -d "$file" ]]; then
        local backup_name="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        if cp -r "$file" "$backup_name"; then
            log_info "Created backup: $backup_name"
            return 0
        else
            log_error "Failed to create backup of $file"
            return 1
        fi
    fi
    return 0
}

# --- UI Functions ---
show_progress() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- Interactive Functions ---
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response
    
    if [[ "$default" == "y" ]]; then
        question="$question [Y/n]: "
    else
        question="$question [y/N]: "
    fi
    
    read -p "$question" response
    response=${response:-$default}
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
    esac
}

# --- Line Ending Fix ---
fix_line_endings_if_needed() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if this script has line ending issues
    if grep -q $'\r' "$0" 2>/dev/null; then
        log_warn "Detected Windows line endings. Attempting to fix..."
        
        # Try to fix using sed
        if command -v sed &> /dev/null; then
            find "$script_dir" -name "*.sh" -type f -exec sed -i 's/\r$//' {} \;
            log_info "Fixed line endings using sed"
        else
            log_error "Cannot fix line endings - sed not available"
            log_error "Please run: find $script_dir -name '*.sh' -exec sed -i 's/\r$//' {} \;"
            return 1
        fi
    fi
    return 0
}

# --- System Information ---
get_system_info() {
    log_info "System Information:"
    log_info "  OS: $(uname -s)"
    log_info "  Architecture: $(uname -m)"
    log_info "  Kernel: $(uname -r)"
    
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        log_info "  Distribution: $PRETTY_NAME"
    fi
    
    log_info "  Shell: $SHELL"
    log_info "  User: $USER"
    log_info "  Home: $HOME"
}

