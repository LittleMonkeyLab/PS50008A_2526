## Generate "Data Analysis I" return pages (local use — not documented on the public site).
## Run from week16/lab:  Rscript generate-analysis-preview.R
## Data live in ../../_project_data/ (some CSVs are expanded offline).
## theboyz.csv: two columns = two *independent* groups (wide layout from first-time entry — not paired rows).

library(ggplot2)
library(dplyr)
library(tibble)
library(readr)
library(grid)
library(gridExtra)
library(readxl)

# ── Paths ───────────────────────────────────────────────────────────────
cmd_args <- commandArgs(trailingOnly = FALSE)
file_arg <- sub("^--file=", "", cmd_args[grep("^--file=", cmd_args)])
lab_dir <- if (length(file_arg)) dirname(normalizePath(file_arg[1])) else getwd()
data_dir <- normalizePath(file.path(lab_dir, "..", "..", "_project_data"))

stopifnot(dir.exists(data_dir))

# ── Brand colours ───────────────────────────────────────────────────────
navy   <- "#275882"
orange <- "#EA8439"
light_navy <- "#4A7FAA"
light_orange <- "#F0A86B"

theme_analysis <- theme_minimal(base_size = 11, base_family = "Atkinson Hyperlegible") +
  theme(
    plot.title = element_text(face = "bold", colour = navy, size = 11,
                              margin = margin(2, 0, 2, 0)),
    plot.subtitle = element_text(colour = "grey40", size = 8.5,
                                  margin = margin(0, 0, 4, 0)),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 9),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(8, 10, 8, 8)
  )

p_fmt <- function(p) {
  if (p < .001) return("< .001")
  sprintf("= %.3f", p)
}

make_stats_grob <- function(title, body) {
  title_grob <- textGrob(title, x = 0.05, y = 0.92, hjust = 0, vjust = 1,
                          gp = gpar(fontface = "bold", fontsize = 11,
                                    col = navy, fontfamily = "Atkinson Hyperlegible"))
  body_grob  <- textGrob(body, x = 0.05, y = 0.72, hjust = 0, vjust = 1,
                          gp = gpar(fontsize = 10, fontfamily = "Courier",
                                    lineheight = 1.2))
  bg <- rectGrob(gp = gpar(fill = "#F7F7F7", col = "#CCCCCC", lwd = 0.5))
  grobTree(bg, title_grob, body_grob)
}

make_header_grob <- function(title_line, group_line, members_line, design_line) {
  t1 <- textGrob("Data Analysis I", x = 0.5, y = 0.92,
                  gp = gpar(col = navy, fontsize = 16, fontface = "bold",
                            fontfamily = "Atkinson Hyperlegible"))
  t2 <- textGrob(title_line, x = 0.5, y = 0.72,
                  gp = gpar(col = "grey30", fontsize = 12,
                            fontfamily = "Atkinson Hyperlegible"))
  t3 <- textGrob(group_line, x = 0.5, y = 0.52,
                  gp = gpar(col = orange, fontsize = 10.5,
                            fontfamily = "Atkinson Hyperlegible", fontface = "bold"))
  grobs <- list(t1, t2, t3)
  if (nzchar(members_line %||% "")) {
    grobs[[length(grobs) + 1L]] <- textGrob(members_line, x = 0.5, y = 0.34,
                  gp = gpar(col = "grey45", fontsize = 9,
                            fontfamily = "Atkinson Hyperlegible"))
    y_design <- 0.16
  } else {
    y_design <- 0.22
  }
  grobs[[length(grobs) + 1L]] <- textGrob(design_line, x = 0.5, y = y_design,
                  gp = gpar(col = "grey50", fontsize = 9,
                            fontfamily = "Atkinson Hyperlegible"))
  line <- linesGrob(x = c(0.05, 0.95), y = c(0.04, 0.04),
                     gp = gpar(col = navy, lwd = 1.5))
  grobs[[length(grobs) + 1L]] <- line
  do.call(grobTree, grobs)
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

make_var_grob <- function(text) {
  textGrob(text, gp = gpar(col = "grey45", fontsize = 9, fontfamily = "Atkinson Hyperlegible"))
}

render_page <- function(filename, header, var_label, stats1, stats2, plot_left, plot_right) {
  png(filename, width = 8, height = 10, units = "in", res = 200,
      bg = "white", family = "Atkinson Hyperlegible")

  grid.newpage()
  pushViewport(viewport(layout = grid.layout(
    nrow = 5, ncol = 2,
    heights = unit(c(1.45, 0.35, 1.3, 3.55, 0.1), "null"),
    widths  = unit(c(1, 1), "null")
  )))

  pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1:2,
                         x = 0.5, y = 0.5, width = 0.94, height = 0.88))
  grid.draw(header)
  popViewport()

  pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1:2))
  grid.draw(var_label)
  popViewport()

  pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1,
                         x = 0.5, y = 0.5, width = 0.88, height = 0.85))
  grid.draw(stats1)
  popViewport()

  pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 2,
                         x = 0.5, y = 0.5, width = 0.88, height = 0.85))
  grid.draw(stats2)
  popViewport()

  pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 1,
                         x = 0.5, y = 0.5, width = 0.92, height = 0.95))
  print(plot_left, vp = current.viewport())
  popViewport()

  pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 2,
                         x = 0.5, y = 0.5, width = 0.92, height = 0.95))
  print(plot_right, vp = current.viewport())
  popViewport()

  popViewport()
  dev.off()
}

