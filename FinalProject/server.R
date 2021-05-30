library(shiny)
library(dplyr)
library(ggplot2)

source("data_clean.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$locations <- renderUI({
        checkboxGroupInput("location", label = h3("locations of interest"), 
                            choices = unique(data$location),
                            selected = "World")
    })
    totalCases <- reactive({
        print(input$slider)
        data %>%
            filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
            filter(location %in% input$location) %>%
            select(location, total_cases)
    })
    output$cases_Plot <- renderPlot({
        ggplot(totalCases()) +
          geom_point(aes(x = total_cases, y = location, color = location), stat = "identity")
    })
})
