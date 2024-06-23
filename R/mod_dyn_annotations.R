#' dyn_annotations UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @importFrom shiny selectInput column fluidRow NS tagList uiOutput actionButton
#' @importFrom shinydashboard box
#'
#' @noRd 
mod_dyn_annotations_ui <- function(id){
  ns <- NS(id)
  fluidPage(
    shiny::div(
      id = id,
      shinydashboard::box(
        shiny::fluidRow(
          column(width = 8,
                 shiny::selectInput(inputId = ns("anntn_type"),
                                    label = "Annotation Type",
                                    choices = names(annotate_layer_args),
                                    selected = "Text"))),
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
        collapsible = TRUE,
        width = "100px",
        status = "primary"
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
  )
}
    
#' dyn_annotations Server Functions
#' @param rv a reactive variable
#' @param annotations list of annotations
#' 
#' @importFrom shiny observeEvent updateSelectInput fluidRow observe
#' @importFrom colourpicker colourInput
#'
#' @noRd 
mod_dyn_annotations_server <- function(id, rv) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns
    
    current_id <- rv$current_id
    observeEvent(input$anntn_type, {
      rv$annotations[[current_id]]$type <- input$anntn_type
      updateSelectInput(session = session,
                        'select_attr',
                        choices = names(annotate_layer_args[[input$anntn_type]]),
                        selected = names(annotate_layer_args[[input$anntn_type]]))
    })
    
    output$dynamic_inputs <- renderUI({
      
      inputs <- lapply(input$select_attr, function(var) {
        switch(var,
               'x' = numericInput(ns("x"), "X", min = 0, value = 0),
               'y' = numericInput(ns("y"), "Y", min = 0, value = 0),
               'text' = textInput(ns("text"), "Text", value = NULL),
               'parse' = checkboxInput(ns("parse"), "Parse", value = FALSE),
               'linetype' = selectInput(ns("linetype"), "Line Type", 
                                        choices = c("solid", "dashed", "dotted",
                                                    "dotdash", "longdash"), selected = "solid"),
               'size' = numericInput(ns("size"), "Size", min = 0, value = 1),
               'alpha' = numericInput(ns("alpha"), "Alpha", min = 0, max = 1, value = 0.7, step = 0.1),
               'xmin' = numericInput(ns("xmin"), "X-Min", min = 0, value = 0),
               'xmax' = numericInput(ns("xmax"), "X-Max", min = 0, value = 0),
               'ymin' = numericInput(ns("ymin"), "Y-Min", min = 0, value = 0),
               'ymax' = numericInput(ns("ymax"), "Y-Max", min = 0, value = 0),
               'xend' = numericInput(ns("xend"), "X-End", min = 0, value = 0),
               'yend' = numericInput(ns("yend"), "Y-End", min = 0, value = 0),
               'linewidth' = numericInput(ns("linewidth"), "Line Width", min = 0, value = 1),
               'xintercept' = numericInput(ns("xintercept"), "X-Intercept", min = 0, value = 0),
               'yintercept' = numericInput(ns("yintercept"), "Y-Intercept", min = 0, value = 0),
               'color' = colourpicker::colourInput(ns('color'), "Color", value = "#000000"),
               'fill' = colourpicker::colourInput(ns('fill'), "Fill", value = "#F0F0F0"),
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
    
    observe({
      annotations_list <- rv$annotations
      
      if (!is.null(annotations_list[[current_id]]$type)) {
        req(input$x, input$y)
        if (annotations_list[[current_id]]$type == "Text") {
          annotations_list[[current_id]] <- list(type  = input$anntn_type,
                                                 x     = input$x, 
                                                 y     = input$y, 
                                                 text  = input$text,
                                                 parse = input$parse,
                                                 color = input$color,
                                                 size  = input$size,
                                                 alpha = input$alpha)
          
        } else if (input$anntn_type == "Horizontal Line") {
          req(input$yintercept)
          annotations_list[[current_id]] <- list(type       = input$anntn_type,
                                                 yintercept = input$yintercept,
                                                 linetype   = input$linetype,
                                                 color      = input$color,
                                                 size       = input$size)
          
        } else if (input$anntn_type == "Vertical Line") {
          req(input$xintercept)
          annotations_list[[current_id]] <- list(type       = input$anntn_type,
                                                 xintercept = input$xintercept,
                                                 linetype   = input$linetype,
                                                 color      = input$color,
                                                 size       = input$size)
          
        } else if (input$anntn_type == "Rectangle") {
          req(input$xmin, input$xmax, input$ymin, input$ymax)
          annotations_list[[current_id]] <- list(type  = input$anntn_type,
                                                 xmin  = input$xmin,
                                                 xmax  = input$xmax,
                                                 ymin  = input$ymin,
                                                 ymax  = input$ymax,
                                                 alpha = input$alpha,
                                                 color = input$color,
                                                 fill  = input$fill)
          
        } else if (input$anntn_type == "Segment") {
          annotations_list[[current_id]] <- list(type     = input$anntn_type,
                                                 x        = input$x,
                                                 y        = input$y,
                                                 xend     = input$yend,
                                                 yend     = input$yend,
                                                 color    = input$color,
                                                 size     = input$size,
                                                 linetype = input$linetype)
          
        } else if (input$anntn_type == "Point Range") {
          annotations_list[[current_id]] <- list(type      = input$anntn_type,
                                                 x         = input$x,
                                                 y         = input$y,
                                                 ymin      = input$ymin,
                                                 ymax      = input$ymax,
                                                 color     = input$color,
                                                 size      = input$size,
                                                 linewidth = input$linewidth,
                                                 alpha     = input$alpha)
          
        }
      } else {
        annotations_list[[current_id]] <- NULL
      }
      
      annotations_list[[current_id]] <- 
        annotations_list[[current_id]][!(sapply(annotations_list[[current_id]], is.null))]
      rv$annotations <- annotations_list
    })
  })
}
    
## To be copied in the UI
# mod_dyn_annotations_ui("dyn_annotations_1")
    
## To be copied in the server
# mod_dyn_annotations_server("dyn_annotations_1")