# ── Between-subjects from long-format CSV ────────────────────────────────
render_between_csv <- function(
    csv_path,
    out_png,
    title_line,
    group_line,
    members_line,
    var_grob_text,
    condition_col,
    value_col,
    level_order,
    ylab,
    y_max,
    fill_colours
) {
  data_bs <- read_csv(csv_path, show_col_types = FALSE)
  data_bs[[condition_col]] <- factor(as.character(data_bs[[condition_col]]), levels = level_order)
  design_line <- sprintf(
    "Between-Subjects Design  |  Independent Samples t-test  |  N = %d",
    nrow(data_bs)
  )

  desc_bs <- data_bs %>%
    group_by(.data[[condition_col]]) %>%
    summarise(
      n = n(),
      Mean = mean(.data[[value_col]], na.rm = TRUE),
      SD = sd(.data[[value_col]], na.rm = TRUE),
      CI_lower = Mean - qt(0.975, n - 1) * SD / sqrt(n),
      CI_upper = Mean + qt(0.975, n - 1) * SD / sqrt(n),
      .groups = "drop"
    )

  f <- as.formula(paste(value_col, "~", condition_col))
  t_bs <- t.test(f, data = data_bs)
  pooled_sd_bs <- sqrt((desc_bs$SD[1]^2 + desc_bs$SD[2]^2) / 2)
  d_bs <- (desc_bs$Mean[1] - desc_bs$Mean[2]) / pooled_sd_bs

  c1 <- level_order[1]
  c2 <- level_order[2]

  fill_vec <- unname(fill_colours[level_order])

  p1_bs <- ggplot(data_bs, aes(x = .data[[condition_col]], y = .data[[value_col]],
                                fill = .data[[condition_col]])) +
    geom_boxplot(width = 0.45, alpha = 0.8, outlier.shape = NA) +
    geom_jitter(width = 0.12, alpha = 0.6, size = 2) +
    scale_fill_manual(values = fill_vec, breaks = level_order, drop = FALSE) +
    scale_y_continuous(limits = c(0, y_max), breaks = pretty(c(0, y_max), n = 8)) +
    labs(title = "Distribution of Scores", x = condition_col, y = ylab) +
    theme_analysis + theme(legend.position = "none")

  desc_bs[[condition_col]] <- factor(as.character(desc_bs[[condition_col]]), levels = level_order)

  p2_bs <- ggplot(desc_bs, aes(x = .data[[condition_col]], y = Mean,
                                fill = .data[[condition_col]])) +
    geom_col(width = 0.45, alpha = 0.85) +
    geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
    scale_fill_manual(values = fill_vec, breaks = level_order, drop = FALSE) +
    scale_y_continuous(limits = c(0, y_max), breaks = pretty(c(0, y_max), n = 8)) +
    labs(title = "Mean Score by Condition", subtitle = "Error bars = 95% CI",
         x = condition_col, y = ylab) +
    theme_analysis + theme(legend.position = "none")

  ntot <- nrow(data_bs)
  stats_desc <- paste0(
    sprintf("%-12s %2d   %4.1f   %.2f\n", as.character(desc_bs[[condition_col]][1]), desc_bs$n[1],
            desc_bs$Mean[1], desc_bs$SD[1]),
    sprintf("%-12s %2d   %4.1f   %.2f",
            as.character(desc_bs[[condition_col]][2]), desc_bs$n[2],
            desc_bs$Mean[2], desc_bs$SD[2])
  )

  render_page(
    out_png,
    make_header_grob(title_line, group_line, members_line %||% "", design_line),
    make_var_grob(var_grob_text),
    make_stats_grob("Descriptive Statistics", paste0(
      "condition     n    Mean     SD\n", stats_desc)),
    make_stats_grob("Inferential Statistics", paste0(
      "Independent Samples t-test\n\n",
      "t(", sprintf("%.2f", t_bs$parameter), ") = ", sprintf("%.2f", t_bs$statistic),
      ",  p ", p_fmt(t_bs$p.value), "\n",
      "95% CI [", sprintf("%.2f", t_bs$conf.int[1]), ", ", sprintf("%.2f", t_bs$conf.int[2]), "]\n",
      "Mean difference = ", sprintf("%.1f", desc_bs$Mean[1] - desc_bs$Mean[2]), "\n",
      "Cohen's d = ", sprintf("%.2f", abs(d_bs)))),
    p1_bs, p2_bs
  )
  message("Wrote ", normalizePath(out_png))
}

