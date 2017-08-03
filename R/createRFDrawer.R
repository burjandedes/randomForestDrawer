#' UI and Server code returner
#'
#' Returns with a list which contains the called ui and server function.
#'
#' @param defaultColor The default color of the class.
#' @param defaultShape The default shape of the class.
#' @param colors The colors for the classes.
#' @param shapes The shapes for the classes.
#' @return With a list which contains the UI and the Server code.
#' @export
createRFDrawer <- function(defaultColor = "blue",
                           defaultShape = "square",
                           colors = NULL,
                           shapes = NULL) {

  list(
    UI = createRFDrawerUI(),
    Server = createRFDrawerServer(defaultColor, defaultShape, colors, shapes)
  )
}
