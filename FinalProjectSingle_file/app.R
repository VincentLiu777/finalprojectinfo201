library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)
library(scales)
library(plotly)
library(shiny.router)


source("data_clean.R")

home_page <- div(
    titlePanel("Dashboard"),
    p("This is a dashboard page")
    
)
settings_page <- div(
    titlePanel("Settings"),
    p("This is a settings page")
)
contact_page <- div(
    titlePanel("Contact"),
    p("This is a contact page")
)

router <- make_router(
    route("/", home_page),
    route("settings", settings_page),
    route("contact", contact_page)
)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    theme = "main.css",
    tags$ul(
        tags$li(a(href = route_link("/"), "Dashboard")),
        tags$li(a(href = route_link("settings"), "Settings")),
        tags$li(a(href = route_link("contact"), "Contact"))
    ),
    router$ui,
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
                         img(src='Coronavirus-CDC-645x645.jpg', align = "left"),
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
                tabPanel("About Us",
                         p("About the Author: The website was written by three students from University of Washington."), 
                         p("Anthony Zhang: A pre-major freshman at UW."),  
                         p("Vincent Liu: A pre-major freshman at UW."),   
                         p("Minhui He: A senior major in Math at UW. "),  
                         p("You can contact us by email: rliu8@uw.edu.")),   
                tabPanel("Numbers of Cases",
                         plotlyOutput("cases_Plot")),
                tabPanel("Mortality Rate",
                         plotlyOutput("Mortality_Plot")), 
                tabPanel("Vaccine",
                         plotlyOutput("vac_Plot")),
                tabPanel("Conclusion", 
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
    )))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output, session) {
    router$server(input, output, session)
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

# Run the application 
shinyApp(ui = ui, server = server)
