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
    
    vac <- reactive({ ## data for vaccine.
      print(input$slider)
      data %>%
        filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
        filter(location %in% input$location) %>%
        select(location, people_fully_vaccinated)
    })
    mortality <- reactive({ ## data for mortality rate
      print(input$slider)
      data %>% 
        mutate(mortality_rate = (new_deaths/new_cases)*100) %>% 
        filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
        filter(location %in% input$location) %>%
        select(location, mortality_rate)
    })
    
#Cases graph section begin
    
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
    
#Cases graph section begin
    
    output$cases_Plot <- renderPlot ({ ## graph correspond with the Infected cases 
    
    segmentData <- reactive({
      print(input$slider)
      data %>%
        filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
        filter(location %in% input$location) %>%
        select(location, total_cases, new_cases)
    })
    
      ggplot(newCases(),aes(x=new_cases, y=location, color = location) ) +
        geom_segment(data = segmentData(), aes(x=new_cases  , xend=total_cases, y=location, yend=location))+
        geom_point(stat = "identity") +
        geom_point(data = totalCases(), aes(x=total_cases, y=location, color = location), stat = "identity")+
        xlab("Value of new cases - total cases")
      
    })
    
    output$vac_Plot <- renderPlot({ ## graph correspond with the vaccine. 
      ggplot(vac()) +
        geom_point(aes(x = people_fully_vaccinated, y = location, color = location), stat = "identity")
    })
    output$Mortality_Plot <- renderPlot({ ## graph correspond with the mortality rate. 
      ggplot(mortality())+
        geom_point(aes(x= mortality_rate, y = location, color = location),stat = "identity")
    })
        
})

