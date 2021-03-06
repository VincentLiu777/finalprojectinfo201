library(shiny)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(tidyverse)
library(scales)
library(plotly)
library(shinydashboard)
library(fresh)

covidData <- read.csv("owid-covid-data (1).csv")

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

