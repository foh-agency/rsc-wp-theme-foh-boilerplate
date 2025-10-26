#!/usr/bin/env bats

# Clean source before every test, to mitigate possible side effects
setup() {
    # Source the script to access its constants
    source "${BATS_TEST_DIRNAME}/../../setup-theme-name.sh"
}

# bats test_tags=excludes
@test "EXCLUDE_PATHS contains dist exclusion" {
   [[ "${EXCLUDE_PATHS}" == *'-not -path "*/dist/*"'* ]]
}
# bats test_tags=excludes
@test "EXCLUDE_PATHS contains node_modules exclusion" {
   [[ "${EXCLUDE_PATHS}" == *'-not -path "*/node_modules/*"'* ]]
}

# bats test_tags=excludes
@test "EXCLUDE_PATHS contains vendor exclusion" {
   [[ "${EXCLUDE_PATHS}" == *'-not -path "*/vendor/*"'* ]]
}
