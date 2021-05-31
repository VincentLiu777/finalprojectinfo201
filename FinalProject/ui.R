library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title

    titlePanel("Covid-19 data visualization and analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("slider", "Time", min = as.Date("2020-01-01"),max =as.Date("2021-05-01"),value=as.Date("2020-01-01"),timeFormat="%m/%Y"),
            uiOutput("locations"),
            actionLink("selectall","Select All") 
        ),

        # Show a plot of the generated distribution
        mainPanel(

            plotlyOutput("cases_Plot"),
            plotlyOutput("Mortality_Plot"), ## added my graph for the time being. 
            plotlyOutput("vac_Plot")

        )
    )
))
