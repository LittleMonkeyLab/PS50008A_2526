## Generate mock "Data Analysis I" return pages
## One for between-subjects, one for within-subjects
## 95% CIs on bar charts; personalised group title

library(ggplot2)
library(patchwork)
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

# Helper to build a stats text grob
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

# Helper to build the title banner grob — now with group name
make_banner_grob <- function(group_line, design_line) {
  bg <- rectGrob(gp = gpar(fill = navy, col = NA))
  t1 <- textGrob("Data Analysis I", x = 0.5, y = 0.78,
                  gp = gpar(col = "white", fontsize = 16, fontface = "bold",
                            fontfamily = "Atkinson Hyperlegible"))
  t2 <- textGrob("The Effect of Word Type on Free Recall", x = 0.5, y = 0.55,
                  gp = gpar(col = "white", fontsize = 13,
                            fontfamily = "Atkinson Hyperlegible"))
  t3 <- textGrob(group_line, x = 0.5, y = 0.32,
                  gp = gpar(col = "#F0A86B", fontsize = 10.5,
                            fontfamily = "Atkinson Hyperlegible", fontface = "bold"))
  t4 <- textGrob(design_line, x = 0.5, y = 0.12,
                  gp = gpar(col = "#B0C4DE", fontsize = 9,
                            fontfamily = "Atkinson Hyperlegible"))
  grobTree(bg, t1, t2, t3, t4)
}

# Variable label grob
make_var_grob <- function() {
  textGrob("IV: Word Type (Concrete vs Abstract)          DV: Words Correctly Recalled (out of 15)",
           gp = gpar(col = "grey45", fontsize = 9, fontfamily = "Atkinson Hyperlegible"))
}


# ============================================================
# BETWEEN-SUBJECTS VARIANT
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
  summarise(n = n(), Mean = mean(words_recalled),
            SD = sd(words_recalled),
            CI_lower = Mean - qt(0.975, n - 1) * SD / sqrt(n),
            CI_upper = Mean + qt(0.975, n - 1) * SD / sqrt(n),
            .groups = "drop")

t_bs <- t.test(words_recalled ~ condition, data = data_bs)
pooled_sd_bs <- sqrt((desc_bs$SD[1]^2 + desc_bs$SD[2]^2) / 2)
d_bs <- (desc_bs$Mean[1] - desc_bs$Mean[2]) / pooled_sd_bs

# Boxplot
p1_bs <- ggplot(data_bs, aes(x = condition, y = words_recalled, fill = condition)) +
  geom_boxplot(width = 0.45, alpha = 0.8, outlier.shape = NA) +
  geom_jitter(width = 0.12, alpha = 0.6, size = 2) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Distribution of Recall Scores",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

# Bar chart with 95% CI
p2_bs <- ggplot(desc_bs, aes(x = condition, y = Mean, fill = condition)) +
  geom_col(width = 0.45, alpha = 0.85) +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Mean Recall by Condition",
       subtitle = "Error bars = 95% CI",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

desc_text_bs <- paste0(
  "condition     n    Mean     SD\n",
  "Concrete     10   ", sprintf("%4.1f", desc_bs$Mean[1]), "   ", sprintf("%.2f", desc_bs$SD[1]), "\n",
  "Abstract     10   ", sprintf("%4.1f", desc_bs$Mean[2]), "   ", sprintf("%.2f", desc_bs$SD[2])
)

ttest_text_bs <- paste0(
  "Independent Samples t-test\n\n",
  "t(", sprintf("%.2f", t_bs$parameter), ") = ", sprintf("%.2f", t_bs$statistic),
  ",  p ", p_fmt(t_bs$p.value), "\n",
  "95% CI [", sprintf("%.2f", t_bs$conf.int[1]), ", ", sprintf("%.2f", t_bs$conf.int[2]), "]\n",
  "Mean difference = ", sprintf("%.1f", desc_bs$Mean[1] - desc_bs$Mean[2]), " words\n",
  "Cohen's d = ", sprintf("%.2f", abs(d_bs))
)

