#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/twenty_most_marginal_seats.txt"

check_file_exists "$TARGET" "twenty_most_marginal_seats.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    check_line_count "$TARGET" "20" "twenty_most_marginal_seats.txt"

    EXPECTED=$(mktemp /tmp/q017_expected.XXXXXX)
    sort -k4 -n "$SEATS" | head -20 | awk '{print $3, $1, $2, $4}' > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "twenty_most_marginal_seats.txt (party name state margin, 20 smallest margins)"
    rm -f "$EXPECTED"
fi

print_summary
