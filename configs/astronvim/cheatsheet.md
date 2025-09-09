# 🚀 AstroNvim Cheatsheet

> **Your comprehensive guide to mastering AstroNvim**  
> Press `<Leader>?` anytime to open this cheatsheet!

## 📖 Table of Contents
- [🎯 Essential Basics](#-essential-basics)
- [🗂️ File Management](#️-file-management) 
- [📝 Editing & Text Objects](#-editing--text-objects)
- [🔍 Search & Replace](#-search--replace)
- [🌳 Neo-tree File Explorer](#-neo-tree-file-explorer)
- [🔧 LSP & Code Features](#-lsp--code-features)
- [🐛 Debugging (DAP)](#-debugging-dap)
- [🌿 Git Integration](#-git-integration)
- [💻 Terminal & Toggleterm](#-terminal--toggleterm)
- [🪟 Window & Buffer Management](#-window--buffer-management)
- [⚙️ Configuration & Help](#️-configuration--help)

---

## 🎯 Essential Basics

### Modes
| Key | Action | Description |
|-----|--------|-------------|
| `i` | Insert mode | Start typing text |
| `a` | Insert after cursor | Insert mode after current character |
| `I` | Insert at line start | Insert at beginning of line |
| `A` | Insert at line end | Insert at end of line |
| `o` | New line below | Create new line and enter insert mode |
| `O` | New line above | Create new line above and enter insert mode |
| `Esc` | Normal mode | Return to normal mode |
| `v` | Visual mode | Select text |
| `V` | Visual Line mode | Select entire lines |
| `Ctrl+v` | Visual Block mode | Select rectangular blocks |

### Movement (The Holy Grail)
| Key | Action | Description |
|-----|--------|-------------|
| `h` `j` `k` `l` | ← ↓ ↑ → | Basic movement |
| `w` | Next word | Jump to start of next word |
| `b` | Previous word | Jump to start of previous word |
| `e` | End of word | Jump to end of current word |
| `0` | Line start | Jump to beginning of line |
| `$` | Line end | Jump to end of line |
| `^` | First non-blank | Jump to first non-whitespace character |
| `gg` | File start | Jump to beginning of file |
| `G` | File end | Jump to end of file |
| `{` `}` | Paragraph | Jump between paragraphs |
| `Ctrl+u` | Half page up | Scroll half page up |
| `Ctrl+d` | Half page down | Scroll half page down |
| `zz` | Center cursor | Center current line on screen |

### Quick Actions
| Key | Action | Description |
|-----|--------|-------------|
| `u` | Undo | Undo last change |
| `Ctrl+r` | Redo | Redo last undone change |
| `.` | Repeat | Repeat last command |
| `yy` | Copy line | Yank entire line |
| `dd` | Delete line | Delete entire line |
| `p` | Paste after | Paste below cursor |
| `P` | Paste before | Paste above cursor |
| `x` | Delete char | Delete character under cursor |
| `r` | Replace char | Replace single character |

---

## 🗂️ File Management

### AstroNvim File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>ff` | Find files | Telescope file finder |
| `<Leader>fo` | Find old files | Recently opened files |
| `<Leader>fw` | Find words | Live grep in project |
| `<Leader>fc` | Find config | Find config files |
| `<Leader>fh` | Find help | Search help tags |
| `<Leader>fk` | Find keymaps | Search keybindings |
| `<Leader>fm` | Find man pages | Search manual pages |
| `<Leader>fr` | Find registers | Search vim registers |
| `<Leader>ft` | Find themes | Browse colorschemes |

### Buffer Management
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>c` | Close buffer | Close current buffer |
| `<Leader>C` | Close all buffers | Close all but current |
| `<Leader>bd` | Pick buffer to close | Interactive buffer close |
| `]b` | Next buffer | Switch to next buffer |
| `[b` | Previous buffer | Switch to previous buffer |
| `<Leader>bb` | Browse buffers | Telescope buffer picker |
| `<Leader>b\` | Close all left | Close buffers to the left |
| `<Leader>b|` | Close all right | Close buffers to the right |

### File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `:w` | Save file | Write current buffer |
| `:wa` | Save all | Write all modified buffers |
| `:q` | Quit | Close current window |
| `:qa` | Quit all | Close all windows |
| `:wq` | Save and quit | Write and close |
| `:q!` | Force quit | Quit without saving |
| `<Leader>fn` | New file | Create new file |

---

## 📝 Editing & Text Objects

### Text Objects (Power User Magic!)
| Pattern | Action | Description |
|---------|--------|-------------|
| `ci"` | Change inside quotes | Change text inside " " |
| `ca"` | Change around quotes | Change text including " " |
| `ci(` | Change inside parens | Change text inside ( ) |
| `ca(` | Change around parens | Change text including ( ) |
| `ci{` | Change inside braces | Change text inside { } |
| `cit` | Change inside tag | Change text inside HTML tag |
| `ciw` | Change inside word | Change current word |
| `caw` | Change around word | Change word including spaces |
| `ci]` | Change inside brackets | Change text inside [ ] |
| `dis` | Delete inside sentence | Delete current sentence |

### Replace Text Objects with:
- `d` = delete
- `y` = yank (copy)  
- `c` = change (delete and enter insert mode)
- `v` = visual select

### Advanced Editing
| Key | Action | Description |
|-----|--------|-------------|
| `J` | Join lines | Join current line with next |
| `gJ` | Join without space | Join lines without adding space |
| `<<` | Indent left | Decrease indentation |
| `>>` | Indent right | Increase indentation |
| `=` | Auto-indent | Fix indentation |
| `gq` | Format text | Reformat paragraph |
| `gU` | Uppercase | Make text uppercase |
| `gu` | Lowercase | Make text lowercase |
| `~` | Toggle case | Switch case of character |

---

## 🔍 Search & Replace

### Basic Search
| Key | Action | Description |
|-----|--------|-------------|
| `/` | Search forward | Search for pattern |
| `?` | Search backward | Search backward for pattern |
| `n` | Next match | Jump to next search result |
| `N` | Previous match | Jump to previous search result |
| `*` | Search word | Search for word under cursor |
| `#` | Search word back | Search backward for word under cursor |
| `<Leader>h` | Clear highlights | Clear search highlighting |

### AstroNvim Search
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>fw` | Find words | Live grep in workspace |
| `<Leader>fW` | Find words cursor | Search word under cursor |
| `<Leader>fs` | Find symbols | Search LSP symbols |
| `<Leader>fS` | Find symbols (all) | Search symbols in workspace |

### Replace
| Command | Action | Description |
|---------|--------|-------------|
| `:s/old/new/` | Replace first | Replace first occurrence in line |
| `:s/old/new/g` | Replace all line | Replace all in current line |
| `:%s/old/new/g` | Replace all file | Replace all in entire file |
| `:%s/old/new/gc` | Replace confirm | Replace with confirmation |
| `:s/\<old\>/new/g` | Replace whole word | Replace only whole words |

---

## 🌳 Neo-tree File Explorer

### Basic Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>e` | Toggle explorer | Open/close Neo-tree |
| `<Leader>o` | Focus explorer | Focus on Neo-tree window |

### In Neo-tree Window
| Key | Action | Description |
|-----|--------|-------------|
| `<CR>` | Open file | Open file or expand folder |
| `<Tab>` | Preview | Preview file without opening |
| `l` | Open | Open file/folder |
| `h` | Close folder | Close current folder |
| `a` | Add file/folder | Create new file or folder |
| `d` | Delete | Delete file/folder |
| `r` | Rename | Rename file/folder |
| `x` | Cut | Cut file/folder |
| `c` | Copy | Copy file/folder |
| `p` | Paste | Paste cut/copied item |
| `R` | Refresh | Refresh tree |
| `?` | Help | Show Neo-tree help |
| `q` | Close | Close Neo-tree |

---

## 🔧 LSP & Code Features

### Language Server Features
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to definition | Jump to definition |
| `gD` | Go to declaration | Jump to declaration |
| `gr` | Go to references | Find all references |
| `gI` | Go to implementation | Jump to implementation |
| `gy` | Go to type def | Jump to type definition |
| `K` | Hover info | Show documentation |
| `<Leader>lh` | Signature help | Show function signature |

### Code Actions
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>la` | Code actions | Show available code actions |
| `<Leader>lf` | Format | Format current buffer |
| `<Leader>lr` | Rename | Rename symbol |
| `<Leader>ls` | Document symbols | Show document symbols |
| `<Leader>lS` | Workspace symbols | Show workspace symbols |
| `<Leader>lG` | Workspace diagnostics | Show all diagnostics |

### Diagnostics
| Key | Action | Description |
|-----|--------|-------------|
| `]d` | Next diagnostic | Jump to next diagnostic |
| `[d` | Previous diagnostic | Jump to previous diagnostic |
| `gl` | Line diagnostics | Show line diagnostics |
| `<Leader>ld` | Hover diagnostic | Show diagnostic details |

### Mason Tool Manager
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>lm` | Mason | Open Mason installer |
| `<Leader>lM` | Mason Log | Show Mason log |

---

## 🐛 Debugging (DAP)

### Debug Controls
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>db` | Toggle breakpoint | Set/remove breakpoint |
| `<Leader>dB` | Conditional breakpoint | Set conditional breakpoint |
| `<Leader>dc` | Continue | Continue execution |
| `<Leader>di` | Step into | Step into function |
| `<Leader>do` | Step over | Step over line |
| `<Leader>dO` | Step out | Step out of function |
| `<Leader>dr` | Restart | Restart debugging session |
| `<Leader>ds` | Start | Start debugging |
| `<Leader>dt` | Terminate | Terminate debug session |

### Debug UI
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>du` | Toggle UI | Toggle debug UI |
| `<Leader>dh` | Hover | Debug hover evaluation |
| `<Leader>dp` | Preview | Preview debug info |

---

## 🌿 Git Integration

### Git Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>gg` | Git status | Open git status (lazygit) |
| `<Leader>gc` | Git commits | Browse commits |
| `<Leader>gt` | Git status | Git status in telescope |
| `<Leader>gb` | Git branches | Browse git branches |
| `<Leader>gC` | Git commits (current file) | File commit history |

### Git Signs (Gutter)
| Key | Action | Description |
|-----|--------|-------------|
| `]g` | Next git hunk | Jump to next change |
| `[g` | Previous git hunk | Jump to previous change |
| `<Leader>gh` | Preview hunk | Preview git hunk |
| `<Leader>gr` | Reset hunk | Reset current hunk |
| `<Leader>gR` | Reset buffer | Reset entire buffer |
| `<Leader>gs` | Stage hunk | Stage current hunk |
| `<Leader>gS` | Stage buffer | Stage entire buffer |
| `<Leader>gu` | Unstage hunk | Unstage current hunk |
| `<Leader>gd` | Diff | Show git diff |

---

## 💻 Terminal & Toggleterm

### Terminal Controls
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>t` | Toggle terminal | Toggle floating terminal |
| `<Leader>tf` | Float terminal | Floating terminal |
| `<Leader>th` | Horizontal terminal | Horizontal split terminal |
| `<Leader>tv` | Vertical terminal | Vertical split terminal |
| `<Ctrl>\\` | Toggle terminal | Quick toggle terminal |

### In Terminal Mode
| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl>\\` | Exit terminal mode | Back to normal mode |
| `<Esc><Esc>` | Exit terminal mode | Alternative exit |

---

## 🪟 Window & Buffer Management

### Window Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl>h` | Focus left | Move to left window |
| `<Ctrl>j` | Focus down | Move to window below |
| `<Ctrl>k` | Focus up | Move to window above |
| `<Ctrl>l` | Focus right | Move to right window |

### Window Resizing
| Key | Action | Description |
|-----|--------|-------------|
| `<Ctrl>Left` | Resize left | Decrease width |
| `<Ctrl>Right` | Resize right | Increase width |
| `<Ctrl>Up` | Resize up | Increase height |
| `<Ctrl>Down` | Resize down | Decrease height |

### Window Splitting
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>\\` | Vertical split | Split window vertically |
| `<Leader>-` | Horizontal split | Split window horizontally |
| `<Leader>wd` | Close window | Close current window |

### Tab Management
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader><Tab>` | Next tab | Switch to next tab |
| `<Leader><S-Tab>` | Previous tab | Switch to previous tab |

---

## ⚙️ Configuration & Help

### Help & Documentation
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>?` | Cheatsheet | Open this cheatsheet! |
| `<Leader>h` | Help | Clear search highlights |
| `:h topic` | Help | Get help on topic |
| `<Leader>fh` | Find help | Search help files |
| `<Leader>fk` | Find keymaps | Search all keybindings |

### AstroNvim Specific
| Key | Action | Description |
|-----|--------|-------------|
| `<Leader>pI` | Plugin info | Show plugin info |
| `<Leader>ps` | Plugin sync | Sync plugins |
| `<Leader>pS` | Plugin status | Show plugin status |
| `<Leader>pu` | Plugin update | Update plugins |
| `<Leader>pa` | Plugin manager | Open plugin manager |

### Settings & Options
| Command | Action | Description |
|---------|--------|-------------|
| `:set number` | Show line numbers | Toggle line numbers |
| `:set wrap` | Toggle wrap | Toggle line wrapping |
| `:colorscheme` | Change theme | Change color scheme |
| `:AstroReload` | Reload config | Reload AstroNvim config |

---

## 🎯 Pro Tips for Beginners

### Start with These 10 Commands
1. `<Leader>e` - File explorer
2. `<Leader>ff` - Find files  
3. `i` - Insert mode
4. `Esc` - Normal mode
5. `:w` - Save
6. `:q` - Quit
7. `u` - Undo
8. `dd` - Delete line
9. `yy` - Copy line
10. `p` - Paste

### Essential Workflow
1. **Open nvim**: `nvim` or `nvim filename`
2. **Explore files**: `<Leader>e` (Neo-tree)
3. **Find files**: `<Leader>ff` 
4. **Edit**: `i` to insert, `Esc` to normal mode
5. **Save**: `:w`
6. **Navigate**: `hjkl` or mouse
7. **Find text**: `<Leader>fw`
8. **Quit**: `:q`

### Remember: Leader = Space
Almost every custom command starts with `Space`. When you see `<Leader>`, press the spacebar!

---

## 🚀 Next Steps

1. **Practice basic movements**: hjkl, w/b/e navigation
2. **Master text objects**: Try `ciw`, `ci"`, `ci(`
3. **Use the file finder**: `<Leader>ff` is your best friend
4. **Learn one new command daily**: Pick from this cheatsheet
5. **Customize**: Edit `~/.config/nvim/lua/plugins/user.lua`

**Happy Vimming! 🎉**

---
*Press `<Leader>?` anytime to return to this cheatsheet*