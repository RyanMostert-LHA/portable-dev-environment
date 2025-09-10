#!/bin/bash

# Automatic Repository Management Setup Script
# This script installs and configures automatic GitHub account switching
# based on repository context (work vs personal)

set -e

echo "🚀 Setting up automatic repository management..."

# 1. Install direnv
echo "📦 Installing direnv..."
if ! command -v direnv &> /dev/null; then
    curl -sfL https://direnv.net/install.sh | bash
    echo "✅ direnv installed to ~/.local/bin/direnv"
else
    echo "✅ direnv already installed"
fi

# 2. Create git config files
echo "⚙️  Setting up conditional git configs..."

# Work git config
cat > ~/.gitconfig-work << 'EOF'
[user]
	email = rmostert@lhar.co.za
	name = RyanMostert-LHA

[credential "https://github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

[credential "https://gist.github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

# Work-specific settings
[core]
	editor = nvim

[push]
	default = current

[pull]
	rebase = true
EOF

# Personal git config
cat > ~/.gitconfig-personal << 'EOF'
[user]
	email = ryanmostert@icloud.com
	name = RyanMostert

[credential "https://github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

[credential "https://gist.github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

# Personal-specific settings
[core]
	editor = nvim

[push]
	default = current

[pull]
	rebase = true
EOF

# Update main gitconfig with conditional includes
cat > ~/.gitconfig << 'EOF'
[user]
	email = rmostert@lhar.co.za
	name = RyanMostert-LHA

[credential "https://github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

[credential "https://gist.github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential

# Core settings
[core]
	editor = nvim

[push]
	default = current

[pull]
	rebase = true

# Conditional includes for automatic switching
[includeIf "gitdir:**/lhasystems/**"]
	path = ~/.gitconfig-work

[includeIf "gitdir:**/*RyanMostert-LHA*/**"]
	path = ~/.gitconfig-work

[includeIf "gitdir:**/*RyanMostert*/**"]
	path = ~/.gitconfig-personal

[includeIf "gitdir:~/Development/Projects/**"]
	path = ~/.gitconfig-personal
EOF

echo "✅ Git configs created"

# 3. Create shell functions for automatic GitHub account switching
echo "🔧 Adding shell automation to ~/.bashrc..."

# Check if automation already exists
if ! grep -q "=== Automatic Repository Management ===" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# === Automatic Repository Management ===
# Initialize direnv for automatic environment switching
if command -v direnv &> /dev/null; then
    eval "$(direnv hook bash)"
fi

# Smart GitHub account switching function
gh_auto_switch() {
    local repo_url=$(git remote get-url origin 2>/dev/null || echo "")
    
    if [[ $repo_url == *"github.com"* ]]; then
        if [[ $repo_url == *"lhasystems"* ]] || [[ $repo_url == *"RyanMostert-LHA"* ]]; then
            # Work repositories
            if [[ $(gh auth status 2>&1 | grep "Active account: true" | grep -c "RyanMostert-LHA") -eq 0 ]]; then
                echo "🏢 Switching to work GitHub account (RyanMostert-LHA)..."
                gh auth switch --user RyanMostert-LHA 2>/dev/null || true
            fi
        elif [[ $repo_url == *"RyanMostert"* ]]; then
            # Personal repositories
            if [[ $(gh auth status 2>&1 | grep "Active account: true" | grep -c "RyanMostert") -eq 0 ]]; then
                echo "🏠 Switching to personal GitHub account (RyanMostert)..."
                gh auth switch --user RyanMostert 2>/dev/null || true
            fi
        fi
    fi
}

# Auto-switch on directory change
auto_gh_switch() {
    gh_auto_switch
}

# Hook into cd command
cd() {
    builtin cd "$@" && auto_gh_switch
}

# Run on shell startup if in a git repo
if git rev-parse --is-inside-work-tree &>/dev/null; then
    auto_gh_switch
fi
EOF
    echo "✅ Shell automation added"
else
    echo "✅ Shell automation already exists"
fi

# 4. Create helper function to generate .envrc files
echo "📄 Creating .envrc template generator..."

cat > ~/.local/bin/create-envrc << 'EOF'
#!/bin/bash

# .envrc file generator for automatic repository management

if [[ $# -eq 0 ]]; then
    echo "Usage: create-envrc [work|personal]"
    echo "Creates a .envrc file for automatic GitHub account switching"
    exit 1
fi

if [[ "$1" == "work" ]]; then
    cat > .envrc << 'ENVRC_EOF'
# Work repository environment
# This file automatically switches to work GitHub account when entering this directory

# Set work GitHub account as active
export GITHUB_ACCOUNT="work"
export GIT_AUTHOR_EMAIL="rmostert@lhar.co.za"
export GIT_COMMITTER_EMAIL="rmostert@lhar.co.za"

# Ensure work GitHub CLI account is active
if command -v gh &> /dev/null; then
    if [[ $(gh auth status 2>&1 | grep "Active account: true" | grep -c "RyanMostert-LHA") -eq 0 ]]; then
        echo "🏢 Auto-switching to work GitHub account..."
        gh auth switch --user RyanMostert-LHA 2>/dev/null || true
    fi
fi

echo "📂 Work environment loaded"
ENVRC_EOF
    echo "✅ Work .envrc created"
    
elif [[ "$1" == "personal" ]]; then
    cat > .envrc << 'ENVRC_EOF'
# Personal repository environment
# This file automatically switches to personal GitHub account when entering this directory

# Set personal GitHub account as active
export GITHUB_ACCOUNT="personal"
export GIT_AUTHOR_EMAIL="ryanmostert@icloud.com"
export GIT_COMMITTER_EMAIL="ryanmostert@icloud.com"

# Ensure personal GitHub CLI account is active
if command -v gh &> /dev/null; then
    if [[ $(gh auth status 2>&1 | grep "Active account: true" | grep -c "RyanMostert") -eq 0 ]]; then
        echo "🏠 Auto-switching to personal GitHub account..."
        gh auth switch --user RyanMostert 2>/dev/null || true
    fi
fi

echo "📂 Personal environment loaded"
ENVRC_EOF
    echo "✅ Personal .envrc created"
else
    echo "❌ Invalid option. Use 'work' or 'personal'"
    exit 1
fi

echo "🔧 Run 'direnv allow' to activate this .envrc file"
EOF

chmod +x ~/.local/bin/create-envrc
echo "✅ .envrc generator created at ~/.local/bin/create-envrc"

echo ""
echo "🎉 Automatic repository management setup complete!"
echo ""
echo "📋 What was installed:"
echo "  ✅ direnv for automatic environment switching"
echo "  ✅ Conditional git configs for work/personal repos"
echo "  ✅ Smart GitHub account switching functions"
echo "  ✅ .envrc template generator"
echo ""
echo "🚀 How to use:"
echo "  • Restart your shell: source ~/.bashrc"
echo "  • Navigate to any git repository"
echo "  • Your GitHub account will auto-switch based on repo context"
echo "  • Create .envrc files with: create-envrc work|personal"
echo ""
echo "🔧 Manual setup for existing repos:"
echo "  • cd your-repo && create-envrc work"
echo "  • direnv allow"
echo ""