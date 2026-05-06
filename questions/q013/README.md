# q013 — Data: seats grouped by state in prescribed order

**Original question:**
Create a file called seats_by_state.txt that lists all NSW seats, then VIC seats, then
WA seats, then QLD seats, then SA seats, then TAS seats, then ACT then NT seats. Within
each state or territory listing the seats should be in alphabetical order.

---

## What to do

Group electorates by state in this exact order: **NSW, VIC, WA, QLD, SA, TAS, ACT, NT**
and sort alphabetically within each group.

```bash
for state in NSW VIC WA QLD SA TAS ACT NT; do
    grep " $state " seats_2019.txt | sort
done > seats_by_state.txt
```

## What the marker checks

- `seats_by_state.txt` exists
- All 151 electorates are present
- State groups appear in the correct order: NSW → VIC → WA → QLD → SA → TAS → ACT → NT
- Within NSW and VIC blocks, seats are alphabetically sorted
- All 4 fields (name, state, party, margin) are preserved

⚠️  Optional state-header lines between groups are acceptable.
