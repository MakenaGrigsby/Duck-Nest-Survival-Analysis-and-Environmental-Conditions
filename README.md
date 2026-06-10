# Duck Nest Survival Analysis

This repository contains code, data, and report materials for a survival analysis of duck nest failure in North Dakota.

The project examines whether Robel vegetation density is associated with duck nest survival while adjusting for early weather conditions, species, year, and nest age at discovery.

## Project Overview

The event of interest is nest failure. Survival time was measured from estimated nest initiation rather than nest discovery because nests may already be active when first found.

Two modeling approaches were used:

- Cox proportional hazards models as a course-aligned comparison
- Interval-censored accelerated failure time models as the final modeling approach

The interval-censored AFT model was used because many nest failures were only known to occur between two nest checks. This allowed failed nests to be represented using lower and upper failure-time bounds instead of assigning all failures to a single check date.

## Data Source

The duck nest data come from the publicly available dataset associated with:

Ringelman, K. M., and Skaggs, C. G. (2019). *Vegetation phenology and nest survival: Diagnosing heterogeneous effects through time*. Ecology and Evolution, 9, 2121–2130. https://doi.org/10.1002/ece3.4906

Weather summaries were created using Daymet daily weather data.

## Main Findings

Higher Robel vegetation density was associated with better nest survival. In the Cox model, higher Robel density was associated with a lower hazard of nest failure. In the interval-censored log-normal AFT model, higher Robel density was associated with longer survival time.

Higher first-7-day temperature was associated with poorer survival outcomes, while first-7-day precipitation was not statistically significant in the final models.

## Repository Contents

```text
duck-nest-survival-analysis/
├── README.md
├── .gitignore
├── robel_2018.06.15.csv
├── duck_nest_survival_cleaned.csv
└── code/
    ├── 01_data_cleaning.R
    ├── 02_exploratory_survival.R
    ├── 03_weather_processing.R
    ├── 04_cox_models.R
    ├── 05_interval_censored_aft.R
    └── 06_diagnostics_sensitivity.R
```

File Descriptions

* robel_2018.06.15.csv: original duck nest dataset used in the analysis
* duck_nest_survival_cleaned.csv: cleaned dataset with initiation-based survival variables
* code/01_data_cleaning.R: cleans the raw duck nest data and defines survival variables
* code/02_exploratory_survival.R: creates exploratory summaries, Kaplan-Meier curves, and log-rank tests
* code/03_weather_processing.R: creates first-7-day weather summaries from Daymet data
* code/04_cox_models.R: fits Cox proportional hazards models and Cox diagnostics
* code/05_interval_censored_aft.R: fits interval-censored accelerated failure time models
* code/06_diagnostics_sensitivity.R: runs diagnostic checks and sensitivity analyses

Methods

The final analysis used initiation-based survival time. Failed nests were represented using initiation-based lower and upper failure-time bounds, while nests not observed to fail were treated as right-censored after their final check.

Candidate interval-censored AFT models included Weibull, log-normal, and log-logistic distributions. These models were compared using AIC, and the log-normal AFT model was selected as the final model.

Sensitivity analyses included midpoint timing for failed nests, removing nests with high age at discovery, spline checks for weather variables, and a Robel density by first-7-day temperature interaction.

Software

The analysis was conducted in R. Main packages used include:

* tidyverse
* survival
* survminer
* ggplot2
* splines
* daymetr

Author

Makena Grigsby
Master’s Student in Statistics
University of California, Riverside
