# SUSNEO Sustainability Dashboard (R Shiny + golem)

[![ci](../../actions/workflows/ci.yml/badge.svg)](../../actions/workflows/ci.yml)

Production-ready (take-home) dashboard for analyzing sustainability energy consumption data across facilities.

## Setup (Posit Cloud / local R)

Install dependencies:

```r
install.packages(c(
  "shiny","golem","bslib","dplyr","DT","ggplot2","lubridate","readr","rlang","R6","shinyWidgets","tidyr",
  "testthat"
))
```

Run the app:

```r
source("app.R")
```

## App overview

- **Data input**: Use bundled sample data (`inst/app/sample_data.csv`) or upload your own CSV.
- **Filters**: Date range + facility multi-select.
- **KPIs**: Total consumption, average daily consumption, total emissions (kgCO2e).
- **Charts**: Time series of consumption; facility comparison bar chart.
- **Table**: Summary by facility and energy type.

## Architecture

- `R/mod_data_source.R`: data upload + validation module
- `R/mod_dashboard.R`: KPI + plots + DT table module
- `R/r6_energy_service.R`: R6 business logic (filtering + KPI + summary table)
- `R/data_utils.R`: CSV read + column normalization + validation

## Data dictionary

Required columns:

- `id`: primary key
- `site`: facility code (e.g., AKBB, GECE, GFBN, VDRK)
- `date`: date of usage (sample format `dd-mm-YYYY`)
- `type`: energy type (Electricity/Fuel/Gas/Waste/Water)
- `value`: usage amount
- `carbon_emission_kgco2e`: emissions due to usage

Note: the provided sample file uses the header `carbon emission in kgco2e` and is normalized automatically.

## Testing

Run unit tests:

```r
install.packages("testthat")
testthat::test_dir("tests/testthat")
```

