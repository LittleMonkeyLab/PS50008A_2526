---
week: 14
session: lab
derived_from: weeks/week14.md
version: 1
status: stub
last_updated: 2025-01-04
---

## Outcomes
P4, P5, P9

## One-liner
Run t-tests in R and practice by-hand calculation for EDS preparation.

## Paragraph


## Activity structure
- 0-15 min: Independent t-test in R (Room A vs Room B RT)
- 15-30 min: Paired t-test in R (if applicable—e.g., simple vs choice RT)
- 30-50 min: By-hand paired t-test calculation (EDS prep)
- 50-60 min: Project time—groups confirm design and test selection

## Skills practised
- P4: Run paired t-test in R (t.test(..., paired = TRUE))
- P5: Run independent t-test in R (t.test())
- P9: Check assumptions (normality, variance)
- By-hand calculation (EDS requirement)

## Data used
Data Olympics dataset

## Software and tools
- R: t.test(), var.test(), shapiro.test()
- Calculator for by-hand work
- Formula sheet provided

## Instructions for students
Part 1: R analysis
- Run independent t-test comparing rooms
- Run paired t-test comparing RT types
- Interpret output: t, df, p, CI

Part 2: By-hand practice
- Given small dataset (10 participants, 2 conditions)
- Calculate mean and SD for each condition
- Calculate difference scores
- Calculate t statistic
- Look up critical value
- Make decision

## Deliverable
R output for both t-tests with written interpretation. By-hand calculation showing all steps.

## Common problems
- Forgetting paired = TRUE for within-subjects
- Misreading R output (which number is t? which is p?)
- By-hand arithmetic errors (especially in SD calculation)
- Confusing one-tailed and two-tailed critical values

## Demonstrator notes
The by-hand calculation is EDS-critical. Walk through one example as a group before independent practice. Circulate and check arithmetic—errors compound.

## Project time
Groups write down: (1) their design type, (2) which test they'll use, (3) their hypothesis in proper form. Check with demonstrator.
