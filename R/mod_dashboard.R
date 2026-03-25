# Module: dashboard (KPIs + plots + table)

#' @export
mod_dashboard_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    bslib::layout_columns(
      bslib::value_box(title = "Total consumption", value = shiny::textOutput(ns("kpi_total"), inline = TRUE)),
      bslib::value_box(title = "Avg daily consumption", value = shiny::textOutput(ns("kpi_avg_daily"), inline = TRUE)),
      bslib::value_box(title = "Total emissions (kgCO2e)", value = shiny::textOutput(ns("kpi_emissions"), inline = TRUE)),
      col_widths = c(4, 4, 4)
    ),
    shiny::br(),
    bslib::layout_columns(
      bslib::card(
        bslib::card_header("Consumption over time"),
        shiny::plotOutput(ns("ts_plot"), height = 280)
      ),
      bslib::card(
        bslib::card_header("Consumption by facility"),
        shiny::plotOutput(ns("bar_plot"), height = 280)
      ),
      col_widths = c(6, 6)
    ),
    shiny::br(),
    bslib::card(
      bslib::card_header("Summary table"),
      DT::DTOutput(ns("summary_tbl"))
    )
  )
}

#' @export
mod_dashboard_server <- function(id, data, svc) {
  shiny::moduleServer(id, function(input, output, session) {
    kpis <- shiny::reactive({
      svc$kpis(data())
    })

    output$kpi_total <- shiny::renderText({
      format(round(kpis()$total_consumption, 0), big.mark = ",")
    })
    output$kpi_avg_daily <- shiny::renderText({
      format(round(kpis()$avg_daily_consumption, 2), big.mark = ",")
    })
    output$kpi_emissions <- shiny::renderText({
      format(round(kpis()$total_emissions, 0), big.mark = ",")
    })

    output$ts_plot <- shiny::renderPlot({
      df <- data()
      req(df)
      pdat <- df |>
        dplyr::group_by(.data$date) |>
        dplyr::summarise(value = sum(.data$value, na.rm = TRUE), .groups = "drop")

      ggplot2::ggplot(pdat, ggplot2::aes(x = .data$date, y = .data$value)) +
        ggplot2::geom_line(color = "#2C7FB8", linewidth = 0.8) +
        ggplot2::geom_point(color = "#2C7FB8", size = 1.2) +
        ggplot2::labs(x = NULL, y = "Consumption", caption = "Sum across selected facilities") +
        ggplot2::theme_minimal(base_size = 12)
    })

    output$bar_plot <- shiny::renderPlot({
      df <- data()
      req(df)
      pdat <- df |>
        dplyr::group_by(.data$site) |>
        dplyr::summarise(value = sum(.data$value, na.rm = TRUE), .groups = "drop") |>
        dplyr::arrange(.data$value)

      ggplot2::ggplot(pdat, ggplot2::aes(x = .data$site, y = .data$value)) +
        ggplot2::geom_col(fill = "#41B6C4") +
        ggplot2::labs(x = NULL, y = "Total consumption") +
        ggplot2::theme_minimal(base_size = 12)
    })

    output$summary_tbl <- DT::renderDT({
      df <- data()
      req(df)
      tbl <- svc$summary_table(df)
      DT::datatable(tbl, options = list(pageLength = 10, scrollX = TRUE))
    })
  })
}

