#!/bin/bash
# Simple script to verify AstroNvim and vim-reference-panel setup

echo "🔍 Checking AstroNvim and vim-reference-panel setup..."
echo "=================================================="

# Check if AstroNvim is installed
if [[ -d "$HOME/.config/nvim" ]]; then
    echo "✅ AstroNvim directory exists at ~/.config/nvim"
else
    echo "❌ AstroNvim not found at ~/.config/nvim"
    exit 1
fi

# Check if vim-reference-panel plugin file exists
if [[ -f "$HOME/.config/nvim/lua/plugins/vim-reference-panel.lua" ]]; then
    echo "✅ vim-reference-panel.lua found in plugins directory"
else
    echo "❌ vim-reference-panel.lua not found"
    exit 1
fi

# Check if Neovim is installed
if command -v nvim &> /dev/null; then
    nvim_version=$(nvim --version | head -n1)
    echo "✅ Neovim is installed: $nvim_version"
else
    echo "❌ Neovim not found"
    exit 1
fi

echo ""
echo "🚀 Setup Status: READY"
echo ""
echo "📋 Next Steps:"
echo "1. Open Neovim: nvim"
echo "2. Wait for plugins to install (first time only)"
echo "3. The vim reference panel should appear on the right side"
echo "4. Press F12 to toggle the panel on/off"
echo ""
echo "📚 The panel contains:"
echo "   • Movement commands (hjkl, word navigation)"
echo "   • Editing commands (insert, delete, change, yank)"
echo "   • Buffer and window management"
echo "   • Search and file operations"
echo "   • Visual mode commands"
echo "   • AstroNvim specific shortcuts"