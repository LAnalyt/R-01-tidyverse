# INTRO TO TIDYVERSE: DATA WRANGLING

# Install tidyverse if needed
if (!require("tidyverse")) install.packages("tidyverse")
# Load base packages manually
library(dplyr)      #transform data
library(ggplot2)    #visualizing data
library(gapminder)  #sample dataset

# Filter() for extracting a subset of observations
gapminder %>%
  filter(country == "China") #filter by country
gapminder %>%
  filter(year == 1957)       #filter by year
gapminder %>%
  filter(lifeExp > 80)       #filter by conditions
gapminder %>%
  filter(country == "Canada",
         year == 1962)       #filter by more conditions

# Arrange() for sorting observations
gapminder %>%
  arrange(lifeExp)           #sort in ascending order
gapminder %>%
  arrange(desc(lifeExp))     #sort in descending order

# Combining filter() and arrange()
gapminder %>%
  filter(yar == 1952) %>%
  arrange(desc(lifeExp))
# What are the lowest GDP countries with life expectancy above 80 in 2007?
gapminder %>%
  filter(year == 2007,
         lifeExp > 80) %>%
  arrange(gdpPercap)

# Mutate() for adding new varaibles (columns) to a dataset or changing existing variables
gapminder %>%
  mutate(pop = pop / 1000000)     #population in millions
gapminder %>%
  mutate(gdp = gdpPercap * pop)   #add dgp column

# Combine filter() and mutate()
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(gdp >= 10000000000)
# Combine arrange() with mutate()
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(desc(gdp))
# Combine filter(), arrange() and mutate()
gapminder %>%
  filter(year == 2007) %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(gdp)
# Find highest population countries in 2007 with a GDP less than 5 billion
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007,  gdp > 5000000000) %>%
  arrange(desc(pop))

# Summarize() for aggregating many observations into a summary
gapminder %>%
  summarize(meanLifeExp = mean(lifeExp)) #average lifeExp
# Name the new column in the summarized result before "="
gapminder %>%
  summarize(averageLifeExp = mean(lifeExp))
# Combine filter() with summarize()
gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp))
# Create multiple columns by putting multiple definitions in summarize() with commas
gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp),
            medianLifeExp = median(lifeExp))
# Find out total population of China in year 2007
gapminder %>%
  filter(year == 2007, country == "China") %>%
  summarize(totalPop = sum(pop))
# Compute the population of the smallest country, the median life expectancy and the highest GDP per capita in 2007
gapminder %>%
  filter(year == 2007) %>%
  summarize(minPop = min(pop),
            medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Group_by() tells summarize() to create one row for each group
gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop)) 
# Summarize by both continent and year
gapminder %>%
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))
# Combine filter() and group_by() 
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))