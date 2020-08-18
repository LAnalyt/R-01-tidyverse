# 1. TRANSFORMING DATA WITH DPLYR

# The Counties dataset ####

# Load tidyverse including the dplyr package
library(tidyverse) 
# Import the counties dataset in form of .rds file in 0_data
counties <- readRDS("counties.rds") # 2015 US Census.
# This is a big dataset. See a few values from all the columns:
glimpse(counties)

# select() #### 
# extracts only a few variables from the dataset.
counties %>%
  select(state, county, population, unemployment)
# Create a new table for the selection
counties_selected <- counties %>%
  select(state, county, population, unemployment)

# The observations are now in alphabetical order by state and county. We might be interested in the counties that have the highest population.
# arrange() ####
# sort the data based on one or more variables
counties_selected %>%
  arrange(population)
# add desc() to sort the counties with the highest population first
counties_selected %>%
  arrange(desc(population))

# filter() #### 
# extract only particular observations from a dataset, based on a condition. E.g, filter only the counties of the state New York
counties_selected %>%
  arrange(desc(population)) %>%
  filter(state == "New York")
# filter based on logical operators
counties_selected %>%
  arrange(desc(population)) %>%
  filter(unemployment < 6)
# Combine multiple conditions in a filter
counties_selected %>%
  arrange(desc(population)) %>%
  filter(state == "New York", unemployment <6)

# Select some more interesting variables
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, unemployment)
# Sort the observations of the public_work variable in descending order.
counties_selected %>% arrange(desc(public_work))
# Filter for counties in the state of California that have a population above 1000000
counties_selected %>%
  filter(state == "California", population > 1000000)
# Filter for Texas and more than 10000 people; sort in descending order of private_work
counties_selected %>%
  filter(state == "Texas", population > 10000) %>%
  arrange(desc(private_work))

# mutate() ####
# Datasets don't usually have all the variables you neen. Mutate() adds new variables or change exisiting variables
# The unemployment variable is in percentage form. What if you're interested in the total number of unemployed rather than as a percentage of the population?
counties_selected %>%
  mutate(unemployed_population = population * unemployment/100)
# What county has the highest number of unemployed people?
counties_selected %>%
  mutate(unemployed_population = population * unemployment/100) %>%
  arrange(desc(unemployed_population))
# Calculating the percentage of women in a county
counties %>% 
  select(state, county, population, men, women) %>%
  mutate(proportion_women = women/population * 100)