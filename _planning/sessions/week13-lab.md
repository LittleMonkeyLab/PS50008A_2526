---
week: 13
session: lab
derived_from: weeks/week13.md
version: 1
status: stub
last_updated: 2025-01-04
---

## Outcomes
C9, P2

## One-liner
Build bootstrap confidence intervals in WebR and interpret what they tell us.

## Paragraph


## Activity structure
- 0-15 min: Guided bootstrap—resample mean RT step by step
- 15-35 min: Build full bootstrap CI (1000 resamples, find 2.5th and 97.5th percentiles)
- 35-50 min: Interpretation exercises—what can/can't we conclude from CIs?
- 50-60 min: Project time—groups operationalise IV and DV

## Skills practised
- Building bootstrap CIs (conceptual, not formula)
- Interpreting CI output
- Recognising what CIs do and don't tell us

## Data used
Data Olympics dataset—their RT data

## Software and tools
- WebR or R
- sample() function for resampling
- quantile() for percentiles

## Instructions for students
Step-by-step worksheet:
1. Take your RT data
2. Resample with replacement (same N)
3. Calculate mean of resample
4. Repeat 1000 times
5. Find 2.5th and 97.5th percentile
6. That's your 95% CI

## Deliverable
Bootstrap CI for their mean RT. Written interpretation sentence.

## Common problems
- Forgetting replace = TRUE in sample()
- Confusion about what the 1000 means are (distribution of estimates, not data)
- Misinterpreting CI as "95% of data falls here"

## Demonstrator notes
Walk through logic slowly. The conceptual leap is from "one mean" to "distribution of possible means." Use the lecture animation as reference.

## Project time
Groups write down their IV (with levels) and DV (with measurement details). Check with demonstrator before leaving.
