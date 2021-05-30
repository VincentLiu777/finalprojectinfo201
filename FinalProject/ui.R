library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
<<<<<<< HEAD
    titlePanel(""),
=======
    titlePanel("Covid-19 data visualization and analysis"),
>>>>>>> efbb96bc87c506ea2ec0bd30fdb5f6f2102078c5

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput()
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("graph")
        )
    )
))
