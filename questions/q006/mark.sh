#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SCRIPT="$RUNDIR/script1.bsh"

check_file_exists "$SCRIPT" "script1.bsh"

if [ "$FILE_EXISTS" = "1" ]; then
    run_script_test "$SCRIPT" "5"   "The argument doubled is 10"  "script1.bsh 5 → 'The argument doubled is 10'"
    run_script_test "$SCRIPT" "0"   "The argument doubled is 0"   "script1.bsh 0 → 'The argument doubled is 0'"
    run_script_test "$SCRIPT" "100" "The argument doubled is 200" "script1.bsh 100 → 'The argument doubled is 200'"
fi

print_summary
