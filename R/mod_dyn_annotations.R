#' dyn_annotations UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dyn_annotations_ui <- function(id){
  ns <- NS(id)
  shiny::div(
    id = id,
    shiny::fluidRow(
      column(width = 8,
             shiny::selectInput(inputId = ns("anntn_type"),
                                label = "Annotation Type",
                                choices = names(annotate_layer_args),
                                selected = "text"))),
    shiny::fluidRow(
      column(width = 8,
             shiny::selectInput(inputId = ns("select_attr"),
                                label = "Select Attributes",
                                choices = NULL,
                                multiple = TRUE))),
    shiny::fluidRow(
      column(width = 12,
             uiOutput(ns("dynamic_inputs")))
    ),
    
    shiny::fluidRow(
      shiny::actionButton(
        ns("deleteButton"),
        "Delete",
        icon = icon('trash'),
        style = 'float: left'
      )
    ),
    br()
  )
}
    
#' dyn_annotations Server Functions
#'
#' @noRd 
mod_dyn_annotations_server <- function(id, rv, annotations){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # annotations <- reactiveVal(list())
    num <- rv$num
    observeEvent(input$anntn_type, {
      
      updateSelectInput(session = session,
                        'select_attr',
                        choices = names(annotate_layer_args[[input$anntn_type]]),
                        selected = names(annotate_layer_args[[input$anntn_type]])[1:3])
    })
    
    output$dynamic_inputs <- renderUI({
      
      inputs <- lapply(input$select_attr, function(var) {
        switch(var,
               'x' = numericInput(ns("x"), "X", min = 0, value = NULL),
               'y' = numericInput(ns("y"), "Y", min = 0, value = NULL),
               'text' = textInput(ns("text"), "Text", value = NULL),
               'parse' = checkboxInput(ns("parse"), "Parse", value = FALSE),
               'linetype' = selectInput(ns("linetype"), "Line Type", 
                                        choices = c("solid", "dashed", "dotted",
                                                    "dotdash", "longdash"), selected = NULL),
               'size' = numericInput(ns("size"), "Size", min = 0, value = NULL),
               'alpha' = numericInput(ns("alpha"), "Alpha", min = 0, max = 1, value = NULL, step = 0.1),
               'xmin' = numericInput(ns("xmin"), "X-Min", min = 0, value = NULL),
               'xmax' = numericInput(ns("xmax"), "X-Max", min = 0, value = NULL),
               'ymin' = numericInput(ns("ymin"), "Y-Min", min = 0, value = NULL),
               'ymax' = numericInput(ns("ymax"), "Y-Max", min = 0, value = NULL),
               'xintercept' = numericInput(ns("xintercept"), "X-Intercept", min = 0, value = NULL),
               'yintercept' = numericInput(ns("yintercept"), "Y-Intercept", min = 0, value = NULL),
               NULL)
      })
      # do.call(tagList, inputs)
      # Arrange the inputs in a 2x2 grid
      rows <- split(inputs, ceiling(seq_along(inputs)/3))
      tagList(
        lapply(rows, function(row) {
          fluidRow(
            lapply(row, function(col) {
              column(4, col)
            })
          )
        })
      )
    })
    
    annotations_list <- annotations()
    annotations_list[[num]] <- list(type = NULL,
                                    x = NULL, 
                                    y = NULL, 
                                    text = NULL,
                                    parse = NULL,
                                    linetype = NULL,
                                    size = NULL,
                                    alpha = NULL,
                                    xmin = NULL,
                                    ymin = NULL,
                                    xmax = NULL,
                                    ymax = NULL,
                                    xintercept = NULL,
                                    yintercept = NULL)
    annotations(annotations_list)
    
    observe({
      
      annotations_list <- annotations()
      
      annotations_list[[num]] <- list(type = input$anntn_type,
                                      x = input$x, 
                                      y = input$y, 
                                      text = input$text,
                                      parse = input$parse,
                                      linetype = input$linetype,
                                      size = input$size,
                                      alpha = input$alpha,
                                      xmin = input$xmin,
                                      ymin = input$ymin,
                                      xmax = input$xmax,
                                      ymax = input$ymax,
                                      xintercept = input$xintercept,
                                      yintercept = input$yintercept)
      annotations(annotations_list)
    })
  })
}
    
## To be copied in the UI
# mod_dyn_annotations_ui("dyn_annotations_1")
    
## To be copied in the server
# mod_dyn_annotations_server("dyn_annotations_1")
