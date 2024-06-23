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
#' @importFrom plotly as_widget
#' @noRd 
mod_download_plot_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download_plot <- renderUI({
      fluidPage(
        actionButton(ns("down_img"), "Download Image",
                        icon = icon('download')),
        
        downloadButton(ns("down_plot"), "Download Plotly", 
                       icon = icon('download')),
        
        plotlyOutput(ns("download_plot_object"))
      )
    })
    
    plot <- reactive({
      if (length(rv$annotations) > 0) {
        plot <- switch (rv$plot_type,
                        '1' = rv$scatter_plot,
                        '2' = rv$bar_chart,
                        '3' = rv$box_plot,
                        NULL
        )
      } else {
        plot <- rv$plot
      }
      
      plot
    })
    
    output$download_plot_object <- renderPlotly({
      plot()
    })
    
    observeEvent(input$down_img, {
      showModal(
        modalDialog(
          title = "Download Plots",
          shiny::fluidRow(
            column(4,
                   shiny::selectInput(
                     inputId  = ns('down_img_type'),
                     choices  = c('png', 'tiff', 'svg', 'pdf', 'tex', 'ps'),
                     selected = 'png',
                     label    = "Format"
                   )),
            column(4,
                   shiny::numericInput(
                     inputId = ns('down_img_width'),
                     label   = "Width (cm)",
                     min     = 1,
                     value   = 16
                   )),
            column(4,
                   shiny::numericInput(
                     inputId = ns('down_img_height'),
                     label   = "Height (cm)",
                     min     = 1,
                     value   = 9
                   ))
          ),
          
          # Download plot
          downloadButton(
            outputId = ns('download_plot_img'),
            label    = "Download Image",
            icon     = icon('camera')
          )
        )
      )
    })
    
    # Download plot
    output$download_plot_img <- downloadHandler(
      filename = function(){
        glue::glue("plot.{input$down_img_type}")
      },
      content = function(con) {
        ggplot2::ggsave(
          filename = con,
          plot     = plot(),
          device   = input$down_img_type,
          width    = input$down_img_width,
          height   = input$down_img_height,
          units    = "cm",
          dpi      = 200,
          limitsize = TRUE
        )
      }
    )
    
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
