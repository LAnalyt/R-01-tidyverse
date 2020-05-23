# INTRO TO TIDYVERSE: DATA VISUALIZATION

# Install tidyverse if needed
if (!require("tidyverse")) install.packages("tidyverse")
# Load base packages manually
library(dplyr)      #transform data
library(ggplot2)    #visualizing data
library(gapminder)  #sample dataset

# Visualize a subset of gapminder in 2007
gapminder_2007 <- gapminder %>%
  filter(year == 2007) 

# There are 3 parts to a ggplot2 graph: data, aesthtics and geometric layer
ggplot(gapminder_2007,        #data
       aes(x = lifeExp,       #aesthetics
           y = gdpPercap)) +
  geom_point()                #geometric layer
# Switch axes
ggplot(gapminder_2007,        #data
       aes(x = gdpPercap,     #aesthetics
           y = lifeExp)) +
  geom_point()                #geometric layer

# With gdpPercap as an axis, it's hard to understand because most points are crammed into a small part of the graph. Variables like gdpPercap are better communicated on a log scale, where each fixed distance represent a multiplication of the value
ggplot(gapminder_2007,
       aes(x = gdpPercap,
           y = lifeExp)) +
  geom_point() +
  scale_x_log10()
# Putting population on a log scale spreads the points out more. To put the y-axis on a log scale, use scale_y_log(10)
ggplot(gapminder_2007,
       aes(x = lifeExp,
           y = pop)) +
  geom_point() +
  scale_y_log10()
# In some cases you might want to put both the x- and y-axes on a log scale
ggplot(gapminder_2007, 
       aes(x = pop,
           y = gdpPercap)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10()

# Choose a variable to represent with color 
ggplot(gapminder_2007,
       aes(x = gdpPercap,
           y = lifeExp, 
           color = continent)) +
  geom_point() +
  scale_x_log10()     #ggplot2 automatically adds a legend.

# Another aesthetic is size which is great for representing numeric variables
ggplot(gapminder_2007,
       aes(x = gdpPercap,
           y = lifeExp, 
           color = continent,
           size = pop)) + 
  geom_point() +
  scale_x_log10()

# ggplot2 supports faceting: dividing the graph into one small sub-graph for each continent
ggplot(gapminder_2007,
       aes(x = gdpPercap,
           y = lifeExp,
           size = pop)) +
  geom_point() +
  facet_wrap(~continent)
# Graph the full gapminder data and facet on year, which lests the graph communicate changes over time
ggplot(gapminder,
       aes(x = gdpPercap,
       y = lifeExp,
       color = continent,
       size = pop)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~year)   #people has lived longer since 1952.
