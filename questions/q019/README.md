# q019 — Data (hard): 20 safest seats

**Original question:**
List the margin, party name and state of the 20 electorates with the largest margins.
List them in order of margin (smallest margin first) and put the result in the file
twenty_safest_seats.txt.

---

## What to do

1. Find the 20 electorates with the **largest** margins.
2. Sort those 20 by margin ascending (smallest of the 20 first).
3. Output field order: **margin party name state**.

```bash
sort -k4 -n seats_2019.txt | tail -20 | sort -k4 -n \
    | awk '{print $4, $3, $1, $2}' > twenty_safest_seats.txt
```

## What the marker checks

- `twenty_safest_seats.txt` exists
- Exactly **20 lines**
- Field order: **margin party name state**
- These are the 20 electorates with the **largest** margins, listed smallest-first within that set
- Contents match expected output exactly

## Notes

The pipeline: `sort -k4 -n` sorts all 151 electorates ascending → `tail -20` takes the
20 largest → `sort -k4 -n` re-sorts those 20 ascending → `awk` reorders fields.
