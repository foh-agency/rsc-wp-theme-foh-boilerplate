#!/usr/bin/env bats

# Clean source before every test, to mitigate possible side effects
setup() {
    # Source the script to access its constants
    source "${BATS_TEST_DIRNAME}/../../setup-theme-name.sh"
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .css" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.css"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .conf" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.conf"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .ini" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.ini"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .js" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.js"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .json" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.json"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .md" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.md"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .php" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.php"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .pot" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.pot"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .scss" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.scss"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .txt" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.txt"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .xml" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.xml"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .yaml" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.yaml"'* ]]
}

# bats test_tags=filetypes
@test "TEXT_FILE_EXTENSIONS contains .yml" {
   [[ "${TEXT_FILE_EXTENSIONS}" == *'-name "*.yml"'* ]]
}
