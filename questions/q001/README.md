# q001 — Vim: keep only the last 20 lines

**Original question:**
Copy the file constitution.txt into a file called con1.txt. Using the vim editor
delete all but the last 20 lines of con1.txt.

---

## What to do

1. Copy constitution.txt into your working directory:
   ```
   cp <REPO_ROOT>/constitution.txt con1.txt
   ```
2. Open con1.txt in vim:
   ```
   vim con1.txt
   ```
3. Inside vim — the file has 421 lines, so delete lines 1–401:
   ```
   :set nu
   :1,401d
   :wq
   ```

## What the marker checks

- `con1.txt` exists
- `con1.txt` has exactly **20 lines**
- Contents match the last 20 lines of the original `constitution.txt`

## Notes

Any valid vim approach to deleting the first 401 lines is acceptable.
The `TERM=vt100;export TERM` setup mentioned in the question sheet is needed
only if vim displays incorrectly in your terminal.
