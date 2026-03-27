#!/usr/bin/env Rscript
## Expand small seed CSVs to teaching / preview sample sizes (reproducible).
## Run from repo root:  Rscript _project_data/expand_seed_data.R
## Or:  cd _project_data && Rscript expand_seed_data.R

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tibble)
})

set.seed(20260227)

repo_root <- Sys.getenv("REPO_ROOT", unset = "")
if (repo_root == "") {
  args_pos <- commandArgs(trailingOnly = TRUE)
  if (length(args_pos) >= 1) {
    repo_root <- args_pos[1]
  } else {
    wd <- normalizePath(getwd())
    if (dir.exists(file.path(wd, "_project_data"))) {
      repo_root <- wd
    } else if (basename(wd) == "_project_data") {
      repo_root <- normalizePath(file.path(wd, ".."))
    } else {
      repo_root <- wd
    }
  }
}

pd <- file.path(repo_root, "_project_data")
if (!dir.exists(pd)) {
  stop("Cannot find _project_data at: ", pd, " — set REPO_ROOT or run from repo root.")
}

# ── Helpers ─────────────────────────────────────────────────────────────

safe_sd <- function(x, default = 1) {
  s <- stats::sd(x, na.rm = TRUE)
  if (is.na(s) || s < 1e-6) default else s
}

#' Between-subjects: sample per condition from Normal(mean, sd) of seed, rounded & clipped.
expand_between <- function(df, condition_col, value_col, n_each = 22,
                           clip_min = 0L, clip_max = 15L) {
  conds <- unique(df[[condition_col]]) # first-appearance order (stable for BM/NBM etc.)
  out <- list()
  pid <- 1L
  for (lev in conds) {
    x <- df[[value_col]][df[[condition_col]] == lev]
    m <- mean(x, na.rm = TRUE)
    s <- safe_sd(x, default = max(0.8, sd(df[[value_col]], na.rm = TRUE) / 2))
    raw <- stats::rnorm(n_each, mean = m, sd = s)
    y <- as.integer(round(pmax(clip_min, pmin(clip_max, raw))))
    out[[length(out) + 1L]] <- tibble::tibble(
      Participant = pid:(pid + n_each - 1L),
      !!condition_col := lev,
      !!value_col := y
    )
    pid <- pid + n_each
  }
  dplyr::bind_rows(out)
}

#' Paired: bootstrap seed rows + small Gaussian noise; preserve within-pair structure.
expand_paired <- function(df, col_high, col_low, n_pairs = 36,
                          clip_min = 1L, clip_max = 10L) {
  n0 <- nrow(df)
  idx <- sample.int(n0, n_pairs, replace = TRUE)
  eps_h <- stats::rnorm(n_pairs, 0, 0.35)
  eps_l <- stats::rnorm(n_pairs, 0, 0.35)
  high <- as.integer(round(pmax(clip_min, pmin(clip_max, df[[col_high]][idx] + eps_h))))
  low <- as.integer(round(pmax(clip_min, pmin(clip_max, df[[col_low]][idx] + eps_l))))
  tibble::tibble(
    Participant = seq_len(n_pairs),
    !!col_high := high,
    !!col_low := low
  )
}

# ── 1. ImogenResults (between: BM vs NBM, words recalled) ───────────────
im_path <- file.path(pd, "ImogenResults.csv")
im <- readr::read_csv(im_path, show_col_types = FALSE)
im_exp <- expand_between(
  im, "Condition", "Words_Recalled", n_each = 22,
  clip_min = 0L, clip_max = 15L
) %>%
  mutate(
    Age = sample(18:40, n(), replace = TRUE),
    Gender = sample(c("F", "M", "NB"), n(), replace = TRUE, prob = c(0.52, 0.43, 0.05))
  ) %>%
  select(Participant, Condition, Age, Gender, Words_Recalled)

readr::write_csv(im_exp, file.path(pd, "ImogenResults_expanded.csv"))

