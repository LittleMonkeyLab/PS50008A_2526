---
week: 15
session: lab
derived_from: weeks/week15.md
version: 1
status: stub
last_updated: 2025-01-04
---

## Outcomes
P6

## One-liner
Run correlations in R, produce scatterplots, and practice by-hand Pearson calculation.

## Paragraph


## Activity structure
- 0-15 min: Scatterplots in R (plot() or ggplot2)
- 15-30 min: Correlation in R (cor(), cor.test())
- 30-50 min: By-hand Pearson correlation (EDS practice paper is correlation)
- 50-60 min: Project time—data collection planning/progress check

## Skills practised
- P6: Run Pearson and Spearman correlation in R
- Produce and interpret scatterplots
- By-hand Pearson r calculation (EDS requirement)

## Data used
Data Olympics dataset—correlate confidence with accuracy, simple RT with choice RT, etc.

## Software and tools
- R: cor(), cor.test(), plot()
- Calculator for by-hand work
- Formula sheet provided

## Instructions for students
Part 1: R analysis
- Produce scatterplot of two continuous variables
- Run cor.test() and interpret output
- Try Spearman: cor.test(..., method = "spearman")

Part 2: By-hand practice (critical for EDS)
- Given paired data (10 pairs)
- Calculate means and SDs
- Calculate r using formula
- Test significance (compare to critical r or use t-conversion)

## Deliverable
Scatterplot with interpretation. cor.test() output with written conclusion. By-hand correlation showing all steps.

## Common problems
- Forgetting to check scatterplot before running correlation (misses nonlinearity)
- By-hand calculation errors (especially sum of products)
- Misinterpreting r strength (r = 0.3 is not "weak" in psychology)
- Confusing correlation coefficient with p-value

## Demonstrator notes
The EDS practice paper is correlation-based—this by-hand practice is directly relevant. Walk through calculation as group, then supervised individual practice.

## Project time
Groups report on data collection progress. Those collecting data this week should have materials ready. Troubleshoot logistics.
