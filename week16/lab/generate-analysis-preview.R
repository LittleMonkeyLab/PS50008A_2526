## Generate mock "Data Analysis I" return pages
## Light header — no heavy navy banner

library(ggplot2)
library(dplyr)
library(tibble)
library(grid)
library(gridExtra)

# ── Brand colours ──
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

# Stats text grob
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

# Light header — just text, thin underline, no heavy block
make_header_grob <- function(group_line, design_line) {
  t1 <- textGrob("Data Analysis I", x = 0.5, y = 0.82,
                  gp = gpar(col = navy, fontsize = 16, fontface = "bold",
                            fontfamily = "Atkinson Hyperlegible"))
  t2 <- textGrob("The Effect of Word Type on Free Recall", x = 0.5, y = 0.55,
                  gp = gpar(col = "grey30", fontsize = 12,
                            fontfamily = "Atkinson Hyperlegible"))
  t3 <- textGrob(group_line, x = 0.5, y = 0.32,
                  gp = gpar(col = orange, fontsize = 10.5,
                            fontfamily = "Atkinson Hyperlegible", fontface = "bold"))
  t4 <- textGrob(design_line, x = 0.5, y = 0.12,
                  gp = gpar(col = "grey50", fontsize = 9,
                            fontfamily = "Atkinson Hyperlegible"))
  line <- linesGrob(x = c(0.05, 0.95), y = c(0.02, 0.02),
                     gp = gpar(col = navy, lwd = 1.5))
  grobTree(t1, t2, t3, t4, line)
}

make_var_grob <- function() {
  textGrob("IV: Word Type (Concrete vs Abstract)          DV: Words Correctly Recalled (out of 15)",
           gp = gpar(col = "grey45", fontsize = 9, fontfamily = "Atkinson Hyperlegible"))
}

