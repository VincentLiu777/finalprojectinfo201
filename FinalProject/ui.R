library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)
library(scales)
library(plotly)
library(shinydashboard)
library(fresh)


#color theme for ui
mytheme <- create_theme(
    adminlte_color(
        light_blue = "#1F2833" #topbar color
    ),
    adminlte_sidebar(
        width = "400px",
        dark_bg = "#0B0C10",#sidebar backgroud color
        dark_hover_bg = "#379683",
        dark_color = "#EDF5E1"#font color
    ),
    adminlte_global(
        content_bg = "#1F2833",#body background color
        box_bg = "#A4B3B6", #box colors#C5C6C7#A4B3B6
        info_box_bg = "#FFFFFF"
        
    )
)


shinyUI(fluidPage(# Application title
        dashboardPage(dashboardHeader(title = "Covid-19 data visualization and analysis"),
                      
        dashboardSidebar( #sidebar
            sliderInput("slider", "Time", min = as.Date("2020-01-01"),max =as.Date("2021-05-01"),value=as.Date("2020-01-01"),timeFormat="%m/%Y"),
            uiOutput("locations"),
            actionLink("selectall","Select All")
        ),
        dashboardBody( #body/main component
            use_theme(mytheme),
            column(width = 6,
                box(title = "Home", width = NULL,status = "primary", solidHeader = TRUE, collapsible = TRUE, #collapsed = TRUE,
                    img(src='Coronavirus.png', width = "30%", height = "30%", align = "right"),
                    p("Welcome to our website. This website is a student assignment for Info 201 in 
                          University of Washington. The website contains information about Covid-19 
                          in general, all data was collected from “Our World in Data”.The dataset 
                          explicitly contains cumulative data and daily data for vaccine numbers, 
                          confirmed cases, confirmed deaths, newly increased cases, etc. 
                          This vaccination dataset uses the most recent official numbers from governments
                          and health ministries worldwide. All data comes from Global Change Data Lab, 
                          on their website, it offers detailed information on editors and data collectors.","Here is the link for reference: ",a(href="https://ourworldindata.org/covid-vaccinations", "[Coronavirus (COVID-19) 
                          Vaccinations - Statistics and Research - Our World in Data.]")),
                    br(),
                    
                    p("For our group’s project, the intended audience could be simply anyone who cares and
                          willing to pay attention to the pandemic data. The audience can have a better 
                          understanding of the pandemic and its influence to various factors after reading our
                          group’s report. In the website, we will offer three graphs that correspond with the 
                          opions on the left. Users have the ability to see a single country or continent, and 
                          also compare various countries or continents. Users also have the ability to drag the 
                          timeline to see the shift on data. The three graphs are: the number of cases, 
                          the mortality rate, and the vaccination.",a(href="https://github.com/VincentLiu777/finalprojectinfo201", "You can learn more about the coding through 
                          our group’s github repository.")),
                    br(),
                    
                    p("Graph of Cases of Infection: The first dot on the graph represents the number of 
                          new cases in that region, where the second dot on the graph represents the total 
                          cases of the region. 
                          Graph of mortality rate: This graph computes the mortality rate for the specific 
                          region, the unit for this graph is in percent. 
                          Graph of vaccine: This graph shows the number of people that are fully vaccinated 
                          in the specific region. SInce the vaccine finally came out in around January 2021, 
                          please drag the timeline to the proper time period in order to examine the data.")),
                
                
                box(title = "About Us",width = NULL,status = "primary",solidHeader = TRUE, collapsible = TRUE, #collapsed = TRUE,
                    p("About the Author: The website was written by three students from University of Washington."), 
                    p("Anthony Zhang: A pre-major freshman at UW."),  
                    p("Vincent Liu: A pre-major freshman at UW."),   
                    p("Minhui He: A senior major in Math at UW. "),  
                    p("You can contact us by email: rliu8@uw.edu.")),
                
                
            ),
           
            column(width = 6,
                box(title = "Numbers of Cases",width = NULL,status = "primary",solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                    
                    plotlyOutput("cases_Plot")),
                
                box(title = "Mortality Rate",width = NULL,status = "primary",solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                    plotlyOutput("Mortality_Plot")), 
                
                box(title = "Vaccine",width = NULL,status = "primary",solidHeader = TRUE, collapsible = TRUE,collapsed = TRUE,
                    plotlyOutput("vac_Plot")),
                
                box(title = "Conclusion", width = NULL,status = "primary", solidHeader = TRUE, collapsible = TRUE, collapsed = TRUE,
                    p("Considering the confirm cases of COVID-19 worldwide, the total number of cases
                               increases rapidly initially and is then controlled regionally by countries. From
                               the plot, the monthly new cases of COVID-19 worldwide was stable at the point around
                               500,000. However, the situation start to get worse around 01/2021. Hypothetically,
                               this increment could caused by the aberrance of COVID-19."),
                    p("In the case of mortality rate, the world's mortality rate of COVID-19 reaches maximum at 08/2021. 
                               Areas with large number of confirmed cases of COVID(South America and Oceania) has raised the 
                               worldwide mortality rate significantly. Lately, around 03/2021, the worldwide mortality rate of 
                               COVID-19 start to stablize around 1.8. "))
            )
           
            
        
            
        )
    )
))


