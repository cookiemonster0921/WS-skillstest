#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

CONST="$REPO_ROOT/constitution.txt"
TARGET="$RUNDIR/con1.txt"

check_file_exists "$TARGET" "con1.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    check_line_count "$TARGET" "20" "con1.txt"
    EXPECTED=$(mktemp /tmp/q001_expected.XXXXXX)
    tail -20 "$CONST" > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "con1.txt"
    rm -f "$EXPECTED"
fi

print_summary
