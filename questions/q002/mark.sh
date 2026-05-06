#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

CONST="$REPO_ROOT/constitution.txt"
TARGET="$RUNDIR/con2.txt"

warn "This question also asks you to name the command used — that written answer cannot be auto-checked."

check_file_exists "$TARGET" "con2.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    check_line_count "$TARGET" "30" "con2.txt"
    EXPECTED=$(mktemp /tmp/q002_expected.XXXXXX)
    tail -30 "$CONST" > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "con2.txt"
    rm -f "$EXPECTED"
fi

print_summary
