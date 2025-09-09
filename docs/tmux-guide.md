# tmux Easy Controls Guide

## 🎯 Super Easy Controls Setup

This tmux configuration provides intuitive controls for terminal multiplexing with mouse support and easy keyboard shortcuts.

## 📋 SUPER EASY CONTROLS (No Prefix Needed)

| Action | Keybinding | Description |
|--------|------------|-------------|
| Switch between panes | `Alt + Arrow Keys` | Navigate panes instantly |
| Switch between windows | `Shift + Left/Right` | Navigate windows instantly |
| Mouse support | `Click/Drag` | Select panes, resize, scroll |

## ⌨️ EASY SHORTCUTS (Ctrl-a + key)

| Action | Keybinding | Description |
|--------|------------|-------------|
| Split pane vertically | `Ctrl-a + \|` or `Ctrl-a + h` | Create vertical split |
| Split pane horizontally | `Ctrl-a + -` or `Ctrl-a + v` | Create horizontal split |
| Reload tmux config | `Ctrl-a + r` | Reload configuration |
| New window | `Ctrl-a + n` | Create new window |
| Close current pane | `Ctrl-a + x` | Kill current pane |
| Close current window | `Ctrl-a + X` | Kill current window |
| Choose session | `Ctrl-a + s` | Session selector |
| New session | `Ctrl-a + S` | Create new session |

## 🎮 VIM-STYLE NAVIGATION (Ctrl-a + key)

| Action | Keybinding | Description |
|--------|------------|-------------|
| Navigate panes | `Ctrl-a + h/j/k/l` | Move left/down/up/right |
| Resize panes | `Ctrl-a + H/J/K/L` | Resize left/down/up/right |

## 💡 Quick Start Commands

```bash
# Basic tmux commands
tmux                    # Start new tmux session
tmux new-session -s dev # Start named session
tmux list-sessions      # List all sessions
tmux attach -t dev      # Attach to named session
tmux kill-session -t dev # Kill named session

# Inside tmux session
Ctrl-a + d             # Detach session (keeps running)
exit                   # Exit current pane/window
```

## 🎨 Mouse Support Features

- **Click to select panes** - No keyboard needed
- **Drag borders to resize** - Intuitive pane sizing
- **Scroll to navigate history** - Natural scrolling
- **Right-click for context menu** - Additional options

## 🔄 Sample Development Workflow

```bash
# 1. Start a project session
tmux new-session -s myproject

# 2. Split into development layout
Ctrl-a + |    # Vertical split for editor/terminal
Ctrl-a + -    # Horizontal split for logs/commands

# 3. Navigate with ease
Alt + Arrows  # Switch between panes
Shift + Left/Right # Switch between windows

# 4. Open editor in one pane
nvim          # Launch AstroNvim

# 5. Detach when done (keeps everything running)
Ctrl-a + d

# 6. Reattach later
tmux attach -t myproject
```

## 🛠️ Configuration Files

- **Config location**: `~/.tmux.conf`
- **This guide**: `~/.tmux-guide.md`
- **Reload config**: `Ctrl-a + r` or `tmux source-file ~/.tmux.conf`

## 🎯 Pro Tips

1. **Start with mouse**: Use mouse for initial learning, then graduate to keyboard shortcuts
2. **Name your sessions**: `tmux new-session -s projectname` for easy identification
3. **Detach often**: `Ctrl-a + d` keeps your work safe and running
4. **Use multiple windows**: `Ctrl-a + n` for different aspects of your project
5. **Combine with AstroNvim**: Perfect terminal-based development environment

## 🔧 Customization

The configuration prioritizes:
- **Ease of use**: Mouse support and no-prefix shortcuts
- **Intuitive keybindings**: Logical symbols (| for vertical, - for horizontal)
- **Visual feedback**: Colored borders and status bar
- **Performance**: Fast escape times and large history buffer

## 📚 Additional Resources

- tmux official documentation: `man tmux`
- Configuration file: `~/.tmux.conf`
- Reload configuration: `Ctrl-a + r`

Happy multiplexing! 🚀