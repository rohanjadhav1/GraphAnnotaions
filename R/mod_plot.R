#' plot UI Function
#'
#' @param id Internal parameters for {golem}.
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("plot"))
  )
}

#' plot Server Function
#'
#' @noRd 
mod_plot_server <- function(id, rv, annotations){
  moduleServer(id, function(input, output, session){
    output$plot <- renderPlotly({
      p <- ggplotly(rv$plot)
      
      annots <- annotations()
      
      if (length(annots) > 0) {
        # browser()
        p <- p %>%
          layout(
            annotations = lapply(annots, function(ann) {
              list(
                type = ann$type,
                x = ann$x,
                y = ann$y,
                text = ann$text,
                size = ann$size,
                alpha = ann$alpha,
                x0 = ann$xmin,
                x1 = ann$xmax,
                y0 = ann$ymin,
                y1 = ann$ymax,
                line = list(dash = input$linetype, width = input$size)
              )
            })
          )
      }
      rv$anntn_plot <- p
      p
    })
  })
}