# ── Between-subjects: two columns in CSV = two separate groups (wide) ───
# Each column is stacked as its own condition; NAs dropped per column.
render_between_wide_two_col_csv <- function(
    csv_path,
    out_png,
    title_line,
    group_line,
    members_line,
    var_grob_text,
    col_left,
    col_right,
    level_order,
    ylab,
    y_max,
    fill_colours
) {
  raw <- read_csv(csv_path, show_col_types = FALSE)
  stopifnot(col_left %in% names(raw), col_right %in% names(raw), length(level_order) == 2L)
  long <- bind_rows(
    tibble(Condition = level_order[1], Score = suppressWarnings(as.numeric(raw[[col_left]]))),
    tibble(Condition = level_order[2], Score = suppressWarnings(as.numeric(raw[[col_right]])))
  ) %>%
    filter(!is.na(Score))
  tf <- tempfile(fileext = ".csv")
  on.exit(unlink(tf), add = TRUE)
  write_csv(long, tf)
  render_between_csv(
    tf,
    out_png,
    title_line = title_line,
    group_line = group_line,
    members_line = members_line,
    var_grob_text = var_grob_text,
    condition_col = "Condition",
    value_col = "Score",
    level_order = level_order,
    ylab = ylab,
    y_max = y_max,
    fill_colours = fill_colours
  )
}

