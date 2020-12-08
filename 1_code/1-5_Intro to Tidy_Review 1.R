# INTRO TO TIDYVERSE: REVIEW

# Install tidyverse if needed:
if (!require("tidyverse")) install.packages("tidyverse")
# Load base packages manually:
library(dplyr)      # transform data.
library(ggplot2)    # visualizing data.
library(gapminder)  # sample dataset.

# 1. Data wrangling ####
# filter() for extracting a subset of observations:
gapminder %>%
  filter(country == "China") # filter by country.
gapminder %>%
  filter(year == 1957)       # filter by year.
gapminder %>%
  filter(lifeExp > 80)       # filter by conditions.
gapminder %>%
  filter(country == "Canada",
         year == 1962)       # filter by more conditions.

# arrange() for sorting observations:
gapminder %>%
  arrange(lifeExp)           # sort in ascending order.
gapminder %>%
  arrange(desc(lifeExp))     # sort in descending order.

# Combining filter() and arrange():
gapminder %>%
  filter(year == 1952) %>%
  arrange(desc(lifeExp))
# What are the lowest GDP countries with life expectancy above 80 in 2007?
gapminder %>%
  filter(year == 2007,
         lifeExp > 80) %>%
  arrange(gdpPercap)

# mutate() for adding new variables (columns) to a data set or changing existing variables:
gapminder %>%
  mutate(pop = pop / 1000000)     # population in millions.
gapminder %>%
  mutate(gdp = gdpPercap * pop)   # add dgp column.

# Combine filter() and mutate():
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(gdp >= 10000000000)
# Combine arrange() with mutate():
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(desc(gdp))
# Combine filter(), arrange() and mutate():
gapminder %>%
  filter(year == 2007) %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(gdp)
# Find highest population countries in 2007 with a GDP less than 5 billion:
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007,  gdp > 5000000000) %>%
  arrange(desc(pop))

# summarize() for aggregating many observations into a summary:
gapminder %>%
  summarize(meanLifeExp = mean(lifeExp)) # average lifeExp
# Name the new column in the summarized result before "=":
gapminder %>%
  summarize(averageLifeExp = mean(lifeExp))
# Combine filter() with summarize():
gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp))
# Create multiple columns by putting multiple definitions in summarize() with commas:
gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp),
            medianLifeExp = median(lifeExp))
# Find out total population of China in year 2007:
gapminder %>%
  filter(year == 2007, country == "China") %>%
  summarize(totalPop = sum(pop))
# Compute the population of the smallest country, the median life expectancy and the highest GDP per capita in 2007:
gapminder %>%
  filter(year == 2007) %>%
  summarize(minPop = min(pop),
            medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# group_by() tells summarize() to create one row for each group.
gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop)) 
# Summarize by both continent and year:
gapminder %>%
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))
# Combine filter() and group_by(): 
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

# 2. Data visualization ####
# Visualize a subset of gapminder in 2007:
gapminder_2007 <- gapminder %>%
  filter(year == 2007) 

# There are 3 parts to a ggplot2 graph: data, aesthetics and geometric layer.
ggplot(gapminder_2007,             # data.
       aes(lifeExp, gdpPercap)) +  # aesthetics.
  geom_point()                     # geometric layer.
# Switch axes
ggplot(gapminder_2007,        
       aes(gdpPercap, lifeExp)) +
  geom_point()                

# With gdpPercap as an axis, it's hard to understand because most points are crammed into a small part of the graph. Variables like gdpPercap are better communicated on a log scale, where each fixed distance represents a multiplication of the value.
ggplot(gapminder_2007,
       aes(gdpPercap, lifeExp)) +
  geom_point() +
  scale_x_log10()
# Putting population on a log scale spreads the points out more. To put the y-axis on a log scale, use scale_y_log(10):
ggplot(gapminder_2007,
       aes(lifeExp, pop)) +
  geom_point() +
  scale_y_log10()
# In some cases you might want to put both the x- and y-axes on a log scale.
ggplot(gapminder_2007, 
       aes(pop, gdpPercap)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

# Choose a variable to represent with color: 
ggplot(gapminder_2007,
       aes(gdpPercap, lifeExp, 
           color = continent)) +
  geom_point() +
  scale_x_log10()     # ggplot2 automatically adds a legend.

# Another aesthetic is size which is great for representing numeric variables:
ggplot(gapminder_2007,
       aes(gdpPercap, lifeExp, 
           color = continent,
           size = pop)) + 
  geom_point() +
  scale_x_log10()

# ggplot2 supports faceting: dividing the graph into one small sub-graph for each continent.
ggplot(gapminder_2007,
       aes(gdpPercap, lifeExp,
           size = pop)) +
  geom_point() +
  facet_wrap(~continent)
# Graph the full gapminder data and facet on year, which lists the graph communicate changes over time:
ggplot(gapminder,
       aes(gdpPercap, lifeExp,
           color = continent,
           size = pop)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~year)   # people has lived longer since 1952.

# 3. Types of visualization ####

## Line plots ####
# Geometric layer for line plots: geom_line
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))
ggplot(by_year,        
       aes(year, meanLifeExp)) +
  geom_line() +            # to use lines for graph
  expand_limits(y = 0)
# Summarize by two variables:
year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(pop),
            medianLifeExp = median(lifeExp))
ggplot(year_continent,
       aes(year, totalPop,
           color = continent)) +
  geom_line() +
  expand_limits(y = 0)

## Bar plots ####
# Create bar plots with geom_col():
by_continent <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))
ggplot(by_continent,
       aes(continent, meanLifeExp)) +
  geom_col()

## Histograms ####

# A histogram is created with geom_histogram.
gapminder_2007 <- gapminder %>%
  filter(year == 2007)
ggplot(gapminder_2007,
       aes(lifeExp)) +  # histograms have only one aesthetic.
  geom_histogram()
# For population, e.g, you need to put x-axis on a log scale.
ggplot(gapminder_2007,
       aes(pop)) +
  geom_histogram() +
  scale_x_log10()

## Boxplots ####
# Create a boxplot with geom_boxplot():
ggplot(gapminder_2007,
       aes(continent, lifeExp)) +
  geom_boxplot()
# Faceting the graph to look at the distribution by both continent and year:
ggplot(gapminder,
       aes(continent, lifeExp)) +
  geom_boxplot() +
  facet_wrap(~ year)