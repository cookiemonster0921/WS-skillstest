# q016 — Data (hard): non-major party seats sorted by margin

**Original question:**
List the name, state, party and margin (in that order) of all seats not held by the
major parties. List them in order of margin (smallest margin first) and put the result
in the file non-major-parties-margin.txt.

---

## Major parties (to exclude)

ALP, LIB, NAT, LNP, GRN

## Minor parties (included in output)

CA (Centre Alliance), IND (Independents), KAP (Katter Party)

## What to do

```bash
grep -v ' ALP \| LIB \| NAT \| LNP \| GRN ' seats_2019.txt \
    | awk '{print $1, $2, $3, $4}' \
    | sort -k4 -n > non-major-parties-margin.txt
```

## What the marker checks

- `non-major-parties-margin.txt` exists
- Correct number of non-major party rows (5 in this dataset)
- Field order: **name state party margin** (4 fields)
- Sorted numerically by margin ascending
- Contents match expected output exactly

Expected rows (sorted by margin):
```
Wentworth NSW IND 1.0
Mayo SA CA 2.9
Indi VIC IND 5.5
Kennedy QLD KAP 11.0
Clark TAS IND 17.8
```
