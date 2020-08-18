# 2. AGGREGRATING DATA ####

# Agrregrating data is a common data science strategy for making datasets manageable and interpretable.
# Load tidyverse including the dplyr package
library(tidyverse) 
# Import the counties dataset in form of .rds file in 0_data
counties <- readRDS("counties.rds") # 2015 US Census.

# count() ####
# Find out the number of observations
counties %>%
  count() # the result is one-row table, with one column called n.
# Count the number of counties in each state
counties %>%
  count(state)
# Count and sort
counties %>%
  count(state, sort = TRUE)
# When we add up counties, we want to weigh each of them differently, e.g, by population.
counties %>% 
  select(state, county, population) %>%
  count(state, wt = population, sort = TRUE)

# Counting by region
counties_selected <- counties %>%
  select(region, state, population, citizens, unemployment)
counties_selected %>%
  count(region, sort = TRUE)
# Counting citizens by state
counties_selected %>%
  count(state, wt = citizens, sort = TRUE)

# Combine mutate() and count() ####
# What are the US states where the most people walk to work?
counties %>%
  select(region, state, population, walk) %>% # walk: % people who walk to work. 
  mutate(population_walk = walk * population/100) %>%
  count(state, wt = population_walk, sort = TRUE)

# count() is a special case of a more general set of verbs: group by and summarize.

# summarize() ####
# takes many observations and turns them into one observation. E.g, find the population of the US
counties %>%
  summarize(total_pop = sum(population))
# Aggregrate and summarize
counties %>%
  summarize(total_pop = sum(population),
            average_unemployment = mean(unemployment))
# Summary functions ####
# sum(): total number
# mean(): average value
# median(): middle value
# min(): minimum value
# max(): maximum value
# n(): size of the group
# Combine the summary funtions with summarize() verb
counties %>%
  summarize(min_pop = min(population), max_unemploy = max(unemployment), average_income = mean(income))

# group_by() ####
# aggregrate within group, e.g, to find the population within each state
counties %>%
  group_by(state) %>%
  summarize(total_pop = sum(population))

# arrange() ####
# It's useful to add an additional step of an arrange(), so that we can focus on the most notable examples 
counties %>%
  group_by(state) %>%
  summarize(total_pop = sum(population),
            average_unemployment = mean(unemployment)) %>%
  arrange(desc(average_unemployment))

# Group by multiple column at the same time
counties %>%
  select(state, metro, county, population) %>%
  group_by(state, metro) %>%
  summarize(total_pop = sum(population))
# Finding the density (in people per square meter)
counties %>%
  select(state, county, land_area, population) %>%
  group_by(state) %>%
  summarize(total_pop = sum(population), 
            total_land = sum(land_area)) %>%
  mutate(density = total_pop/total_land) %>%
  arrange(desc(density))
# Summarizing by state and region
counties %>%
  group_by(region, state) %>%
  summarize(total_pop = sum(population)) %>%
  summarize(average_pop = mean(total_pop),
            median_pop = median(total_pop))

# top_n() ###  
# What if instead of aggregrating each state, you only want to find the largest county in each state? Top_n() in Dplyr is very useful for keeping the most extreme observations from each group.
counties_selected %>%
  group_by(state) %>%
  top_n(1, population) # find the county with highest population in each state.
# Put any number as the first argument in top_n() and get that many counties from each state.
counties_selected %>%
  group_by(state) %>%
  top_n(3, unemployment)
# Find the highest-income state in each region
counties %>%
  select(region, state, county, population, income) %>%
  group_by(region, state) %>%
  summarize(average_income = mean(income)) %>%
  top_n(1, average_income)

# ungroup() ####
# ungroup the observations that are grouped by group_by()
# In how many states do more people live in metro areas than non-metro areas?
counties %>%
  select(state, metro, population) %>%
  group_by(state, metro) %>%
  summarize(total_pop = sum(population)) %>%
  top_n(1, total_pop) %>%
  ungroup() %>%
  count(metro)