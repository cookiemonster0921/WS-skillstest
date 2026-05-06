#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/sorted_seats.txt"

check_file_exists "$TARGET" "sorted_seats.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    TOTAL=$(awk 'END{print NR}' "$SEATS")
    check_line_count "$TARGET" "$TOTAL" "sorted_seats.txt"

    EXPECTED=$(mktemp /tmp/q012_expected.XXXXXX)
    sort "$SEATS" > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "sorted_seats.txt (all electorates sorted by name)"
    rm -f "$EXPECTED"
fi

print_summary
