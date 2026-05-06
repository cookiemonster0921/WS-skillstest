#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
SCRIPT="$RUNDIR/get_seats.sh"

check_file_exists "$SCRIPT" "get_seats.sh"

if [ "$FILE_EXISTS" = "1" ]; then
    # Test 1: ALP NSW — compare sorted output
    EXPECTED_ALP_NSW=$(grep ' ALP ' "$SEATS" | grep ' NSW ' | awk '{print $1, $4}' | sort)
    EXPECTED_COUNT=$(printf '%s\n' "$EXPECTED_ALP_NSW" | grep -c .)
    ACTUAL_ALP_NSW=$(bash "$SCRIPT" ALP NSW 2>/dev/null | sort)
    if [ "$ACTUAL_ALP_NSW" = "$EXPECTED_ALP_NSW" ]; then
        pass "get_seats.sh ALP NSW → correct output ($EXPECTED_COUNT electorates)"
    else
        fail "get_seats.sh ALP NSW → output mismatch"
        info "Expected (sorted): $(printf '%s\n' "$EXPECTED_ALP_NSW" | head -5) ..."
        info "Got (sorted):      $(printf '%s\n' "$ACTUAL_ALP_NSW" | head -5) ..."
    fi

    # Test 2: LIB VIC — verify count matches
    LIB_VIC_EXPECTED=$(grep ' LIB ' "$SEATS" | grep ' VIC ' | wc -l | tr -d ' ')
    LIB_VIC_ACTUAL=$(bash "$SCRIPT" LIB VIC 2>/dev/null | wc -l | tr -d ' ')
    if [ "$LIB_VIC_ACTUAL" = "$LIB_VIC_EXPECTED" ]; then
        pass "get_seats.sh LIB VIC → correct line count ($LIB_VIC_EXPECTED)"
    else
        fail "get_seats.sh LIB VIC → got $LIB_VIC_ACTUAL lines, expected $LIB_VIC_EXPECTED"
    fi

    # Test 3: Output should only have 2 fields (name and margin)
    TWO_FIELD_LINES=$(bash "$SCRIPT" ALP NSW 2>/dev/null | awk '{print NF}' | sort -u)
    if [ "$TWO_FIELD_LINES" = "2" ]; then
        pass "get_seats.sh output has exactly 2 fields per line (name and margin)"
    else
        fail "get_seats.sh output field count per line: $TWO_FIELD_LINES (expected 2)"
    fi
fi

print_summary
