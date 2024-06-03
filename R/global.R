# list of possible arguments
annotate_layer_args <- list(
  text = list(
    x = list(req = TRUE),
    y = list(req = TRUE),
    text = list(req = TRUE),
    parse = list(req = TRUE),
    # color = list(req = FALSE),
    size = list(req = FALSE),
    alpha = list(req = FALSE)
    # fontface = list(req = FALSE),
    # family = list(req = FALSE),
    # angle = list(req = FALSE),
    # hjust = list(req = FALSE), #"inward", # (“left”, “center”, “right”, “inward”, “outward”)
    # vjust = list(req = FALSE) # "inward", # (“bottom”, “middle”, “top”, “inward”, “outward”)
    # check_overlap = list(req = FALSE) # TRUE # boolean
  ),
  hline = list(
    yintercept = list(req = TRUE),
    # y = list(req = TRUE),
    linetype = list(req = FALSE),
    # color = list(req = FALSE),
    alpha = list(req = FALSE),
    size = list(req = FALSE)
  ),
  vline = list(
    xintercept = list(req = TRUE),
    # x = list(req = TRUE),
    linetype = list(req = FALSE),
    # color = list(req = FALSE),
    alpha = list(req = FALSE),
    size = list(req = FALSE)
  ),
  rect = list(
    xmin = list(req = TRUE),
    xmax = list(req = TRUE),
    ymin = list(req = TRUE),
    ymax = list(req = TRUE),
    alpha = list(req = TRUE)
    # color = list(req = FALSE),
    # fill = list(req = FALSE)
  )
)