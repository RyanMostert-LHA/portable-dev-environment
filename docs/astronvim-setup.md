# AstroNvim Configuration Guide

## 🚀 Current Setup Status

✅ **Neovim**: v0.11.4 (Latest)  
✅ **AstroNvim**: Installed at `~/.config/nvim/`  
✅ **Dependencies**: ripgrep, fd-find installed  

## 🎯 First Time Setup

```bash
# 1. Launch AstroNvim (will auto-install plugins)
nvim

# 2. Wait for all plugins to install
# (This happens automatically on first run)

# 3. Restart Neovim after installation
:q
nvim
```

## ⌨️ Essential AstroNvim Keybindings

### File Operations
| Action | Keybinding | Description |
|--------|------------|-------------|
| File Explorer | `<Space> + e` | Toggle file tree |
| Find Files | `<Space> + f + f` | Fuzzy find files |
| Find Text | `<Space> + f + w` | Search text in files |
| Recent Files | `<Space> + f + o` | Open recent files |
| Save File | `<Space> + w` | Save current file |

### Navigation
| Action | Keybinding | Description |
|--------|------------|-------------|
| Go to Definition | `g + d` | Jump to definition |
| Go Back | `<Ctrl> + o` | Go back in jump list |
| Go Forward | `<Ctrl> + i` | Go forward in jump list |
| Next Buffer | `]b` | Next open file |
| Previous Buffer | `[b` | Previous open file |

### Git Integration
| Action | Keybinding | Description |
|--------|------------|-------------|
| Git Status | `<Space> + g + s` | Open Git status |
| Git Commits | `<Space> + g + c` | Browse commits |
| Git Branches | `<Space> + g + b` | Browse branches |
| Git Diff | `<Space> + g + d` | Show file diff |

### Terminal
| Action | Keybinding | Description |
|--------|------------|-------------|
| Toggle Terminal | `<Space> + t + f` | Float terminal |
| Horizontal Terminal | `<Space> + t + h` | Horizontal split |
| Vertical Terminal | `<Space> + t + v` | Vertical split |

### Code Actions
| Action | Keybinding | Description |
|--------|------------|-------------|
| Code Actions | `<Space> + l + a` | Show code actions |
| Format Document | `<Space> + l + f` | Format current file |
| Rename Symbol | `<Space> + l + r` | Rename variable/function |
| Show Diagnostics | `<Space> + l + d` | Show error diagnostics |

## 🛠️ Language Server Setup

AstroNvim will automatically prompt to install language servers for:
- **Python**: pylsp, pyright
- **JavaScript/TypeScript**: tsserver
- **JSON**: jsonls
- **Lua**: lua_ls
- **Bash**: bashls

## 🎨 Customization

### User Configuration
Create custom config at `~/.config/nvim/lua/user/`:

```bash
# Create user configuration directory
mkdir -p ~/.config/nvim/lua/user

# Basic user config example
cat > ~/.config/nvim/lua/user/init.lua << 'USEREOF'
return {
  -- Set colorscheme
  colorscheme = "astrodark",
  
  -- Configure AstroNvim options
  options = {
    opt = {
      relativenumber = true, -- Show relative line numbers
      wrap = false,         -- Disable line wrapping
      tabstop = 2,          -- Tab width
      shiftwidth = 2,       -- Indent width
    },
  },
}
USEREOF
```

## 🔧 Plugin Management

```bash
# Update all plugins
:AstroUpdate

# Install new plugin
:AstroInstall

# Check plugin status
:AstroHealth

# Reload configuration
:AstroReload
```

## 💡 Pro Tips

1. **Start Simple**: Learn `<Space> + e` (file explorer) and `<Space> + f + f` (find files) first
2. **Use Which-Key**: Press `<Space>` and wait - shows all available shortcuts
3. **Terminal Integration**: Use `<Space> + t + f` for floating terminal
4. **Git Workflow**: Use `<Space> + g + s` for git status and staging
5. **Language Features**: Install language servers when prompted

## 🎯 Quick Development Workflow

```bash
# 1. Start AstroNvim
nvim

# 2. Open file explorer
<Space> + e

# 3. Navigate and open files
<Enter> to open file

# 4. Find files quickly
<Space> + f + f
# Type filename and <Enter>

# 5. Search for text
<Space> + f + w
# Type search term

# 6. Git operations
<Space> + g + s  # Git status
<Space> + g + c  # Commits

# 7. Code actions
<Space> + l + a  # Code actions
<Space> + l + f  # Format code
```

## 🔄 Integration with tmux

Perfect combination:
```bash
# 1. Start tmux session
tmux new-session -s dev

# 2. Split for editor and terminal
Ctrl-a + |  # Vertical split

# 3. In left pane: Launch AstroNvim
nvim

# 4. In right pane: Run commands, git, etc.
# Use Alt + Arrows to switch between panes
```

## 📚 Learning Resources

- **Built-in Help**: `:help` in Neovim
- **AstroNvim Docs**: Check `~/.config/nvim/README.md`
- **Which-Key**: Press `<Space>` to see available commands
- **Telescope**: `<Space> + f` shows all find options

## 🛟 Troubleshooting

```bash
# Check AstroNvim health
nvim -c ":AstroHealth"

# Reset if needed (backup first!)
mv ~/.config/nvim ~/.config/nvim.backup
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

# Check Neovim config
nvim -c ":checkhealth"
```

Happy coding with AstroNvim! 🚀