#' download_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_download_plot_ui <- function(id){
  ns <- NS(id)
  tabPanel("Download Image", uiOutput(ns("download_plot")))
}
    
#' download_plot Server Functions
#'
#' @noRd 
mod_download_plot_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_plot <- renderUI({
      fluidPage(
        downloadButton(ns("down_plot"), "Download Plot", 
                       icon = icon('download')),
        
        plotlyOutput(ns("download_plot_object"))
      )
    })
    
    plot <- reactive({
      if (!is.null(rv$anntn_plot)) {
        rv$anntn_plot
      } else {
        rv$plot
      }
    })
    
    output$download_plot_object <- renderPlotly({
      plot()
    })
    
    output$down_plot <- downloadHandler(
      filename = function() {
        paste("plot-", Sys.Date(), ".html", sep = "")
      },
      content = function(file) {
        htmlwidgets::saveWidget(widget = plot(), 
                                file = file)
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_download_plot_ui("download_plot_1")
    
## To be copied in the server
# mod_download_plot_server("download_plot_1")
