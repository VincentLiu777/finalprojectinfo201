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
    output$vac_Plot <- renderPlot({ ## graph correspond with the vaccine. 
        ggplot(vac()) +
          geom_point(aes(x = people_fully_vaccinated, y = location, color = location), stat = "identity")
    })
    output$Mortality_Plot <- renderPlot({ ## graph correspond with the mortality rate. 
        ggplot(mortality())+
            geom_point(aes(x= mortality_rate, y = location, color = location),stat = "identity")
    })
})
