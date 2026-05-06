#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/NSW_sorted.txt"

check_file_exists "$TARGET" "NSW_sorted.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED=$(mktemp /tmp/q011_expected.XXXXXX)
    grep ' NSW ' "$SEATS" | awk '{print $1}' | sort > "$EXPECTED"
    EXPECTED_COUNT=$(wc -l < "$EXPECTED" | tr -d ' ')

    check_line_count "$TARGET" "$EXPECTED_COUNT" "NSW_sorted.txt"
    check_content_matches "$TARGET" "$EXPECTED" "NSW_sorted.txt (sorted NSW names)"

    # Extra: confirm no extra fields snuck in
    if grep -qE ' (NSW|VIC|WA|QLD|SA|TAS|ACT|NT) ' "$TARGET" 2>/dev/null; then
        fail "NSW_sorted.txt contains extra fields — should be seat names only"
    else
        pass "NSW_sorted.txt contains seat names only (no state/party/margin)"
    fi

    rm -f "$EXPECTED"
fi

print_summary
