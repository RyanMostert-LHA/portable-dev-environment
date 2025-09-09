# 🚀 AstroNvim Quick Start Guide

> **New to Vim? Start here!** Master these 20 commands first.

## 🎯 The Absolute Essentials (Learn These First!)

### Getting In and Out
```
nvim filename     # Open nvim with a file
:w                # Save file
:q                # Quit
:wq               # Save and quit
:q!               # Quit without saving (force)
```

### The Sacred Movement Keys (hjkl)
```
h  ←  Move left
j  ↓  Move down  
k  ↑  Move up
l  →  Move right
```

### Modes (The Vim Way)
```
i        # INSERT mode - start typing
Esc      # NORMAL mode - back to navigation
v        # VISUAL mode - select text
```

### Your First 10 AstroNvim Commands
```
Space + e      # Open file explorer (Neo-tree)
Space + f + f  # Find files (fuzzy finder)
Space + ?      # Open this cheatsheet!
i              # Start typing (insert mode)
Esc            # Stop typing (normal mode)
:w             # Save your work
u              # Undo last change
dd             # Delete entire line
yy             # Copy entire line  
p              # Paste
```

## 🎮 Your First Session Workflow

1. **Open nvim**: `nvim`
2. **Open file explorer**: Press `Space` then `e`
3. **Navigate in Neo-tree**: Use `j/k` to move, `Enter` to open
4. **Start editing**: Press `i` to type
5. **Stop editing**: Press `Esc` to get back to normal mode
6. **Save**: Type `:w` and press Enter
7. **Quit**: Type `:q` and press Enter

## 🔑 Key Concept: Leader Key = Space

In AstroNvim, almost every custom command starts with the **Space** bar. When you see `<Leader>` in documentation, that means **Space**.

## 🆘 Emergency Commands (When You're Stuck)

```
Esc Esc Esc    # Get back to normal mode (press multiple times)
:q!            # Quit without saving (escape hatch)
u              # Undo if you messed something up
Space + ?      # Open help cheatsheet
```

## 📚 Learning Path

### Week 1: Basic Survival
- Master `hjkl` movement
- Learn `i` (insert) and `Esc` (normal mode)
- Practice `:w` (save) and `:q` (quit)
- Use `Space + e` for file explorer

### Week 2: Text Editing
- Learn `dd` (delete line), `yy` (copy line), `p` (paste)
- Try `u` (undo) and `Ctrl+r` (redo)
- Practice `w` and `b` for word movement

### Week 3: File Management  
- Master `Space + ff` (find files)
- Learn `Space + fw` (find words in project)
- Try buffer navigation with `]b` and `[b`

### Week 4: Advanced Movement
- Learn `0` (start of line), `$` (end of line)
- Try `gg` (top of file), `G` (bottom of file)
- Practice `f` + letter to jump to character

## 🎯 Practice Exercise

Try this 5-minute exercise:
1. Open nvim: `nvim practice.txt`
2. Enter insert mode: `i`
3. Type: "Hello AstroNvim!"
4. Exit insert mode: `Esc`
5. Copy the line: `yy`
6. Paste it: `p`
7. Save: `:w`
8. Quit: `:q`

## 🚀 When You're Ready for More

Open the full cheatsheet anytime with: `Space + ?`

**Remember: Everyone starts slow with Vim. Give yourself 2 weeks to feel comfortable!**

---
*Press `Space + ?` for the complete cheatsheet*