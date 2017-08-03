#' Convert a tree to a graph
#'
#' Processes and converts a single tree of a random forest to an igraph graph.
#'
#' With this function we can convert a tree of a random forest model to an
#' igraph graph.
#' At first we process the raw tree data and make a graph data from it.
#' After that we add properties to the graph.
#' And finally we append the new graph to a list which contains igraph graphs.
#' @param treeGraphList A list which contains the graphs.
#' @param rawTreeDataFrame A tree, which created with the randomForest::getTree function.
#' @param defaultColor The default color of the nodes.
#' @param defaultShape  The deafult shape of the nodes.
#' @param classes The classes of the random forest target variables (if any).
#' @param colors The colors of the classes (if any).
#' @param shapes The shapes of the classes (if any).
#'
#' @return A list which contains the new and a previous graphs.
#'
#' @import dplyr
#' @examples
#' \dontrun{
#' # Model must be a valid rf model with keep.forest=TRUE
#' treeGraphList <- list()
#' treeGraphList <- processTree(
#'                    treeGraphList
#'                    randomForest::getTree(model, k=1, labelVar=TRUE),
#'                  )
#' print(treeGraphList)
#' }
processTree <- function(treeGraphList,
                        rawTreeDataFrame,
                        defaultColor = "blue",
                        defaultShape = "square",
                        classes = NULL,
                        colors = NULL,
                        shapes = NULL)
{
  # If the caller won't renamed the columns we rename it.
  if (identical(colnames(rawTreeDataFrame),c("left daughter",
                                             "right daughter",
                                             "split var",
                                             "split point",
                                             "status",
                                             "prediction"))) {
    colnames(rawTreeDataFrame) = c("left.daughter", "right.daughter",
                                    "split.var", "split.point", "status",
                                    "prediction")
  }

  # Maybe invalid tree object or the caller renamed the colnames.
  if (!identical(colnames(rawTreeDataFrame), c("left.daughter",
                                               "right.daughter",
                                               "split.var",
                                               "split.point",
                                               "status",
                                               "prediction"))) {
    error("The tree data frame column names must be: left.daughter,
           right.daughter, split.var, split.point, status, prediction")
  }

  # Convert the split values to numeric
  rawTreeDataFrame$split.point <- as.numeric(as.character(rawTreeDataFrame$split.point))

  # Make leaf node's split point NA
  rawTreeDataFrame[!is.na(rawTreeDataFrame$prediction),]$split.point <- NA_integer_

  # Make the left (TRUE) and the right (FALSE) edges.
  edgesDataFrame <- data.frame(
    from = rep(row.names(rawTreeDataFrame), 2),
    to = c(rawTreeDataFrame$left.daughter, rawTreeDataFrame$right.daughter),
    label = c(rep("T", nrow(rawTreeDataFrame)), rep("F", nrow(rawTreeDataFrame))),
    label.color = c(rep("orange", 2*nrow(rawTreeDataFrame)))
  )

  # Make a grapg from the data frame and delete the vertices
  treeGraph <- graph_from_data_frame(edgesDataFrame) %>% delete_vertices("0")

  # A temporary data frame which will store the new split label (variable <= value)
  # The color and the shape properties of the vertexes.
  temp <- rawTreeDataFrame[,c("split.var", "prediction", "split.point")]

  temp[,1] <- as.character(temp[,1])
  temp[,2] <- as.character(temp[,2])

  # Make the new split label
  temp[is.na(temp$split.var),]$split.var <- as.character(temp$prediction[is.na(temp$split.var)])
  temp[!is.na(temp$split.point),]$split.var <- paste0(temp[!is.na(temp$split.point),]$split.var,
                                                      "<=", temp[!is.na(temp$split.point),]$split.point)

  # Get color for the nodes
  temp <- cbind(temp, sapply(temp$prediction,
                             getColorForClass,
                             defaultColor = defaultColor,
                             classes = classes,
                             colors = colors))
  colnames(temp)[ncol(temp)] <- "color"
  temp$color <- as.character(temp$color)

  # Get shapes for the nodes
  temp <- cbind(temp, sapply(temp$prediction,
                             getShapeForClass,
                             defaultShape = defaultShape,
                             classes = classes,
                             shapes = shapes))
  colnames(temp)[ncol(temp)] <- "shape"
  temp$shape <- as.character(temp$shape)

  # Add properties to the vertexes
  V(treeGraph)$label <- gsub("_"," ", temp$split.var)
  V(treeGraph)$color <- as.character(temp$color)
  V(treeGraph)$shape <- as.character(temp$shape)

  # Set the color of the edges to black
  E(treeGraph)$color <- "black"

  # Add the new tree to the existing list
  append(treeGraphList, list(treeGraph))
}
