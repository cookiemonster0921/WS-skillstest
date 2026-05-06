# q012 — Data: sort all seats to sorted_seats.txt

**Original question:**
Sort the seats_2019.txt file by electorate name into a new file sorted_seats.txt.

---

## What to do

Sort all rows alphabetically by electorate name (field 1) and write to `sorted_seats.txt`.

```bash
sort seats_2019.txt > sorted_seats.txt
```

## What the marker checks

- `sorted_seats.txt` exists
- Contains exactly **151 lines** (all electorates)
- All **4 fields** (name, state, party, margin) are preserved per line
- Sorted lexicographically by field 1 (electorate name)
- Contents match `sort seats_2019.txt` exactly
