# q005 — Vim: replace 'the' and 'The' with 'THE'

**Original question:**
Copy the file constitution.txt to the file con5.txt. Modify every occurrence of the
words "the" and "The" to the string "THE".

---

## What to do

1. Copy constitution.txt:
   ```
   cp <REPO_ROOT>/constitution.txt con5.txt
   ```
2. Open in vim and replace both forms:
   ```
   vim con5.txt
   :%s/[Tt]he/THE/g
   :wq
   ```

## What the marker checks

- `con5.txt` exists
- Every occurrence of `the` **or** `The` (substring, case of first letter only) has been
  replaced with `THE`
- `THE` already present in the original is not double-replaced

## Notes

⚠️  The question uses "words" but does not specify whole-word boundaries.
The expected interpretation (substring) means `other` → `oTHEr` and
`There` → `THEre` etc.
