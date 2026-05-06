#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
TARGET="$RUNDIR/seats_by_state.txt"

check_file_exists "$TARGET" "seats_by_state.txt"

if [ "$FILE_EXISTS" = "1" ]; then
    TOTAL=$(wc -l < "$SEATS" | tr -d ' ')

    # Count data lines (lines that contain a known state code flanked by spaces)
    DATA_LINES=$(grep -E ' (NSW|VIC|WA|QLD|SA|TAS|ACT|NT) ' "$TARGET" | wc -l | tr -d ' ')
    if [ "$DATA_LINES" = "$TOTAL" ]; then
        pass "seats_by_state.txt has $TOTAL data lines (all electorates present)"
    else
        warn "seats_by_state.txt has $DATA_LINES data lines (expected $TOTAL); headers may be present — that is acceptable"
    fi

    # Check state ordering: first occurrence of each state must follow the prescribed order
    STATES="NSW VIC WA QLD SA TAS ACT NT"
    PREV_LINE=0
    ORDER_OK=1
    for STATE in $STATES; do
        FIRST_LINE=$(grep -n " $STATE " "$TARGET" | head -1 | cut -d: -f1)
        if [ -z "$FIRST_LINE" ]; then
            fail "State $STATE not found in seats_by_state.txt"
            ORDER_OK=0
        elif [ "$FIRST_LINE" -gt "$PREV_LINE" ]; then
            PREV_LINE="$FIRST_LINE"
        else
            fail "State ordering wrong: $STATE block starts at line $FIRST_LINE but previous state ended at line $PREV_LINE"
            ORDER_OK=0
        fi
    done
    if [ "$ORDER_OK" = "1" ]; then
        pass "State group order is correct (NSW, VIC, WA, QLD, SA, TAS, ACT, NT)"
    fi

    # Check alphabetical order within NSW block
    NSW_NAMES=$(grep ' NSW ' "$TARGET" | awk '{print $1}')
    NSW_SORTED=$(printf '%s\n' $NSW_NAMES | sort)
    if [ "$NSW_NAMES" = "$NSW_SORTED" ]; then
        pass "NSW seats are alphabetically sorted within their block"
    else
        fail "NSW seats are NOT alphabetically sorted within their block"
    fi

    # Check alphabetical order within VIC block
    VIC_NAMES=$(grep ' VIC ' "$TARGET" | awk '{print $1}')
    VIC_SORTED=$(printf '%s\n' $VIC_NAMES | sort)
    if [ "$VIC_NAMES" = "$VIC_SORTED" ]; then
        pass "VIC seats are alphabetically sorted within their block"
    else
        fail "VIC seats are NOT alphabetically sorted within their block"
    fi

    warn "State header lines (if any) are acceptable per spec — only data rows are counted above."
fi

print_summary
