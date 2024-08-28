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
#' @importFrom htmlwidgets saveWidget
#' @importFrom plotly renderPlotly plotlyOutput ggplotly
#' @importFrom glue glue
#' @importFrom shiny downloadButton reactive downloadHandler wellPanel
#' @noRd 
mod_download_plot_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_plot <- renderUI({
      fluidPage(
        # Download plot
        br(),
        downloadButton(outputId = ns('download_plot_img'),
                       label    = "Download Image",
                       icon     = icon('camera')),
        
        downloadButton(ns("down_plot"), "Download Plotly", 
                       icon = icon('download')),
        br(),
        wellPanel(
          plotlyOutput(ns("download_plot_object"))
        )
      )
    })
    
    plot <- reactive({
      if (length(rv$annotations) > 0) {
        plot <- switch(rv$plot_type,
                       'scatter_plot' = rv$scatter_plot,
                       'bar_chart'    = rv$bar_chart,
                       'box_plot'     = rv$box_plot,
                       NULL)
      } else {
        plot <- rv$plot
      }
      
      plot
    })
    
    output$download_plot_object <- renderPlotly({
      plot()
    })
    
    # Download plot
    output$download_plot_img <- downloadHandler(
      filename = function(){
        glue::glue("{rv$plot_type}_{Sys.Date()}.png")
      },
      content = function(file) {
        ggplot2::ggsave(
          filename = file,
          plot     = plot(),
          width    = 20,
          height   = 15,
          dpi      = 200
        )
      }
    )
    
    output$down_plot <- downloadHandler(
      filename = function() {
        glue::glue("{rv$plot_type}_{Sys.Date()}.html")
      },
      content = function(file) {
        htmlwidgets::saveWidget(widget = ggplotly(plot()), 
                                file = file)
      }
    )
  })
}
    
## To be copied in the UI
# mod_download_plot_ui("download_plot_1")
    
## To be copied in the server
# mod_download_plot_server("download_plot_1")
