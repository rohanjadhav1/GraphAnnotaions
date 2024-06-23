#' plot UI Function
#'
#' @param id Internal parameters for {golem}.
#' @importFrom shiny plotOutput NS tagList
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_plot_ui <- function(id){
  ns <- NS(id)
  div(
    wellPanel(
      style = "position: fixed; width: 60%;",
      plotOutput(ns("plot"))
    )
  )
}

#' plot Server Function
#'
#' @param annotations list annotations
#' @param rv reactive 
#'
#' @importFrom ggplot2 annotate
#' @importFrom shiny renderPlot
#' 
#' @noRd 
mod_plot_server <- function(id, rv) {
  moduleServer(id, function(input, output, session) {
    
    output$plot <- renderPlot({
      p <- rv$plot
      annots <- rv$annotations
      
      if (length(annots) > 0) {
        p <- display_plot(p, annots)
        if (rv$plot_type == '1') {
          rv$scatter_plot <- p
        } else if (rv$plot_type == '2') {
          rv$bar_chart <- p
        } else if (rv$plot_type == '3') {
          rv$box_plot <- p
        }
      }
      p
    })
  })
}
