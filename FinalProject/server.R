library(shiny)
library(dplyr)
library(ggplot2)

covidData <- read.csv("../raw data/owid-covid-data (1).csv")

covidData[is.na(covidData)] = 0

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
    vac <- reactive({
        print(input$slider)
        data %>%
            filter(month == format(as.POSIXlt(input$slider), "%m/%Y")) %>%
            filter(location %in% input$location) %>%
            select(location, people_fully_vaccinated)
    })
    output$vac_Plot <- renderPlot({
        ggplot(vac()) +
          geom_point(aes(x = people_fully_vaccinated, y = location, color = location), stat = "identity")
    })
})
