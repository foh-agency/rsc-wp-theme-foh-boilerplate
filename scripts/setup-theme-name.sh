#!/bin/bash

# FOH WordPress Theme Namespace Setup Script
# This script automates the namespace replacement process described in the README

# SCRIPT SETTINGS

# -e           Exit immediately if any command returns a non-zero status (fails).
# -u           Exit if you try to use an undefined variable.
# -o pipefail  Fail if any command in the pipe fails, not just the last one.
set -euo pipefail

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

check_git_status() {
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            print_warning "You have uncommitted changes in git!"
            print_warning ${BOLD}"It's highly recommended to commit or stash changes first."${NC}
            read -p "Continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Good choice! Run 'git add . && git commit -m \"Before theme setup\"' first."
                exit 0
            fi
        else
            print_success "✓ Git working directory is clean"
        fi
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

# Function to replace URLs specifically
replace_url() {
    local file=$1
    local old_url=$2
    local new_url=$3
    local temp_file="${file}.tmp"
    
    # Use awk to replace the specific URL
    awk -v old_url="$old_url" -v new_url="$new_url" '
    {
        gsub(old_url, new_url)
        print $0
    }
    ' "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
}

# Create backup of all files that will be modified
create_backup() {
    local backup_dir="/tmp/theme-setup-backup-$$"
    print_info "Creating backup at: ${backup_dir}"
    
    mkdir -p "${backup_dir}"
    
    # Copy all files that could be modified
    # Only backup text files since we only modify text files
    while read -r file; do
        local dir_path="${backup_dir}/$(dirname "${file}")"
        mkdir -p "${dir_path}"
        cp "${file}" "${backup_dir}/${file}"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    
    echo "${backup_dir}"
}

# Restore from backup if something goes wrong
restore_backup() {
    local backup_dir="$1"
    
    if [[ -d "${backup_dir}" ]]; then
        print_error "Error occurred! Restoring files from backup..."
        
        # Restore all files from backup
        while read -r backup_file; do
            local relative_path="${backup_file#${backup_dir}/}"
            cp "${backup_file}" "${relative_path}"
        done < <(find "${backup_dir}" -type f)
        
        print_info "Files restored successfully."
        rm -rf "${backup_dir}"
    else
        print_error "No such backup dir exists: ${backup_dir}"
    fi
}

# Clean up backup after successful completion
cleanup_backup() {
    local backup_dir="$1"
    
    if [[ -d "${backup_dir}" ]]; then
        print_success "All changes completed successfully. Cleaning up backup..."
        rm -rf "${backup_dir}"
        print_success "Deleted temporary backup dir: ${backup_dir}"
    fi
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
    read -p "Theme slug: " THEME_SLUG

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
}

# Function to get theme information
get_theme_info() {
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
}

# Function to get and validate repository URL
get_repository_url() {
    echo
    print_info "Repository URL (current: https://github.com/foh-agency/rsc-wp-theme-foh-boilerplate)"
    echo "Enter the GitHub URL (HTTPS or SSH format):"
    echo "  HTTPS: https://github.com/username/repo-name"
    echo "  SSH:   git@github.com:username/repo-name.git"
    read -p "Repository URL: " -r REPO_URL
    while [[ -z "$REPO_URL" ]]; do
        print_error "Repository URL cannot be empty."
        read -p "Repository URL: " -r REPO_URL
    done
    
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
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup cancelled."
        exit 1
    fi
}


# MAIN LOGIC

main() {
    
    clear
    echo "═══════════════════════════════════════════════════════"
    echo "   FOH WordPress Theme - Namespace Setup"
    echo "═══════════════════════════════════════════════════════"
    echo

    # Check if we're in the right directory
    check_theme_directory

    # Collect all user inputs
    get_theme_slug
    get_theme_info
    get_repository_url
    get_final_confirmation

    echo
    print_info "Starting namespace replacement..."
    echo

    # Step 1: Replace 'foh' text domain (single quotes)
    print_info "Step 1/11: Replacing text domain in single quotes..."
    while read -r file; do
        safe_replace "$file" "'foh'" "'${THEME_SLUG}'"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Text domain (single quotes) replaced"

    # Step 2: Replace "foh" text domain (double quotes)
    print_info "Step 2/11: Replacing text domain in double quotes..."
    while read -r file; do
        safe_replace "$file" "\"foh\"" "\"${THEME_SLUG}\""
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Text domain (double quotes) replaced"

    # Step 3: Replace foh_ function prefix
    print_info "Step 3/11: Replacing function prefix..."
    while read -r file; do
        safe_replace "$file" "foh_" "${THEME_SLUG}_"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Function prefix replaced"

    # Step 4: Replace FOH_ constants
    print_info "Step 4/11: Replacing constants..."
    while read -r file; do
        safe_replace "$file" "FOH_" "${THEME_SLUG_UPPER}_"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Constants replaced"

    # Step 5: Update style.css header information
    print_info "Step 5/11: Updating style.css header information..."
    
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
    print_info "Step 6/11: Replacing .pot file references..."
    while read -r file; do
        safe_replace "$file" "foh\\.pot" "${THEME_SLUG}.pot"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success ".pot file references replaced"

    # Step 7: Replace foh in DocBlocks (with space before)
    print_info "Step 7/11: Replacing namespace in DocBlocks..."
    while read -r file; do
        safe_replace "$file" " foh" " ${THEME_SLUG_TITLE}"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "DocBlocks updated"

    # Step 8: Replace foh- prefixed handles
    print_info "Step 8/11: Replacing prefixed handles..."
    while read -r file; do
        safe_replace "$file" "foh-" "${THEME_SLUG}-"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Prefixed handles replaced"

    # Step 9: Replace [foh function prefix in comments
    print_info "Step 9/11: Replacing function prefix in brackets..."
    while read -r file; do
        safe_replace "$file" "\\\\[foh" "[${THEME_SLUG}"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Function prefix in brackets replaced"

    # Step 10: Replace repository URLs
    print_info "Step 10/11: Replacing repository URLs..."
    while read -r file; do
        replace_url "$file" "https://github.com/foh-agency/rsc-wp-theme-foh-boilerplate" "$REPO_URL"
    done < <(find . -type f \( ${TEXT_FILE_EXTENSIONS} \) ${EXCLUDE_PATHS})
    print_success "Repository URLs replaced"

    echo
    print_info "Step 11/11: Renaming files..."

    # Rename .pot file if it exists
    if [ -f "languages/foh.pot" ]; then
        mv "languages/foh.pot" "languages/${THEME_SLUG}.pot"
        print_success "Renamed languages/foh.pot → languages/${THEME_SLUG}.pot"
    fi

    # Rename files with foh- prefix (any file type)
    while read -r file; do
        newfile="${file/foh-/${THEME_SLUG}-}"
        mv "$file" "$newfile"
        print_success "Renamed: $(basename "$file") → $(basename "$newfile")"
    done < <(find . -type f -name "foh-*" ${EXCLUDE_PATHS})

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
    print_success "🎉 Namespace setup complete!"
    echo "═══════════════════════════════════════════════════════"
    echo
    print_info "✨ What was changed:"
    echo "  • Text domain: 'foh' → '${THEME_SLUG}'"
    echo "  • Function prefix: foh_ → ${THEME_SLUG}_"
    echo "  • Constants: FOH_ → ${THEME_SLUG_UPPER}_"
    echo "  • Theme info: ${THEME_NAME} by ${THEME_AUTHOR}"
    echo "  • Repository: ${REPO_URL}"
    echo
    print_warning "📋 Your manual next steps:"
    echo "  1. Review the changes with: git diff"
    echo "  2. Update footer.php links with your information"
    echo "  3. Update webpack.common.js with your local site directory"
    echo "  4. Run: npm install"
    echo "  5. Run: composer install"
    echo
    print_info "📁 You should make sure the theme directory is renamed to: ${THEME_SLUG}"
    print_success "🚀 You're all set! The theme is ready for development."
    echo
}

# ENTRY POINT

# Safe execution wrapper with backup/restore
safe_main() {
    local backup_dir
    
    # Create backup before making any changes
    backup_dir=$(create_backup)
    
    # Set up error handling to restore backup if anything inside trap fails
    # This trap may not catch errors within subshells
    trap "restore_backup '${backup_dir}'; exit 1" ERR
    
    # Run the main function
    main
    
    # If we get here, main succeeded
    cleanup_backup "${backup_dir}"
    
    # Clear the trap
    trap - ERR
}

# Run safe main function
safe_main