# ── Within-subjects (paired) from wide CSV ─────────────────────────────
render_within_csv <- function(
    csv_path,
    out_png,
    title_line,
    group_line,
    members_line,
    var_grob_text,
    col_a,
    col_b,
    level_a,
    level_b,
    ylab,
    y_max,
    drop_incomplete_rows = FALSE
) {
  sp <- read_csv(csv_path, show_col_types = FALSE)
  if (isTRUE(drop_incomplete_rows)) {
    cc <- stats::complete.cases(sp)
    sp <- sp[cc, , drop = FALSE]
  }
  n_ws <- nrow(sp)
  vec_a <- as.numeric(sp[[col_a]])
  vec_b <- as.numeric(sp[[col_b]])
  design_line <- sprintf(
    "Within-Subjects Design  |  Paired Samples t-test  |  N = %d",
    n_ws
  )

  data_long <- tibble(
    participant = rep(seq_len(n_ws), 2),
    condition = factor(rep(c(level_a, level_b), each = n_ws), levels = c(level_a, level_b)),
    score = c(vec_a, vec_b)
  )

  desc_ws <- data_long %>%
    group_by(condition) %>%
    summarise(n = n(), Mean = mean(score), SD = sd(score), .groups = "drop")

  t_ws <- t.test(vec_a, vec_b, paired = TRUE)
  diffs <- vec_a - vec_b
  d_ws <- mean(diffs) / sd(diffs)

  pm <- (vec_a + vec_b) / 2
  gm <- mean(c(vec_a, vec_b))
  adj_a <- vec_a - pm + gm
  adj_b <- vec_b - pm + gm
  morey <- sqrt(2)
  desc_ws$CI_lower <- c(
    mean(adj_a) - qt(0.975, n_ws - 1) * sd(adj_a) / sqrt(n_ws) * morey,
    mean(adj_b) - qt(0.975, n_ws - 1) * sd(adj_b) / sqrt(n_ws) * morey
  )
  desc_ws$CI_upper <- c(
    mean(adj_a) + qt(0.975, n_ws - 1) * sd(adj_a) / sqrt(n_ws) * morey,
    mean(adj_b) + qt(0.975, n_ws - 1) * sd(adj_b) / sqrt(n_ws) * morey
  )

  p1_ws <- ggplot(data_long, aes(x = condition, y = score)) +
    geom_line(aes(group = participant), alpha = 0.25, colour = "grey50") +
    geom_point(aes(colour = condition), size = 2.5, alpha = 0.7) +
    scale_colour_manual(values = c(navy, orange), breaks = c(level_a, level_b), drop = FALSE) +
    scale_y_continuous(limits = c(0, y_max), breaks = pretty(c(0, y_max), n = 8)) +
    labs(title = "Paired Scores by Participant", subtitle = "Lines connect same participant",
         x = "Condition", y = ylab) +
    theme_analysis + theme(legend.position = "none")

  desc_ws$condition <- factor(as.character(desc_ws$condition), levels = c(level_a, level_b))

  p2_ws <- ggplot(desc_ws, aes(x = condition, y = Mean, fill = condition)) +
    geom_col(width = 0.45, alpha = 0.85) +
    geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
    scale_fill_manual(values = c(navy, light_orange), breaks = c(level_a, level_b), drop = FALSE) +
    scale_y_continuous(limits = c(0, y_max), breaks = pretty(c(0, y_max), n = 8)) +
    labs(title = "Mean Score by Condition", subtitle = "Error bars = 95% within-subject CI",
         x = "Condition", y = ylab) +
    theme_analysis + theme(legend.position = "none")

  stats_desc <- paste0(
    sprintf("%-22s %2d   %4.1f   %.2f\n", as.character(desc_ws$condition[1]), desc_ws$n[1],
            desc_ws$Mean[1], desc_ws$SD[1]),
    sprintf("%-22s %2d   %4.1f   %.2f",
            as.character(desc_ws$condition[2]), desc_ws$n[2],
            desc_ws$Mean[2], desc_ws$SD[2])
  )

  render_page(
    out_png,
    make_header_grob(title_line, group_line, members_line %||% "", design_line),
    make_var_grob(var_grob_text),
    make_stats_grob("Descriptive Statistics", paste0(
      "condition              n    Mean     SD\n", stats_desc)),
    make_stats_grob("Inferential Statistics", paste0(
      "Paired Samples t-test\n\n",
      "t(", t_ws$parameter, ") = ", sprintf("%.2f", t_ws$statistic),
      ",  p ", p_fmt(t_ws$p.value), "\n",
      "95% CI [", sprintf("%.2f", t_ws$conf.int[1]), ", ", sprintf("%.2f", t_ws$conf.int[2]), "]\n",
      "Mean difference = ", sprintf("%.1f", mean(diffs)), "\n",
      "Cohen's d = ", sprintf("%.2f", abs(d_ws)))),
    p1_ws, p2_ws
  )
  message("Wrote ", normalizePath(out_png))
}

# ============================================================
# Outputs (branded headers for each group)
# ============================================================

render_between_csv(
  file.path(data_dir, "ImogenResults_expanded.csv"),
  file.path(lab_dir, "analysis-preview-TedImoBea.png"),
  title_line = "Background music and recall",
  group_line = "\U0001F3B6 TedImoBea",
  members_line = "Teddy \u2022 Imogen \u2022 Beatriz",
  var_grob_text = "IV: Condition (BM vs NBM)          DV: Words recalled",
  condition_col = "Condition",
  value_col = "Words_Recalled",
  level_order = c("BM", "NBM"),
  ylab = "Words recalled",
  y_max = 16,
  fill_colours = c(BM = navy, NBM = light_orange)
)

