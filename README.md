# Duck Nest Survival Analysis

This repository contains code, data, and report materials for a survival analysis of duck nest failure in North Dakota.

The project examines whether Robel vegetation density is associated with duck nest survival while adjusting for early weather conditions, species, year, and nest age at discovery.

## Project Overview

The event of interest is nest failure. Survival time was measured from estimated nest initiation rather than nest discovery because nests may already be active when first found.

Two modeling approaches were used:

- Cox proportional hazards models as a course-aligned comparison
- Interval-censored accelerated failure time models as the final modeling approach

The interval-censored AFT model was used because many nest failures were only known to occur between two nest checks. This allowed failed nests to be represented using lower and upper failure-time bounds instead of assigning all failures to a single check date.

## Why This Analysis Was Needed

Duck nests are not always found at the beginning of the nesting period, and failures are not always observed exactly when they happen. A nest may be active at one field check and found failed at a later check, which means the true failure time occurred somewhere between those two visits.

Because of this, the analysis used estimated nest initiation as the time origin and treated many failures as interval-censored. Cox proportional hazards models were used as a standard comparison, while interval-censored accelerated failure time models were used as the final modeling approach because they better matched how the failure times were recorded.

## Key Terms

| Term | Meaning in this project |
|---|---|
| Nest failure | The event of interest. A nest was considered failed if failure was observed during monitoring. |
| Right-censoring | A nest was not observed to fail by the final field check, so its later failure time was unknown. |
| Interval-censoring | A failed nest was known to be active at one check and failed by a later check, so the exact failure time was only known to fall within that interval. |
| Estimated initiation | The estimated date when the nest began. This was used as the time origin for survival time. |
| `LastPresent` | The last field check when the nest was known to be active. |
| `LastChecked` | The final field check for the nest; for failed nests, this was the check when failure was observed. |
| Robel density | A visual obstruction measurement of vegetation around the nest. Higher values indicate taller or denser vegetation cover. |
| First-7-day temperature | Mean temperature during the first 7 days after estimated nest initiation. |
| First-7-day precipitation | Total precipitation during the first 7 days after estimated nest initiation. |
| Cox proportional hazards model | A hazard-based survival model used as a course-aligned comparison. |
| AFT model | An accelerated failure time model. In this project, it was used to model survival time directly using interval-censored failure times. |
| Time ratio | The AFT model interpretation. Values greater than 1 indicate longer survival time, while values less than 1 indicate shorter survival time. |

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
