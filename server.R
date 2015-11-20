library(shiny)

shinyServer(function(input, output) {
  output$image <- renderImage({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    list(src = inFile$datapath,
         width = 600,
         alt = "This is alternate text")
  })
  output$name <- renderText({
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    c("Image: " , inFile$name)
  })
  output$datapath <- renderText({
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    c("Path: " , inFile$datapath)
  })
  output$size <- renderText({
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    c("Size: " , inFile$size)
  })
  output$type <- renderText({
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    c("Type: " , inFile$type)
  })

})