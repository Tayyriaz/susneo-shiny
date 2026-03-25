# Module: data source (upload or sample)

#' @export
mod_data_source_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h5("Data"),
    shiny::radioButtons(
      ns("data_mode"),
      label = NULL,
      choices = c("Use sample data" = "sample", "Upload CSV" = "upload"),
      selected = "sample",
      inline = TRUE
    ),
    shiny::conditionalPanel(
      condition = sprintf("input['%s'] == 'upload'", ns("data_mode")),
      shiny::fileInput(ns("file"), "Upload CSV", accept = c(".csv"))
    ),
    shiny::helpText("Required columns: id, site, date, type, value, carbon_emission_kgco2e")
  )
}

#' @export
mod_data_source_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    data_rv <- shiny::reactiveVal(NULL)

    shiny::observeEvent(input$data_mode, {
      if (identical(input$data_mode, "sample")) {
        sample_path <- system.file("app", "sample_data.csv", package = "susneoshiny")
        if (sample_path == "") {
          # Fallback: if running from app.R without installing package
          sample_path <- file.path("inst", "app", "sample_data.csv")
        }
        df <- susneo_read_data(sample_path)
        susneo_validate_data(df)
        data_rv(df)
      } else {
        data_rv(NULL)
      }
    }, ignoreInit = FALSE)

    shiny::observeEvent(input$file, {
      req(input$file)
      df <- susneo_read_data(input$file$datapath)
      susneo_validate_data(df)
      data_rv(df)
    })

    data_rv
  })
}

