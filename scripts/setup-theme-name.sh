#!/bin/bash

# FOH WordPress Theme Namespace Setup Script
# This script automates the namespace replacement process described in the README

# SCRIPT SETTINGS, ERROR HANDLING

# -e           Exit immediately if any command returns a non-zero status (fails).
# -u           Exit if you try to use an undefined variable.
# -E           ERR trap is inherited by shell functions, command substitutions, and subshells
# -o pipefail  Fail if any command in the pipe fails, not just the last one.
set -euEo pipefail

# Disable terminal bell
set bell-style none 2>/dev/null || true

# Options to debug this script
# set -x # Debug
# set -v # Verbose
# set -n # No execute / syntax check
# set -o # Show all current settings

# Global error handler - makes set -e more reliable
error_handler() {
    local exit_code=$?
    local line_number=$1
    echo "ERROR: Script failed at line $line_number with exit code $exit_code" >&2
    echo "Command: ${BASH_COMMAND}" >&2
    # Kill the entire process group to ensure main script exits upon subshell error
    kill -TERM 0 2>/dev/null || exit $exit_code
}

# Set up ERR trap to catch all errors, even in functions and subshells
trap 'error_handler ${LINENO}' ERR


# CONSTANTS

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Common exclusion paths for find commands (global variable)
EXCLUDE_PATHS=(-not -path "*/node_modules/*" \
               -not -path "*/vendor/*" \
               -not -path "*/dist/*" \
               -not -path "./README.md")

# File extensions that should be processed (text files only)
TEXT_FILE_EXTENSIONS=( \( -name "*.conf" \
                        -o -name "*.css" \
                        -o -name "*.ini" \
                        -o -name "*.js" \
                        -o -name "*.json" \
                        -o -name "*.md" \
                        -o -name "*.php"\
                        -o -name "*.pot" \
                        -o -name "*.scss" \
                        -o -name "*.txt" \
                        -o -name "*.xml" \
                        -o -name "*.yaml" \
                        -o -name "*.yml" \) )

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
    print_warning "Make sure you have a backup or clean git state! Script may take 5–10 minutes"
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


# TRANSFORMATION HELPERS

# Generic function to iterate over theme files and execute a callback function
# Usage: replace_in_theme_files callback_function_name
# Returns the number of files processed in global variable $files_processed
replace_in_theme_files() {
    local callback_function="$1"
    files_processed=0
    
    # Check if callback function exists
    if ! declare -f "$callback_function" > /dev/null; then
        print_error "Function '$callback_function' does not exist"
        return 1
    fi
    
    while read -r file; do
        "$callback_function" "$file" || return 1
        ((files_processed++))
    done < <(find . -type f "${TEXT_FILE_EXTENSIONS[@]}" "${EXCLUDE_PATHS[@]}")
    
    return 0
}

# Function to perform safe replacement (avoiding URLs)
# Only protect foh when it's part of foh-agency.com
# All other instances of foh get replaced normally
safe_replace() {
    local file=$1
    local pattern=$2
    local replacement=$3
    local temp_file="${file}.tmp"
    
    # read -r line returns false when it hits EOF
    # To avoid unexpected behavior when files don't end in a new line,
    # [[ -n "$line" ]] returns true if $line contains any characters
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == *"foh-agency.com"* ]]; then
            # Line contains foh-agency.com, don't replace to avoid breaking the URL
            echo "$line"
        else
            # Safe to replace - no foh-agency.com URL to protect
            echo "$line" | sed "s@${pattern}@${replacement}@g"
        fi
    done < "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
}

# Callback functions for slug replacement
replace_single_quotes() {
    local file="$1"
    safe_replace "$file" "'foh'" "'${THEME_SLUG}'"
}

replace_double_quotes() {
    local file="$1"
    safe_replace "$file" "\"foh\"" "\"${THEME_SLUG}\""
}

# Callback functions for code prefix replacement
replace_function_prefix() {
    local file="$1"
    safe_replace "$file" "foh_" "${THEME_SLUG}_"
}

replace_constants() {
    local file="$1"
    safe_replace "$file" "FOH_" "${THEME_SLUG_UPPER}_"
}

# Callback function for pot file references
replace_pot_references() {
    local file="$1"
    safe_replace "$file" "foh\\.pot" "${THEME_SLUG}.pot"
}

# Callback function for handle prefixes
replace_handle_prefixes() {
    local file="$1"
    local pattern="foh-"
    local replacement="${THEME_SLUG}-"
    local temp_file="${file}.tmp"
    
    # Protect URLs
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == *"http"* ]] || [[ "$line" == *"github.com"* ]] || [[ "$line" == *"foh-agency.com"* ]]; then
            # Line contains any URL, don't replace to avoid breaking URLs
            echo "$line"
        else
            # Safe to replace - no URLs to protect
            echo "$line" | sed "s@${pattern}@${replacement}@g"
        fi
    done < "$file" > "$temp_file"
    
    mv "$temp_file" "$file"
}

