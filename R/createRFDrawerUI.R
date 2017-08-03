#' Returns with the random forest drawer UI closure
#' 
#' This function returns with an UI closure which can be passed to eg. renderUI.
#' @return With the UI closure.
#' @import shiny
#' @import visNetwork
createRFDrawerUI <- function() {
  function(id, input, output, session) {
    # Get the namespace of the UI
    ns <- NS(id)
    
    # The UI of the random forest drawer
    div(fluidPage(
      fileInput(ns("rfUploader"), 
                "Upload a .rf.RDS file",
                accept = c(".rf.RDS"),
                buttonLabel = "Browse...", 
                placeholder = "No RF model selected"),
      visNetworkOutput(ns("network")),
      fluidRow(
        column(width = 4, align="right",
               shiny::actionButton(ns("left"), "<-")
        ),
        column(width = 4, align="center",
               shiny::textOutput(ns("pageNumber"))     
        ),
        column(width = 4, 
               shiny::actionButton(ns("right"), "->")     
        )
      )
    ))
  }
}