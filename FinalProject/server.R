library(shiny)
library(dplyr)

read.csv("raw data/owid-covid-data(1).csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    dataInput <- reactive({
      getSymbols(input$symb, src = "yahoo",
                 from = input$dates[1],
                 to = input$dates[2],
                 auto.assign = FALSE)
    })
  
  
    output$plot <- renderPlot({
      data <- getSymbols(input$symb, src = "yahoo",
                         from = input$dates[1],
                         to = input$dates[2],
                         auto.assign = FALSE)
      
      chartSeries(data, theme = chartTheme("white"),
                  type = "line", log.scale = input$log, TA = NULL)
    })
  
    

    output$distPlot <- renderPlot({

       
    })

})
