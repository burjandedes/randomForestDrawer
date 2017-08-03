#' Get shape for a class
#'
#' Get shape for a factor's class based on the parameter values.
#'
#' This is basically a LUT, which finds the proper shape for a factor's class.
#' We can add the \code{classes}, the \code{shapes} or a \code{defaultShape}.
#' @param classValue The caller wants a shape for this class.
#' @param defaultShape The default shape, if we can't return with a shape
#' @param classes A list of possibly classes.
#' @param shapes A list which contains the shapes of the classes.
#' @return A shape as a string.
#' @examples 
#' \dontrun{
#' print(getShapeForClass("Test",classes = c("Test", "Test2"), shapes=c("triangle", "circle")))
#' print(getShapeForClass("Test2"))
#' print(getShapeForClass(NA,classes = c("Test", "Test2"), shapes=c("triangle", "circle")))
#' }
getShapeForClass <- function(classValue,
                             defaultShape = "square",
                             classes = NULL,
                             shapes = NULL) {
  
  #Return with the default shape if not have class or unparametrized call.
  if (is.na(classValue) || is.null(classes) || is.null(shapes) || 
      length(classes) != length(shapes)) {
    return(defaultShape)
  }
  
  # Get the classes shape
  returnValue <- shapes[which(classes == classValue)]
  
  # If we doesn't have a shape then return with the default.
  if (identical(returnValue, integer(0))) {
    return(defaultShape)
  }
  
  # Return with the proper shape.
  returnValue
}
