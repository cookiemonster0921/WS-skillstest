#!/usr/bin/env bash
# practice/lib/mark_helpers.sh
# Sourced (not executed) by every per-question mark.sh.

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

GREEN=$'\033[32m'
RED=$'\033[31m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
DIM=$'\033[2m'
RESET=$'\033[0m'

pass() {
    PASS_COUNT=$(( PASS_COUNT + 1 ))
    printf "${GREEN}✅ PASS: %s${RESET}\n" "$1"
}

fail() {
    FAIL_COUNT=$(( FAIL_COUNT + 1 ))
    printf "${RED}❌ FAIL: %s${RESET}\n" "$1"
}

warn() {
    WARN_COUNT=$(( WARN_COUNT + 1 ))
    printf "${YELLOW}⚠️  WARN: %s${RESET}\n" "$1"
}

info() {
    printf "${BLUE}   ℹ  %s${RESET}\n" "$1"
}

# check_file_exists <filepath> <label>
# Sets FILE_EXISTS=1 on success, 0 on failure.
check_file_exists() {
    local filepath="$1"
    local label="$2"
    if [ -f "$filepath" ]; then
        pass "$label exists"
        FILE_EXISTS=1
    else
        fail "$label not found (expected at: $filepath)"
        FILE_EXISTS=0
    fi
}

# check_line_count <filepath> <expected> <label>
check_line_count() {
    local filepath="$1"
    local expected="$2"
    local label="$3"
    local actual
    actual=$(awk 'END{print NR}' "$filepath")
    if [ "$actual" = "$expected" ]; then
        pass "$label has exactly $expected lines"
    else
        fail "$label has $actual lines (expected $expected)"
    fi
}

# check_content_matches <actual_file> <expected_file> <label>
check_content_matches() {
    local actual="$1"
    local expected="$2"
    local label="$3"
    if diff -q "$actual" "$expected" > /dev/null 2>&1; then
        pass "$label content matches expected"
    else
        fail "$label content differs from expected"
        info "--- first differences (expected vs actual) ---"
        diff "$expected" "$actual" | head -15 | while IFS= read -r line; do
            info "$line"
        done
        info "----------------------------------------------"
    fi
}

# check_contains_string <filepath> <string> <label>
check_contains_string() {
    local filepath="$1"
    local string="$2"
    local label="$3"
    if grep -qF "$string" "$filepath"; then
        pass "$label"
    else
        fail "$label (expected to find: '$string')"
    fi
}

# run_script_test <script_path> <args_string> <expected_stdout> <label>
run_script_test() {
    local script="$1"
    local args="$2"
    local expected="$3"
    local label="$4"
    local actual
    actual=$(eval bash '"$script"' $args 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        pass "$label"
    else
        fail "$label"
        info "expected: '$expected'"
        info "got:      '$actual'"
    fi
}

# run_script_exitcode <script_path> <args_string> <expected_exit> <label>
run_script_exitcode() {
    local script="$1"
    local args="$2"
    local expected_exit="$3"
    local label="$4"
    local actual_exit
    eval bash '"$script"' $args > /dev/null 2>&1
    actual_exit=$?
    if [ "$actual_exit" = "$expected_exit" ]; then
        pass "$label (exit code $expected_exit)"
    else
        fail "$label (exit code was $actual_exit, expected $expected_exit)"
    fi
}

# print_summary — call at end of every mark.sh
print_summary() {
    local BOLD=$'\033[1m'
    echo ""
    printf "${DIM}─────────────────────────────────────────${RESET}\n"
    if [ "$FAIL_COUNT" -gt 0 ]; then
        printf "${RED}${BOLD}Score: %d passed, %d failed, %d warnings${RESET}\n" \
            "$PASS_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        exit 1
    else
        printf "${GREEN}${BOLD}Score: %d passed, %d failed, %d warnings${RESET}\n" \
            "$PASS_COUNT" "$FAIL_COUNT" "$WARN_COUNT"
        exit 0
    fi
}
