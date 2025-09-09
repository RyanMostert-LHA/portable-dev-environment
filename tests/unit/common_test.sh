#!/bin/bash

# Load shunit2
. ../shunit2/shunit2

# Source the script we are testing
. ../../scripts/install/common.sh

test_log_info() {
    assertEquals "[INFO] Test message" "$(log_info 'Test message')"
}

test_log_warn() {
    assertEquals "[WARN] Test message" "$(log_warn 'Test message')"
}

test_log_error() {
    assertEquals "[ERROR] Test message" "$(log_error 'Test message')"
}
