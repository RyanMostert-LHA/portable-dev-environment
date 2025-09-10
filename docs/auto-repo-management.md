# Automatic Repository Management

This system automatically switches your GitHub account and git configuration based on repository context (work vs personal).

## 🚀 Features

- **Automatic GitHub account switching** when navigating between work/personal repos
- **Conditional git configuration** with different user settings per repository type
- **Environment-based repository detection** using direnv
- **Smart repository detection** based on remote URLs and directory structure

## 🔧 How It Works

### 1. **Repository Detection Patterns**
- **Work repositories**: `lhasystems/*`, `RyanMostert-LHA/*`
- **Personal repositories**: `RyanMostert/*`, `~/Development/Projects/*`

### 2. **Automatic Switching**
- When you `cd` into a repository, the system detects the type
- GitHub CLI account switches automatically
- Git user configuration adapts to repository context
- Environment variables are set via `.envrc` files

### 3. **Configuration Files**
- `~/.gitconfig` - Main config with conditional includes
- `~/.gitconfig-work` - Work-specific settings (rmostert@lhar.co.za)
- `~/.gitconfig-personal` - Personal settings (ryanmostert@icloud.com)
- `.envrc` - Per-repository environment configuration

## 📖 Usage

### Setup (run once)
```bash
./scripts/setup-auto-repo-management.sh
source ~/.bashrc
```

### Creating .envrc files for repositories
```bash
# For work repositories
cd /path/to/work/repo
create-envrc work
direnv allow

# For personal repositories  
cd /path/to/personal/repo
create-envrc personal
direnv allow
```

### Manual account switching
```bash
# Switch to work account
gh auth switch --user RyanMostert-LHA

# Switch to personal account
gh auth switch --user RyanMostert
```

## 🎯 Benefits

1. **No more manual account switching** - happens automatically
2. **Correct git identity** for each repository type
3. **Seamless workflow** between work and personal projects
4. **Environment isolation** with proper credentials
5. **Neovim GitHub integration** works correctly in any repo

## 🔍 Troubleshooting

### Check current setup
```bash
# View active GitHub account
gh auth status

# Check git config in current repo
git config user.email

# Test direnv
direnv status
```

### Debug repository detection
```bash
# Check remote URL
git remote get-url origin

# Test detection function
gh_auto_switch
```

## 📂 Directory Structure Examples

```
~/
├── clib_work/           # Work repo → RyanMostert-LHA
├── Development/
│   └── Projects/
│       └── personal-project/  # Personal → RyanMostert
└── other-work-repo/     # If contains lhasystems → Work
```

## 🎉 What This Solves

Before this setup, you had to manually:
- Remember which GitHub account to use
- Switch accounts manually with `gh auth switch`
- Configure git user settings per repository
- Deal with authentication errors in Neovim's GitHub integration

Now it's **completely automatic**! 🚀