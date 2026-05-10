# Linux/Unix Practice Question Bank

Extracted from `extra_skills_problems v1-04.pdf` — 21 questions total.

---

## Vim

### q001 – Vim – delete all but last 20 lines

**Difficulty:** easy

**Original text:**
> Copy the file constitution.txt into a file called con1.txt. Using the vim editor delete all but the last 20 lines of con1.txt

**Task summary:** Create con1.txt from constitution.txt then use vim to keep only the last 20 lines.

**Required files:** `constitution.txt`

**Expected outputs:**
- con1.txt (last 20 lines of constitution.txt)

**Commands likely needed:** `cp` `vim` `:set nu` `1,<N-20>d` `:wq`

**Marking notes:**
- con1.txt must exist
- con1.txt must contain exactly the last 20 lines of constitution.txt
- Verify with: wc -l con1.txt && tail -20 constitution.txt | diff - con1.txt

**Ambiguity notes:**
- The vim command sequence is not specified; any valid vim deletion approach is acceptable

---

### q002 – Non-vim alternative – last 30 lines to con2.txt

**Difficulty:** easy

**Original text:**
> Can you do the task required in (1) without using vim? What command would you use? Using the command, create a file called con2.txt with the last 30 lines of constitution.txt

**Task summary:** Use a shell command (e.g. tail) instead of vim to create con2.txt containing the last 30 lines of constitution.txt.

**Required files:** `constitution.txt`

**Expected outputs:**
- con2.txt (last 30 lines of constitution.txt)

**Commands likely needed:** `tail -30 constitution.txt > con2.txt`

**Marking notes:**
- con2.txt must exist
- con2.txt must contain exactly the last 30 lines of constitution.txt
- Verify with: tail -30 constitution.txt | diff - con2.txt

**Ambiguity notes:**
- Question also asks the student to name the command; a written answer as well as the file may be expected

---

### q003 – Vim – move lines 100–200 to end of file

**Difficulty:** medium

**Original text:**
> Copy the file constitution.txt into a file called con3.txt. Using the vim editor, moves lines 100 to 200 inclusive to the end of the file.

**Task summary:** Create con3.txt, then use vim to cut lines 100–200 and paste them at the end of the file.

**Required files:** `constitution.txt`

**Expected outputs:**
- con3.txt with lines 100–200 relocated to the end

**Commands likely needed:** `cp` `vim` `:100,200m$` `:wq`

**Marking notes:**
- con3.txt must exist
- Lines 100–200 of the original must appear at the end of the file
- All other lines must remain in original relative order

**Ambiguity notes:**
- Word 'moves' (typo for 'move') does not change meaning
- 'End of file' could mean after the current last line; accept any placement that appends block after all non-moved content

---

### q004 – Vim – replace all 'the' with 'THE'

**Difficulty:** easy

**Original text:**
> Copy the file constitution.txt to the file con4.txt Modify every occurrence of the string "the" to the string "THE".

**Task summary:** Create con4.txt from constitution.txt and replace every occurrence of the substring 'the' (case-sensitive) with 'THE'.

**Required files:** `constitution.txt`

**Expected outputs:**
- con4.txt with all 'the' replaced by 'THE'

**Commands likely needed:** `cp` `vim` `:%s/the/THE/g` `:wq`

**Marking notes:**
- Every occurrence of 'the' (as a substring) must be replaced with 'THE'
- Occurrences inside larger words (e.g. 'other' → 'oTHEr') ARE replaced because no word-boundary is specified
- Case-sensitive: 'The', 'THE' etc. are NOT replaced

**Ambiguity notes:**
- The question says 'the string the' implying substring match, not whole-word match

---

### q005 – Vim – replace 'the' and 'The' with 'THE'

**Difficulty:** easy

**Original text:**
> Copy the file constitution.txt to the file con5.txt Modify every occurrence of the words "the" and "The" to the string "THE".

**Task summary:** Create con5.txt from constitution.txt and replace every occurrence of 'the' or 'The' with 'THE'.

**Required files:** `constitution.txt`

**Expected outputs:**
- con5.txt with 'the' and 'The' replaced by 'THE'

**Commands likely needed:** `cp` `vim` `:%s/[Tt]he/THE/g` `:wq`

**Marking notes:**
- Both 'the' and 'The' occurrences must become 'THE'
- 'THE' already present should not be double-replaced
- Substring replacement (not whole-word) is implied by the problem wording

**Ambiguity notes:**
- The question uses 'words' but does not say whole-word boundary; substring replacement is the expected interpretation based on context

---

## Shell Scripting

### q006 – Shell script – double an integer argument

**Difficulty:** easy

**Original text:**
> Write a shell script called script1.bsh that takes one argument (an integer). The script should print out the string "The argument doubled is " followed by the argument multiplied by two.

