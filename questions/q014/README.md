# q014 — Data (hard): seat held by smallest margin

**Original question:**
What seat is held by the smallest margin? Put the answer in a text file smallest.txt.

---

## What to do

Sort `seats_2019.txt` numerically by the margin field (field 4) and take the first row.

```bash
sort -k4 -n seats_2019.txt | head -1 > smallest.txt
```

## What the marker checks

- `smallest.txt` exists
- Contains the electorate name of the seat with the smallest margin
- Contains the correct margin value

Expected row: **Herbert QLD ALP 0.02**
