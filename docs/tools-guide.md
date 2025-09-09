# Terminal Programming & Navigation Tools Guide

## 🎯 Quick Start

After running the installation and configuration scripts:

```bash
./scripts/install-tools.sh      # Install all tools
./scripts/configure-tools.sh    # Configure tools
source ~/.bashrc                # Apply changes
```

## 📁 File Navigation & Management

### **eza** (Modern ls replacement)
```bash
# Basic usage (aliased to ls, ll, la)
ls              # List files with icons
ll              # Detailed list with icons
la              # Show all files including hidden
tree            # Tree view (eza --tree)
```

### **ranger** (Terminal file manager)
```bash
ranger          # Launch file manager

# Key bindings in ranger:
# h,j,k,l        - Navigate (vim-style)
# Enter          - Enter directory/open file
# q              - Quit
```

## 🔍 Search & Text Processing

### **ripgrep (rg)** - Ultra-fast grep
```bash
rg "pattern" .                    # Search in current directory
rg -i "pattern"                   # Case insensitive
rg --type js "function"           # Search only JavaScript files
```

### **fd** - Better find
```bash
fd filename                       # Find file by name
fd -t f "\.js$"                  # Find JavaScript files
fd -t d config                   # Find directories named 'config'
```

### **fzf** - Fuzzy finder
```bash
fzf                              # Interactive file selector
# Ctrl+R         - Command history search
# Ctrl+T         - File search
```

### **bat** - Better cat
```bash
bat file.txt                     # Syntax highlighted output (aliased to cat)
```

## 🚀 Terminal Enhancements

### **tmux** - Terminal multiplexer
```bash
tmux                             # Start new session
tmux new -s name                 # Named session
tmux attach -t name              # Attach to session
```

### **Starship** - Smart prompt
- Shows git status, language versions, and command time

## 💻 Development Tools

### **lazygit** - Git TUI
```bash
lg                               # Launch lazygit (alias)
```

### **git-delta** - Better git diff
```bash
git diff                         # Enhanced diff view
```

### **btop** - System monitor
```bash
btop                             # Modern system monitor (aliased to top)
```

## 🎨 Quality of Life

### **trash-cli** - Safe file deletion
```bash
rm file.txt                      # Move to trash (safe, aliased)
trash-list                       # List trashed files
```

### **thefuck** - Command correction
```bash
fuck                             # Corrects last command after typo
```

## 🛠️ Programming Languages

### **Rust** (Installed via rustup)
```bash
cargo new project                # Create new project
cargo build                      # Build project
cargo run                        # Run project
```

## ⚡ Pro Tips

```bash
# Find and edit files
fd "\.js$" | fzf | xargs nvim

# Search for TODO comments
rg -n "TODO" | fzf | cut -d: -f1 | xargs nvim

# Project-specific tmux session
tmux new -s myproject
```
