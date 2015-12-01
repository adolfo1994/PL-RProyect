library(shiny)
library(jpeg)
library(ggplot2)

# Tema de ploteo para ggplot, define estilos para la tabla
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

# Función principal del servidor
shinyServer(function(input, output) {
  
  # Primer output, la imagen original
  output$image <- renderImage({
    
    inFile <- input$image1
    
    if (is.null(inFile))   # validar que se haya subido la imagen
      return(NULL)
    
    list(src = inFile$datapath,
         height = 300,
         alt = "Imagen original") # Mostrar
  })
  
  output$plot <- renderPlot({
    inFile <- input$image2
    
    if (is.null(inFile))         # Validar que se haya subido la imagen
      return(NULL)        
    img = readJPEG(inFile$datapath) # Leer imagen JPEG
    closeAllConnections();
    # Obtener dimensión de la imagen
    imgDm <- dim(img)

    # Assiganr RGB al frame de datos
    imgRGB <- data.frame(
      x = rep(1:imgDm[2], each = imgDm[1]),
      y = rep(imgDm[1]:1, imgDm[2]),
      R = as.vector(img[,,1]),
      G = as.vector(img[,,2]),
      B = as.vector(img[,,3])
    )
    
    kClusters <- input$bins # Numero de clusters, obtenidos del slider 
    kMeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = kClusters)  # kmeans, que ya esta implementado
    kColours <- rgb(kMeans$centers[kMeans$cluster,]) # generar la imagen clusterizada
    p <- ggplot(data = imgRGB, aes(x = x, y = y)) + 
      geom_point(colour = kColours) +
      labs(title = paste("k-Means Clustering of", kClusters, "Colours")) +
      xlab("x") +
      ylab("y") + 
      plotTheme()                            # Mostrar la imagen en output
    print(p)
  })
})