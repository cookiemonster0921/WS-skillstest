# q021 — Shell script: get_seats.sh with full error checking

**Original question:**
Take your answer from (7) and add error checking:
(a) If the number of arguments is incorrect print:
    `Incorrect number of Arguments`
    `Usage : get_seats.sh <party_name> <state>`
(b) Check that the party initials are valid. If they are invalid print "Invalid Party" and exit.
(c) Check that the state initials are valid. If they are invalid print "Invalid State" and exit.
(d) If your script has passed the error checking in (a), (b) and (c), but there are no actual
    electorates held for the party and state/territory supplied as arguments (for example there are
    no NAT members in WA) then the script should print:
    `No electorates held by <party name> in <state/territory name>`

---

## What to do

Extend `get_seats.sh` from q020 with these four checks in order:

```bash
#!/bin/bash
VALID_PARTIES="ALP LIB NAT LNP GRN CA IND KAP"
VALID_STATES="NSW VIC WA QLD SA TAS ACT NT"

if [ "$#" -ne 2 ]; then
    echo "Incorrect number of Arguments"
    echo "Usage : get_seats.sh <party_name> <state>"
    exit 1
fi

PARTY_VALID=0
for p in $VALID_PARTIES; do
    [ "$1" = "$p" ] && PARTY_VALID=1
done
if [ "$PARTY_VALID" = "0" ]; then
    echo "Invalid Party"
    exit 1
fi

STATE_VALID=0
for s in $VALID_STATES; do
    [ "$2" = "$s" ] && STATE_VALID=1
done
if [ "$STATE_VALID" = "0" ]; then
    echo "Invalid State"
    exit 1
fi

RESULTS=$(grep " $2 " seats_2019.txt | grep " $1 " | awk '{print $1, $4}')
if [ -z "$RESULTS" ]; then
    echo "No electorates held by $1 in $2"
else
    printf '%s\n' "$RESULTS"
fi
```

## What the marker checks

| Test                               | Expected output                                   |
|------------------------------------|---------------------------------------------------|
| `bash get_seats.sh`                | `Incorrect number of Arguments` + Usage line      |
| `bash get_seats.sh ALP`            | Same error                                        |
| `bash get_seats.sh FOOBAR NSW`     | `Invalid Party`                                   |
| `bash get_seats.sh ALP FOOSTATE`   | `Invalid State`                                   |
| `bash get_seats.sh NAT WA`         | `No electorates held by NAT in WA`                |

## Valid values

- **Parties:** ALP LIB NAT LNP GRN CA IND KAP
- **States:**  NSW VIC WA QLD SA TAS ACT NT

## Ambiguity notes

⚠️  Exit codes for (b) and (c) are not specified — any non-zero is fine.
⚠️  Whether errors go to stdout or stderr is not specified.
