# Fit Cox proportional hazards models using initiation-based survival time.

library(tidyverse)
library(survival)
library(survminer)

duck_weather_7 <- read.csv("data/processed/duck_weather_7.csv")

# Final stratified Cox model
cox_final <- coxph(
  Surv(time, status) ~ robel.found + mean.temp.first7 + log_precip.first7 + strata(year) +
    strata(species) + strata(age.found.group), data = duck_weather_7)

summary(cox_final)

# Hazard ratio table
cox_results <- broom::tidy(cox_final, exponentiate = TRUE, conf.int = TRUE)

write.csv(cox_results, "results/cox_results.csv", row.names = FALSE)

# Proportional hazards check
cox_ph <- cox.zph(cox_final)
print(cox_ph)

# Cox-Snell residuals
cox_snell <- residuals(cox_final, type = "expected")

cox_snell_fit <- survfit(Surv(cox_snell, status) ~ 1, data = duck_weather_7)

cox_snell_df <- data.frame(time = cox_snell_fit$time, cumhaz = -log(cox_snell_fit$surv))

ggplot(cox_snell_df, aes(x = time, y = cumhaz)) +
  geom_step() +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  labs(
    x = "Cox-Snell residual",
    y = "Estimated cumulative hazard",
    title = "Cox-Snell residual check"
  ) +
  theme_minimal()

ggsave(
  filename = "plots/cox_snell_residual_check.png", width = 6, height = 4, dpi = 300)
