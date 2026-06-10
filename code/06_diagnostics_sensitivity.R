# Run diagnostics and sensitivity analyses.

library(tidyverse)
library(survival)
library(survminer)
library(splines)

duck_weather_7 <- read.csv("data/processed/duck_weather_7.csv")

duck_weather_7 <- duck_weather_7 %>%
  mutate(log_precip.first7 <- log(1 + precip.first7))

# Cox linear temperature model
cox_temp_linear <- coxph(
  Surv(time, status) ~
    robel.found + mean.temp.first7 + log_precip.first7 + strata(year) + strata(species) + 
    strata(age.found.group), data = duck_weather_7)

# Cox spline temperature model
cox_temp_spline <- coxph(
  Surv(time, status) ~ robel.found + ns(mean.temp.first7, df = 3) +
    log_precip.first7 + strata(year) + strata(species) + strata(age.found.group), data = duck_weather_7)

AIC(cox_temp_linear, cox_temp_spline)
anova(cox_temp_linear, cox_temp_spline, test = "LRT")

# Temperature group descriptive check
duck_weather_7 <- duck_weather_7 %>%
  mutate(
    temp.group = cut(
      mean.temp.first7,
      breaks = quantile(mean.temp.first7, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE),
      include.lowest = TRUE,
      labels = c("Low temp", "Middle temp", "High temp")
    )
  )

survdiff(Surv(time, status) ~ temp.group, data = duck_weather_7) 

# Cox Robel by temperature interaction
cox_interaction <- coxph(
  Surv(time, status) ~ robel.found * mean.temp.first7 + log_precip.first7 +
    strata(year) + strata(species) + strata(age.found.group), data = duck_weather_7)

summary(cox_interaction)
anova(cox_temp_linear, cox_interaction, test = "LRT")
AIC(cox_temp_linear, cox_interaction)

# High age-at-discovery sensitivity
duck_age35 <- duck_weather_7 %>%
  filter(age.found <= 35)

cox_age35 <- coxph(
  Surv(time, status) ~ robel.found + mean.temp.first7 + log_precip.first7 + strata(year) +
    strata(species) + strata(age.found.group), data = duck_age35)

summary(cox_age35)
