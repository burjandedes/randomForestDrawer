# Random Forest Drawer

## Preface
Welcome on my Github page. In this repository you can find an R package, which
contains a Shiny module, which can draw a Random Forest model created in R.
This project uses the [shiny](https://shiny.rstudio.com/), the 
[visNetwork](http://datastorm-open.github.io/visNetwork/), the 
[iGraph](http://igraph.org/), the [randomForest](https://cran.r-project.org/web/packages/randomForest/index.html)
and the [dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html)
packages.
This drawer is interactive so you can navigate in the canvas and drag the nodes 
horizontally.

## Example
In the */inst/examples/* folder, you can find an example, that shows you
the usage of this package and an example random forest model too.

## Random Forest
In order to get the trees you need, you must add the parameter **keep.forest = TRUE**
to you fit function.

## Data
For now this project can read only *.rf.RDS* files. For additional details see this
[page](https://stats.stackexchange.com/questions/143943/applying-randomforest-algorithm-fit-on-new-data-without-recomputing-the-fit), it will shows you how the **saveRDS** function works.
