library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)
library(scales)
library(plotly)
library(shinydashboard)
library(fresh)


source("data_clean.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    output$locations <- renderUI({
        checkboxGroupInput("location", label = h3("Locations of interest"), 
                            choices = unique(data$location),
                            selected = "World")
        
    })
#selectAll action button begin
    observe({
      if(input$selectall == 0) return(NULL) 
      else if (input$selectall%%2 == 0)
      {
        updateCheckboxGroupInput(session,"location",h3("Locations of interest"),choices=unique(data$location))
      }
      else
      {
        updateCheckboxGroupInput(session,"location",h3("Locations of interest"),choices=unique(data$location), selected = unique(data$location) )
      }
    })
#selectAll action button end    
    
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
    
#Cases graph section end
    
    output$cases_Plot <- renderPlotly ({ ## graph correspond with the Infected cases 
    
      segmentData <- reactive({
        print(input$slider)
        data %>%
          filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
          filter(location %in% input$location) %>%
          select(location, total_cases, new_cases)
      })
    
      p1 =  ggplot(newCases(),aes(x=new_cases, y=location, color = location) ) +
        geom_segment(data = segmentData(), aes(x=new_cases, xend=total_cases, y=location, yend=location))+
        geom_point(stat = "identity") +
        geom_point(data = totalCases(), aes(x=total_cases, color = location, stat = "identity"))+
        theme(legend.position = "none")+
        xlab("Cases of infection, New cases -> total cases") +
        scale_x_continuous(labels = comma)
      
      ggplotly(p1, tooltip = c("x", "y"))%>% 
        style(hoverinfo = "none", traces = 1)
      

    })
    
   
    output$Mortality_Plot <- renderPlotly({ ## graph correspond with the mortality rate. 
      p2 = ggplot(mortality())+
        geom_segment(aes(x=0  , xend=mortality_rate , y=location, yend=location, color = location))+
        geom_point(aes(x= mortality_rate, y = location, color = location),stat = "identity")+
        theme(legend.position = "none")+
        xlab("Cases of mortality") +
        scale_x_continuous(labels = comma)
      
        ggplotly(p2, tooltip = c("x", "y"))%>% 
          style(hoverinfo = "none", traces = 1)
      
      
    })
    
    output$vac_Plot <- renderPlotly({ ## graph correspond with the vaccine. 
      p3 = ggplot(vac()) +
        geom_segment(aes(x=0  , xend=people_fully_vaccinated, y=location, yend=location, color = location))+
        geom_point(aes(x = people_fully_vaccinated, y = location, color = location), stat = "identity")+
        theme(legend.position = "none")+
        xlab("Number of fully vaccinated individual") +
        scale_x_continuous(labels = comma)
      
      ggplotly(p3, tooltip = c("x", "y"))%>% 
        style(hoverinfo = "none", traces = 1)
    })
      
})

