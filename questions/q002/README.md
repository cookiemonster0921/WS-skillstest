# q002 — Without vim: last 30 lines to con2.txt

**Original question:**
Can you do the task required in (1) without using vim? What command would you use?
Using the command, create a file called con2.txt with the last 30 lines of constitution.txt.

---

## What to do

Create `con2.txt` containing the **last 30 lines** of `constitution.txt` using a
shell command (not vim). Also note which command you used.

Example:
```bash
tail -30 <REPO_ROOT>/constitution.txt > con2.txt
```

## What the marker checks

- `con2.txt` exists
- `con2.txt` has exactly **30 lines**
- Contents match the last 30 lines of the original `constitution.txt`

⚠️  The written answer naming the command cannot be auto-checked.
