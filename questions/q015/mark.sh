#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/ALP_electorates.txt"

check_file_exists "$TARGET" "ALP_electorates.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED=$(mktemp /tmp/q015_expected.XXXXXX)
    grep ' ALP ' "$SEATS" | awk '{print $1, $2, $4}' | sort -k1 > "$EXPECTED"
    ALP_COUNT=$(wc -l < "$EXPECTED" | tr -d ' ')

    check_line_count "$TARGET" "$ALP_COUNT" "ALP_electorates.txt"
    check_content_matches "$TARGET" "$EXPECTED" "ALP_electorates.txt (name state margin, sorted)"

    # Extra: confirm no party field present (all 3-field lines)
    if awk '{if (NF != 3) exit 1}' "$TARGET"; then
        pass "ALP_electorates.txt has exactly 3 fields per line (name state margin)"
    else
        fail "ALP_electorates.txt has lines with wrong field count (expected 3: name state margin)"
    fi

    rm -f "$EXPECTED"
fi

print_summary
