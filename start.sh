#!/usr/bin/env bash
# Usage: ./start.sh <question_id>   e.g.  ./start.sh q001
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
QID="$1"

if [ -z "$QID" ]; then
    echo "Usage: $0 <question_id>"
    echo "Example: $0 q001"
    exit 1
fi

QDIR="$SCRIPT_DIR/questions/$QID"
RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -d "$QDIR" ]; then
    echo "Error: No question folder found for '$QID' (looked in $QDIR)"
    echo "Available questions:"
    ls "$SCRIPT_DIR/questions/" 2>/dev/null | tr '\n' ' '
    echo ""
    exit 1
fi

echo "Setting up $QID ..."
rm -rf "$RUNDIR"
mkdir -p "$RUNDIR"

# Copy starter files if any exist
if [ -d "$QDIR/files" ] && [ "$(ls -A "$QDIR/files" 2>/dev/null)" ]; then
    cp -r "$QDIR/files/." "$RUNDIR/"
fi

# Run setup script if present
if [ -f "$QDIR/setup.sh" ]; then
    bash "$QDIR/setup.sh" "$RUNDIR" "$REPO_ROOT"
fi

echo ""
echo "══════════════════════════════════════════════"
if [ -f "$QDIR/README.md" ]; then
    cat "$QDIR/README.md"
fi
echo "══════════════════════════════════════════════"
echo ""
echo "Your working directory: $RUNDIR"
echo "When done, run:         cd \"$(dirname "$RUNDIR")\" && ./mark.sh $QID"
echo "                    or: cd \"$SCRIPT_DIR\" && ./mark.sh $QID"
