# q020 — Shell script: list seats for a party in a state

**Original question:**
Write a bash shell script where the user supplies the initials for the party as the first
argument and the initials of the state or territory as the second argument. The script
should then list the name and margins for all seats held by that party in that state.

---

## What to do

Create `get_seats.sh` that accepts `<party> <state>` and prints each matching electorate's
name and margin (2 fields per line).

Example:
```bash
#!/bin/bash
grep " $2 " seats_2019.txt | grep " $1 " | awk '{print $1, $4}'
```

## What the marker checks

| Test                        | What is checked                                    |
|-----------------------------|----------------------------------------------------|
| `bash get_seats.sh ALP NSW` | Output matches all NSW ALP electorates (name+margin) |
| `bash get_seats.sh LIB VIC` | Correct number of results                          |
| Output format               | Exactly 2 fields per line: name and margin         |

## Notes

- The script reads from `seats_2019.txt` in the working directory.
- No error checking is required for this question (that is q021).