# ── Helper to render a full page ──
render_page <- function(filename, header, var_label, stats1, stats2, plot_left, plot_right) {
  png(filename, width = 8, height = 10, units = "in", res = 200,
      bg = "white", family = "Atkinson Hyperlegible")

  grid.newpage()
  pushViewport(viewport(layout = grid.layout(
    nrow = 5, ncol = 2,
    heights = unit(c(1.2, 0.35, 1.3, 3.8, 0.1), "null"),
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


# ============================================================
# BETWEEN-SUBJECTS
# ============================================================

concrete_bs <- c(13, 9, 14, 10, 11, 8, 12, 11, 15, 10)
abstract_bs  <- c(10, 6, 12, 7, 9, 5, 11, 8, 7, 10)

data_bs <- tibble(
  participant = 1:20,
  condition = factor(rep(c("Concrete", "Abstract"), each = 10),
                     levels = c("Concrete", "Abstract")),
  words_recalled = c(concrete_bs, abstract_bs)
)

desc_bs <- data_bs %>%
  group_by(condition) %>%
  summarise(n = n(), Mean = mean(words_recalled), SD = sd(words_recalled),
            CI_lower = Mean - qt(0.975, n - 1) * SD / sqrt(n),
            CI_upper = Mean + qt(0.975, n - 1) * SD / sqrt(n), .groups = "drop")

t_bs <- t.test(words_recalled ~ condition, data = data_bs)
pooled_sd_bs <- sqrt((desc_bs$SD[1]^2 + desc_bs$SD[2]^2) / 2)
d_bs <- (desc_bs$Mean[1] - desc_bs$Mean[2]) / pooled_sd_bs

p1_bs <- ggplot(data_bs, aes(x = condition, y = words_recalled, fill = condition)) +
  geom_boxplot(width = 0.45, alpha = 0.8, outlier.shape = NA) +
  geom_jitter(width = 0.12, alpha = 0.6, size = 2) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Distribution of Recall Scores",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

p2_bs <- ggplot(desc_bs, aes(x = condition, y = Mean, fill = condition)) +
  geom_col(width = 0.45, alpha = 0.85) +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Mean Recall by Condition", subtitle = "Error bars = 95% CI",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

render_page(
  "analysis-preview-between.png",
  make_header_grob("Group T  (Ali, Bertie & Charlie)",
                   "Between-Subjects Design  |  Independent Samples t-test  |  N = 20"),
  make_var_grob(),
  make_stats_grob("Descriptive Statistics", paste0(
    "condition     n    Mean     SD\n",
    "Concrete     10   ", sprintf("%4.1f", desc_bs$Mean[1]), "   ", sprintf("%.2f", desc_bs$SD[1]), "\n",
    "Abstract     10   ", sprintf("%4.1f", desc_bs$Mean[2]), "   ", sprintf("%.2f", desc_bs$SD[2]))),
  make_stats_grob("Inferential Statistics", paste0(
    "Independent Samples t-test\n\n",
    "t(", sprintf("%.2f", t_bs$parameter), ") = ", sprintf("%.2f", t_bs$statistic),
    ",  p ", p_fmt(t_bs$p.value), "\n",
    "95% CI [", sprintf("%.2f", t_bs$conf.int[1]), ", ", sprintf("%.2f", t_bs$conf.int[2]), "]\n",
    "Mean difference = ", sprintf("%.1f", desc_bs$Mean[1] - desc_bs$Mean[2]), " words\n",
    "Cohen's d = ", sprintf("%.2f", abs(d_bs)))),
  p1_bs, p2_bs
)


# ============================================================
# WITHIN-SUBJECTS
# ============================================================

n_ws <- 20
concrete_ws <- c(12, 10, 8, 14, 11, 9, 13, 7, 11, 10, 12, 9, 14, 11, 8, 13, 10, 12, 9, 11)
abstract_ws <- c(10, 10, 9, 11, 10, 8, 10, 9,  9, 12, 11, 7, 13, 11, 6, 14, 10,  9, 10, 8)

data_ws <- tibble(
  participant = rep(1:n_ws, 2),
  condition = factor(rep(c("Concrete", "Abstract"), each = n_ws),
                     levels = c("Concrete", "Abstract")),
  words_recalled = c(concrete_ws, abstract_ws)
)

desc_ws <- data_ws %>%
  group_by(condition) %>%
  summarise(n = n(), Mean = mean(words_recalled), SD = sd(words_recalled), .groups = "drop")

t_ws <- t.test(concrete_ws, abstract_ws, paired = TRUE)
diffs <- concrete_ws - abstract_ws
d_ws <- mean(diffs) / sd(diffs)

# Cousineau-Morey within-subject 95% CIs
pm <- (concrete_ws + abstract_ws) / 2
gm <- mean(c(concrete_ws, abstract_ws))
adj_c <- concrete_ws - pm + gm
adj_a <- abstract_ws - pm + gm
morey <- sqrt(2)
desc_ws$CI_lower <- c(
  mean(adj_c) - qt(0.975, n_ws - 1) * sd(adj_c) / sqrt(n_ws) * morey,
  mean(adj_a) - qt(0.975, n_ws - 1) * sd(adj_a) / sqrt(n_ws) * morey
)
desc_ws$CI_upper <- c(
  mean(adj_c) + qt(0.975, n_ws - 1) * sd(adj_c) / sqrt(n_ws) * morey,
  mean(adj_a) + qt(0.975, n_ws - 1) * sd(adj_a) / sqrt(n_ws) * morey
)

data_paired <- tibble(
  participant = rep(1:n_ws, 2),
  condition = factor(rep(c("Concrete", "Abstract"), each = n_ws),
                     levels = c("Concrete", "Abstract")),
  recalled = c(concrete_ws, abstract_ws)
)

p1_ws <- ggplot(data_paired, aes(x = condition, y = recalled)) +
  geom_line(aes(group = participant), alpha = 0.25, colour = "grey50") +
  geom_point(aes(colour = condition), size = 2.5, alpha = 0.7) +
  scale_colour_manual(values = c("Concrete" = navy, "Abstract" = orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Paired Scores by Participant", subtitle = "Lines connect same participant",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

p2_ws <- ggplot(desc_ws, aes(x = condition, y = Mean, fill = condition)) +
  geom_col(width = 0.45, alpha = 0.85) +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Mean Recall by Condition", subtitle = "Error bars = 95% within-subject CI",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

render_page(
  "analysis-preview-within.png",
  make_header_grob("Group T  (Ali, Bertie & Charlie)",
                   "Within-Subjects Design  |  Paired Samples t-test  |  N = 20"),
  make_var_grob(),
  make_stats_grob("Descriptive Statistics", paste0(
    "condition     n    Mean     SD\n",
    "Concrete     20   ", sprintf("%4.1f", desc_ws$Mean[1]), "   ", sprintf("%.2f", desc_ws$SD[1]), "\n",
    "Abstract     20   ", sprintf("%4.1f", desc_ws$Mean[2]), "   ", sprintf("%.2f", desc_ws$SD[2]))),
  make_stats_grob("Inferential Statistics", paste0(
    "Paired Samples t-test\n\n",
    "t(", t_ws$parameter, ") = ", sprintf("%.2f", t_ws$statistic),
    ",  p ", p_fmt(t_ws$p.value), "\n",
    "95% CI [", sprintf("%.2f", t_ws$conf.int[1]), ", ", sprintf("%.2f", t_ws$conf.int[2]), "]\n",
    "Mean difference = ", sprintf("%.1f", mean(diffs)), " words\n",
    "Cohen's d = ", sprintf("%.2f", abs(d_ws)))),
  p1_ws, p2_ws
)

cat("Done.\n")
