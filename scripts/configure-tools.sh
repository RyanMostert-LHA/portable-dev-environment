#!/bin/bash

# Enhanced Configuration Script for Terminal Tools
# Part of the Portable Development Environment
# Improved with PATH verification and better error handling

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
fi

set -e

echo "🔧 Configuring Terminal Tools..."
echo "================================="
echo ""

# --- Pre-configuration Checks ---
pre_config_checks() {
    log_info "Performing pre-configuration checks..."
    
    # Check if we have a home directory
    if [[ -z "$HOME" ]]; then
        log_error "HOME directory not set"
        exit 1
    fi
    
    # Check if we can write to home directory
    if [[ ! -w "$HOME" ]]; then
        log_error "Cannot write to HOME directory: $HOME"
        exit 1
    fi
    
    log_success "Pre-configuration checks completed"
}

# --- Configuration Setup ---
setup_config_directories() {
    log_info "📁 Creating configuration directories..."
    
    local config_dirs=(
        "$HOME/.config/ranger"
        "$HOME/.config/starship"  
        "$HOME/.config/tmux"
        "$HOME/.config/bat"
        "$HOME/.config/fzf"
    )
    
    for dir in "${config_dirs[@]}"; do
        if mkdir -p "$dir"; then
            log_info "Created directory: $dir"
        else
            log_warn "Failed to create directory: $dir"
        fi
    done
    
    log_success "Configuration directories created"
    echo ""
}

