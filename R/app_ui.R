app_ui <- function() {
  bslib::page_navbar(
    title = "SUSNEO Sustainability Dashboard",
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),
    bslib::nav_panel(
      "Dashboard",
      shiny::layout_sidebar(
        shiny::sidebar(
          mod_data_source_ui("data_source"),
          shiny::hr(),
          shiny::h5("Filters"),
          shiny::uiOutput("filters_ui")
        ),
        mod_dashboard_ui("dashboard")
      )
    ),
    bslib::nav_panel(
      "About",
      shiny::tagList(
        shiny::h3("About"),
        shiny::p("Demo app built using a golem-style structure (modules + business logic via R6).")
      )
    )
  )
}

