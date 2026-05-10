#!/usr/bin/env bash
# Usage: ./start.sh <question_id>   e.g.  ./start.sh q001

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
QID="$1"

# Colour codes
BOLD=$'\033[1m'
RED=$'\033[31m'
GREEN=$'\033[32m'
CYAN=$'\033[36m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# ── Validate input ────────────────────────────────────────────────────────────
if [ -z "$QID" ]; then
    printf "${BOLD}Usage:${RESET}   %s <question_id>\n" "$0"
    printf "${BOLD}Example:${RESET} %s q001\n" "$0"
    exit 1
fi

QDIR="$SCRIPT_DIR/questions/$QID"
RUNDIR="$SCRIPT_DIR/runs/$QID"

if [ ! -d "$QDIR" ]; then
    printf "${RED}Error:${RESET} No question folder found for '${BOLD}%s${RESET}'\n" "$QID"
    printf "Available questions: "
    ls "$SCRIPT_DIR/questions/" 2>/dev/null | tr '\n' ' '
    printf "\n"
    exit 1
fi

# ── Set up run directory ──────────────────────────────────────────────────────
printf "${DIM}Setting up %s ...${RESET}\n" "$QID"
rm -rf "$RUNDIR"
mkdir -p "$RUNDIR"

if [ -d "$QDIR/files" ] && [ "$(ls -A "$QDIR/files" 2>/dev/null)" ]; then
    cp -r "$QDIR/files/." "$RUNDIR/"
fi

if [ -f "$QDIR/setup.sh" ]; then
    bash "$QDIR/setup.sh" "$RUNDIR" "$REPO_ROOT"
fi

# ── Display question (no answers) ─────────────────────────────────────────────
# Locate questions.json — prefer local data/ then one level up
if [ -f "$SCRIPT_DIR/data/questions.json" ]; then
    QUESTIONS_FILE="$SCRIPT_DIR/data/questions.json"
else
    QUESTIONS_FILE="$REPO_ROOT/data/questions.json"
fi

python3 - "$QID" "$QUESTIONS_FILE" <<'PYEOF'
import json, sys, textwrap

qid   = sys.argv[1]
qfile = sys.argv[2]

BOLD  = '\033[1m'
CYAN  = '\033[36m'
YELL  = '\033[33m'
DIM   = '\033[2m'
RESET = '\033[0m'
LINE  = '═' * 56

try:
    with open(qfile) as f:
        questions = json.load(f)
except Exception as e:
    print(f"(Could not load questions.json: {e})", file=sys.stderr)
    sys.exit(0)

q = next((x for x in questions if x['id'] == qid), None)
if not q:
    sys.exit(0)

# Header
print(f'\n{CYAN}{LINE}{RESET}')
print(f'{BOLD}{CYAN}  {q["id"].upper()} — {q["title"]}{RESET}')
print(f'{CYAN}{LINE}{RESET}\n')

# Original question text (word-wrapped)
print(f'{BOLD}Question:{RESET}')
for line in textwrap.wrap(q.get('original_text', ''), width=70):
    print(f'  {line}')
print()

# Task summary
print(f'{BOLD}What to do:{RESET}')
for line in textwrap.wrap(q.get('task_summary', ''), width=70):
    print(f'  {line}')
print()

# Files available in the run directory
files = q.get('required_files', [])
if files:
    print(f'{BOLD}Files in your working directory:{RESET}')
    for f in files:
        print(f'  • {f}')
    print()

# Hints: commands_likely_needed, but filter out full pipelines
# (pipelines usually ARE the answer; individual command names are safe hints)
all_hints  = q.get('commands_likely_needed', [])
safe_hints = [c for c in all_hints if '|' not in c]
if safe_hints:
    print(f'{YELL}Useful commands to know:{RESET}')
    for h in safe_hints:
        print(f'  {DIM}{h}{RESET}')
    print()
PYEOF

# ── Working directory and next steps ─────────────────────────────────────────
printf "${CYAN}${BOLD}  Next steps:${RESET}\n"
printf "\n"
printf "  1. Move into your working directory:\n"
printf "     ${GREEN}cd %s${RESET}\n" "$RUNDIR"
printf "\n"
printf "  2. Do your work there.\n"
printf "\n"
printf "  3. When finished, mark your answer:\n"
printf "     ${GREEN}cd %s${RESET}\n" "$SCRIPT_DIR"
printf "     ${GREEN}./mark.sh %s${RESET}\n" "$QID"
printf "${CYAN}$(printf '═%.0s' {1..56})${RESET}\n\n"