# ── 2. jfk (between: WPhone vs XPhone, score) ────────────────────────────
jf_path <- file.path(pd, "jfk.csv")
jf <- readr::read_csv(jf_path, show_col_types = FALSE)
jf_exp <- expand_between(
  jf, "Group", "Score", n_each = 22,
  clip_min = 0L, clip_max = 20L
) %>%
  mutate(
    Age = sample(18:32, n(), replace = TRUE),
    Gender = sample(c("F", "M"), n(), replace = TRUE, prob = c(0.55, 0.45))
  ) %>%
  select(Participant = Participant, Group, Age, Gender, Score)

readr::write_csv(jf_exp, file.path(pd, "jfk_expanded.csv"))

# ── 3. social_presence_throws (paired: High vs Low) ──────────────────────
sp_path <- file.path(pd, "social_presence_throws.csv")
sp <- readr::read_csv(sp_path, show_col_types = FALSE)
sp_exp <- expand_paired(
  sp, "High_Social_Presence", "Low_Social_Presence", n_pairs = 40,
  clip_min = 1L, clip_max = 10L
)

readr::write_csv(sp_exp, file.path(pd, "social_presence_throws_expanded.csv"))

# ── 4. perfume (between: Low vs High sleep, identification accuracy out of five) ─
# Seed: Outcome Correct/Incorrect → Identification_accuracy on 1–5 (Correct=5, Incorrect=1).
# Sleep_group: Low = ≤7 h, High = ≥8 h (from Hours_sleep).
perf_path <- file.path(pd, "perfume.csv")
perf <- readr::read_csv(perf_path, show_col_types = FALSE)
perf_exp <- expand_between(
  perf, "Sleep_group", "Identification_accuracy", n_each = 22,
  clip_min = 1L, clip_max = 5L
) %>%
  mutate(
    Age = sample(18:35, n(), replace = TRUE),
    Gender = sample(c("F", "M", "NB"), n(), replace = TRUE, prob = c(0.55, 0.40, 0.05))
  ) %>%
  select(Participant, Sleep_group, Age, Gender, Identification_accuracy)

readr::write_csv(perf_exp, file.path(pd, "perfume_expanded.csv"))

# ── 5. memoral_colours (between: Yellow vs Grey background, words recalled /12) ─
mc_path <- file.path(pd, "memoral_colours.csv")
mc <- readr::read_csv(mc_path, show_col_types = FALSE)
mc_exp <- expand_between(
  mc, "Condition", "Words_Recalled", n_each = 22,
  clip_min = 0L, clip_max = 12L
) %>%
  mutate(
    Age = sample(18:35, n(), replace = TRUE),
    Gender = sample(c("F", "M", "NB"), n(), replace = TRUE, prob = c(0.55, 0.40, 0.05))
  ) %>%
  select(Participant, Condition, Age, Gender, Words_Recalled)

readr::write_csv(mc_exp, file.path(pd, "memoral_colours_expanded.csv"))

# ── 6. doughnuts (paired: smiling vs neutral approachability /10) ───────
dn_path <- file.path(pd, "doughnuts.csv")
dn <- readr::read_csv(dn_path, show_col_types = FALSE)
dn_exp <- expand_paired(
  dn, "Smiling", "Neutral", n_pairs = 40,
  clip_min = 1L, clip_max = 10L
)

readr::write_csv(dn_exp, file.path(pd, "doughnuts_expanded.csv"))

# ── 7. afm (paired: smiling vs scowling, willingness to hire /10) ────────
afm_path <- file.path(pd, "afm.csv")
afm <- readr::read_csv(afm_path, show_col_types = FALSE)
afm_exp <- expand_paired(
  afm, "Smiling", "Scowling", n_pairs = 40,
  clip_min = 1L, clip_max = 10L
)

readr::write_csv(afm_exp, file.path(pd, "afm_expanded.csv"))

message("Wrote:\n  ", file.path(pd, "ImogenResults_expanded.csv"), "\n  ",
        file.path(pd, "jfk_expanded.csv"), "\n  ",
        file.path(pd, "social_presence_throws_expanded.csv"), "\n  ",
        file.path(pd, "perfume_expanded.csv"), "\n  ",
        file.path(pd, "memoral_colours_expanded.csv"), "\n  ",
        file.path(pd, "doughnuts_expanded.csv"), "\n  ",
        file.path(pd, "afm_expanded.csv"))
