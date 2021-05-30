library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("owid-covid-data(1)")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({
        output$graph <- renderPlot({
           ggplot(data, aes()) +
            geom_bar()
            })
       
    })

})