**Task summary:** Create script1.bsh: accepts one integer argument and prints 'The argument doubled is <2*arg>'.

**Expected outputs:**
- stdout: 'The argument doubled is <value>'

**Commands likely needed:** `#!/bin/bash` `expr` `echo` `$(( ))`

**Marking notes:**
- Script must be named script1.bsh
- Output string must match exactly: 'The argument doubled is '
- The doubled value must be arithmetically correct
- Test with: bash script1.bsh 5  →  The argument doubled is 10

**Ambiguity notes:**
- No input validation is required by the question; non-integer input behaviour is unspecified

---

### q007 – Shell script – compare two integer arguments

**Difficulty:** easy

**Original text:**
> Write a shell script called script2.bsh that takes two integer arguments.
> If the first argument is bigger than the second it should print "The first argument is bigger than the second."
> If the second argument is bigger than the first it should print "The second argument is bigger than the first."
> If the arguments are equal then the script should print "The arguments are equal"

**Task summary:** Create script2.bsh: compare two integer arguments and print the appropriate comparison message.

**Expected outputs:**
- stdout: 'The first argument is bigger than the second.'
- stdout: 'The second argument is bigger than the first.'
- stdout: 'The arguments are equal'

**Commands likely needed:** `#!/bin/bash` `if` `-gt` `-lt` `-eq` `echo`

**Marking notes:**
- Script must be named script2.bsh
- All three output strings must match exactly (including trailing period on first two)
- Test with: bash script2.bsh 5 3 / bash script2.bsh 3 5 / bash script2.bsh 4 4

**Ambiguity notes:**
- 'The arguments are equal' lacks a trailing period unlike the other two messages; preserve original wording

---

### q008 – Shell script – compare two integers with argument-count validation

**Difficulty:** medium

**Original text:**
> Make a copy of your answer from (2). Call the copy script2.bsh. Modify the script so that if the number of arguments supplied is not exactly two, the script prints the message "Incorrect number of Arguments – 2 required" and then exits, returning the number 23 to the operating system.

**Task summary:** Extend script2.bsh (from q007) to validate that exactly two arguments are supplied; if not, print the error message and exit with code 23.

**Expected outputs:**
- stdout (wrong arg count): 'Incorrect number of Arguments – 2 required'
- exit code 23 when argument count != 2

**Commands likely needed:** `#!/bin/bash` `$#` `-ne 2` `echo` `exit 23`

**Marking notes:**
- Script must still be named script2.bsh (per question wording – likely intended as script3.bsh; see ambiguity_notes)
- Exit code must be exactly 23: verify with $?
- Error message must match exactly
- Normal comparison behaviour from q007 must still work

**Ambiguity notes:**
- The question says 'Call the copy script2.bsh' but q007 already creates script2.bsh; this is likely a naming error and the intended filename may be script3.bsh
- The en-dash (–) in the error message may differ from a standard hyphen; accept both

---

## Data Processing – Basic Questions

> **Data file context:** `seats_2019.txt` contains 2019 Australian federal election electorate data.
> Fields (space-separated): `electorate_name  state  party_initials  margin`
> Multi-word electorate names are hyphenated. Data is unordered.
>
> Major parties: ALP, LIB, NAT, LNP, GRN
> Minor parties: CA, IND, KAP

### q009 – Data – count VIC seats

**Difficulty:** easy

**Original text:**
> How many seats are there in Victoria (VIC)?

**Task summary:** Count the number of electorates in seats_2019.txt where the state field is VIC.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- stdout: a single integer count

**Commands likely needed:** `grep` `awk` `wc -l`

**Marking notes:**
- No output file specified; stdout answer is sufficient unless instructor requires a file
- Correct answer can be verified against seats_2019.txt

**Ambiguity notes:**
- Question does not specify an output file; marking may accept command + printed number

---

### q010 – Data – list NSW seat names

**Difficulty:** easy

**Original text:**
> List all the seats in NSW (just the seat names).

**Task summary:** Extract and print only the electorate name (field 1) for all rows where state == NSW.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- stdout: one seat name per line

**Commands likely needed:** `grep` `awk '{print $1}'` `cut -d' ' -f1`

**Marking notes:**
- Only seat names should appear – no state, party, or margin
- No output file required by this question

---

### q011 – Data – sorted NSW seats to NSW_sorted.txt

**Difficulty:** easy

**Original text:**
> Take your answer from (2) and sort it into a file NSW_sorted.txt

**Task summary:** Sort the NSW seat names (from q010) alphabetically and write to NSW_sorted.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- NSW_sorted.txt: alphabetically sorted NSW seat names, one per line

**Commands likely needed:** `grep` `awk` `sort` `> NSW_sorted.txt`

**Marking notes:**
- NSW_sorted.txt must exist
- Contents must be alphabetically sorted (default LC sort)
- Only seat names – no other fields

