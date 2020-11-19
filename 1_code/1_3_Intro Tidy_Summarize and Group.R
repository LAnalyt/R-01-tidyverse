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
# Combine verbs to specify the median life expectancy in one year:
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp)) 
# Summarize multiple variables:
gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# 3.2 Group_by ####

# Use group_by() before summarize() will summarize within group instead of summarizing the entire data set. 
# Summarize by year:
gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))
# Summarize by continent:
gapminder %>%
  filter(year == 1957) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))
# Summarize by multiple variables:
gapminder %>%
  group_by(year, continent) %>%
  summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# 3. Visualizing summarized data ####

# Turn the summarized data into informative graphics using ggplot2:
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))
# Create a scatter plot showing the change in medianLifeExp over time:
ggplot(by_year, aes(x = year, y = medianLifeExp)) + 
  geom_point() + 
  expand_limits(y = 0)
# Summarize medianGdpPercap within each continent within each year:
by_year_continent <- gapminder %>% 
  group_by(year, continent) %>% 
  summarize(medianGdpPercap = median(gdpPercap))
# Plot the change in medianGdpPercap in each continent over time:
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap), color = continent) + 
  geom_point() + 
  expand_limits(y = 0)
# Summarize the median GDP and median life expectancy per continent in 2007:
by_continent_2007 <- gapminder %>% 
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), medianGdpPercap = median(gdpPercap))
# Use a scatter plot to compare the median GDP and median life expectancy:
ggplot(by_continent_2007, aes(x = medianGdpPercap, y = medianLifeExp, color = continent)) + 
  geom_point()