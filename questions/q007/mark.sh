#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SCRIPT="$RUNDIR/script2.bsh"

check_file_exists "$SCRIPT" "script2.bsh"

if [ "$FILE_EXISTS" = "1" ]; then
    run_script_test "$SCRIPT" "5 3" \
        "The first argument is bigger than the second." \
        "script2.bsh 5 3 → first bigger"
    run_script_test "$SCRIPT" "3 5" \
        "The second argument is bigger than the first." \
        "script2.bsh 3 5 → second bigger"
    run_script_test "$SCRIPT" "4 4" \
        "The arguments are equal" \
        "script2.bsh 4 4 → equal (no trailing period)"
fi

print_summary
