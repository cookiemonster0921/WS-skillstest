#!/usr/bin/env bash
# Usage: ./reset.sh <question_id>   e.g.  ./reset.sh q001

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QID="$1"

if [ -z "$QID" ]; then
    echo "Usage: $0 <question_id>"
    exit 1
fi

RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -d "$RUNDIR" ]; then
    echo "Nothing to reset: $RUNDIR does not exist."
    exit 0
fi

rm -rf "$RUNDIR"
echo "Reset complete: $RUNDIR removed."
echo "Run ./start.sh $QID to start fresh."
