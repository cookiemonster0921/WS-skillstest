# q015 — Data (hard): ALP seats to ALP_electorates.txt

**Original question:**
List the name, state and margin (in that order) of all seats held by the ALP. List them
in alphabetical order by electorate name and put the result in the file ALP_electorates.txt.

---

## What to do

Filter for ALP seats, print 3 fields (name, state, margin — omit party), sort by name.

```bash
grep ' ALP ' seats_2019.txt | awk '{print $1, $2, $4}' | sort > ALP_electorates.txt
```

## What the marker checks

- `ALP_electorates.txt` exists
- Correct number of ALP electorates (computed from data file)
- Exactly **3 fields per line**: name state margin (party field is omitted)
- Sorted alphabetically by electorate name
- Contents match expected output exactly
