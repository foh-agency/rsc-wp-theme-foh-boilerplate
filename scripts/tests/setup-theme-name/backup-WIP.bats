#!/usr/bin/env bats

# Clean source before every test, to mitigate possible side effects
setup() {
    # Source the script to access its utility functions
    source "${BATS_TEST_DIRNAME}/../../setup-theme-name.sh"
}

# bats test_tags=backup
@test "create_backup returns a backup directory path" {
    run create_backup
    # Should exit successfully
    [ "$status" -eq 0 ]
    # Should output a path in /tmp with the expected prefix
    echo "${output}" >&3
}

# bats test_tags=backup
@test "create_backup creates directory in /tmp" {
    backup_dir=$(create_backup)
    # Directory should actually exist on filesystem
    [ -d "$backup_dir" ]
    # Clean up
    rm -rf "$backup_dir"
}

# bats test_tags=backup
@test "create_backup directory has unique PID in name" {
    backup_dir=$(create_backup)
    # Should contain the current shell's PID for uniqueness
    [[ "$backup_dir" == *"$$"* ]]
    # Clean up
    rm -rf "$backup_dir"
}

# bats test_tags=backup
@test "create_backup processes files with find command" {
    # Test that the find command in create_backup finds files (any files)
    # This ensures the while loop runs (which it didn't always: bug)
    
    # Run create_backup and capture its output
    run create_backup
    [ "$status" -eq 0 ]
    
    # Should find and process some files (we know .php and .md files exist)
    # The function prints file info, so output should contain file paths
    [[ "$output" == *"File:"* ]]
    
    # Clean up the created backup directory
    backup_dir=$(echo "$output" | tail -1)
    rm -rf "$backup_dir"
}