---

### q012 – Data – sort all electorates to sorted_seats.txt

**Difficulty:** easy

**Original text:**
> Sort the seats_2019.txt file by electorate name into a new file sorted_seats.txt

**Task summary:** Sort every line of seats_2019.txt alphabetically by the first field (electorate name) and write to sorted_seats.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- sorted_seats.txt: all lines sorted by electorate name

**Commands likely needed:** `sort seats_2019.txt > sorted_seats.txt` `sort -k1`

**Marking notes:**
- sorted_seats.txt must exist
- All four fields must be preserved per line
- Sorted by field 1 (electorate name)

---

### q013 – Data – seats grouped by state in prescribed order

**Difficulty:** medium

**Original text:**
> Create a file called seats_by_state.txt that lists all NSW seats, then VIC seats, then WA seats, then QLD seats, then SA seats, then TAS seats, then ACT then NT seats. Within each state or territory listing the seats should be in alphabetical order.

**Task summary:** Produce seats_by_state.txt: electorates grouped in the order NSW, VIC, WA, QLD, SA, TAS, ACT, NT, alphabetically sorted within each group.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- seats_by_state.txt: all electorates grouped and sorted as specified

**Commands likely needed:** `grep` `sort` `cat` `>>`

**Marking notes:**
- State grouping order must be exactly: NSW, VIC, WA, QLD, SA, TAS, ACT, NT
- Within each group, lines must be alphabetically sorted by electorate name
- All four fields must be present

**Ambiguity notes:**
- Whether a state-header line should be included is not specified; accept with or without headers

---

## Data Processing – Harder Questions

### q014 – Data (hard) – seat held by smallest margin

**Difficulty:** medium

**Original text:**
> What seat is held by the smallest margin? Put the answer in a text file smallest.txt

**Task summary:** Find the electorate with the minimum margin (field 4) and write that row to smallest.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- smallest.txt: single line containing the row with the smallest margin

**Commands likely needed:** `sort -k4 -n` `head -1` `> smallest.txt`

**Marking notes:**
- smallest.txt must exist
- Must contain the row with the numerically smallest margin value

**Ambiguity notes:**
- If there is a tie for smallest margin, which row to include is unspecified

---

### q015 – Data (hard) – ALP seats alphabetically to ALP_electorates.txt

**Difficulty:** medium

**Original text:**
> List the name, state and margin (in that order) of all seats held by the ALP. List them in alphabetical order by electorate name and put the result in the file ALP_electorates.txt

**Task summary:** Extract ALP rows, output fields: name state margin, sorted alphabetically by name, into ALP_electorates.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- ALP_electorates.txt: 3-field lines (name state margin) sorted by name

**Commands likely needed:** `grep ' ALP '` `awk '{print $1, $2, $4}'` `sort -k1` `> ALP_electorates.txt`

**Marking notes:**
- ALP_electorates.txt must exist
- Only three fields: name, state, margin (party field omitted)
- Sorted alphabetically by electorate name
- Only ALP rows included

---

### q016 – Data (hard) – non-major party seats by margin

**Difficulty:** medium

**Original text:**
> List the name, state, party and margin (in that order) of all seats not held by the major parties. List them in order of margin (i.e. smallest margin first) and put the result in the file non-major-parties-margin.txt

**Task summary:** Exclude ALP, LIB, NAT, LNP, GRN rows; output name, state, party, margin sorted by margin ascending into non-major-parties-margin.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- non-major-parties-margin.txt: 4-field lines sorted by margin (ascending)

**Commands likely needed:** `grep -v ' ALP \| LIB \| NAT \| LNP \| GRN '` `awk '{print $1, $2, $3, $4}'` `sort -k4 -n`

**Marking notes:**
- Major parties to exclude: ALP, LIB, NAT, LNP, GRN
- Minor parties remaining: CA, IND, KAP (and any others in file)
- Output field order: name state party margin
- Sorted numerically by margin ascending

**Ambiguity notes:**
- The PDF lists GRN as a major party; verify this interpretation against the file

---

### q017 – Data (hard) – 20 most marginal seats

**Difficulty:** medium

**Original text:**
> List the party, name, state and margin of the 20 electorates with the smallest margins. List them in order of margin (i.e. smallest margin first) and put the result in the file twenty_most_marginal_seats.txt

**Task summary:** Sort all electorates by margin ascending, take top 20, output party name state margin into twenty_most_marginal_seats.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- twenty_most_marginal_seats.txt: 20 lines, fields: party name state margin

**Commands likely needed:** `sort -k4 -n` `head -20` `awk '{print $3, $1, $2, $4}'`

**Marking notes:**
- Exactly 20 lines
- Field order: party name state margin
- Sorted by margin ascending (numerically)

---

