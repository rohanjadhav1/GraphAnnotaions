#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @importFrom shiny tagList tabsetPanel tabPanel fluidPage actionButton
#' @importFrom shiny sidebarLayout sidebarPanel mainPanel
#' @importFrom shinydashboard dashboardPage dashboardHeader dashboardSidebar dashboardBody
#' @importFrom magrittr %>% 
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    # List the first level UI elements here.
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Graph Annotations",
                                      tags$li(
                                        class = "dropdown",
                                        a(href = "https://www.linkedin.com/in/rohan-jadhav-924642103/",
                                          icon('linkedin'))),
                                      tags$li(
                                        class = "dropdown",
                                        a(href = "https://github.com/rohanjadhav1/GraphAnnotations",
                                          icon('github')))
                                      ),
      shinydashboard::dashboardSidebar(width = 0),
      shinydashboard::dashboardBody(
        fluidPage(
          # Output: Table summarizing the values entered---
          tabsetPanel(
            type = "tabs",
            id = "tabSet",
            mod_upload_graph_ui("upload_graph_1"),
            tabPanel("Add Annotations", 
                     fluidPage(
                       sidebarLayout(
                         sidebarPanel(
                           actionButton('add', "Add Annotation", 
                                        icon = icon('plus'))
                         ),
                         mainPanel(
                           mod_plot_ui("plot_ui_1")
                         )
                       )
                     )),
            mod_download_plot_ui("download_plot_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#' 
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "GraphAnnotations"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
