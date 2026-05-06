# q010 — Data: list NSW seat names

**Original question:**
List all the seats in NSW (just the seat names).

---

## What to do

Print only the electorate **names** (field 1) for all rows where state = NSW.

Example:
```bash
grep " NSW " seats_2019.txt | awk '{print $1}'
```

## What the marker checks

No output file is required — just print the names to stdout.

Expected: **47 seat names**, one per line, with no state/party/margin fields.

⚠️  If you save output to a file, the marker will check it automatically.
