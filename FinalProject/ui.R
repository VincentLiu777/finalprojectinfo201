library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid-19 data visualization and analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput()
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("")
        )
    )
))
