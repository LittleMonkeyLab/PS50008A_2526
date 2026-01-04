---
week: 14
session: lecture
derived_from: weeks/week14.md
version: 1
status: stub
last_updated: 2025-01-04
---

## Outcomes
C1, C2, C3, C5, C6, C7, C10, C11, C12, C14, C15, C16

## One-liner
The logic of inference: null hypotheses, p-values, t-tests, and choosing the right test for your design.

## Paragraph


## Structure
- 0-10 min: "Could this difference be nothing?" The null hypothesis as thought experiment [C10]
- 10-20 min: p-values—what they are and aren't [C11]. "How surprising if null true?"
- 20-30 min: Significance decisions—α = .05, what it means [C12]
- 30-40 min: Design types and test selection [C1, C2, C3, C14, C15, C16]
  - Between-participants → independent t / Mann-Whitney
  - Within-participants → paired t / Wilcoxon
  - When to go nonparametric
- 40-50 min: Hypotheses—experimental vs correlational [C5], 1-tailed vs 2-tailed [C6, C7]

## Key points for MCQ
- p-value is NOT "probability hypothesis is true"
- p < .05 means "significant at α = .05"
- Test selection decision tree (design → test)
- Hypothesis form matching (1-tailed requires direction; 2-tailed doesn't)

## Examples and demos
- Room A vs Room B RT: run the t-test, interpret p
- Show permutation logic briefly (connect to bootstrap from week 13)
- Walk through test selection flowchart with examples

## Connections
- To lab: Run t-tests in R, practice by-hand calculation
- To project: Groups identify which test they'll need
- To prior weeks: CI interpretation—"is zero in the interval?" connects to significance
- To future weeks: Week 15 correlation; week 18 MCQ tests all this

## Materials needed
- Test selection flowchart/decision tree
- Data Olympics dataset
- Hypothesis examples (good and bad)

## Pedagogy notes
This is the densest lecture—lots of MCQ-critical content. Go slower than feels natural. Use the test selection flowchart repeatedly. The p-value misconceptions need explicit debunking.
