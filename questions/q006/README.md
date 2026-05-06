# q006 — Shell script: double an integer argument

**Original question:**
Write a shell script called script1.bsh that takes one argument (an integer). The script
should print out the string "The argument doubled is " followed by the argument
multiplied by two.

---

## What to do

Create a file called `script1.bsh` in your working directory.

Example content:
```bash
#!/bin/bash
echo "The argument doubled is $(( $1 * 2 ))"
```

## What the marker checks

| Command             | Expected output              |
|---------------------|------------------------------|
| `bash script1.bsh 5`   | `The argument doubled is 10` |
| `bash script1.bsh 0`   | `The argument doubled is 0`  |
| `bash script1.bsh 100` | `The argument doubled is 200`|

Output must match **exactly** (including the trailing space after "is ").
