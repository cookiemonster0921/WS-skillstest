#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

CONST="$REPO_ROOT/constitution.txt"
TARGET="$RUNDIR/con5.txt"

check_file_exists "$TARGET" "con5.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED=$(mktemp /tmp/q005_expected.XXXXXX)
    sed 's/[Tt]he/THE/g' "$CONST" > "$EXPECTED"
    check_content_matches "$TARGET" "$EXPECTED" "con5.txt (all 'the'/'The' → 'THE')"
    rm -f "$EXPECTED"
fi

print_summary
