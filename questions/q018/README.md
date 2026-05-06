# q018 — Data (hard): electorate count per state/territory

**Original question:**
List all the states and territories and the total number of electorates in each of them.

---

## What to do

Count electorates grouped by state/territory (field 2).

```bash
awk '{print $2}' seats_2019.txt | sort | uniq -c
```

## What the marker checks

No output file is required — just print to stdout.

Expected counts:
```
ACT :  3
NSW : 47
NT  :  2
QLD : 30
SA  : 10
TAS :  5
VIC : 38
WA  : 16
```

⚠️  Output format (count before or after state name) is not strictly specified.
If you save output to a file, the marker will check it automatically.
