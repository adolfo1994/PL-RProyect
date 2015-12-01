library(shiny)

shinyUI(fluidPage(

  # Titulo
  titlePanel("Clustering de Color en imagenes"),

  # Layout
  sidebarLayout(
    sidebarPanel(
      # Slider para seleccion el numero clusters
      sliderInput(
      "bins", 
      "Number of clusters: ",
      min = 2, max = 9, value = 4),
      
      # Imagen original
      fileInput(
        "image1",
        "Original Image",
        multiple = FALSE,
        accept = NULL,
        width = NULL),
      
      # Imagen a clusterizar
      fileInput(
        "image2",
        "Clustered Image",
        multiple = FALSE,
        accept = NULL,
        width = NULL)
    ),

    # Mostrar Imagen original y plot de los pixeles clusterizados
    mainPanel(
      imageOutput("image"),
      plotOutput('plot')
    )
  )
))
