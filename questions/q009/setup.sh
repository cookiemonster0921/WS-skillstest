#!/usr/bin/env bash
# Copy seats_2019.txt into the run directory
RUNDIR="$1"
REPO_ROOT="$2"
cp "$REPO_ROOT/seats_2019.txt" "$RUNDIR/seats_2019.txt"
