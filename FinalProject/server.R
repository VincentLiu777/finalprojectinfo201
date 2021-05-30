library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)

#source("data_clean.R")

covidData <- read.csv("../raw data/owid-covid-data (1).csv")
data <- covidData %>%
  filter(continent == "" | location =="United States" | location == "China" | 
           location == "Russia" | location == "Japan" | location == "Germany" |
           location == "Brazil" | location == "United Arab Emirates" |
           location == "United Kingdom") %>%
  select(location, date, total_cases, new_cases, total_deaths, new_deaths, people_fully_vaccinated) %>%
  mutate(month = format(as.POSIXlt(date), "%m/%Y")) %>%
  group_by(location, month) %>%
  summarise(total_cases = max(total_cases), 
            new_cases = max(new_cases),
            total_deaths = max(total_deaths),
            new_deaths = max(new_deaths),
            people_fully_vaccinated = max(people_fully_vaccinated))

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

