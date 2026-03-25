#' Normalize column names
#' @param x Character vector
#' @return Character vector
susneo_normalize_names <- function(x) {
  tolower(gsub("\\s+", "_", trimws(x)))
}

#' Read and standardize SUSNEO energy data
#' @param path Character path to a CSV file
#' @return A tibble with standardized columns
#' @export
susneo_read_data <- function(path) {
  df <- readr::read_csv(path, show_col_types = FALSE)
  names(df) <- susneo_normalize_names(names(df))

  # Normalize the emissions column name from the provided sample.
  if ("carbon_emission_in_kgco2e" %in% names(df)) {
    df <- dplyr::rename(df, carbon_emission_kgco2e = carbon_emission_in_kgco2e)
  }

  # Sample is dd-mm-YYYY; use lubridate for robustness.
  if ("date" %in% names(df)) {
    df$date <- suppressWarnings(lubridate::dmy(df$date))
    if (all(is.na(df$date))) {
      # Fallback to any parseable date
      df$date <- suppressWarnings(as.Date(df$date))
    }
  }

  df
}

#' Validate dataset structure
#' @param df A data.frame/tibble
#' @return TRUE if valid; otherwise throws an error with a helpful message
#' @export
susneo_validate_data <- function(df) {
  required <- c("id", "site", "date", "type", "value", "carbon_emission_kgco2e")
  missing <- setdiff(required, names(df))
  if (length(missing) > 0) {
    rlang::abort(paste0("Missing required columns: ", paste(missing, collapse = ", ")))
  }

  if (!inherits(df$date, "Date")) {
    rlang::abort("Column `date` must be parsed as Date.")
  }
  if (any(is.na(df$date))) {
    rlang::abort("Column `date` contains NA after parsing. Please check date format.")
  }
  if (!is.numeric(df$value)) {
    rlang::abort("Column `value` must be numeric.")
  }
  if (!is.numeric(df$carbon_emission_kgco2e)) {
    rlang::abort("Column `carbon_emission_kgco2e` must be numeric.")
  }

  TRUE
}

