#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/twenty_safest_seats.txt"

check_file_exists "$TARGET" "twenty_safest_seats.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    check_line_count "$TARGET" "20" "twenty_safest_seats.txt"

    # Expected: take the 20 LARGEST margins (tail -20 after ascending sort),
    # then sort those 20 ascending and reorder fields to: margin party name state.
    EXPECTED=$(mktemp /tmp/q019_expected.XXXXXX)
    sort -k4 -n "$SEATS" | tail -20 | sort -k4 -n \
        | awk '{print $4, $3, $1, $2}' > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "twenty_safest_seats.txt (margin party name state, 20 largest margins sorted ascending)"
    rm -f "$EXPECTED"
fi

print_summary
