#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SEATS="$REPO_ROOT/seats_2019.txt"
EXPECTED_COUNT=$(grep ' NSW ' "$SEATS" | wc -l | tr -d ' ')

warn "q010: No output file was specified — this is a stdout-only question."
info "Expected: $EXPECTED_COUNT NSW seat names, one per line (name field only)."
info "Verify command: grep \" NSW \" seats_2019.txt | awk '{print \$1}'"

# If any .txt file exists (other than the data file), check it
FOUND_FILE=0
for f in "$RUNDIR"/*.txt; do
    [ "$f" = "$RUNDIR/seats_2019.txt" ] && continue
    if [ -f "$f" ]; then
        FOUND_FILE=1
        info "Checking optional output file: $(basename "$f")"
        check_line_count "$f" "$EXPECTED_COUNT" "$(basename "$f")"
        # Check it does NOT contain extra fields (state/party/margin patterns)
        if grep -qE ' (NSW|VIC|WA|QLD|SA|TAS|ACT|NT) ' "$f" 2>/dev/null; then
            fail "$(basename "$f") appears to contain state/party/margin fields — should be names only"
        else
            pass "$(basename "$f") appears to contain names only (no state/party/margin columns)"
        fi
    fi
done

if [ "$FOUND_FILE" = "0" ]; then
    warn "No output .txt file found — manually verify your command prints $EXPECTED_COUNT seat names."
fi

print_summary
