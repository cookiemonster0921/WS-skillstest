# q011 — Data: sorted NSW seats to NSW_sorted.txt

**Original question:**
Take your answer from (2) and sort it into a file NSW_sorted.txt.

---

## What to do

Extract NSW seat names, sort them alphabetically, and write to `NSW_sorted.txt`.

```bash
grep " NSW " seats_2019.txt | awk '{print $1}' | sort > NSW_sorted.txt
```

## What the marker checks

- `NSW_sorted.txt` exists
- Contains exactly **47 lines**
- Lines are alphabetically sorted
- Contains **seat names only** — no state, party, or margin fields
- Contents match the expected output exactly
