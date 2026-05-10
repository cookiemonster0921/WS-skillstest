#!/usr/bin/env bash
# Usage: ./reset.sh <question_id>   e.g.  ./reset.sh q001

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
QID="$1"

BOLD=$'\033[1m'
RED=$'\033[31m'
YELLOW=$'\033[33m'
GREEN=$'\033[32m'
RESET=$'\033[0m'

if [ -z "$QID" ]; then
    printf "${BOLD}Usage:${RESET} %s <question_id>\n" "$0"
    exit 1
fi

RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -d "$RUNDIR" ]; then
    printf "${YELLOW}Nothing to reset:${RESET} %s does not exist.\n" "$RUNDIR"
    exit 0
fi

printf "${YELLOW}Resetting %s ...${RESET}\n" "$QID"
rm -rf "$RUNDIR"
printf "${GREEN}Done.${RESET} Run directory removed.\n"
printf "Start fresh with: ${BOLD}./start.sh %s${RESET}\n" "$QID"
