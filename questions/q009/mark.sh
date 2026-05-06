#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
EXPECTED_COUNT=$(grep ' VIC ' "$SEATS" | wc -l | tr -d ' ')

warn "q009: No output file was specified — this is a stdout-only question."
info "Expected answer: $EXPECTED_COUNT (number of VIC seats)"
info "Verify command:  grep \" VIC \" seats_2019.txt | wc -l"

# Accept any .txt file in RUNDIR that contains the answer
FOUND_FILE=0
for f in "$RUNDIR"/*.txt; do
    [ "$f" = "$RUNDIR/seats_2019.txt" ] && continue  # skip the data file itself
    if [ -f "$f" ]; then
        FOUND_FILE=1
        info "Checking optional output file: $(basename "$f")"
        if grep -qF "$EXPECTED_COUNT" "$f"; then
            pass "$(basename "$f") contains expected count ($EXPECTED_COUNT)"
        else
            fail "$(basename "$f") does not contain expected count ($EXPECTED_COUNT)"
        fi
    fi
done

if [ "$FOUND_FILE" = "0" ]; then
    warn "No output .txt file found — manually verify your command prints: $EXPECTED_COUNT"
fi

print_summary
