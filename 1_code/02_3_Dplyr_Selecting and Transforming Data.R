# 3. SELECTING AND TRANSFORMING DATA

# There are many variables in the counties dataset, and often you only need to work with a subset of them.
library(tidyverse) 
counties <- readRDS("counties.rds")
# Examine all the variables in the counties table
glimpse(counties)

# Select a range ####
# E.g, if we're interested in knowing how people get to work, select related columns. The colon is useful for getting many columns at a time
counties %>%
  select(state, county, drive:work_at_home) %>%
  arrange(drive)
# Select industry-related variables
counties %>%
  select(state, county, population, professional:production) %>%
  # Arrange service in descending order to find which counties have the highest rates of working in the service industry
  arrange(desc(service))

# Select helpers ####
# Select helpers are functions that specify criteria for choosing columns. Contains()) takes strings and result the columns that contain a set of certain characters.
counties %>%
  select(state, county, contains("work")) #
# starts_with: select only the columns that start with a particular prefix
counties %>%
  select(state, county, starts_with("income"))
# ends_with(): finds columns that end with a particular string
counties %>%
  select(state, county, population, ends_with("work")) %>%
  # filter just for the counties where at least 50% of the population is engaged in public work
  filter(public_work >= 50)
# For more select helpers
?select_helpers

# Removing a variable ####
counties %>%
  select(-census_id)

# rename() ####
# Rename the unemploymen column to unemployment_rate
counties %>%
  select(state, county, unemployment) %>%
  rename(unemployment_rate = unemployment)
# Or use select() with rename argument
counties %>%
  select(state, county, unemployment_rate = unemployment)
# The rename() verb is often useful for changing the name of a column that comes out of another verb, such as count()
counties %>%
  count(state) %>%
  rename(num_counties = n)

# transmute() ####
# transmute() is a combination of select() and mutate() to get a subset of the columns and transform and change them at the same time. E.g, select andd calculate a fraction of the population that made up of men.
counties %>%
  transmute(state, county, frachtion_men = men/population) # saves some effort comparing to using both mutate() and select().
# Use transmute() to control which variables to keep, which variables to calculate, and which variables to drop
counties %>%
  transmute(state, county, population, density = population/land_area) %>%
  filter(population > 1000000) %>%
  arrange(density)