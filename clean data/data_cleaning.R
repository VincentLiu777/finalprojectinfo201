covidData <- read.csv("raw data/owid-covid-data.csv")

covidData[is.na(covidData)] = 0

library(dplyr)

dataSummary_Cont <- covidData %>% 
  group_by(continent) %>% 
  summarise(newCasesByContinent = mean(new_cases), 
            newDeathByContinent = mean(new_deaths),
            newCasePerMillionBYContinent = mean(new_cases_per_million))
            
            
            
dataSummary1 <- covidData %>% 
  group_by(location) %>% 
  summarise(newCasesByCountry = mean(new_cases),
            newDeathByCountry = mean(new_deaths),
            newCasePerMillionBYCountry = mean(new_cases_per_million))
