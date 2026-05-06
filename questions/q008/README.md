# q008 — Shell script: comparison + argument-count validation

**Original question:**
Make a copy of your answer from (2). Call the copy script2.bsh. Modify the script so
that if the number of arguments supplied is not exactly two, the script prints the
message "Incorrect number of Arguments – 2 required" and then exits, returning the
number 23 to the operating system.

---

## Naming note

⚠️  The question says "call the copy script2.bsh" but q007 already creates script2.bsh.
This is almost certainly a typo. **Name your script `script3.bsh`** to avoid confusion.
(The marker accepts both script3.bsh and script2.bsh.)

## What to do

Copy your script from q007 and extend it to check argument count first:

```bash
#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Incorrect number of Arguments – 2 required"
    exit 23
fi
if [ "$1" -gt "$2" ]; then
    echo "The first argument is bigger than the second."
elif [ "$2" -gt "$1" ]; then
    echo "The second argument is bigger than the first."
else
    echo "The arguments are equal"
fi
```

## What the marker checks

- Normal comparison (5 3, 3 5, 4 4) still produces correct output
- 0 arguments → output contains `Incorrect number of Arguments`, exit code **23**
- 1 argument  → same
- 3 arguments → same

⚠️  Both `–` (en-dash) and `-` (hyphen) are accepted in the error message.
