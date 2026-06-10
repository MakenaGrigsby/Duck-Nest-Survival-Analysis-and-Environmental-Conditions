# Fit interval-censored accelerated failure time models.

library(tidyverse)
library(survival)

duck_interval <- read.csv("data/processed/duck_weather_7.csv")

# Define initiation-based lower and upper failure-time bounds
duck_interval <- duck_interval %>%
  mutate(
    time.lower <- LastPresent - initiation,
    time.upper <- LastChecked - initiation,
    time.upper.model <- ifelse(status == 0, NA, time.upper),
    log_precip.first7 <- log(1 + precip.first7)
  ) %>%
  filter(time.lower > 0) %>%
  filter(status == 0 | time.upper > time.lower)

# Weibull AFT
aft_weibull <- survreg(
  Surv(time.lower, time.upper.model, type = "interval2") ~ robel.found +
    mean.temp.first7 + log_precip.first7 + year + age.found.group + species, data = duck_interval,
dist = "weibull")

# Log-normal AFT
aft_lognormal <- survreg(
  Surv(time.lower, time.upper.model, type = "interval2") ~ robel.found + mean.temp.first7 +
    log_precip.first7 + year + age.found.group + species, data = duck_interval, dist = "lognormal")

# Log-logistic AFT
aft_loglogistic <- survreg(
  Surv(time.lower, time.upper.model, type = "interval2") ~ robel.found + mean.temp.first7 +
log_precip.first7 + year + age.found.group + species, data = duck_interval, dist = "loglogistic")

# Compare AIC
aft_aic <- AIC(aft_weibull, aft_lognormal, aft_loglogistic)
print(aft_aic)

write.csv(
  aft_aic,
  "results/aft_aic_comparison.csv",
  row.names = TRUE
)

# Final model summary
summary(aft_lognormal)

# Time ratios for final AFT model
aft_coef <- summary(aft_lognormal)$table

aft_results <- data.frame(
  variable = rownames(aft_coef),
  estimate = aft_coef[, "Value"],
  se = aft_coef[, "Std. Error"],
  z = aft_coef[, "z"],
  p_value = aft_coef[, "p"]
)

aft_results <- aft_results %>%
  mutate(
    time_ratio = exp(estimate),
    lower_95 = exp(estimate - 1.96 * se),
    upper_95 = exp(estimate + 1.96 * se)
  )

write.csv(
  aft_results,
  "results/aft_results.csv",
  row.names = FALSE
)
