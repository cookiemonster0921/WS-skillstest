#!/usr/bin/env bash
RUNDIR="$1"
REPO_ROOT="$2"
. "$REPO_ROOT/practice/lib/mark_helpers.sh"

SCRIPT="$RUNDIR/get_seats.sh"

check_file_exists "$SCRIPT" "get_seats.sh"

if [ "$FILE_EXISTS" = "1" ]; then
    # ── (a) Wrong argument count ─────────────────────────────────────────────
    OUT_0=$(bash "$SCRIPT" 2>/dev/null || true)
    if printf '%s' "$OUT_0" | grep -q "Incorrect number of Arguments"; then
        pass "(a) 0 args → error message contains 'Incorrect number of Arguments'"
    else
        fail "(a) 0 args → expected 'Incorrect number of Arguments', got: '$OUT_0'"
    fi
    if printf '%s' "$OUT_0" | grep -q "get_seats.sh"; then
        pass "(a) 0 args → Usage line contains 'get_seats.sh'"
    else
        fail "(a) 0 args → Usage line should contain 'get_seats.sh'"
    fi

    OUT_1=$(bash "$SCRIPT" ALP 2>/dev/null || true)
    if printf '%s' "$OUT_1" | grep -q "Incorrect number of Arguments"; then
        pass "(a) 1 arg → error message contains 'Incorrect number of Arguments'"
    else
        fail "(a) 1 arg → expected error message, got: '$OUT_1'"
    fi

    # Exit code must be non-zero for wrong arg count
    bash "$SCRIPT" > /dev/null 2>&1 || EXIT_0=$?
    EXIT_0=${EXIT_0:-0}
    if [ "$EXIT_0" -ne 0 ]; then
        pass "(a) 0 args → exits with non-zero status"
    else
        fail "(a) 0 args → should exit with non-zero status (got 0)"
    fi

    # ── (b) Invalid party ────────────────────────────────────────────────────
    OUT_B=$(bash "$SCRIPT" FOOBAR NSW 2>/dev/null || true)
    if printf '%s' "$OUT_B" | grep -q "Invalid Party"; then
        pass "(b) Invalid party 'FOOBAR' → 'Invalid Party' message"
    else
        fail "(b) Invalid party 'FOOBAR' → expected 'Invalid Party', got: '$OUT_B'"
    fi

    # ── (c) Invalid state ────────────────────────────────────────────────────
    OUT_C=$(bash "$SCRIPT" ALP FOOSTATE 2>/dev/null || true)
    if printf '%s' "$OUT_C" | grep -q "Invalid State"; then
        pass "(c) Invalid state 'FOOSTATE' → 'Invalid State' message"
    else
        fail "(c) Invalid state 'FOOSTATE' → expected 'Invalid State', got: '$OUT_C'"
    fi

    # (c) should NOT say "Invalid Party" (checks are in order: party then state)
    if ! printf '%s' "$OUT_C" | grep -q "Invalid Party"; then
        pass "(c) Checks are ordered: valid party passes before state is checked"
    else
        warn "(c) Got 'Invalid Party' for invalid-state test — party check should pass first"
    fi

    # ── (d) Valid args but no matching electorates ───────────────────────────
    # NAT WA: confirmed zero NAT seats in WA
    OUT_D=$(bash "$SCRIPT" NAT WA 2>/dev/null || true)
    if printf '%s' "$OUT_D" | grep -q "No electorates held by"; then
        pass "(d) NAT WA → 'No electorates held by' message"
    else
        fail "(d) NAT WA → expected 'No electorates held by ...', got: '$OUT_D'"
    fi
    if printf '%s' "$OUT_D" | grep -q "NAT"; then
        pass "(d) No-results message includes party name (NAT)"
    else
        fail "(d) No-results message should include party name (NAT)"
    fi
    if printf '%s' "$OUT_D" | grep -q "WA"; then
        pass "(d) No-results message includes state name (WA)"
    else
        fail "(d) No-results message should include state name (WA)"
    fi

    warn "Exit codes for (b) and (c) are not specified by the question — not checked."
    warn "Whether errors go to stdout or stderr is not specified — not checked."
fi

print_summary
