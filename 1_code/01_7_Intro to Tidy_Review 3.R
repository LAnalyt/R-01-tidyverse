# INTRO TO TIDYVERSE: TYPE OF VISUALIZATION

# Install tidyverse if needed
if (!require("tidyverse")) install.packages("tidyverse")
# Load base packages manually
library(dplyr)      #transform data
library(ggplot2)    #visualizing data
library(gapminder)  #sample dataset

# SCATTERPLOT ####################################################

# Geometric layer for scatterplot: geom_point
ggplot(gapminder,      
       aes(x = lifeExp,     
           y = gdpPercap)) +
  geom_point()                 #to use dots for graph

# LINE PLOTS ####################################################

# Geometric layer for line plots: geom_line
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))
ggplot(by_year,        
       aes(x = year,     
           y = meanLifeExp)) +
       geom_line() +           #to use lines for graph
       expand_limits(y = 0)
# Summarize by two variables
year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(pop),
    medianLifeExp = median(lifeExp))
ggplot(year_continent,
       aes(x = year,
           y = totalPop,
           color = continent)) +
       geom_line() +
       expand_limits(y = 0)

# BAR PLOTS ######################################################

# Create bar plots with geom_col()
by_continent <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))
ggplot(by_continent,
  aes(x = continent,
           y = meanLifeExp)) +
  geom_col()

# HISTOGRAMS ####################################################

# A histogram is created with geom_histogram
gapminder_2007 <- gapminder %>%
  filter(year == 2007)
ggplot(gapminder_2007,
        aes(x = lifeExp)) +  # histograms have only one aesthetic
  geom_histogram()
# For population, e.g, you need to put x-axis on a log scale
ggplot(gapminder_2007,
       aes(x = pop)) +
  geom_histogram() +
  scale_x_log10()

# BOXPLOTS #####################################################

# Create a boxplot with geom_boxplot()
ggplot(gapminder_2007,
       aes(x = continent,
           y = lifeExp)) +
  geom_boxplot()
# Faceting the graph to look at the distribution by both continent and year
ggplot(gapminder,
       aes(x = continent,
           y = lifeExp)) +
  geom_boxplot() +
  facet_wrap(~ year)