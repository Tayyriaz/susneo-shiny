app_server <- function(input, output, session) {
  svc <- SusneoEnergyService$new()

  data_rv <- mod_data_source_server("data_source")

  output$filters_ui <- shiny::renderUI({
    df <- data_rv()
    if (is.null(df) || nrow(df) == 0) return(NULL)

    shiny::tagList(
      shiny::dateRangeInput(
        "date_range",
        "Date range",
        start = min(df$date, na.rm = TRUE),
        end = max(df$date, na.rm = TRUE)
      ),
      shinyWidgets::pickerInput(
        "sites",
        "Facilities",
        choices = sort(unique(df$site)),
        selected = sort(unique(df$site)),
        multiple = TRUE,
        options = list(`actions-box` = TRUE, `live-search` = TRUE)
      )
    )
  })

  filtered_data <- shiny::reactive({
    df <- data_rv()
    if (is.null(df)) return(NULL)

    # If filters not yet initialized, show full data.
    if (is.null(input$date_range) || is.null(input$sites)) return(df)

    svc$filter_data(
      df = df,
      date_range = input$date_range,
      sites = input$sites
    )
  })

  mod_dashboard_server("dashboard", data = filtered_data, svc = svc)
}

