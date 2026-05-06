#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

CONST="$REPO_ROOT/constitution.txt"
TARGET="$RUNDIR/con4.txt"

check_file_exists "$TARGET" "con4.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED=$(mktemp /tmp/q004_expected.XXXXXX)
    sed 's/the/THE/g' "$CONST" > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "con4.txt (all 'the' → 'THE')"
    rm -f "$EXPECTED"
fi

print_summary
