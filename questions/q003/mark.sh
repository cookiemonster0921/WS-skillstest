#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

CONST="$REPO_ROOT/constitution.txt"
TARGET="$RUNDIR/con3.txt"

check_file_exists "$TARGET" "con3.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    TOTAL=$(awk 'END{print NR}' "$CONST")
    check_line_count "$TARGET" "$TOTAL" "con3.txt"
    # Expected: lines 1-99, then lines 201-end, then lines 100-200 (moved to end).
    # Use awk (not sed/head) so the partial last line of constitution.txt gets a
    # proper newline appended before lines 100-200 are concatenated.
    EXPECTED=$(mktemp /tmp/q003_expected.XXXXXX)
    {
        awk 'NR>=1  && NR<=99'  "$CONST"
        awk 'NR>=201'           "$CONST"
        awk 'NR>=100 && NR<=200' "$CONST"
    } > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "con3.txt"
    rm -f "$EXPECTED"
fi

print_summary
