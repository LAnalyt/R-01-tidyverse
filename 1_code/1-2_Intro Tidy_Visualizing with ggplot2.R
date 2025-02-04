# 2 VISUALIZING WITH GGPLOT2

# 2.1 Create a scatter plot ####

# Loading the gapminder, dplyr and ggplot2 packages:
library(gapminder) # tracks economic and social indicators of countries over time.
library(dplyr) # provides step-by-step to transform data.
library(ggplot2)# create elegant data visualizations using the grammar of graphics.
# Create a subset for observations in the year 1952:
gapminder_1952 <- gapminder %>% 
  filter(year == 1952)
# Create a scatter plot to compare population and GDP per capita:
ggplot(gapminder_1952, 
       aes(pop, gdpPercap)) +
  geom_point() 
# gapminder_1952: the data used to plot.
# aesthetic mapping aes(x, y): visual dimension of the graph.
# "+": adding a layer to the graph.
# geom_point(): geometric object, in this case "point" is the scatter plot where each observations correspond to one point.
# Together, 3 pars of the code (data, aesthetic mapping, and layer) construct the scatter plot.

# Create another scatter plot to compare population and life expectancy:
ggplot(gapminder_1952, 
       aes(pop, lifeExp)) + 
  geom_point() 

# 2.2 Log scales ####

# Since population is spread over several orders of magnitude, with some countries having a much higher population than others, it's useful to work with on a logarithmic scale - a scale where each fixed distance represents a multiplication of the value.
ggplot(gapminder_1952, 
       aes(pop, lifeExp)) + 
  geom_point() + 
  scale_x_log10() # same data, but each unit on the x-axis represents a change of 10 times the population.
# Both population and GDP per-capita are better represented with log scales, since they vary over many orders of magnitude, so the scatter plot for them could us log-scale on both x and y axes
ggplot(gapminder_1952, 
       aes(pop, gdpPercap)) +
  geom_point() + 
  scale_x_log10() + 
  scale_y_log10()
# Notice the points are more spread out on the x-axis. This makes it easy to see that there isn't a correlation between population and life expectancy.

# 2.3 Additional aesthetics ####

# Add more aesthetics - color and size to communicate even more information in the scatter plot:
ggplot(gapminder_1952, 
       aes(pop, lifeExp, 
           color = continent)) + 
  geom_point() + 
  scale_x_log10()
# Add size aesthetic to represent a country's gdpPercap:
ggplot(gapminder_1952, 
       aes(pop, lifeExp, 
           color = continent, 
           size = gdpPercap)) + 
  geom_point() +
  scale_x_log10()

# 2.4 Faceting ####

# Another way of exploring data in terms of categorical variables is dividing the plot into subplots to get one smaller graph for each continent. This is called faceting, another powerful way to communicate relationship within your data.
ggplot(gapminder_1952, 
       aes(pop, lifeExp)) + 
  geom_point() + 
  scale_x_log10() + 
  facet_wrap(~ continent) # "~" typically means "by", meaning that we split the plot by continent. This tells ggplot2 to divide the data into subplots based on the continent variable.
# Faceting by year:
ggplot(gapminder, 
       aes(gdpPercap, lifeExp, 
                      color = continent, 
                      size = pop)) + 
  geom_point() +
  scale_x_log10() +
  facet_wrap(~year)