
# Run tests on all scripts
bats scripts/tests/

# Run tests on one script
bats scripts/tests/setup-theme-name/

# Run tests on one specific area of one script
bats scripts/tests/setup-theme-name/colors.bats
