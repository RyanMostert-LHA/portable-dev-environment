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

# --- Validation Functions ---
check_command() {
    if ! command -v $1 &> /dev/null; then
        log_error "$1 could not be found"
        exit 1
    fi
}

check_network() {
    if ! ping -c 1 google.com &> /dev/null; then
        log_error "No network connection"
        exit 1
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

