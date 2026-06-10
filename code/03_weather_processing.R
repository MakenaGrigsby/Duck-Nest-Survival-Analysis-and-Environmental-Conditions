# Process Daymet weather data and create first-7-day weather summaries
# for each monitored duck nest using initiation-based time.

library(tidyverse)
library(lubridate)

# Load cleaned nest data

duck_clean <- read.csv("data/processed/duck_nest_survival_cleaned.csv")

# If date variables were saved as character strings, convert them here.
# Adjust the format if your dates are stored differently.
duck_clean <- duck_clean %>%
  mutate(
    initiation <- as.Date(initiation),
    LastChecked <- as.Date(LastChecked),
    FirstFound <- as.Date(FirstFound),
    LastPresent <- as.Date(LastPresent)
  )

# Load Daymet daily weather data

# This assumes you already downloaded/created a daily Daymet file
# with one row per nest per day.

daymet_daily <- read.csv("data/processed/daymet_daily_by_nest.csv")

daymet_daily <- daymet_daily %>%
  mutate(date <- as.Date(date), mean.temp <- (tmax + tmin) / 2)


# Create first-7-day weather summaries

# The first-7-day window starts at estimated nest initiation.
# It includes initiation through initiation + 6 days.
# If a nest was checked before the full 7-day window was complete,
# the window ends at LastChecked.

duck_weather_7 <- duck_clean %>%
  select(
    nest_id,
    initiation,
    LastChecked,
    everything()
  ) %>%
  left_join(daymet_daily, by = "nest") %>%
  filter(
    date >= initiation,
    date <= pmin(initiation + 6, LastChecked)
  ) %>%
  group_by(nest_id) %>%
  summarise(
    mean.temp.first7 <- mean(mean.temp, na.rm = TRUE),
    precip.first7 <- sum(prcp, na.rm = TRUE),
    weather.days.first7 <- n(),
    .groups = "drop"
  ) %>%
  right_join(duck_clean, by = "nest") %>%
  mutate(
    log_precip.first7 <- log(1 + precip.first7)
  )

# Check weather summary completeness

weather_check <- duck_weather_7 %>%
  count(weather.days.first7)

print(weather_check)

summary(
  duck_weather_7 %>%
    select(mean.temp.first7, precip.first7, log_precip.first7)
)

# Save processed dataset with weather variables

write.csv(
  duck_weather_7,
  "data/processed/duck_weather_7.csv",
  row.names = FALSE
)
