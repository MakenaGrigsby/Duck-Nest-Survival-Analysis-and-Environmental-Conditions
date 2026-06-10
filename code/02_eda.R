# Create exploratory summaries, Kaplan-Meier curves, and log-rank tests.

library(tidyverse)
library(survival)
library(survminer)
library(ggplot2)

duck_clean <- read.csv("data/processed/duck_nest_survival_cleaned.csv")

# Robel density histogram
ggplot(duck_clean, aes(x = robel.found)) +
  geom_histogram(bins = 30, color = "white") +
  labs(
    x = "Robel density",
    y = "Count",
    title = "Distribution of Robel vegetation density"
  ) +
  theme_minimal()

ggsave(
  filename = "plots/eda_robel_found_histogram.png",
  width = 6,
  height = 4,
  dpi = 300
)

# Create Robel density groups
duck_clean <- duck_clean %>%
  mutate(
    robel.group <- cut(
      robel.found,
      breaks = quantile(robel.found, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
      include.lowest = TRUE,
      labels = c("Low Robel", "Middle Robel", "High Robel")
    )
  )

# Kaplan-Meier curve by Robel group
km_robel <- survfit(Surv(time, status) ~ robel.group, data = duck_clean)

km_plot <- ggsurvplot(
  km_robel,
  data = duck_clean,
  risk.table = FALSE,
  conf.int = FALSE,
  xlab = "Days since estimated nest initiation",
  ylab = "Estimated survival probability",
  legend.title = "Robel group"
)

ggsave(
  filename = "plots/km_robel_density_group_initiation_time.png",
  plot = km_plot$plot,
  width = 6,
  height = 4,
  dpi = 300
)

# Log-rank test
survdiff(Surv(time, status) ~ robel.group, data = duck_clean)
