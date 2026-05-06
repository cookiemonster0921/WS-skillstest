# q017 — Data (hard): 20 most marginal seats

**Original question:**
List the party, name, state and margin of the 20 electorates with the smallest margins.
List them in order of margin (smallest margin first) and put the result in the file
twenty_most_marginal_seats.txt.

---

## What to do

Sort by margin, take the 20 smallest, reorder fields to: party name state margin.

```bash
sort -k4 -n seats_2019.txt | head -20 | awk '{print $3, $1, $2, $4}' \
    > twenty_most_marginal_seats.txt
```

## What the marker checks

- `twenty_most_marginal_seats.txt` exists
- Exactly **20 lines**
- Field order: **party name state margin**
- Sorted by margin ascending (smallest first)
- Contents match expected output exactly
