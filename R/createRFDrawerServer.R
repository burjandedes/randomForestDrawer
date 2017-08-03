#' Returns with the random forest drawer server closure
#'
#' This function returns with a server closure which can be passed to eg. callModule.
#' @param defaultColor The default color of the class.
#' @param defaultShape The default shape of the class.
#' @param colors The colors for the classes.
#' @param shapes The shapes for the classes.
#' @return With the server closure.
#' @import shiny
#' @import visNetwork
#' @import randomForest
createRFDrawerServer <- function(defaultColor, defaultShape, colors, shapes) {
  function(input, output, session) {
    page <- 1

    PAGE_MAX <- 1
    PAGE_MIN <- 1

    fileUploaded <- FALSE

    treeGraphList <- list()

    observeEvent(input$rfUploader, {
      fileUploaded <- FALSE
      fileUploaded <<- fileUploaded

      randomForestModel <- readRDS(input$rfUploader$datapath)

      PAGE_MAX <- randomForestModel$ntree

      for (i in PAGE_MIN:PAGE_MAX) {
        currentTree <- getTree(
          randomForestModel,
          k = i,
          labelVar = TRUE
        )

        colnames(currentTree) <- c("left.daughter", "right.daughter", "split.var",
                                   "split.point", "status", "prediction")

        treeGraphList <- processTree(
          treeGraphList,
          currentTree,
          defaultColor,
          defaultShape,
          levels(randomForestModel$y),
          colors,
          shapes
        )

        treeGraphList <<- treeGraphList
      }

      page <<- 1
      fileUploaded <<- TRUE
      PAGE_MAX <<- PAGE_MAX

      output$pageNumber <- renderText({
        paste0("Selected tree: ", page)
      })

      output$network <- renderVisNetwork({
        getVisNetworkFromIGraph(toVisNetworkData(treeGraphList[[page]], idToLabel = FALSE))
      })
    })

    output$network <- renderVisNetwork({
      if (!fileUploaded)
        return()

      output$network <- renderVisNetwork({
        getVisNetworkFromIGraph(toVisNetworkData(treeGraphList[[page]], idToLabel = FALSE))
      })
    })

    output$pageNumber <- renderText({
      paste0("Upload a proper .rf.RDS random forest model.")
    })

    observeEvent(input$left,{
      if (!fileUploaded)
        return()

      page <- if(page > PAGE_MIN) page - 1 else PAGE_MAX

      output$pageNumber <- renderText({
        paste0("Selected tree: ", page)
      })

      output$network <- renderVisNetwork({
        getVisNetworkFromIGraph(toVisNetworkData(treeGraphList[[page]], idToLabel = FALSE))
      })

      page <<- page

    })

    observeEvent(input$right,{
      if (!fileUploaded)
        return()

      page <- if(page < PAGE_MAX) page + 1 else PAGE_MIN

      output$pageNumber <- renderText({
        paste0("Selected tree: ", page)
      })

      output$network <- renderVisNetwork({
        getVisNetworkFromIGraph(toVisNetworkData(treeGraphList[[page]], idToLabel = FALSE))
      })

      page <<- page

    })
  }
}
