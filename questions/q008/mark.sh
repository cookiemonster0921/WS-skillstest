#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

# The question says "Call the copy script2.bsh" but q007 already uses that name.
# Accept script3.bsh (most likely intended) or script2.bsh as a fallback.
SCRIPT=""
if [ -f "$RUNDIR/script3.bsh" ]; then
    SCRIPT="$RUNDIR/script3.bsh"
    info "Found script3.bsh (recommended filename for this question)."
elif [ -f "$RUNDIR/script2.bsh" ]; then
    SCRIPT="$RUNDIR/script2.bsh"
    warn "Found script2.bsh — question says 'script2.bsh' but q007 already uses that name. Accepted here."
else
    fail "Neither script3.bsh nor script2.bsh found in run directory."
fi

if [ -n "$SCRIPT" ]; then
    # Comparison logic from q007 must still work
    run_script_test "$SCRIPT" "5 3" \
        "The first argument is bigger than the second." \
        "Comparison still works: 5 3 → first bigger"
    run_script_test "$SCRIPT" "3 5" \
        "The second argument is bigger than the first." \
        "Comparison still works: 3 5 → second bigger"
    run_script_test "$SCRIPT" "4 4" \
        "The arguments are equal" \
        "Comparison still works: 4 4 → equal"

    # Wrong arg count: 0 args
    OUT_0=$(bash "$SCRIPT" 2>/dev/null || true)
    if printf '%s' "$OUT_0" | grep -q "Incorrect number of Arguments"; then
        pass "0 args → error message contains 'Incorrect number of Arguments'"
    else
        fail "0 args → expected error message containing 'Incorrect number of Arguments', got: '$OUT_0'"
    fi

    # Wrong arg count: 1 arg
    OUT_1=$(bash "$SCRIPT" "5" 2>/dev/null || true)
    if printf '%s' "$OUT_1" | grep -q "Incorrect number of Arguments"; then
        pass "1 arg → error message contains 'Incorrect number of Arguments'"
    else
        fail "1 arg → expected error message, got: '$OUT_1'"
    fi

    # Wrong arg count: 3 args
    OUT_3=$(bash "$SCRIPT" 1 2 3 2>/dev/null || true)
    if printf '%s' "$OUT_3" | grep -q "Incorrect number of Arguments"; then
        pass "3 args → error message contains 'Incorrect number of Arguments'"
    else
        fail "3 args → expected error message, got: '$OUT_3'"
    fi

    # Exit code must be 23 when arg count is wrong
    run_script_exitcode "$SCRIPT" "" "23" "0 args → exit code 23"
    run_script_exitcode "$SCRIPT" "5" "23" "1 arg → exit code 23"

    warn "The en-dash (–) vs hyphen (-) in the error message is not strictly checked."
fi

print_summary
