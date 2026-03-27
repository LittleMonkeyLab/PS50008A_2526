# Seed data expansion (teaching / analysis previews)

Several small CSV files in this folder are **seed** datasets (real pilot-style snippets). For Week 16 “Data Analysis I” preview figures and for sensible teaching sample sizes, they are expanded into `*_expanded.csv` using a **reproducible** R script.

## Files

| Seed file | Expanded file | Design | N (expanded) |
|-----------|---------------|--------|----------------|
| `ImogenResults.csv` | `ImogenResults_expanded.csv` | Between-subjects (BM vs NBM) | 44 (22 per condition) |
| `jfk.csv` | `jfk_expanded.csv` | Between-subjects (WPhone vs XPhone) | 44 (22 per group) |
| `social_presence_throws.csv` | `social_presence_throws_expanded.csv` | Within-subjects / paired (High vs Low presence) | 40 pairs |
| `perfume.csv` | `perfume_expanded.csv` | Between-subjects (Low vs High sleep night before; DV identification accuracy out of five) | 44 (22 per group) |
| `memoral_colours.csv` | `memoral_colours_expanded.csv` | Between-subjects (Yellow vs Grey screen background; words recalled /12) | 44 (22 per condition) |
| `doughnuts.csv` | `doughnuts_expanded.csv` | Within-subjects / paired (Smiling vs Neutral approachability /10) | 40 pairs |
| `afm.csv` | `afm_expanded.csv` | Within-subjects / paired (Smiling vs Scowling; willingness to hire /10) | 40 pairs |

**`perfume` seed:** `Outcome` (Correct / Incorrect) is mapped to **`Identification_accuracy`** on a **1–5** scale (Correct = 5, Incorrect = 1), i.e. **identification accuracy (out of five)**. **`Sleep_group`** is **Low** (≤7 h) vs **High** (≥8 h) from **`Hours_sleep`**. Expansion uses the same between-subjects logic with **clip 1–5**.

**Original seeds are not modified.** Regeneration overwrites only the `*_expanded.csv` files.

## What we did to the seed data

### Between-subjects (`ImogenResults`, `jfk`)

1. For each condition/group, compute the **mean** and **SD** of the outcome in the seed file.
2. If a group has only one observation or zero variance, fall back to a small default SD (or half the overall SD).
3. Draw **new** observations from `Normal(mean, SD)`, **round** to integers, then **clip** to a plausible range:
   - `Words_Recalled`: 0–15  
   - `Score` (jfk): 0–20  
   - `Identification_accuracy` (perfume): 1–5 (out of five)  
   - `Words_Recalled` (memoral_colours): 0–12  
4. **`set.seed(20260227)`** so every run produces the same expanded files.
5. **Demographics** (`Age`, `Gender`) are **simulated** for realism only (not used in the t-tests); they are not derived from the seeds.

This keeps the **direction and rough spread** of the seed groups while inflating *n* to classroom-friendly sizes. It is **not** claiming the expanded file is real collected data — it is **illustrative** for previews and examples.

### Paired / within-subjects (`social_presence_throws`, `doughnuts`, `afm`)

1. **Bootstrap** rows from the seed table with replacement to reach **40** participants.
2. Add **independent** Gaussian noise (SD ≈ 0.35) to each of the two columns, then **round** and **clip** scores to **1–10**.
3. Same **`set.seed(20260227)`** for reproducibility.

This preserves **within-pair patterns** from the seed (correlation structure roughly similar) while increasing *n*.

## How to regenerate

From the **repository root**:

```bash
Rscript _project_data/expand_seed_data.R
```

Then regenerate the Week 16 lab preview PNGs:

```bash
cd week16/lab
Rscript generate-analysis-preview.R
```

Requirements: R packages `readr`, `dplyr`, `tibble`, `ggplot2`, `grid`, `gridExtra`.

## Preview images produced

`week16/lab/generate-analysis-preview.R` reads the **expanded** CSVs and writes:

| PNG (group-labelled) | Source data | Test |
|-----|-------------|------|
| `analysis-preview-TedImoBea.png` | `ImogenResults_expanded.csv` | Independent samples *t* |
| `analysis-preview-JFKz-Girlies.png` | `jfk_expanded.csv` | Independent samples *t* |
| `analysis-preview-Perfume.png` | `perfume_expanded.csv` | Independent samples *t* |
| `analysis-preview-DNM.png` | `social_presence_throws_expanded.csv` | Paired samples *t* |
| `analysis-preview-Simones-Pantheon.png` | `simones_pantheon.csv` (from `simones_pantheon.xlsx`) | Independent samples *t* |
| `analysis-preview-The-Boyz.png` | `theboyz.csv` (as-is; two columns = two independent groups) | Independent samples *t* |
| `analysis-preview-Memoral-Colours.png` | `memoral_colours_expanded.csv` | Independent samples *t* |
| `analysis-preview-Doughnuts.png` | `doughnuts_expanded.csv` | Paired samples *t* |
| `analysis-preview-AFM.png` | `afm_expanded.csv` | Paired samples *t* |

Headers on the figures say **“Example group (illustrative only)”** — they are **not** tied to a real group name from class.

## Changing sample sizes

Edit `_project_data/expand_seed_data.R`:

- `n_each = 22` in `expand_between()` calls  
- `n_pairs = 40` in `expand_paired()`  

Then re-run both scripts above.
