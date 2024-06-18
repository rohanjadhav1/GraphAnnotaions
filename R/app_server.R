#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  rv <- reactiveValues(
    plot = NULL
  )
  
  # Tab1
  mod_upload_graph_server("upload_graph_1", rv)
  
  # Tab 2
  annotations <- reactiveVal(list())
  
  observeEvent(input$add, {
    current_id <- paste0("id_", input$add)
    rv$current_id <- current_id
    insertUI(
      selector = "#add",
      where = "beforeBegin",
      ui = mod_dyn_annotations_ui(current_id)
    )
    
    mod_dyn_annotations_server(current_id, rv, annotations)
    
    observeEvent(input[[paste0(current_id, '-deleteButton')]], {
      annotations_list <- annotations()
      annotations_list[[current_id]] <- NULL
      annotations(annotations_list)
      removeUI(selector = paste0("#", current_id))
    })
  })
  
  mod_plot_server("plot_ui_1", rv, annotations)
  
  # Tab 3
  mod_download_plot_server("download_plot_1", rv)
}
