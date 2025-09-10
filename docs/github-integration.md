# GitHub Integration Guide

## 🚀 GitHub PR Plugin (octo.nvim)

Your AstroNvim setup now includes powerful GitHub integration that lets you:
- Review PRs directly in Neovim
- Read and write PR comments
- Manage GitHub issues
- Approve/request changes on PRs
- Never leave your editor for GitHub workflows

## 🔧 Setup Requirements

### 1. GitHub CLI Authentication
```bash
# Login to GitHub (required for octo.nvim)
gh auth login

# Follow the prompts to authenticate
# Choose: GitHub.com -> HTTPS -> Yes (Git operations) -> Login with browser
```

### 2. Verify Setup
```bash
# Test GitHub CLI access
gh repo view

# Should show your current repository info
```

## ⌨️ Essential Commands

### Pull Requests
```vim
:Octo pr list                    " List all PRs
:Octo pr create                  " Create new PR
:Octo pr edit 123               " Edit/view PR #123
:Octo pr diff 123               " Show PR diff
:Octo pr checkout 123           " Checkout PR branch
:Octo pr merge 123              " Merge PR
:Octo pr close 123              " Close PR
```

### Issues
```vim
:Octo issue list                " List all issues
:Octo issue create              " Create new issue
:Octo issue edit 456            " Edit/view issue #456
:Octo issue close 456           " Close issue
```

### Reviews
```vim
:Octo review start              " Start a PR review
:Octo review submit             " Submit your review
:Octo review comments           " View review comments
```

## 🎯 Keyboard Shortcuts

### Leader Key Shortcuts (Space + ...)
| Shortcut | Action |
|----------|--------|
| `<space>gpl` | List PRs |
| `<space>gpc` | Create PR |
| `<space>gps` | Search PRs |
| `<space>gpr` | Start review |
| `<space>gil` | List issues |
| `<space>gic` | Create issue |
| `<space>gis` | Search issues |

### PR Review Shortcuts
| Shortcut | Action |
|----------|--------|
| `<space>ca` | Add comment |
| `<space>cd` | Delete comment |
| `]c` | Next comment |
| `[c` | Previous comment |
| `<space>po` | Checkout PR |
| `<space>pm` | Merge PR |
| `<space>pd` | Show PR diff |
| `<C-b>` | Open in browser |

### Reactions
| Shortcut | Reaction |
|----------|----------|
| `<space>r+` | 👍 thumbs up |
| `<space>r-` | 👎 thumbs down |
| `<space>rr` | 🚀 rocket |
| `<space>rh` | ❤️ heart |
| `<space>rl` | 😄 laugh |
| `<space>rp` | 🎉 party |

### Review Workflow
| Shortcut | Action |
|----------|--------|
| `<C-a>` | Approve review |
| `<C-r>` | Request changes |
| `<C-m>` | Comment review |
| `<space>sa` | Add suggestion |

## 🎪 Typical Workflow

### 1. List and Select PR
```vim
:Octo pr list
" Select a PR number, then:
:Octo pr edit 123
```

### 2. Review PR
- Read the description and comments
- Check files with `<space>pf`
- View diff with `<space>pd`
- Navigate comments with `]c` and `[c`

### 3. Add Comments
- Position cursor on the line you want to comment
- Press `<space>ca` to add comment
- Type your comment and save

### 4. Submit Review
```vim
:Octo review start
" Add multiple comments, then:
:Octo review submit
" Choose: approve, request changes, or comment
```

### 5. Checkout and Test
```vim
" Checkout the PR branch locally
<space>po

" Test the changes, then switch back
:Git checkout main
```

## 💡 Pro Tips

1. **Use in any Git repository** - Just navigate to a repo and run `:Octo pr list`

2. **Quick navigation** - Use `gf` to jump to files mentioned in comments

3. **Browser fallback** - Press `<C-b>` to open current PR/issue in browser

4. **Bulk operations** - Select multiple PRs in list view for bulk actions

5. **Search filters** - Use `:Octo pr search author:username` for advanced filtering

6. **Draft PRs** - Create draft PRs with `:Octo pr create draft`

## 🔍 Troubleshooting

### Authentication Issues
```bash
# Re-authenticate with GitHub
gh auth refresh

# Check authentication status
gh auth status
```

### Repository Not Found
```bash
# Make sure you're in a Git repository
git remote -v

# Should show GitHub URLs
```

### Plugin Not Loading
```vim
" Check if plugin loaded
:Lazy

" Look for 'octo.nvim' in the list
" If issues, try:
:Lazy sync
```

## 🚀 Getting Started

1. **Open any GitHub repository** in your terminal
2. **Launch Neovim**: `nvim`
3. **List PRs**: `:Octo pr list`
4. **Select a PR**: `:Octo pr edit [number]`
5. **Start reviewing!** 🎉

Your GitHub workflow just got supercharged! 🚀