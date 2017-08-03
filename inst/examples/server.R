shinyServer(function(input, output, session) {
  shinyFunctions <- createRFDrawer(
    colors = c("green", "yellow", "red"),
    shapes = rep("triangle", 3)
  )

  output$rfDrawer <- renderUI({
    shinyFunctions$UI("rf")
  })

  callModule(shinyFunctions$Server, id = "rf")
})