banner_bs <- make_banner_grob(
  "Group T  (Ali, Bertie & Charlie)",
  "Between-Subjects Design  |  Independent Samples t-test  |  N = 20"
)
var_bs    <- make_var_grob()
stats1_bs <- make_stats_grob("Descriptive Statistics", desc_text_bs)
stats2_bs <- make_stats_grob("Inferential Statistics", ttest_text_bs)

png("analysis-preview-between.png", width = 8, height = 10, units = "in", res = 200,
    bg = "white", family = "Atkinson Hyperlegible")

grid.newpage()
pushViewport(viewport(layout = grid.layout(
  nrow = 5, ncol = 2,
  heights = unit(c(1.4, 0.35, 1.3, 3.5, 0.1), "null"),
  widths  = unit(c(1, 1), "null")
)))

pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1:2,
                       x = 0.5, y = 0.5, width = 0.94, height = 0.88))
grid.draw(banner_bs)
popViewport()

pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1:2))
grid.draw(var_bs)
popViewport()

pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1,
                       x = 0.5, y = 0.5, width = 0.88, height = 0.85))
grid.draw(stats1_bs)
popViewport()

pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 2,
                       x = 0.5, y = 0.5, width = 0.88, height = 0.85))
grid.draw(stats2_bs)
popViewport()

pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 1,
                       x = 0.5, y = 0.5, width = 0.92, height = 0.95))
print(p1_bs, vp = current.viewport())
popViewport()

pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 2,
                       x = 0.5, y = 0.5, width = 0.92, height = 0.95))
print(p2_bs, vp = current.viewport())
popViewport()

popViewport()
dev.off()

cat("Between-subjects:\n")
cat("  Concrete M =", desc_bs$Mean[1], " SD =", round(desc_bs$SD[1], 2), "\n")
cat("  Abstract M =", desc_bs$Mean[2], " SD =", round(desc_bs$SD[2], 2), "\n")
cat("  t =", round(t_bs$statistic, 2), " df =", round(t_bs$parameter, 2),
    " p =", round(t_bs$p.value, 3), " d =", round(abs(d_bs), 2), "\n\n")


# ============================================================
# WITHIN-SUBJECTS VARIANT
# ============================================================

# Manually crafted paired data — moderate effect (d ~ 0.5) with realistic noise
n_ws <- 20
concrete_ws <- c(12, 10, 8, 14, 11, 9, 13, 7, 11, 10, 12, 9, 14, 11, 8, 13, 10, 12, 9, 11)
abstract_ws <- c(10, 10, 9, 11, 10, 8, 10, 9,  9, 12, 11, 7, 13, 11, 6, 14, 10,  9, 10, 8)
# diffs:        2   0  -1  3   1  1   3  -2  2  -2   1  2   1   0  2  -1   0   3  -1  3

data_ws <- tibble(
  participant = rep(1:n_ws, 2),
  condition = factor(rep(c("Concrete", "Abstract"), each = n_ws),
                     levels = c("Concrete", "Abstract")),
  words_recalled = c(concrete_ws, abstract_ws)
)

desc_ws <- data_ws %>%
  group_by(condition) %>%
  summarise(n = n(), Mean = mean(words_recalled),
            SD = sd(words_recalled), .groups = "drop")

t_ws <- t.test(concrete_ws, abstract_ws, paired = TRUE)
diffs <- concrete_ws - abstract_ws
d_ws <- mean(diffs) / sd(diffs)

# Cousineau-Morey within-subject 95% CIs
participant_means <- (concrete_ws + abstract_ws) / 2
grand_mean <- mean(c(concrete_ws, abstract_ws))

# Adjust scores by removing between-subject variance
adj_concrete <- concrete_ws - participant_means + grand_mean
adj_abstract <- abstract_ws - participant_means + grand_mean

# Morey correction factor
morey_factor <- sqrt(2 / (2 - 1))  # sqrt(n_conditions / (n_conditions - 1))

ci_concrete <- mean(adj_concrete) + c(-1, 1) * qt(0.975, n_ws - 1) * sd(adj_concrete) / sqrt(n_ws) * morey_factor
ci_abstract <- mean(adj_abstract) + c(-1, 1) * qt(0.975, n_ws - 1) * sd(adj_abstract) / sqrt(n_ws) * morey_factor

desc_ws$CI_lower <- c(ci_concrete[1], ci_abstract[1])
desc_ws$CI_upper <- c(ci_concrete[2], ci_abstract[2])

