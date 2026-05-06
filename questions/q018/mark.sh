#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"

warn "q018: No output file was specified — this is a stdout-only question."
info "Expected counts per state (computed from data file):"
awk '{print $2}' "$SEATS" | sort | uniq -c | awk '{printf "   %-4s : %d\n", $2, $1}'

# Accept any .txt file in RUNDIR (other than the data file itself)
FOUND_FILE=0
for f in "$RUNDIR"/*.txt; do
    [ "$f" = "$RUNDIR/seats_2019.txt" ] && continue
    if [ -f "$f" ]; then
        FOUND_FILE=1
        info "Checking optional output file: $(basename "$f")"
        for STATE in NSW VIC WA QLD SA TAS ACT NT; do
            if grep -q "$STATE" "$f"; then
                pass "$(basename "$f") contains $STATE"
            else
                fail "$(basename "$f") missing $STATE"
            fi
        done
        # Verify count for at least VIC (38) and NSW (47) as spot checks
        VIC_EXPECTED=$(grep ' VIC ' "$SEATS" | wc -l | tr -d ' ')
        NSW_EXPECTED=$(grep ' NSW ' "$SEATS" | wc -l | tr -d ' ')
        if grep -q "$VIC_EXPECTED" "$f"; then
            pass "$(basename "$f") contains VIC count ($VIC_EXPECTED)"
        else
            fail "$(basename "$f") does not contain VIC count ($VIC_EXPECTED)"
        fi
        if grep -q "$NSW_EXPECTED" "$f"; then
            pass "$(basename "$f") contains NSW count ($NSW_EXPECTED)"
        else
            fail "$(basename "$f") does not contain NSW count ($NSW_EXPECTED)"
        fi
    fi
done

if [ "$FOUND_FILE" = "0" ]; then
    warn "No output .txt file found — manually verify your command output matches the counts above."
fi

print_summary
