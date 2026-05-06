# q009 — Data: count VIC seats

**Original question:**
How many seats are there in Victoria (VIC)?

---

## What to do

Run a command that counts the number of electorates where state = VIC in `seats_2019.txt`.

Example:
```bash
grep " VIC " seats_2019.txt | wc -l
```

## What the marker checks

No output file is required — just print the answer to stdout.

Expected answer: **38**

⚠️  If you save your answer to a file (e.g. `vic_count.txt`), the marker will check it automatically.
