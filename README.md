# Duck Nest Survival Analysis

This repository contains code and report materials for a survival analysis of duck nest failure in North Dakota. The project examines whether Robel vegetation density is associated with nest survival while adjusting for early weather conditions, species, year, and nest age at discovery.

## Project Overview

The analysis uses monitored duck nest data from the 2016 and 2017 nesting seasons. The event of interest is nest failure. Survival time was measured from estimated nest initiation rather than nest discovery because nests may already be active when they are first found.

Two main modeling approaches were used:

- Cox proportional hazards models as a course-aligned comparison
- Interval-censored accelerated failure time models as the final modeling approach

The interval-censored AFT model was used because many nest failures were only known to occur between two nest checks.

## Main Findings

Higher Robel vegetation density was associated with better nest survival. In the Cox model, higher Robel density was associated with a lower hazard of nest failure. In the interval-censored log-normal AFT model, higher Robel density was associated with longer survival time.

First-7-day temperature was also associated with survival, while first-7-day precipitation was not statistically significant in the final models.

## Repository Structure

- `R/`: R scripts for data cleaning, exploratory analysis, modeling, diagnostics, and sensitivity checks
- `report/`: final project report files
- `plots/`: figures used in the report
- `results/`: model output tables and summaries
- `data/`: raw and processed data, if permitted

## Methods

The final analysis used initiation-based survival time. Failed nests were represented using lower and upper failure-time bounds, while nests not observed to fail were treated as right-censored. Weibull, log-normal, and log-logistic interval-censored AFT models were compared using AIC, and the log-normal model was selected as the final AFT model.

## Software

The analysis was conducted in R using packages including:

- `survival`
- `survminer`
- `tidyverse`
- `ggplot2`
- `daymetr`

## Author

Makena Grigsby  
Master's Student in Statistics  
University of California, Riverside
