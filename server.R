library(shiny)
library(jpeg)
library(ggplot2)

plotTheme <- function() {
  theme(
    panel.background = element_rect(
      size = 3,
      colour = "black",
      fill = "white"),
    axis.ticks = element_line(
      size = 2),
    panel.grid.major = element_line(
      colour = "gray80",
      linetype = "dotted"),
    panel.grid.minor = element_line(
      colour = "gray90",
      linetype = "dashed"),
    axis.title.x = element_text(
      size = rel(1.2),
      face = "bold"),
    axis.title.y = element_text(
      size = rel(1.2),
      face = "bold"),
    plot.title = element_text(
      size = 20,
      face = "bold",
      vjust = 1.5)
  )
}  
shinyServer(function(input, output) {
  
  output$image <- renderImage({
    
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    list(src = inFile$datapath,
         height = 300,
         alt = "This is alternate text")
  })
  
  output$plot <- renderPlot({
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    img = readJPEG(inFile$datapath)
    closeAllConnections();
    # Obtain the dimension
    imgDm <- dim(img)
    
    # Assign RGB channels to data frame
    imgRGB <- data.frame(
      x = rep(1:imgDm[2], each = imgDm[1]),
      y = rep(imgDm[1]:1, imgDm[2]),
      R = as.vector(img[,,1]),
      G = as.vector(img[,,2]),
      B = as.vector(img[,,3])
    )
    kClusters <- input$bins
    kMeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = kClusters)
    kColours <- rgb(kMeans$centers[kMeans$cluster,])
    p <- ggplot(data = imgRGB, aes(x = x, y = y)) + 
      geom_point(colour = kColours) +
      labs(title = paste("k-Means Clustering of", kClusters, "Colours")) +
      xlab("x") +
      ylab("y") + 
      plotTheme()
    print(p)
  })
#   
#   output$name <- renderText({
#     inFile <- input$file
#     if (is.null(inFile))
#       return(NULL)
#     c("Image: " , inFile$name)
#   })
#   output$datapath <- renderText({
#     inFile <- input$file
#     if (is.null(inFile))
#       return(NULL)
#     c("Path: " , inFile$datapath)
#   })
#   output$size <- renderText({
#     inFile <- input$file
#     if (is.null(inFile))
#       return(NULL)
#     c("Size: " , inFile$size)
#   })
#   output$type <- renderText({
#     inFile <- input$file
#     if (is.null(inFile))
#       return(NULL)
#     c("Type: " , inFile$type)
#   })

})