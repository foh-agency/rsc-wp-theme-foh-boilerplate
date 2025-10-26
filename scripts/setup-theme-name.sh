#!/bin/bash

# FOH WordPress Theme Namespace Setup Script
# This script automates the namespace replacement process described in the README

# SCRIPT SETTINGS

# -e           Exit immediately if any command returns a non-zero status (fails).
# -u           Exit if you try to use an undefined variable.
# -o pipefail  Fail if any command in the pipe fails, not just the last one.
set -euo pipefail

# Disable terminal bell
set bell-style none 2>/dev/null || true

# Options to debug this script
# set -x # Debug
# set -v # Verbose
# set -n # No execute / syntax check
# set -o # Show all current settings

# CONSTANTS

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Common exclusion paths for find commands (global variable)
EXCLUDE_PATHS='-not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/dist/*"'

# File extensions that should be processed (text files only)
TEXT_FILE_EXTENSIONS='-name "*.php" -o -name "*.js" -o -name "*.css" -o -name "*.scss" -o -name "*.json" -o -name "*.md" -o -name "*.txt" -o -name "*.pot" -o -name "*.xml" -o -name "*.yml" -o -name "*.yaml" -o -name "*.ini" -o -name "*.conf"'

# LOGGERS

# Function to print colored output to stderr
print_info() {
    echo -e "${BLUE}ℹ${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}✓${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1" >&2
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}


# UTILITIES

check_git_status() {
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            print_warning "You have uncommitted changes in git!"
            print_warning ${BOLD}"It's highly recommended to commit or stash changes first."${NC}
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "You have cancelled theme setup. Get to a clean git state, then try again."
                exit 0
            fi
        else
            print_success "✓ Git working directory is clean"
        fi
    fi
}

# Function to check if we're in the theme directory
check_theme_directory() {
    if [ ! -f "style.css" ] || [ ! -f "functions.php" ]; then
        print_error "This doesn't appear to be a WordPress theme directory."
        print_error "Please run this script from the theme root (where style.css is located)."
        exit 1
    fi
    
    if ! grep -q "FOH" style.css; then
        print_error "This doesn't appear to be the FOH boilerplate theme."
        print_error "Make sure you're in the right directory with the FOH theme files."
        exit 1
    fi
    
    # Check git status for safety
    check_git_status
}

# Function to validate slug format (letters only)
validate_slug() {
    local slug=$1
    if [[ ! $slug =~ ^[a-z]+$ ]]; then
        print_error "Invalid slug format. Use only lowercase letters (no numbers or special characters)."
        return 1
    fi
    return 0
}

# Function to generate title case name from slug
generate_title_case() {
    local slug=$1
    # Capitalize first letter
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${slug:0:1})${slug:1}"
}


# USER INPUT

get_theme_slug() {
    # Get the new namespace/slug from user
    echo "Enter your namespace slug (e.g., 'mega' for Megatherium Theme):"
    echo "This will be used as:"
    echo "  - Theme directory name"
    echo "  - Text domain"
    echo "  - Prefix for constants and function names"
    echo "  - File names"
    echo
    echo "Note: Use only lowercase letters (no numbers or special characters)"
    echo
    read -p "Theme slug (mega): " THEME_SLUG
    THEME_SLUG=${THEME_SLUG:-mega}

    # Validate slug
    if ! validate_slug "$THEME_SLUG"; then
        exit 1
    fi

    # Generate variations
    THEME_SLUG_UPPER=$(echo "$THEME_SLUG" | tr '[:lower:]' '[:upper:]')
    THEME_SLUG_TITLE=$(generate_title_case "$THEME_SLUG")
    
    echo
    print_info "Namespace variations:"
    echo "  Slug: ${THEME_SLUG}"
    echo "  Uppercase: ${THEME_SLUG_UPPER}"
    echo "  Title Case: ${THEME_SLUG_TITLE}"
    echo
    
    read -p "Does this look correct? [Y/n]: " -n 1 -r
    echo
    # Default to 'y' if empty (just Enter pressed)
    REPLY=${REPLY:-y}
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled."
        exit 1
    fi
}

# Function to get theme information
get_theme_info() {
    echo
    print_info "Now let's update the theme information in style.css..."
    echo
    
    # Get theme name
    read -p "Enter theme name (Megatherium Theme): " -r THEME_NAME
    THEME_NAME=${THEME_NAME:-"Megatherium Theme"}
    
    # Get theme description
    read -p "Enter theme description (A test WordPress theme): " -r THEME_DESCRIPTION
    THEME_DESCRIPTION=${THEME_DESCRIPTION:-"A test WordPress theme"}
    
    # Get author name
    read -p "Enter author name (Test Author): " -r THEME_AUTHOR
    THEME_AUTHOR=${THEME_AUTHOR:-"Test Author"}
}

# Function to get and validate repository URL
get_repository_url() {
    echo
    read -p "Enter the repository URL in HTTPS or SSH format (https://github.com/testuser/test-theme): " -r REPO_URL
    REPO_URL=${REPO_URL:-"https://github.com/testuser/test-theme"}
    
    # Convert SSH format to HTTPS if needed
    if [[ "$REPO_URL" =~ ^git@github\.com: ]]; then
        # Convert git@github.com:username/repo.git to https://github.com/username/repo.git
        REPO_URL="https://github.com/${REPO_URL#git@github.com:}"
        print_info "Converted SSH format to HTTPS"
    fi
    
    # Validate GitHub URL format
    if [[ ! "$REPO_URL" =~ ^https://github\.com ]]; then
        print_error "Doesn't appear to be a valid GitHub address. URL must start with https://github.com"
        exit 1
    fi
    
    # Clean up URL: remove .git suffix if present
    if [[ "$REPO_URL" =~ \.git$ ]]; then
        REPO_URL="${REPO_URL%.git}"
        print_info "Removed .git suffix from URL"
    fi
    
    # Clean up URL: remove trailing slash if present
    if [[ "$REPO_URL" =~ /$ ]]; then
        REPO_URL="${REPO_URL%/}"
        print_info "Removed trailing slash from URL"
    fi
    
    print_info "Using repository URL: ${REPO_URL}"
}

# Function to get final confirmation
get_final_confirmation() {
    echo
    echo -e "${BOLD}Are you ready to modify files in place?${NC}"
    print_warning "Make sure you have a backup or clean git state!"
    read -p "Continue? [Y/n]: " -n 1 -r
    echo
    # Default to 'y' if empty (just Enter pressed)  
    REPLY=${REPLY:-y}
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled."
        exit 1
    fi
}

get_user_input() {
    get_theme_slug
    get_theme_info
    get_repository_url
    get_final_confirmation
}

# MAIN LOGIC

main() {
    
    clear
    echo
    echo
    echo "═══════════════════════════════════════════════════════"
    echo "   FOH WordPress Theme - Namespace Setup"
    echo "═══════════════════════════════════════════════════════"
    echo

    # Check if we're in the right directory
    check_theme_directory

    get_user_input

    echo
    print_info "Starting namespace replacement..."
    echo
}

main
