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
            tabsetPanel(
                tabPanel("Home",
                        p("Welcome to our website. This website is a student assignment for Info 201 in 
                          University of Washington. The website contains information about Covid-19 
                          in general, all data was collected from “Our World in Data”.The dataset 
                          explicitly contains cumulative data and daily data for vaccine numbers, 
                          confirmed cases, confirmed deaths, newly increased cases, etc. 
                          This vaccination dataset uses the most recent official numbers from governments
                          and health ministries worldwide. All data comes from Global Change Data Lab, 
                          on their website, it offers detailed information on editors and data collectors. 
                          Here is the link for reference: [Coronavirus (COVID-19) Vaccinations - Statistics 
                           and Research - Our World in Data.] (https://ourworldindata.org/covid-vaccinations)"),
                       p("For our group’s project, the intended audience could be simply anyone who cares and
                          willing to pay attention to the pandemic data. The audience can have a better 
                          understanding of the pandemic and its influence to various factors after reading our
                          group’s report. In the website, we will offer three graphs that correspond with the 
                          opions on the left. Users have the ability to see a single country or continent, and 
                          also compare various countries or continents. Users also have the ability to drag the 
                          timeline to see the shift on data. The three graphs are: the number of cases, 
                          the mortality rate, and the vaccination. You can learn more about the coding through 
                          our group’s github repository. (VincentLiu777/finalprojectinfo201: 
                                                              final project for Info 201 (github.com)) "),
                      p("Graph of Cases of Infection: The first dot on the graph represents the number of 
                          new cases in that region, where the second dot on the graph represents the total 
                          cases of the region. 
                          Graph of mortality rate: This graph computes the mortality rate for the specific 
                          region, the unit for this graph is in percent. 
                          Graph of vaccine: This graph shows the number of people that are fully vaccinated 
                          in the specific region. SInce the vaccine finally came out in around January 2021, 
                          please drag the timeline to the proper time period in order to examine the data.")),
                tabPanel("About Us",
                         p("About the Author: The website was written by three students from University of Washington."), 
                         p("Anthony Zhang: A pre-major freshman at UW."),  
                         p("Vincent Liu: A pre-major freshman at UW."),   
                         p("Minghui He: A senior major in … at UW. "),  
                         p("You can contact us by email: rliu8@uw.edu.")),   
                tabPanel("Numbers of Cases",
                         plotlyOutput("cases_Plot")),
                tabPanel("Mortality Rate",
                        plotlyOutput("Mortality_Plot")), 
                tabPanel("Vaccine",
                            plotlyOutput("vac_Plot"))

        )
    )
)))
