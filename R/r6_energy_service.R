## Business logic layer (R6)

#' Energy service (filtering + KPI calculations)
#' @export
SusneoEnergyService <- R6::R6Class(
  classname = "SusneoEnergyService",
  public = list(
    filter_data = function(df, date_range, sites) {
      if (is.null(df) || nrow(df) == 0) return(df)
      if (is.null(date_range) || length(date_range) != 2) return(df)
      if (is.null(sites) || length(sites) == 0) return(df)

      dplyr::filter(
        df,
        rlang::.data$date >= as.Date(date_range[[1]]),
        rlang::.data$date <= as.Date(date_range[[2]]),
        rlang::.data$site %in% sites
      )
    },

    kpis = function(df) {
      if (is.null(df) || nrow(df) == 0) {
        return(list(
          total_consumption = 0,
          avg_daily_consumption = 0,
          total_emissions = 0
        ))
      }

      by_day <- df |>
        dplyr::group_by(rlang::.data$date) |>
        dplyr::summarise(consumption = sum(rlang::.data$value, na.rm = TRUE), .groups = "drop")

      list(
        total_consumption = sum(df$value, na.rm = TRUE),
        avg_daily_consumption = mean(by_day$consumption, na.rm = TRUE),
        total_emissions = sum(df$carbon_emission_kgco2e, na.rm = TRUE)
      )
    },

    summary_table = function(df) {
      if (is.null(df) || nrow(df) == 0) return(df)

      df |>
        dplyr::group_by(rlang::.data$site, rlang::.data$type) |>
        dplyr::summarise(
          days = dplyr::n_distinct(rlang::.data$date),
          total_value = sum(rlang::.data$value, na.rm = TRUE),
          total_emissions = sum(rlang::.data$carbon_emission_kgco2e, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(dplyr::desc(rlang::.data$total_value))
    }
  )
)

