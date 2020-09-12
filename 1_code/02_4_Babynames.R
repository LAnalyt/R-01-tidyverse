# 4. CASE STUDY: BABY NAMES

# Load tidyverse
library(tidyverse) 
# Load the Babynames dataset
babynames <- readRDS("babynames.rds") # represent the names of babies born in the US each year.
# Examine the dataset
glimpse(babynames)

# Find the frequency of a name in each year
babynames_filtered <- babynames %>%
  filter(name == "Amy")
# Use ggplot2 to generate a plot for the filtered name
ggplot(babynames_filtered, aes(x = year, y = number)) +
  geom_line() 
# The plot shows many baies born in the 70s and 80s were  named "Amy", but relatively few today.

# Filter for multiple names 
babynames_multiple <- babynames %>%
  filter(name %in% c("Amy", "Christopher"))
# Visualize these names as a line plot over time
ggplot(babynames_multiple, aes(x = year, y = number, color = name))                          + geom_line()

# Filter and arrange for one year
babynames %>%
  filter(year == 1990) %>%
  arrange(desc(number))

# Find the most common names in one year
babynames %>%
  group_by(year) %>%
  top_n(1, number)

# Filter for the names Steven, Thomas, and Matthew
selected_names <- babynames %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))
# Visualize the names over time
ggplot(selected_names, aes(x = year, y = number, color = name)) +                         geom_line() 
# A different total of number of babies are born in each year, and what we're interested in is what percentage of people born in that year have that name.
# First calculate how many people were born in each year
babynames <- babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  # ungroup() when you're done with the groups
  ungroup() %>%
  # calculate the fraction of people born in each year that have each name
  mutate(fraction = number/year_total)
# Graph again the 3 names but use fraction instead of number
ggplot(selected_names, aes(x = year, y = fraction, color = name)) + geom_line()
# The graph looks different, because the dataset inluces relatively few babies from 1800s and early 1900s

# Adding the total and maximum for each name
babynames %>%
  group_by(name) %>%
  mutate(name_total = sum(number), name_max = max(number)) %>%
  ungroup() %>%
  mutate(fraction_max = number/name_max)