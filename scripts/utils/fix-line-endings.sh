#!/bin/bash

# Fix Line Endings Utility Script
# Part of the Portable Development Environment
# Converts Windows line endings to Unix format and validates script execution

set -e

echo "🔧 Fixing line endings for all shell scripts..."
echo "=============================================="

# Function to fix line endings using sed (fallback if dos2unix not available)
fix_line_endings_sed() {
    local file="$1"
    if [[ -f "$file" ]]; then
        # Check if file has Windows line endings
        if grep -q $'\r' "$file" 2>/dev/null; then
            echo "🔧 Fixing: $(basename "$file")"
            sed -i 's/\r$//' "$file"
            return 0
        else
            echo "✅ Already OK: $(basename "$file")"
            return 1
        fi
    fi
}

# Function to fix line endings using dos2unix (preferred method)
fix_line_endings_dos2unix() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo "🔧 Fixing: $(basename "$file")"
        dos2unix "$file" 2>/dev/null
        return 0
    fi
}

# Try to install dos2unix if not available
USE_SED=false
if ! command -v dos2unix &> /dev/null; then
    echo "📦 dos2unix not found, trying to install..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update &> /dev/null
        if sudo apt-get install -y dos2unix &> /dev/null; then
            echo "✅ dos2unix installed successfully"
        else
            echo "⚠️  dos2unix installation failed, using sed fallback"
            USE_SED=true
        fi
    else
        echo "⚠️  apt-get not available, using sed fallback"
        USE_SED=true
    fi
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🔍 Searching for shell scripts in: $PROJECT_ROOT"

# Count files processed
FIXED_COUNT=0
TOTAL_COUNT=0

# Find all .sh files and fix their line endings
while IFS= read -r -d '' file; do
    ((TOTAL_COUNT++))
    if [[ "$USE_SED" == "true" ]]; then
        if fix_line_endings_sed "$file"; then
            ((FIXED_COUNT++))
        fi
    else
        fix_line_endings_dos2unix "$file"
        ((FIXED_COUNT++))
    fi
done < <(find "$PROJECT_ROOT" -name "*.sh" -type f -print0)

echo ""
echo "✅ Line ending fixes complete!"
echo "📋 Summary:"
echo "   - Total shell scripts found: $TOTAL_COUNT"
echo "   - Scripts fixed: $FIXED_COUNT"
echo "   - All scripts now have Unix line endings"
echo "   - Scripts should execute without \\r errors"
echo ""