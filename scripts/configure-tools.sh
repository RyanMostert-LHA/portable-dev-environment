#!/bin/bash

# Configuration Script for Terminal Tools
# Part of the Portable Development Environment

set -e

echo "🔧 Configuring Terminal Tools..."
echo "================================="

# Create config directories
echo "📁 Creating configuration directories..."
mkdir -p ~/.config/ranger
mkdir -p ~/.config/starship
mkdir -p ~/.config/tmux

# Configure bash aliases and functions
echo "🔗 Setting up bash aliases..."
cat >> ~/.bashrc << 'BASHEOF'

# === Portable Dev Environment Aliases ===
# File navigation
alias ll='eza -la --icons --group-directories-first'
alias ls='eza --icons'
alias tree='eza --tree --icons'
alias la='eza -la --icons'

# Better cat and search
alias cat='batcat || bat'
alias grep='rg'
alias find='fd'

# Git shortcuts
alias lg='lazygit'
alias gd='git delta'

# System monitoring
alias top='btop'
alias du='ncdu'

# Safety aliases
alias rm='trash-put'
alias cp='cp -i'
alias mv='mv -i'

# FZF integration
alias fzf-file='fd --type f | fzf --preview "batcat --style=numbers --color=always {} || bat --style=numbers --color=always {}"'
alias fzf-dir='fd --type d | fzf'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# === Functions ===
# Quick file search and edit
fe() {
    local file
    file=$(fd --type f | fzf --preview 'batcat --style=numbers --color=always {} || bat --style=numbers --color=always {}') && nvim "$file"
}

# Search in files with preview
search() {
    rg --line-number --no-heading --color=always "$1" | fzf --delimiter ':' --preview 'batcat --style=numbers --color=always --highlight-line {2} {1} || bat --style=numbers --color=always --highlight-line {2} {1}'
}

# Initialize tools
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
fi

# FZF key bindings
if command -v fzf &> /dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.bash 2>/dev/null || true
    source /usr/share/doc/fzf/examples/completion.bash 2>/dev/null || true
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
BASHEOF

echo "✅ Configuration complete!"
echo ""
echo "🔄 To apply all changes, run:"
echo "   source ~/.bashrc"
echo "   or restart your terminal"
echo ""
echo "📖 Check docs/tools-guide.md for usage examples!"
echo ""
