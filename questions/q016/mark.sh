#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/non-major-parties-margin.txt"

check_file_exists "$TARGET" "non-major-parties-margin.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    EXPECTED=$(mktemp /tmp/q016_expected.XXXXXX)
    # Exclude major parties (space-padded to avoid substring matches)
    grep -v ' ALP \| LIB \| NAT \| LNP \| GRN ' "$SEATS" \
        | awk '{print $1, $2, $3, $4}' \
        | sort -k4 -n > "$EXPECTED"
    NON_MAJOR_COUNT=$(wc -l < "$EXPECTED" | tr -d ' ')

    info "Expected $NON_MAJOR_COUNT non-major-party rows."
    check_line_count "$TARGET" "$NON_MAJOR_COUNT" "non-major-parties-margin.txt"
    check_content_matches "$TARGET" "$EXPECTED" "non-major-parties-margin.txt (name state party margin, sorted by margin)"

    rm -f "$EXPECTED"
fi

print_summary
