#' Get color for a class
#'
#' Get color for a factor's class based on the parameter values.
#'
#' This is basically a LUT, which finds the proper color for a factor's class.
#' We can add the \code{classes}, the \code{colors} or a \code{defaultColor}.
#' @param classValue The caller wants a color for this class.
#' @param defaultColor The default color, if we can't return with a color.
#' @param classes A list of possibly classes.
#' @param colors A list which contains the colors of the classes.
#' @return A color as a string.
#' @examples
#' \dontrun{
#' print(getColorForClass("Test",classes = c("Test", "Test2"), colors=c("red", "blue")))
#' print(getColorForClass("Test2"))
#' print(getColorForClass(NA,classes = c("Test", "Test2"), colors=c("red", "blue")))
#' }
getColorForClass <- function(classValue,
                             defaultColor = "blue",
                             classes = NULL,
                             colors = NULL) {

  #Return with the default color if not have class or unparametrized call.
  if (is.na(classValue) || is.null(classes) || is.null(colors) ||
      length(classes) != length(colors)) {
    return(defaultColor)
  }

  # Get the classes color
  returnValue <- colors[which(classes == classValue)]

  # If we doesn't have a color then return with the default.
  if (identical(returnValue, integer(0))) {
    return(defaultColor)
  }

  # Return with the proper color.
  returnValue
}
