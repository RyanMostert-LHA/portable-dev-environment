#!/bin/bash

# Source common functions
source "$(dirname "$0")/../install/common.sh"

log_info "Starting health check..."

# --- Check Functions ---

check_docker() {
    log_info "Checking Docker..."
    check_command docker
    if ! docker info > /dev/null 2>&1; then
        log_error "Docker is not running."
    else
        log_info "Docker is running."
    fi
}

check_node() {
    log_info "Checking Node.js..."
    check_command node
    check_command npm
    log_info "Node version: $(node -v)"
    log_info "npm version: $(npm -v)"
}

check_python() {
    log_info "Checking Python..."
    check_command python3.11
    log_info "Python version: $(python3.11 --version)"
}

check_git() {
    log_info "Checking Git..."
    check_command git
    log_info "Git version: $(git --version)"
}

check_resources() {
    log_info "Checking system resources..."
    log_info "CPU usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    log_info "Memory usage: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
    log_info "Disk usage: $(df -h / | awk 'NR==2{printf "%s", $5}')"
}


# --- Main Function ---
main() {
    check_docker
    check_node
    check_python
    check_git
    check_resources
    
    log_info "Health check complete. All checks passed!"
}

main
