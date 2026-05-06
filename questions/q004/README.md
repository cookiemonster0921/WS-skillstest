# q004 — Vim: replace all 'the' with 'THE'

**Original question:**
Copy the file constitution.txt to the file con4.txt. Modify every occurrence of the
string "the" to the string "THE".

---

## What to do

1. Copy constitution.txt:
   ```
   cp <REPO_ROOT>/constitution.txt con4.txt
   ```
2. Open in vim and replace:
   ```
   vim con4.txt
   :%s/the/THE/g
   :wq
   ```

## What the marker checks

- `con4.txt` exists
- Every occurrence of the **substring** `the` (case-sensitive) has been replaced with `THE`

## Important notes

- This is a **substring** replacement, not a whole-word replacement.
  For example: `other` → `oTHEr`, `there` → `THEre`.
- Only lowercase `the` is replaced. `The` and `THE` are NOT changed by this question.
  (That is q005.)
