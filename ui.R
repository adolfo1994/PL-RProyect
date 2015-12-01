
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Clustering de Color en imagenes"),

  # FileInput
  sidebarLayout(
    sidebarPanel(
      sliderInput(
      "bins", 
      "Number of clusters: ",
      min = 2, max = 7, value = 4),
      
      fileInput(
        "file",
        "files",
        multiple = FALSE,
        accept = NULL,
        width = NULL)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      imageOutput("image"),
      plotOutput('plot')
    )
  )
))
