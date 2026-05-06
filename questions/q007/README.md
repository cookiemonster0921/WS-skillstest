# q007 — Shell script: compare two integer arguments

**Original question:**
Write a shell script called script2.bsh that takes two integer arguments.
- If the first argument is bigger than the second it should print "The first argument is bigger than the second."
- If the second argument is bigger than the first it should print "The second argument is bigger than the first."
- If the arguments are equal then the script should print "The arguments are equal"

---

## What to do

Create `script2.bsh` in your working directory.

Example:
```bash
#!/bin/bash
if [ "$1" -gt "$2" ]; then
    echo "The first argument is bigger than the second."
elif [ "$2" -gt "$1" ]; then
    echo "The second argument is bigger than the first."
else
    echo "The arguments are equal"
fi
```

## What the marker checks

| Command               | Expected output                                    |
|-----------------------|----------------------------------------------------|
| `bash script2.bsh 5 3` | `The first argument is bigger than the second.`   |
| `bash script2.bsh 3 5` | `The second argument is bigger than the first.`   |
| `bash script2.bsh 4 4` | `The arguments are equal`                         |

⚠️  Note: the first two messages have a trailing **period**; "The arguments are equal" does **not**.
