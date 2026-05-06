# q003 — Vim: move lines 100–200 to end of file

**Original question:**
Copy the file constitution.txt into a file called con3.txt. Using the vim editor,
move lines 100 to 200 inclusive to the end of the file.

---

## What to do

1. Copy constitution.txt:
   ```
   cp <REPO_ROOT>/constitution.txt con3.txt
   ```
2. Open in vim and move the block:
   ```
   vim con3.txt
   ```
   Inside vim:
   ```
   :100,200m$
   :wq
   ```

## What the marker checks

- `con3.txt` exists
- `con3.txt` still has **421 lines** (no lines dropped)
- Lines 100–200 of the original appear at the **end** of the file
- Lines 1–99 and 201–421 remain in their original order before the moved block

## Expected structure after editing

```
Lines 1–99     (unchanged)
Lines 201–421  (unchanged)
Lines 100–200  (moved to end)
```
