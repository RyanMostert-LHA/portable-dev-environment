#!/bin/bash

# Terminal Programming & Navigation Tools Installation Script
# Part of the Portable Development Environment
# https://github.com/RyanMostert/portable-dev-environment

set -e

echo "🚀 Installing Terminal Programming & Navigation Tools..."
echo "=================================================="

# Update package lists
echo "📦 Updating package lists..."
sudo apt update

# File Navigation & Management
echo "📁 Installing file navigation tools..."
sudo apt install -y ranger nnn mc eza tree

# Search & Text Processing
echo "🔍 Installing search and text processing tools..."
sudo apt install -y ripgrep fd-find fzf bat jq

# Terminal Enhancements
echo "🚀 Installing terminal enhancements..."
sudo apt install -y tmux

# Install Starship prompt
echo "⭐ Installing Starship prompt..."
if ! command -v starship &> /dev/null; then
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
fi

# Development Tools
echo "💻 Installing development tools..."
sudo apt install -y git-delta htop btop ncdu

# Install lazygit
echo "📊 Installing lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
fi

# Quality of Life Utilities
echo "🎨 Installing quality of life utilities..."
sudo apt install -y trash-cli pipx

# Install thefuck via pipx
echo "🔧 Installing thefuck..."
if ! command -v thefuck &> /dev/null; then
    pipx install thefuck
fi

# Programming Language Tools
echo "🛠️  Installing programming language tools..."

# Install Rust
echo "🦀 Installing Rust toolchain..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
fi

# Node.js is already installed via nodesource repository

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 Installed tools:"
echo "   📁 File Navigation: ranger, nnn, mc, eza, tree"
echo "   🔍 Search & Text: ripgrep, fd-find, fzf, bat, jq"
echo "   🚀 Terminal: tmux, starship"
echo "   💻 Development: git-delta, lazygit, htop, btop, ncdu"
echo "   🎨 Quality of Life: trash-cli, thefuck"
echo "   🛠️  Languages: Rust, Node.js"
echo ""
echo "🔧 Next steps:"
echo "   1. Run: source ~/.bashrc (or restart your terminal)"
echo "   2. Run: ./scripts/configure-tools.sh to set up configurations"
echo "   3. Check the docs/tools-guide.md for usage examples"
echo ""