# Callback function for docblocks
replace_docblocks() {
    local file="$1"
    safe_replace "$file" " foh" " ${THEME_SLUG}"
    safe_replace "$file" " FOH" " ${THEME_SLUG_TITLE}"
}

# Callback function for repository URLs
replace_repo_urls() {
    local file="$1"
    # Note: This needs a different approach since we need replace_url function
    # We'll need to implement this differently in the main function
    safe_replace "$file" "https://github.com/foh-agency/rsc-wp-theme-foh-boilerplate" "$REPO_URL"
}

# Callback function for bracket references [foh (no closing bracket)
replace_bracket_references() {
    local file="$1"
    safe_replace "$file" "\\[foh" "\\[${THEME_SLUG}"
}


# TRANSFORMATION STEPS

# Replace slug in single and double quotes
update_slug_in_quotes() {
    print_info "Step 1/11: Replacing slug in single quotes..."
    replace_in_theme_files replace_single_quotes
    print_success "Slug (single quotes) replaced. ${files_processed} files checked."

    print_info "Step 2/11: Replacing slug in double quotes..."
    replace_in_theme_files replace_double_quotes
    print_success "Slug (double quotes) replaced. ${files_processed} files checked."
}

# Replace function prefixes and constants
update_code_prefixes() {
    print_info "Step 3/11: Replacing function prefix..."
    replace_in_theme_files replace_function_prefix
    print_success "Function prefix replaced. ${files_processed} files checked."

    print_info "Step 4/11: Replacing constants..."
    replace_in_theme_files replace_constants
    print_success "Constants replaced. ${files_processed} files checked."
}

# Update style.css theme header
update_theme_header() {
    print_info "Step 5/11: Updating style.css header information..."
    
    sed -i.bak \
        -e "s/^Theme Name:.*/Theme Name: ${THEME_NAME}/" \
        -e "s/^Description:.*/Description: ${THEME_DESCRIPTION}/" \
        -e "s/^Author:.*/Author: ${THEME_AUTHOR}/" \
        -e "s/Text Domain: foh/Text Domain: ${THEME_SLUG}/g" \
        style.css
    
    rm -f style.css.bak
    print_success "style.css header updated. 1 file checked."
}

# Replace translation file references
update_pot_references() {
    print_info "Step 6/11: Replacing .pot file references..."
    replace_in_theme_files replace_pot_references
    print_success ".pot file references replaced. ${files_processed} files checked."
}

# Update DocBlock namespaces and comments
update_docblocks() {
    print_info "Step 7/11: Replacing namespace in DocBlocks..."
    replace_in_theme_files replace_docblocks
    print_success "DocBlocks updated. ${files_processed} files checked."
}

# Replace handle prefixes (CSS/JS handles, etc.)
update_handle_prefixes() {
    print_info "Step 8/11: Replacing prefixed handles..."
    replace_in_theme_files replace_handle_prefixes
    print_success "Prefixed handles replaced. ${files_processed} files checked."
}

# Update repository URLs
update_repo_urls() {
    print_info "Step 9/11: Replacing repository URLs..."
    replace_in_theme_files replace_repo_urls
    print_success "Repository URLs replaced. ${files_processed} files checked."
}

# Update bracket references
update_bracket_references() {
    print_info "Step 10/11: Replacing bracket references..."
    replace_in_theme_files replace_bracket_references
    print_success "Bracket references replaced. ${files_processed} files checked."
}

# Rename files and clean up
rename_files() {
    echo
    print_info "Step 11/11: Renaming files..."

    local files_renamed=0

    # Rename languages/foh.pot if it exists
    if [ -f "languages/foh.pot" ]; then
        mv "languages/foh.pot" "languages/${THEME_SLUG}.pot"
        print_success "Renamed languages/foh.pot → languages/${THEME_SLUG}.pot"
        ((files_renamed++))
    fi

    # Rename files with foh- prefix
    while read -r file; do
        newfile="${file/foh-/${THEME_SLUG}-}"
        mv "$file" "$newfile"
        print_success "Renamed: $(basename "$file") → $(basename "$newfile")"
        ((files_renamed++))
    done < <(find . -type f -name "foh-*" "${EXCLUDE_PATHS[@]}")

    print_success "File renaming completed. ${files_renamed} files processed."
}


# SUMMARY

show_completion_summary() {
    echo
    echo "═══════════════════════════════════════════════════════"
    print_success "🎉 Namespace setup complete!"
    echo "═══════════════════════════════════════════════════════"
    echo
    print_info "✨ What was changed:"
    echo "  • Slug: 'foh' → '${THEME_SLUG}'"
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

    # Execute all transformation steps
    # update_slug_in_quotes || return 1
    # update_code_prefixes || return 1
    # update_theme_header || return 1
    # update_pot_references || return 1
    update_docblocks || return 1
    # update_handle_prefixes || return 1
    # update_bracket_references || return 1
    # update_repo_urls || return 1
    # rename_files || return 1

    # Only show completion summary if all steps succeeded
    show_completion_summary
}

main
