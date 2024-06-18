#' plot UI Function
#'
#' @param id Internal parameters for {golem}.
#' @importFrom shiny plotOutput NS tagList
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("plot"))
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
mod_plot_server <- function(id, rv, annotations) {
  moduleServer(id, function(input, output, session) {
    
    plot <- reactive({
      p <- rv$plot
      annots <- annotations()
      if (length(annots) > 0) {
        p <- display_plot(p, annots)
        rv$anntn_plot <- p
      }
      p
    })
    
    output$plot <- renderPlot({
      req(plot())
      plot()
    })
  })
}
