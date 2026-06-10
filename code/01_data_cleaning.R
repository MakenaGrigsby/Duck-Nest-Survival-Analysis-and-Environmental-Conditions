# Duck Nest Survival Analysis
# Clean the duck nest survival data and define initiation-based survival times.

library(tidyverse)
library(lubridate)

# Load data
duck_raw <- read.csv("data/raw/robel_2018.06.15.csv")

# Clean and define survival variables
duck_clean <- duck_raw %>%
  mutate(
    status <- ifelse(fate == "failed", 1, 0),
    time <- LastChecked - initiation,
    age.found <- FirstFound - initiation
  ) %>%
  filter(time > 0)

# Create age-at-discovery groups
duck_clean <- duck_clean %>%
  mutate(
    age.found.group <- case_when(
      age.found <= 9 ~ "Young",
      age.found <= 15 ~ "Middle",
      age.found >= 16 ~ "Older",
      TRUE ~ NA_character_
    ),
    age.found.group <- factor(age.found.group, levels = c("Young", "Middle", "Older"))
  )

# Save processed dataset
write.csv(duck_clean, "data/processed/duck_nest_survival_cleaned.csv", row.names = FALSE)
