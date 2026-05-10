#!/usr/bin/env bash
# Usage: ./mark.sh <question_id>   e.g.  ./mark.sh q001

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
QID="$1"

BOLD=$'\033[1m'
RED=$'\033[31m'
CYAN=$'\033[36m'
RESET=$'\033[0m'

if [ -z "$QID" ]; then
    printf "${BOLD}Usage:${RESET} %s <question_id>\n" "$0"
    exit 1
fi

QDIR="$SCRIPT_DIR/questions/$QID"
RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -f "$QDIR/mark.sh" ]; then
    printf "${RED}Error:${RESET} No mark script found for '${BOLD}%s${RESET}'\n" "$QID"
    exit 1
fi

if [ ! -d "$RUNDIR" ]; then
    printf "${RED}Error:${RESET} Run directory not found for '${BOLD}%s${RESET}'\n" "$QID"
    printf "Run ${BOLD}./start.sh %s${RESET} first.\n" "$QID"
    exit 1
fi

printf "\n${CYAN}$(printf '═%.0s' {1..56})${RESET}\n"
printf "${BOLD}${CYAN}  Marking %s${RESET}\n" "$QID"
printf "${CYAN}$(printf '═%.0s' {1..56})${RESET}\n\n"

bash "$QDIR/mark.sh" "$RUNDIR" "$REPO_ROOT"