render_between_csv(
  file.path(data_dir, "jfk_expanded.csv"),
  file.path(lab_dir, "analysis-preview-JFKz-Girlies.png"),
  title_line = "Phone presence & attention",
  group_line = "JFKz Girlies",
  members_line = "Fawziya \u2022 Jasmine \u2022 Katie-Anne \u2022 Zoe",
  var_grob_text = "IV: Phone group (WPhone vs XPhone)          DV: Score",
  condition_col = "Group",
  value_col = "Score",
  level_order = c("WPhone", "XPhone"),
  ylab = "Score",
  y_max = 18,
  fill_colours = c(WPhone = navy, XPhone = light_orange)
)

render_within_csv(
  file.path(data_dir, "social_presence_throws_expanded.csv"),
  file.path(lab_dir, "analysis-preview-DNM.png"),
  title_line = "The effect of social presence on task performance",
  group_line = "DNM",
  members_line = "Nicole \u2022 Dallas \u2022 Marta",
  var_grob_text = "IV: Social presence (High vs Low)          DV: Performance score (1\u201310)",
  col_a = "High_Social_Presence",
  col_b = "Low_Social_Presence",
  level_a = "High presence",
  level_b = "Low presence",
  ylab = "Score (1\u201310)",
  y_max = 11
)

# Simone's Pantheon — refresh CSV from Excel (one column: comma-separated rows; blank rows ignored)
export_simones_pantheon_csv <- function() {
  xlsx_path <- file.path(data_dir, "simones_pantheon.xlsx")
  if (!file.exists(xlsx_path)) {
    message("Skipping Pantheon: ", basename(xlsx_path), " not found.")
    return(invisible(FALSE))
  }
  xl <- read_excel(xlsx_path, col_names = FALSE)
  lines <- xl[[1L]]
  lines <- lines[!is.na(lines) & nzchar(trimws(lines))]
  lines <- lines[-1L]
  parts <- strsplit(lines, ",")
  df <- tibble(
    participant_id = vapply(parts, function(p) p[[1L]], character(1L)),
    condition = vapply(parts, function(p) p[[2L]], character(1L)),
    recall_score = as.numeric(vapply(parts, function(p) p[[3L]], character(1L)))
  ) %>%
    mutate(condition = recode(condition, no_music = "No music", music = "Music"))
  write_csv(df, file.path(data_dir, "simones_pantheon.csv"))
  message("Refreshed simones_pantheon.csv from simones_pantheon.xlsx (n = ", nrow(df), ").")
  invisible(TRUE)
}

export_simones_pantheon_csv()

# Simone's Pantheon — music vs no music, person detail recall
render_between_csv(
  file.path(data_dir, "simones_pantheon.csv"),
  file.path(lab_dir, "analysis-preview-Simones-Pantheon.png"),
  title_line = "Music vs no music — person detail recall",
  group_line = "Simone\u2019s Pantheon",
  members_line = "",
  var_grob_text = "IV: Listening (Music vs No music)          DV: Recall score",
  condition_col = "condition",
  value_col = "recall_score",
  level_order = c("No music", "Music"),
  ylab = "Detail recall score",
  y_max = 12,
  fill_colours = c(`No music` = navy, Music = light_orange)
)

render_between_wide_two_col_csv(
  file.path(data_dir, "theboyz.csv"),
  file.path(lab_dir, "analysis-preview-The-Boyz.png"),
  title_line = "Not smiling vs smiling (task scores)",
  group_line = "The Boyz",
  members_line = "",
  var_grob_text = "IV: Expression (Not smiling vs Smiling)          DV: Score",
  col_left = "notSmiling",
  col_right = "Smiling",
  level_order = c("Not smiling", "Smiling"),
  ylab = "Score",
  y_max = 110,
  fill_colours = c(`Not smiling` = navy, Smiling = light_orange)
)

cat("Done.\n")
