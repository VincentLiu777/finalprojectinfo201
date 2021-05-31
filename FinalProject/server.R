library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)


source("data_clean.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$locations <- renderUI({
        checkboxGroupInput("location", label = h3("locations of interest"), 
                            choices = unique(data$location),
                            selected = "World")
    })
    
    #vac <- reactive({
     # print(input$slider)
     # data %>%
       # filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
      #  filter(location %in% input$location) %>%
      #  select(location, people_fully_vaccinated)
    #})
    
    newCases <- reactive({
      print(input$slider)
      data %>%
        filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
        filter(location %in% input$location) %>%
        select(location, new_cases)
    })
    
    totalCases <- reactive({
        print(input$slider)
        data %>%
            filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
            filter(location %in% input$location) %>%
            select(location, total_cases)
    })
    
    #dataCombined <- reactive({
      #x=data$location, 
      #print(input$slider)
      #newCases()
      #totalCases()
    #})
    
    #out <- reactive({
      #combined <- c(totalCases(), newCases())
    #})
    output$cases_Plot <- renderPlot ({
    
    segmentData <- reactive({
      print(input$slider)
      data %>%
        filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
        filter(location %in% input$location) %>%
        select(location, total_cases, new_cases)
    })
      
      #ggplot(totalCases()) +
        #geom_point(aes(x = total_cases, y = location, color = location), stat = "identity")
      
      ggplot(newCases(),aes(x=new_cases, y=location, color = location) ) +
        geom_segment(data = segmentData(), aes(x=new_cases  , xend=total_cases, y=location, yend=location))+
        geom_point(stat = "identity") +
        geom_point(data = totalCases(), aes(x=total_cases, y=location, color = location), stat = "identity")+
        xlab("Value of new cases - total cases")
        
        #coord_flip()#+
        #Etheme_ipsum() #+
        #theme(legend.position = "none")
      
    })
        
})

