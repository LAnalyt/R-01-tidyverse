# 3 GROUPING AND SUMMARIZING

# Loading the gapminder, dplyr and ggplot2 packages:
library(gapminder) # tracks economic and social indicators of countries over time.
library(dplyr) # provides step-by-step to transform data.
library(ggplot2)# create elegant data visualizations using the grammar of graphics.

# 3.1 Summarize ####

# summarize() turns many rows into one row.
# Functions that can be used with summarize():
# mean(): returns the average value.
# sum(): returns the total value.
# median(): returns the middle value.
# min(): returns the minimum value.
# max(): returns the maximum value.

# Find out the median life expectancy in Gapminder:
gapminder %>% 
  summarize(medianLifeExp = median(lifeExp)) 
# Rather than summarizing the entire dataset, you may want to find the median life expectancy for only one particular year. Combine verbs to specify the median life expectancy in one year:
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp)) 
# Summarize multiple variables:
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))

# 3.2 Group_by ####

# Use group_by() before summarize() will summarize within group instead of summarizing the entire data set. 
# Summarize by year:
gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))
# Summarize by continent:
gapminder %>%
  filter(year == 1957) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))
# Summarize by multiple variables:
gapminder %>%
  group_by(year, continent) %>%
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))

# 3. Visualizing summarized data ####

# Instead of viewing the summarized data as a table, save it as an object so we can visualize it later: 
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(totalPop = sum(pop),
            meanLifePop = sum(pop))
# Turn the summarized data into informative graphics using ggplot2:
ggplot(by_year, aes(year, totalPop)) + 
  geom_point()
# The resulting graph of population by year shows the change in the total population which is going up over time. The graph is, however, a little misleading because it doesn't include zero. Specify the y-axis starts at zero by adding the graphing layer expand_limits:
ggplot(by_year, aes(year, totalPop)) + 
  geom_point() +
  expand_limits(y = 0) # population is almost tripling!
# Create another graph of the average life expectancy over time:
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp))
ggplot(by_year, aes(year, meanLifeExp)) + 
  geom_point() + 
  expand_limits(y = 0)

# Now we want to see the changes in population separately within each continent. 
by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(pop))
# Separate the visualization the data over time within each continent by color aesthetics:
ggplot(by_year_continent, aes(year, totalPop, 
                              color = continent)) +
  geom_point() +
  expand_limits(y = 0)
# This shows 5 separate trends on the same graph. We can see Asia was always the most populated continent and has been growing the most rapidly. 

# Summarize medianGdpPercap within each continent within each year:
by_year_continent <- gapminder %>% 
  group_by(year, continent) %>% 
  summarize(medianGdpPercap = median(gdpPercap))
# Plot the change in medianGdpPercap in each continent over time:
ggplot(by_year_continent, aes(year, medianGdpPercap), 
       color = continent) + 
  geom_point() + 
  expand_limits(y = 0)

# Comparing median life expectancy and median GDP per continent in 2007:
by_continent_2007 <- gapminder %>% 
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), 
            medianGdpPercap = median(gdpPercap))
# Use a scatter plot to compare the median GDP and median life expectancy:
ggplot(by_continent_2007, aes(medianGdpPercap, medianLifeExp, 
                              color = continent)) + 
  geom_point()