# --- Tool Verification ---
verify_tools() {
    log_info "🔍 Verifying installed tools..."
    
    local tools_to_check=(
        "eza:File listing with icons"
        "rg:ripgrep - fast text search"
        "fzf:fuzzy finder"
        "bat:enhanced cat with syntax highlighting"
        "starship:cross-shell prompt"
        "lazygit:Git TUI"
        "btop:system monitor"
        "ranger:file manager"
        "delta:Git diff viewer"
        "trash-put:safe file deletion"
    )
    
    local missing_tools=()
    local found_tools=()
    
    for tool_desc in "${tools_to_check[@]}"; do
        local tool="${tool_desc%%:*}"
        local desc="${tool_desc#*:}"
        
        # Handle special cases
        case "$tool" in
            "rg")
                if check_command_silent ripgrep || check_command_silent rg; then
                    found_tools+=("$tool_desc")
                else
                    missing_tools+=("$tool_desc")
                fi
                ;;
            "bat")
                if check_command_silent bat || check_command_silent batcat; then
                    found_tools+=("$tool_desc")
                else
                    missing_tools+=("$tool_desc")
                fi
                ;;
            "delta")
                if check_command_silent delta || check_command_silent git-delta; then
                    found_tools+=("$tool_desc")
                else
                    missing_tools+=("$tool_desc")
                fi
                ;;
            *)
                if check_command_silent "$tool"; then
                    found_tools+=("$tool_desc")
                else
                    missing_tools+=("$tool_desc")
                fi
                ;;
        esac
    done
    
    # Report findings
    if [[ ${#found_tools[@]} -gt 0 ]]; then
        log_success "Found tools:"
        for tool in "${found_tools[@]}"; do
            echo "    ✅ ${tool}"
        done
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_warn "Missing tools (some aliases may not work):"
        for tool in "${missing_tools[@]}"; do
            echo "    ❌ ${tool}"
        done
        echo ""
        log_info "Run './scripts/install-tools.sh' to install missing tools"
    fi
    
    echo ""
}

# --- Bash Configuration ---
configure_bash_aliases() {
    log_info "🔗 Setting up bash aliases and functions..."
    
    # Backup existing .bashrc
    if [[ -f "$HOME/.bashrc" ]]; then
        create_backup "$HOME/.bashrc"
    fi
    
    # Check if our configuration is already present
    if grep -q "# === Portable Dev Environment Aliases ===" "$HOME/.bashrc" 2>/dev/null; then
        log_info "Configuration already present in ~/.bashrc, skipping..."
        return 0
    fi
    
    # Add enhanced configuration to .bashrc
    log_info "Adding enhanced bash configuration..."
    cat >> "$HOME/.bashrc" << 'BASHEOF'

# === Portable Dev Environment Aliases ===
# File navigation (with fallbacks for missing tools)
if command -v eza &> /dev/null; then
    alias ll='eza -la --icons --group-directories-first'
    alias ls='eza --icons'
    alias tree='eza --tree --icons'
    alias la='eza -la --icons'
else
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
    alias tree='tree'
fi

# Better cat and search (with fallbacks)
if command -v batcat &> /dev/null; then
    alias cat='batcat'
elif command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v fdfind &> /dev/null; then
    alias find='fdfind'
elif command -v fd &> /dev/null; then
    alias find='fd'
fi

# Git shortcuts
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

if command -v delta &> /dev/null; then
    alias gd='git diff --no-index'
    # Configure git to use delta if available
    git config --global core.pager delta 2>/dev/null || true
    git config --global interactive.diffFilter 'delta --color-only' 2>/dev/null || true
elif command -v git-delta &> /dev/null; then
    alias gd='git diff --no-index'
fi

# System monitoring
if command -v btop &> /dev/null; then
    alias top='btop'
elif command -v htop &> /dev/null; then
    alias top='htop'
fi

if command -v ncdu &> /dev/null; then
    alias du='ncdu'
fi

# Safety aliases
if command -v trash-put &> /dev/null; then
    alias rm='trash-put'
    alias del='trash-put'  # Alternative alias
fi
alias cp='cp -i'
alias mv='mv -i'

# FZF integration (with fallbacks)
if command -v fzf &> /dev/null; then
    if command -v fd &> /dev/null || command -v fdfind &> /dev/null; then
        local fd_cmd="fd"
        command -v fdfind &> /dev/null && fd_cmd="fdfind"
        
        if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
            local bat_cmd="bat"
            command -v batcat &> /dev/null && bat_cmd="batcat"
            alias fzf-file="$fd_cmd --type f | fzf --preview '$bat_cmd --style=numbers --color=always {}'"
        else
            alias fzf-file="$fd_cmd --type f | fzf --preview 'cat {}'"
        fi
        
        alias fzf-dir="$fd_cmd --type d | fzf"
    fi
fi

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# === Enhanced Functions ===
# Quick file search and edit
fe() {
    local file
    local fd_cmd="find . -type f"
    local preview_cmd="cat"
    
    # Use better tools if available
    if command -v fd &> /dev/null; then
        fd_cmd="fd --type f"
    elif command -v fdfind &> /dev/null; then
        fd_cmd="fdfind --type f"
    fi
    
    if command -v bat &> /dev/null; then
        preview_cmd="bat --style=numbers --color=always"
    elif command -v batcat &> /dev/null; then
        preview_cmd="batcat --style=numbers --color=always"
    fi
    
    if command -v fzf &> /dev/null; then
        file=$($fd_cmd | fzf --preview "$preview_cmd {}") && nvim "$file"
    else
        echo "fzf is required for this function"
        return 1
    fi
}

# Search in files with preview
search() {
    if [[ -z "$1" ]]; then
        echo "Usage: search <pattern>"
        return 1
    fi
    
    local search_cmd="grep -rn"
    local preview_cmd="cat"
    
    if command -v rg &> /dev/null; then
        search_cmd="rg --line-number --no-heading --color=always"
    fi
    
    if command -v bat &> /dev/null; then
        preview_cmd="bat --style=numbers --color=always --highlight-line {2}"
    elif command -v batcat &> /dev/null; then
        preview_cmd="batcat --style=numbers --color=always --highlight-line {2}"
    fi
    
    if command -v fzf &> /dev/null; then
        $search_cmd "$1" | fzf --delimiter ':' --preview "$preview_cmd {1}"
    else
        $search_cmd "$1"
    fi
}

# === Tool Initialization ===
# Initialize Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# Initialize thefuck
if command -v thefuck &> /dev/null; then
    eval "$(thefuck --alias)"
fi

# FZF key bindings and completion
if command -v fzf &> /dev/null; then
    # Try different locations for FZF scripts
    local fzf_locations=(
        "/usr/share/doc/fzf/examples"
        "/usr/share/fzf"
        "/usr/local/share/fzf"
        "$HOME/.fzf"
    )
    
    for location in "${fzf_locations[@]}"; do
        if [[ -f "$location/key-bindings.bash" ]]; then
            source "$location/key-bindings.bash"
            break
        fi
    done
    
    for location in "${fzf_locations[@]}"; do
        if [[ -f "$location/completion.bash" ]]; then
            source "$location/completion.bash"
            break
        fi
    done
fi

# === PATH Configuration ===
# Add local bins to PATH (avoid duplicates)
add_to_path() {
    local new_path="$1"
    if [[ -d "$new_path" ]] && [[ ":$PATH:" != *":$new_path:"* ]]; then
        export PATH="$new_path:$PATH"
    fi
}

add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "/usr/local/bin"

# === Environment Variables ===
# Configure tools
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# FZF configuration
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    
    # Use ripgrep for FZF if available
    if command -v rg &> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    elif command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    elif command -v fdfind &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# === Portable Dev Environment Marker ===
export PORTABLE_DEV_ENV_CONFIGURED=true
BASHEOF

    log_success "Bash configuration added to ~/.bashrc"
    echo ""
}

# --- Configuration Summary ---
show_config_summary() {
    log_success "Terminal tools configuration completed!"
    echo ""
    
    log_info "Configuration Summary:"
    echo "  ✅ Configuration directories created"
    echo "  ✅ Enhanced bash aliases and functions added"
    echo "  ✅ PATH updated with local directories"
    echo "  ✅ Tool initialization scripts configured"
    echo "  ✅ Fallbacks configured for missing tools"
    echo ""
    
    log_info "Next Steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    echo "  2. Test the new aliases: ll, cat, lg, btop, etc."
    echo "  3. Try the functions: fe (file edit), search <pattern>"
    echo "  4. Check the tool guides: docs/tools-guide.md"
    echo ""
    
    if [[ -n "$MISSING_TOOLS" ]]; then
        log_warn "Some tools are missing. Run './scripts/install-tools.sh' to install them."
        echo ""
    fi
}

# --- Main Configuration Function ---
main() {
    echo "🔧 Terminal Tools Configuration"
    echo "==============================="
    echo ""
    
    # Run configuration steps
    pre_config_checks
    echo ""
    
    setup_config_directories
    
    verify_tools
    
    configure_bash_aliases
    
    show_config_summary
    
    log_success "Configuration complete!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
