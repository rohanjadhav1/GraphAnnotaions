#' upload_graph UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @importFrom shiny uiOutput NS
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_upload_graph_ui <- function(id){
  ns <- NS(id)
  tabPanel("Upload Image", uiOutput(ns("upload_plot")))
}
    
#' upload_graph Server Functions
#' 
#' @importFrom shiny renderUI plotOutput renderPlot
#'
#' @noRd 
mod_upload_graph_server <- function(id, rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$upload_plot <- renderUI({
      
      wellPanel(
        sidebarLayout(
          sidebarPanel(width = 3,
            shiny::fileInput(inputId = "input_plot",
                             label = "Upload Image(yet to work)", 
                             accept = c(".jpeg", ".png", ".pdf")),
            selectInput(inputId = ns("select_plot"),
                        label = "Select Plot",
                        choices = c("Scatter Plot" = 1,
                                    "Bar Chart" = 2,
                                    "Box Plot" = 3),
                        selected = 1)
          ),
          mainPanel(
            plotOutput(ns("plot"))
          ))
        )
    })
    
    observeEvent(input$input_plot, {
      input_file <- input$input_plot$datapath
      if (!is.null(input_file)) {
        plot <- png::readPNG(input_file)
        rv$plot <- plot
      }
    })
    
    observeEvent(input$select_plot, {
      if (input$select_plot == 1) {
        plot <- readRDS("./inst/plots/line_plot.rds")
      } else if (input$select_plot == 2) {
        plot <- readRDS("./inst/plots/bar_chart.rds")
      } else if (input$select_plot == 3) {
        plot <- readRDS("./inst/plots/box_plot.rds")
      }
      
      rv$plot <- plot
      rv$plot_type <- input$select_plot
    })
    
    output$plot <- renderPlot({
      rv$plot
    })
 
  })
}

## To be copied in the UI
# mod_upload_graph_ui("upload_graph_1")
    
## To be copied in the server
# mod_upload_graph_server("upload_graph_1")
