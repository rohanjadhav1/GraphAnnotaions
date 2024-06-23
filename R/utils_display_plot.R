#' To display the plot with the certain annotations 
#'
#' @description A utils function
#' 
#' @importFrom ggplot2 annotate geom_hline geom_vline
#'
#' @return Return plot with the applied certain annotations
#' @export
display_plot <- function(p, annots) {
  for (i in seq_along(annots)) {
    if (!is.null(annots[[i]]$type)) {
      if (annots[[i]]$type == "Text") {
        p <- p + annotate(geom = "text", x = annots[[i]]$x, 
                          y = annots[[i]]$y, label = annots[[i]]$text, 
                          size = annots[[i]]$size, alpha = annots[[i]]$alpha, 
                          parse = annots[[i]]$parse, color = annots[[i]]$color)
        
      } else if (annots[[i]]$type == "Horizontal Line") {
        p <- p + geom_hline(yintercept = annots[[i]]$yintercept,
                            linetype = annots[[i]]$linetype, size = annots[[i]]$size, 
                            color = annots[[i]]$color)
        
      } else if (annots[[i]]$type == "Vertical Line") {
        p <- p + geom_vline(xintercept = annots[[i]]$xintercept,
                            linetype = annots[[i]]$linetype, size = annots[[i]]$size, 
                            color = annots[[i]]$color)
        
      } else if (annots[[i]]$type == "Rectangle") {
        p <- p + annotate(geom = "rect", xmin = annots[[i]]$xmin,
                          ymin = annots[[i]]$ymin, xmax = annots[[i]]$xmax, 
                          ymax = annots[[i]]$ymax, alpha = annots[[i]]$alpha,
                          color = annots[[i]]$color, fill = annots[[i]]$fill)
        
      } else if (annots[[i]]$type == "Segment") {
        p <- p + annotate(geom = "segment", x = annots[[i]]$x,
                          y = annots[[i]]$y, xend= annots[[i]]$xend, 
                          yend = annots[[i]]$yend, linetype = annots[[i]]$linetype,
                          color = annots[[i]]$color, size = annots[[i]]$size)
        
      } else if (annots[[i]]$type == "Point Range") {
        p <- p + annotate(geom = "pointrange", x = annots[[i]]$x,
                          y = annots[[i]]$y,size = annots[[i]]$size,
                          ymin = annots[[i]]$ymin, ymax = annots[[i]]$ymax,
                          # xmin = annots[[i]]$xmin, xmax = annots[[i]]$xmax,
                          alpha = annots[[i]]$alpha, colour = annots[[i]]$color, 
                          linewidth = annots[[i]]$linewidth)
        
      } 
    } else {
      p
    }
  }
  p
}