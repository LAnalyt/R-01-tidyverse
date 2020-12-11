# 3. SELECTING AND TRANSFORMING DATA

# Load dplyr and the county dataset.
library(dplyr) 
counties <- readRDS("counties.rds")
# Examine all the variables in the counties table:
glimpse(counties)

# 3.1 Select a range ####
# There are many variables in the counties dataset, and often you only need to work with a subset of them.
# E.g, if we're interested in knowing how people get to work, select related columns. The colon ":" is useful for getting many consecutive columns at a time.
counties %>%
  select(state, county, drive:work_at_home) %>%
  arrange(drive)
# By selecting and arranging these columns, we can find out that cities where the fewest people drive to work are a few regions in Alaska and in New York city. By focusing on this part of the data, we can see interesting insights like people in New York mostly take transit to work, while the small parts of Alaska mostly walk.
# Select industry-related variables:
counties %>%
  select(state, county, population, professional:production) %>%
  # Arrange service in descending order to find which counties have the highest rates of working in the service industry
  arrange(desc(service))

# 3.3 Select helpers ####
# Select helpers are functions that specify criteria for choosing columns. 
# contains(): takes strings and result the columns that contain a set of certain characters.
counties %>%
  select(state, county, contains("work")) 
# starts_with: select only the columns that start with a particular prefix.
counties %>%
  select(state, county, starts_with("income"))
# ends_with(): finds columns that end with a particular string.
counties %>%
  select(state, county, population, ends_with("work")) %>%
# Filter just for the counties where at least 50% of the population is engaged in public work:
  filter(public_work >= 50)
# For more select helpers:
?select_helpers

# 3.3 Remove variables ####
# Remove a variable with the minus symbol:
counties %>%
  select(-census_id)

# 3.4 Rename variables ####
# Rename the unemployment column to unemployment_rate:
counties %>%
  select(state, county, unemployment) %>%
  rename(unemployment_rate = unemployment)
# Or use select() with rename argument:
counties %>%
  select(state, county, unemployment_rate = unemployment)
# The difference is in select() you need to keep along all other columns, with rename() you can just pick one column.
# The rename verb is often useful for changing the name of a column that comes out of another verb, such as count().
counties %>%
  count(state) %>%
  rename(num_counties = n)

# 3.5 transmute() ####
# transmute() is a combination of select() and mutate() to get a subset of the columns and transform and change them at the same time. E.g, select and calculate a fraction of the population that made up of men:
counties %>%
  transmute(state, county, fraction_men = men/population) # saves some effort comparing to using both mutate() and select().
# Use transmute() to control which variables to keep, which variables to calculate, and which variables to drop.
counties %>%
  transmute(state, county, population, density = population/land_area) %>%
  filter(population > 1000000) %>%
  arrange(density) # looks like San Bernadino is the lowest density county with a population about one million. 

# Choose among the 4 verbs:
counties %>% # change the name a column.
  rename(unemployment_rate = unemployment)
counties %>% # select and keep columns.
  select(state, county, contains("poverty"))
counties %>% # calculate a column without dropping the other columns.
  mutate(fraction_women = women / population)
counties %>% # select and calculate columns.
  transmute(state, county, employment_rate = employed / population)