# Paired line plot
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
  labs(title = "Paired Scores by Participant",
       subtitle = "Lines connect same participant",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

# Bar chart with within-subject 95% CIs
p2_ws <- ggplot(desc_ws, aes(x = condition, y = Mean, fill = condition)) +
  geom_col(width = 0.45, alpha = 0.85) +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.12, linewidth = 0.5) +
  scale_fill_manual(values = c("Concrete" = navy, "Abstract" = light_orange)) +
  scale_y_continuous(limits = c(0, 16), breaks = seq(0, 16, 2)) +
  labs(title = "Mean Recall by Condition",
       subtitle = "Error bars = 95% within-subject CI",
       x = "Word Type", y = "Words Recalled (out of 15)") +
  theme_analysis + theme(legend.position = "none")

desc_text_ws <- paste0(
  "condition     n    Mean     SD\n",
  "Concrete     20   ", sprintf("%4.1f", desc_ws$Mean[1]), "   ", sprintf("%.2f", desc_ws$SD[1]), "\n",
  "Abstract     20   ", sprintf("%4.1f", desc_ws$Mean[2]), "   ", sprintf("%.2f", desc_ws$SD[2])
)

ttest_text_ws <- paste0(
  "Paired Samples t-test\n\n",
  "t(", t_ws$parameter, ") = ", sprintf("%.2f", t_ws$statistic),
  ",  p ", p_fmt(t_ws$p.value), "\n",
  "95% CI [", sprintf("%.2f", t_ws$conf.int[1]), ", ", sprintf("%.2f", t_ws$conf.int[2]), "]\n",
  "Mean difference = ", sprintf("%.1f", mean(diffs)), " words\n",
  "Cohen's d = ", sprintf("%.2f", abs(d_ws))
)

banner_ws <- make_banner_grob(
  "Group T  (Ali, Bertie & Charlie)",
  "Within-Subjects Design  |  Paired Samples t-test  |  N = 20"
)
var_ws    <- make_var_grob()
stats1_ws <- make_stats_grob("Descriptive Statistics", desc_text_ws)
stats2_ws <- make_stats_grob("Inferential Statistics", ttest_text_ws)

png("analysis-preview-within.png", width = 8, height = 10, units = "in", res = 200,
    bg = "white", family = "Atkinson Hyperlegible")

grid.newpage()
pushViewport(viewport(layout = grid.layout(
  nrow = 5, ncol = 2,
  heights = unit(c(1.4, 0.35, 1.3, 3.5, 0.1), "null"),
  widths  = unit(c(1, 1), "null")
)))

pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1:2,
                       x = 0.5, y = 0.5, width = 0.94, height = 0.88))
grid.draw(banner_ws)
popViewport()

pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1:2))
grid.draw(var_ws)
popViewport()

pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1,
                       x = 0.5, y = 0.5, width = 0.88, height = 0.85))
grid.draw(stats1_ws)
popViewport()

pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 2,
                       x = 0.5, y = 0.5, width = 0.88, height = 0.85))
grid.draw(stats2_ws)
popViewport()

pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 1,
                       x = 0.5, y = 0.5, width = 0.92, height = 0.95))
print(p1_ws, vp = current.viewport())
popViewport()

pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 2,
                       x = 0.5, y = 0.5, width = 0.92, height = 0.95))
print(p2_ws, vp = current.viewport())
popViewport()

popViewport()
dev.off()

cat("Within-subjects:\n")
cat("  Concrete M =", desc_ws$Mean[1], " SD =", round(desc_ws$SD[1], 2), "\n")
cat("  Abstract M =", desc_ws$Mean[2], " SD =", round(desc_ws$SD[2], 2), "\n")
cat("  t =", round(t_ws$statistic, 2), " df =", t_ws$parameter,
    " p =", round(t_ws$p.value, 4), " d =", round(abs(d_ws), 2), "\n")
cat("  Within-subject CI concrete:", round(ci_concrete, 2), "\n")
cat("  Within-subject CI abstract:", round(ci_abstract, 2), "\n")

cat("\nDone — generated analysis-preview-between.png and analysis-preview-within.png\n")
