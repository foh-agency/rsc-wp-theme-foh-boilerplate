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
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Common exclusion paths for find commands (array)
EXCLUDE_PATHS=(-not -path "*/dist/*" -not -path "*/node_modules/*" -not -path "*/vendor/*")

# File extensions that should be processed (array)
TEXT_FILE_EXTENSIONS=( \( -name "*.conf" -o -name "*.css" -o -name "*.ini" -o -name "*.js" -o -name "*.json" -o -name "*.md" -o -name "*.php" -o -name "*.pot" -o -name "*.scss" -o -name "*.txt" -o -name "*.xml" -o -name "*.yaml" -o -name "*.yml" \) )


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

create_backup() {
    # Set path with unique PID each time this script runs
    local backup_dir="/tmp/com.foh-agency.theme-setup-backup-$$"

    print_info "Creating backup at: ${backup_dir}"

    # Create backup dir
    # -p creates parent directories as needed
    mkdir -p "${backup_dir}"

    # Copy all files that could be modified
    # Only backup text files since we only modify text files
    # E.g. file: ./src/php/theme-features/utils.php
    while read -r file; do
        # Store the file's path including its parent backup_dir
        # E.g. /tmp/theme-setup-backup-30890/./src/php/theme-features
        local dir_path="${backup_dir}/$(dirname ${file})"

        # If the current 'file' (while loop iteration) is a directory, then
        # create a directory with that name in the backup_dir
        mkdir -p "${dir_path}"
        cp "${file}" "${dir_path}"
    done < <(find . -type f "${TEXT_FILE_EXTENSIONS[@]}" "${EXCLUDE_PATHS[@]}")

    echo "${backup_dir}"
}

cleanup_backup() {
    local backup_dir="${1}"

    # If provided backup_dir doesn't exist, complain
    if [ ! -d "${backup_dir}" ]; then
        print_error "Backup cleanup error: ${backup_dir} does not exist. Provide a valid backup dir."
    else
        print_info "Backup cleanup: About to delete ${backup_dir}"

        # Delete the current backup_dir
        rm -rf "${backup_dir}"

        # If backup_dir no longer exists, celebrate
        if [ ! -d "${backup_dir}" ]; then
            print_success "Backup cleanup: Deleted ${backup_dir}"
        fi
    fi
}

# USER INPUT


# MAIN LOGIC

main() {
    echo "I am mainn"
}


# ENTRY POINT

# Safe execution wrapper with backup/restore
safe_main() {
    local backup_dir
    
    # Create backup before making any changes
    backup_dir=$(create_backup)
    backup_dir_ls=$(ls -al "${backup_dir}")

    # Set up error handling to restore backup if anything inside trap fails
    # This trap may not catch errors within subshells
    # TODO: write restore_backup()
    # trap "restore_backup '${backup_dir}'; exit 1" ERR
    
    # Run the main function
    main
    
    # If we get here, main succeeded
    echo "${backup_dir_ls}"
    cleanup_backup "${backup_dir}"
    
    # Clear the trap
    trap - ERR
}


# EXECUTION GUARD: Only run main logic when script is executed directly
# This allows the script to be safely sourced by tests without executing main()
# 
# ${BASH_SOURCE[0]} = path to current script file
# ${0}              = path to the script being executed
# When sourced: BASH_SOURCE[0] = this file, but ${0} = the sourcing script
# When executed: both variables point to this same file
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    safe_main
fi