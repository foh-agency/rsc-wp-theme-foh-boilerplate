#!/bin/bash

# FOH WordPress Theme Namespace Setup Script
# This script automates the namespace replacement process described in the README

# -e           Exit immediately if any command returns a non-zero status (fails).
# -u           Exit if you try to use an undefined variable.
# -o pipefail  Fail if any command in the pipe fails, not just the last one.
set -euo pipefail

# Options to debug this script
# set -x # Debug
# set -v # Verbose
# set -n # No execute / syntax check
# set -o # Show all current settings

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
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
    fi
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

# Function to perform safe replacement (avoiding URLs)
safe_replace() {
    local file=$1
    local pattern=$2
    local replacement=$3
    local temp_file="${file}.tmp"
    
    # Use awk to skip lines containing URLs (http://, https://, //)
    awk -v pattern="$pattern" -v replacement="$replacement" '
    {
        # Check if line contains a URL pattern
        if ($0 ~ /https?:\/\/|\/\/[a-zA-Z0-9]/) {
            # Line contains URL, print as-is
            print $0
        } else {
            # Safe to do replacement
            gsub(pattern, replacement)
            print $0
        }
    }
    ' "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
}

# Main script
main() {
    # Common exclusion paths for find commands
    local EXCLUDE_PATHS='-not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/dist/*"'
    
    clear
    echo "═══════════════════════════════════════════════════════"
    echo "   FOH WordPress Theme - Namespace Setup"
    echo "═══════════════════════════════════════════════════════"
    echo

    # Check if we're in the right directory
    check_theme_directory

    # Get the new namespace/slug from user
    echo "Enter your namespace slug (e.g., 'mega' for Megatherium project):"
    echo "This will be used as:"
    echo "  - Theme directory name"
    echo "  - Text domain"
    echo "  - Prefix for constants and function names"
    echo "  - File names"
    echo
    echo "Note: Use only lowercase letters (no numbers or special characters)"
    echo
    read -p "Project slug: " THEME_SLUG

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
    
    read -p "Does this look correct? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled."
        exit 1
    fi

    echo
    print_info "Now let's update the theme information in style.css..."
    echo
    
    # Get theme name
    read -p "Enter theme name (e.g., 'Megatherium Theme'): " -r THEME_NAME
    while [[ -z "$THEME_NAME" ]]; do
        print_error "Theme name cannot be empty."
        read -p "Enter theme name: " -r THEME_NAME
    done
    
    # Get theme description
    read -p "Enter theme description: " -r THEME_DESCRIPTION
    while [[ -z "$THEME_DESCRIPTION" ]]; do
        print_error "Theme description cannot be empty."
        read -p "Enter theme description: " -r THEME_DESCRIPTION
    done
    
    # Get author name
    read -p "Enter author name: " -r THEME_AUTHOR
    while [[ -z "$THEME_AUTHOR" ]]; do
        print_error "Author name cannot be empty."
        read -p "Enter author name: " -r THEME_AUTHOR
    done

    echo
    echo -e "${BOLD}Are you ready to modify files in place?${NC}"
    print_warning "Make sure you have a backup or clean git state!"
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled."
        exit 1
    fi

    echo
    print_info "Starting namespace replacement..."
    echo

    # Step 1: Replace 'foh' text domain (single quotes)
    print_info "Step 1/10: Replacing text domain in single quotes..."
    find . -type f ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "'foh'" "'${THEME_SLUG}'"
    done
    print_success "Text domain (single quotes) replaced"

    # Step 2: Replace "foh" text domain (double quotes)
    print_info "Step 2/10: Replacing text domain in double quotes..."
    find . -type f ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "\"foh\"" "\"${THEME_SLUG}\""
    done
    print_success "Text domain (double quotes) replaced"

    # Step 3: Replace foh_ function prefix
    print_info "Step 3/10: Replacing function prefix..."
    find . -type f -name "*.php" ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "foh_" "${THEME_SLUG}_"
    done
    print_success "Function prefix replaced"

    # Step 4: Replace FOH_ constants
    print_info "Step 4/10: Replacing constants..."
    find . -type f -name "*.php" ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "FOH_" "${THEME_SLUG_UPPER}_"
    done
    print_success "Constants replaced"

    # Step 5: Update style.css header information
    print_info "Step 5/10: Updating style.css header information..."
    
    # Update multiple fields in style.css with a single backup
    sed -i.bak \
        -e "s/^Theme Name:.*/Theme Name: ${THEME_NAME}/" \
        -e "s/^Description:.*/Description: ${THEME_DESCRIPTION}/" \
        -e "s/^Author:.*/Author: ${THEME_AUTHOR}/" \
        -e "s/Text Domain: foh/Text Domain: ${THEME_SLUG}/g" \
        style.css
    
    # Clean up backup file
    rm -f style.css.bak
    
    print_success "style.css header updated"

    # Step 6: Replace foh.pot reference
    print_info "Step 6/10: Replacing .pot file references..."
    find . -type f -name "*.php" ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "foh\\.pot" "${THEME_SLUG}.pot"
    done
    print_success ".pot file references replaced"

    # Step 7: Replace foh in DocBlocks (with space before)
    print_info "Step 7/10: Replacing namespace in DocBlocks..."
    find . -type f -name "*.php" ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" " foh" " ${THEME_SLUG_TITLE}"
    done
    print_success "DocBlocks updated"

    # Step 8: Replace foh- prefixed handles
    print_info "Step 8/10: Replacing prefixed handles..."
    find . -type f \( -name "*.php" -o -name "*.js" \) ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "foh-" "${THEME_SLUG}-"
    done
    print_success "Prefixed handles replaced"

    # Step 9: Replace [foh function prefix in comments
    print_info "Step 9/10: Replacing function prefix in brackets..."
    find . -type f -name "*.php" ${EXCLUDE_PATHS} | while read -r file; do
        safe_replace "$file" "\\[foh" "[${THEME_SLUG}"
    done
    print_success "Function prefix in brackets replaced"

    echo
    print_info "Step 10/10: Renaming files..."

    # Rename .pot file if it exists
    if [ -f "languages/foh.pot" ]; then
        mv "languages/foh.pot" "languages/${THEME_SLUG}.pot"
        print_success "Renamed languages/foh.pot → languages/${THEME_SLUG}.pot"
    fi

    # Rename JS files with foh prefix
    find . -type f -name "foh-*.js" ${EXCLUDE_PATHS} | while read -r file; do
        newfile="${file/foh-/${THEME_SLUG}-}"
        mv "$file" "$newfile"
        print_success "Renamed: $(basename "$file") → $(basename "$newfile")"
    done

    echo
    print_info "Checking for any remaining temporary backup files..."
    backup_files=$(find . -name "*.bak" -type f ${EXCLUDE_PATHS})
    if [[ -n "$backup_files" ]]; then
        echo "$backup_files"
        read -p "Remove these backup files? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            find . -name "*.bak" -type f ${EXCLUDE_PATHS} -delete
            print_success "Backup files removed"
        fi
    else
        print_success "No temporary backup files found"
    fi

    echo
    echo "═══════════════════════════════════════════════════════"
    print_success "Namespace setup complete!"
    echo "═══════════════════════════════════════════════════════"
    echo
    print_warning "Your manual next steps:"
    echo "  1. Review the changes with: git diff"
    echo "  2. Update footer.php links with your information"
    echo "  3. Update webpack.common.js with your local site directory"
    echo "  4. Run: npm install"
    echo "  5. Run: composer install"
    echo
    print_info "The theme directory itself should be renamed to: ${THEME_SLUG}"
    echo
}

# Run main function
main