### q018 – Data (hard) – electorate count per state/territory

**Difficulty:** medium

**Original text:**
> List all the states and territories and the total number of electorates in each of them.

**Task summary:** Count electorates grouped by state/territory and print each state with its count.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- stdout (or file): each state/territory and its electorate count

**Commands likely needed:** `awk '{print $2}'` `sort` `uniq -c`

**Marking notes:**
- All 8 states/territories must appear: NSW, VIC, WA, QLD, SA, TAS, ACT, NT
- Counts must be correct
- No output file specified; stdout accepted

**Ambiguity notes:**
- Output format (count first or state first) not specified

---

### q019 – Data (hard) – 20 safest seats to twenty_safest_seats.txt

**Difficulty:** medium

**Original text:**
> List the margin, party name and state of the 20 electorates with the largest margins. List them in order of margin (i.e. smallest margin first) and put the result in the file twenty_safest_seats.txt

**Task summary:** Find the 20 electorates with the largest margins; output margin party name state sorted by margin ascending into twenty_safest_seats.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- twenty_safest_seats.txt: 20 lines, fields: margin party name state

**Commands likely needed:** `sort -k4 -n` `tail -20` `awk '{print $4, $3, $1, $2}'` `sort -k1 -n`

**Marking notes:**
- Exactly 20 lines
- Field order: margin party name state
- These are the 20 LARGEST margins but listed smallest-first within that set

**Ambiguity notes:**
- The question says 'list them in order of margin (smallest margin first)' referring to ordering within the 20 selected, not among all seats

---

## Shell Scripting – Advanced

### q020 – Shell script – list seats for a party in a state

**Difficulty:** medium

**Original text:**
> Write a bash shell script where the user supplies the initials for the party as the first argument and the initials of the state or territory as the second argument. The script should then list the name and margins for all seats held by that party in that state.

**Task summary:** Create get_seats.sh: accepts <party> <state> arguments and lists electorate name and margin from seats_2019.txt.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- stdout: name and margin for matching electorates

**Commands likely needed:** `#!/bin/bash` `grep` `awk` `$1` `$2`

**Marking notes:**
- Script should be named get_seats.sh
- Must filter by both party (field 3) and state (field 2)
- Output fields: name and margin only

**Ambiguity notes:**
- Script filename is inferred from q021 error message 'Usage: get_seats.sh'; not explicitly stated in this question

---

### q021 – Shell script – get_seats.sh with full error checking

**Difficulty:** hard

**Original text:**
> Take your answer from (7) and add error checking:
> (a) If the number of arguments is incorrect print:
> Incorrect number of Arguments
> Usage : get_seats.sh \<party_name\> \<state\>
> (b) Check that the party initials are valid. If they are invalid print "Invalid Party" and exit.
> (c) Check that the state initials are valid. If they are invalid print "Invalid State" and exit.
> (d) If your script has passed the error checking in (a), (b) and (c), but there are no actual electorates held for the party and state/territory supplied as arguments (for example there are no NAT members in WA) then the script should print:
> No electorates held by \<party name\> in \<state/territory name\>

**Task summary:** Extend get_seats.sh (from q020) with: (a) argument count check, (b) valid party check, (c) valid state check, (d) no-results message.

**Required files:** `seats_2019.txt`

**Expected outputs:**
- stderr/stdout (a): 'Incorrect number of Arguments\nUsage : get_seats.sh <party_name> <state>'
- stdout (b): 'Invalid Party'
- stdout (c): 'Invalid State'
- stdout (d): 'No electorates held by <party name> in <state/territory name>'

**Commands likely needed:** `#!/bin/bash` `$#` `-ne 2` `case` `grep` `exit`

**Marking notes:**
- Valid parties: ALP, LIB, NAT, LNP, GRN, CA, IND, KAP
- Valid states: NSW, VIC, WA, QLD, SA, TAS, ACT, NT
- Checks should be applied in order: (a) then (b) then (c) then (d)
- The placeholder <party name> and <state/territory name> in (d) must be substituted with actual supplied values
- Exit codes for (b) and (c) are not specified; non-zero exit is reasonable

**Ambiguity notes:**
- The full party name (e.g. 'Australian Labor Party') vs initials in message (d) is unspecified; initials are acceptable
- Whether to use stdout or stderr for error messages is unspecified
- Exit code after (b) and (c) not specified

---

## How to re-run extraction

```bash
# From the repo root:
python scripts/extract_questions.py
```

Optional: install a PDF library to enable raw-text cross-checking (not required for output generation):

```bash
pip install pymupdf          # preferred
# OR
pip install pdfminer.six     # fallback
```

The question bank is maintained directly in `scripts/extract_questions.py` (the `QUESTIONS` list).
Edit that list and re-run the script to regenerate `data/questions.json` and `data/questions.md`.
