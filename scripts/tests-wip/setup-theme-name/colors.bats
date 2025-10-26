#!/usr/bin/env bats

# Clean source before every test, to mitigate possible side effects
setup() {
    # Source the script to access its constants
    source "${BATS_TEST_DIRNAME}/../../setup-theme-name.sh"
}

# bats test_tags=color
@test "RED constant has correct ANSI escape sequence" {
    [ "$RED" = '\033[1;31m' ]
}

# bats test_tags=color
@test "GREEN constant has correct ANSI escape sequence" {
    [ "$GREEN" = '\033[1;32m' ]
}

# bats test_tags=color
@test "YELLOW constant has correct ANSI escape sequence" {
    [ "$YELLOW" = '\033[1;33m' ]
}

# bats test_tags=color
@test "BLUE constant has correct ANSI escape sequence" {
    [ "$BLUE" = '\033[1;34m' ]
}

# bats test_tags=color
@test "BOLD constant has correct ANSI escape sequence" {
    [ "$BOLD" = '\033[1m' ]
}

# bats test_tags=color
@test "NC constant has correct ANSI escape sequence" {
    [ "$NC" = '\033[0m' ]
}
