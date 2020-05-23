#1 DATA WRANGLING 

#1.1 Gapminder R ####

#Loading the gapminder and dplyr packages
library(gapminder) #tracks economic and social indicators of countries over time
library(dplyr) #provides step-by-step to transform data
#If the message shows the pacakage is missing, you need to install them first with install.package("") 
#Have a first look at the dataset gapminder
gapminder #1704 observations (rows), 6 variables (columns)

#1.2 Filter ####

#The filter verb extracts particular observations based on a condition. Filter is a common first step in data analysis.
#Every time you apply a verb in dplyr, use a pipe (%>%), takes whatever before it and feeds it to the next step.
#E.g, filter the gapminder dataset for the year 1957
gapminder %>% 
  filter(year == 1957) #"==": logical equal
#Or, filter for the result of a single country
gapminder %>%
  filter(country == "United States") #characters must be in "..." format
#You can also filter with more conditions, separate by ","
gapminder %>%
  filter(year == 2002, country == "China") 

#1.3 Arrange ####

#The arrange verb sorts the observations in the dataset in the ascending or descending order. This is useful, e.g when you want to know the most extreme value in your dataset.
#E.g, sort in the ascending order of GDP per capital 
gapminder %>%
  arrange(gdpPercap) #Congo has the least GDP per capital
#By default it's ascending order
#Sort in descending order of GDP per capital 
gapminder %>%
  arrange(desc(gdpPercap)) #Kuwait hast the most 
#Sort in the ascending order of life expectancy (lifeExp)
gapminder %>%
  arrange(lifeExp) #Rwanda 
#Sort in descending order
gapminder %>%
  arrange(desc(lifeExp)) #Japan
#Just like "filter", the gapminder object itself doesn't change, "arrange" just gives a new sorted dataset.
#Combine filter() with arrange() to find the highest population countries in a particular year.
gapminder %>% 
  filter(year == 1957) %>%
  arrange(desc(pop)) #of course, China is on top!
#Or which country has the highest GDP per capital in 2007?
gapminder %>%
  filter(year == 2007) %>%
  arrange(desc(gdpPercap)) #Norway

#1.3 Mutate ####

#The mutate verb allows to change an existing variable or adding a new one based on the other ones.
#E.g, calculate population per million
gapminder %>%
  mutate(pop = pop / 1000000) #the value in pop column is much smaller now
#Inside the mutate(), the left side is what is being replaced, the right side is what being calculated.
#This is how you manipulate existing variables in data processing and cleaning.
#Find out the GDP and add it as a new variable
gapminder %>%
  mutate(gdp = gdpPercap * pop) 
#Use mutate to change lifeExp to be in months
gapminder %>%
  mutate(lifeExp = 12 * lifeExp) #values in lifeExp change
#Use mutate to create a new column called lifeExpMonths
gapminder %>%
  mutate(lifeExpMonths = 12 * lifeExp) 
#Combing verbs to find the countries with the highest life expectancy, in months, in a particular year
gapminder %>%
  mutate(lifeExpMonths = 12 * lifeExp) %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExpMonths)) #Japan again, of course
#Which country has the highest GDP in the same year?
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007) %>%
  arrange(desc(gdp)) #United States
