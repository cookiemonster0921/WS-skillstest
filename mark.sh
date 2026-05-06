#!/usr/bin/env bash
# Usage: ./mark.sh <question_id>   e.g.  ./mark.sh q001

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
QID="$1"

if [ -z "$QID" ]; then
    echo "Usage: $0 <question_id>"
    exit 1
fi

QDIR="$SCRIPT_DIR/questions/$QID"
RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -f "$QDIR/mark.sh" ]; then
    echo "Error: No mark.sh found for '$QID' (looked in $QDIR/mark.sh)"
    exit 1
fi

if [ ! -d "$RUNDIR" ]; then
    echo "Error: Run directory not found: $RUNDIR"
    echo "Have you run:  ./start.sh $QID  first?"
    exit 1
fi

echo "══════════════════════════════════════════════"
echo "Marking $QID"
echo "══════════════════════════════════════════════"
bash "$QDIR/mark.sh" "$RUNDIR" "$REPO_ROOT"
