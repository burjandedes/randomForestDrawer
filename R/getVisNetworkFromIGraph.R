#' Get visNetwork from IGraph wrapper
#'
#' Converts and IGraph graph into a visNetwork.
#'
#' Converts an IGraph into a visNetwork which has a hiearchical layout.
#' Made some performance boosting.
#' But it's still interactive.
#' This function also makes the nice tree layout for the graph.
#' @param graph The IGraph graph which we want to convert.
#'
#' @return A fully functional visNetwork
#' @import visNetwork
#' @import igraph
getVisNetworkFromIGraph <- function(graph) {
  visNetwork(graph$nodes, graph$edges) %>%
    visPhysics(enabled = FALSE) %>%
    visEdges(smooth = FALSE) %>%
    visInteraction(dragNodes = TRUE,
                   dragView = TRUE,
                   zoomView = TRUE,
                   navigationButtons = TRUE) %>%
    visHierarchicalLayout(direction = "UD",
                          levelSeparation = 500,
                          nodeSpacing = 300,
                          blockShifting = FALSE,
                          parentCentralization = TRUE,
                          sortMethod = "directed")
}
