# 4. CASE STUDY: BABY NAMES

# 4.1 The babynames dataset #### 
# Load tidyverse:
library(tidyverse) 
# Load the Babynames dataset:
babynames <- readRDS("babynames.rds") # represent the names of babies born in the US each year.
# Examine the data set:
glimpse(babynames)

# Find the frequency of a name in each year:
babynames_filtered <- babynames %>%
  filter(name == "Amy")
# Use ggplot2 to generate a plot for the filtered name:
ggplot(babynames_filtered, 
       aes(year, number)) +
  geom_line() 
# The plot shows many babies born in the 70s and 80s were named "Amy", but relatively few today.

# Filter for multiple names:
babynames_multiple <- babynames %>%
  filter(name %in% c("Amy", "Christopher"))
# Visualize these names as a line plot over time:
ggplot(babynames_multiple, 
       aes(year, number, 
           color = name)) +
  geom_line()

# Filter and arrange for one year:
babynames %>%
  filter(year == 1990) %>%
  arrange(desc(number))

# Find the most common names in one year:
babynames %>%
  group_by(year) %>%
  top_n(1, number)

# 4.2 Grouped mutates ####
# Filter for the names Steven, Thomas, and Matthew:
selected_names <- babynames %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))
# Visualize the names over time:
ggplot(selected_names, 
       aes(year, number, 
           color = name)) + 
  geom_line() 
# A different total of number of babies are born in each year, and what we're interested in is what percentage of people born in that year have that name. To calculate that, you have to use grouped mutate.
babynames_fraction <- babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  # ungroup() when you're done with the groups
  ungroup() %>%
  # calculate the fraction of people born in each year that have each name.
  mutate(fraction = number/year_total)
# Filter the three names again:
selected_names <- babynames_fraction %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))
# Graph again the 3 names but use fraction instead of number:
ggplot(selected_names, 
       aes(year, fraction, 
           color = name)) + 
  geom_line()
# The graph looks different, because the dataset includes relatively few babies from 1800s and early 1900s.

# Pick a few names and calculate each of them as a fraction of their peak. This is a type of "normalizing" a name, where you're focused on the relative change within each name rather than the overall popularity of the name.
names_normalized <- babynames %>%
  group_by(name) %>%
  mutate(name_total = sum(number),
         name_max = max(number)) %>%
  ungroup() %>%
  mutate(fraction_max = number / name_max)
# Filter for the names Steven, Thomas, and Matthew:
names_filtered <- names_normalized %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))
# Visualize these names over time:
ggplot(names_filtered, 
      aes(year, fraction_max, 
          color = name)) + 
  geom_line() # the line for each name hits a peak at 1, although the peak year differs for each name.

# 4.3 lag() function ####
# You've discovered a few names that have gone through major changes over time. But what if you want to look at the biggest changes within each name? To do this, you have to find differences between each pair of consecutive years with the lag function of the dplyr.
# lag(): takes a vector and returns another of the same length. E.g:
v <- c(1, 3, 6, 14)
lag(v) # move each item to the right by one.
# By lining up each item in the vector with the item directly before it, we can compare consecutive steps and calculate the changes.

# Find the changes in the popularity of the name "Matthew" in consecutive years:
babynames_fraction %>% 
  filter(name == "Matthew") %>%
  arrange(year) %>%
  mutate(difference = fraction - lag(fraction)) %>%
  arrange(desc(difference))
# The first observation is missing a difference, because there is no previous year. After that we can see whether the popularity of "Matthew" goes up or down. By arranging the table in descending order in the difference, we could see the biggest jump in popularity is in 1975 and 1970.

# Find the changes in the popularity of every name using grouped mutate:
babynames_fraction %>%
  arrange(name, year) %>%
  mutate(difference = fraction - lag(fraction)) %>%
  group_by(name) %>%
  arrange(desc(difference))
# Using ratios to describe the frequency of a name:
babynames_ratios <- babynames_fraction %>%
  arrange(name, year) %>%
  group_by(name) %>%
  mutate(ratio = fraction/lag(fraction))
# Look further into the names that experienced the biggest jumps in popularity in consecutive years:
babynames_ratios %>%
  top_n(1, ratio) %>%
  arrange(desc(ratio)) %>%
  filter(fraction >= 0.001)
# The jump in 1885 of "Grover" can be explained: Grover Cleveland was a president elected in 1884. 