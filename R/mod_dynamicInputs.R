#' dynamicInputs UI Function
#'
#' @param id Internal parameters for {golem}.
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_dynamicInputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("add_annotation"), "Add Annotation"),
    uiOutput(ns("input_ui"))
  )
}

#' dynamicInputs Server Function
#'
#' @noRd 
mod_dynamicInputs_server <- function(id, annotations, rv){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
  observeEvent(input$add_annotation, {
    current_id <- paste0("id_", input$add_annotation)
    rv$current_id <- current_id
    insertUI(
      selector = paste0('#', ns("input_ui")),
      where = "beforeBegin",
      ui = mod_dyn_annotations_ui(current_id)
    )
    
    mod_dyn_annotations_server(current_id, rv)
    
    observeEvent(input[[paste0(current_id, '-deleteButton')]], {
      removeUI(selector = paste0("#", current_id))
    })
  })
  
  })
}
