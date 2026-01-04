---
week: 13
session: lecture
derived_from: weeks/week13.md
version: 1
status: stub
last_updated: 2025-01-04
---

## Outcomes
C9, C18, C19

## One-liner
Estimation-first: what's our best guess and how uncertain are we? Bootstrap CIs and effect sizes.

## Paragraph


## Structure
- 0-10 min: From "what's the mean?" to "what's the range of plausible means?"
- 10-25 min: Bootstrap intuition—resample, recalculate, repeat. Live demo.
- 25-35 min: Confidence intervals—what 95% actually means (and doesn't mean)
- 35-45 min: Effect sizes—Cohen's d. "Significant" vs "big."
- 45-50 min: Sample size and precision [C19]—more data = narrower intervals

## Key points for MCQ
- CI interpretation: "95% confident the true value is between X and Y"
- CI does NOT mean "95% probability the true value is in this interval"
- Effect size as standardised magnitude

## Examples and demos
- Bootstrap their mean RT: watch the distribution of resampled means
- Show CIs getting narrower with larger N
- Effect size examples: small (d=0.2), medium (d=0.5), large (d=0.8)

## Connections
- To lab: Build bootstrap CIs in WebR
- To project: Groups should plan to report effect sizes, not just p-values
- To prior weeks: Builds on week 12 variability concepts
- To future weeks: Week 14 inference as "is zero in the interval?"

## Materials needed
- Bootstrap visualisation (animated or live R)
- Data Olympics dataset
- Effect size reference card

## Pedagogy notes
The bootstrap animation is the key moment—let them see sampling variability physically. Don't get bogged down in formula for SE; the resampling intuition is more valuable at this stage.
