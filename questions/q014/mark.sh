#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/smallest.txt"

check_file_exists "$TARGET" "smallest.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED_ROW=$(sort -k4 -n "$SEATS" | head -1)
    info "Expected row: $EXPECTED_ROW"
    # Check by constituent parts (electorate name and margin value)
    EXPECTED_NAME=$(printf '%s' "$EXPECTED_ROW" | awk '{print $1}')
    EXPECTED_MARGIN=$(printf '%s' "$EXPECTED_ROW" | awk '{print $4}')
    check_contains_string "$TARGET" "$EXPECTED_NAME" "smallest.txt contains electorate name ($EXPECTED_NAME)"
    check_contains_string "$TARGET" "$EXPECTED_MARGIN" "smallest.txt contains margin ($EXPECTED_MARGIN)"
    warn "If there were a tie for smallest margin, any tied row is acceptable."
fi

print_summary
