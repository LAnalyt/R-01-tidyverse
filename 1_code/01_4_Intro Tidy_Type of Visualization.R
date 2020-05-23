# 4. TYPES OF VISUALIZATION

# 4.1 Types of plots

# There are many types of graph that can be made in ggplot2, each of which is useful for visualizing a particular type of data:
# scatter plot: useful for comparing 2 variables
# line plot: useful for showing change over time
# bar plot: good at comparing statistics for each of several categories
# histogram: describes the distribution of a one-dimensional numeric variable
# box plot: compares the distribution of a numeric variable among several categories.

# Loading the gapminder, dplyr and ggplot2 packages
library(gapminder) #tracks economic and social indicators of countries over time
library(dplyr) #provides step-by-step to transform data
library(ggplot2)#create elegant data visualisations using the grammar of graphics

# 4.2 Line plot

# A line plot is useful for visualizing trends over time. Examine how the median GDP per capita has changed over time.
# First summarize the median gdpPercap by year
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianGdpPercap = median(gdpPercap))
# Create a line plot
ggplot(by_year, aes(x = year, y = medianGdpPercap)) + 
  geom_line() + expand_limits(y = 0) #the only difference with the scatter plot is geom_line() instead of geom_point()
# Examine the change within each continent.
by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(medianGdpPercap = median(gdpPercap))
# Add color in the aes code
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, color = continent)) + 
  geom_line() + expand_limits(y = 0)

# 4.3 Bar plot

# A bar plot is useful for visualizing summary statistics, such as the median GDP in each continent.
# First Summarize the median gdpPercap by continent in 1952
by_continent <- gapminder %>%
  filter(year == 1952) %>%
  group_by(continent) %>%
  summarize(medianGdpPercap = mean(gdpPercap))
# Create a bar plot showing medianGdp by continent
ggplot(by_continent, aes(x = continent, y = medianGdpPercap)) + 
  geom_col() #x is categorical variable, y is the variable that determines the height of the bars.
# Unlike scatter plots or line plots, bar plots always start at zero.
# Visualizing GDP per capita by country in Oceania in 1952
oceania_1952 <- gapminder %>%
  filter(year == 1952, continent == "Oceania")
# Create a bar plot of gdpPercap by country
ggplot(oceania_1952, aes(x = country, y = gdpPercap)) +
  geom_col() #Oceania has only 2 countries, therefore only 2 columns.

# 4.4 Histogram

# A histogram is useful for examining the distribution of a numeric variable. Create a histogram showing the distribution of life expectancy in the year 1952
gapminder_1952 <- gapminder %>%
  filter(year == 1952) %>%
  mutate(pop_by_mil = pop / 1000000)
ggplot(gapminder_1952, aes(x = pop_by_mil)) + 
  geom_histogram() #histogram has only x-axis representing the variable whose distribution we're examining.
# Customize the width of the column with bindwith() to make the histogram focuses more on the general shape more than the small details:
ggplot(gapminder_1952, aes(x = pop_by_mil)) + 
  geom_histogram(binwidth = 50) #each of the bar represents a width of 50 million.
# There are several countries with a much higher population than others, which causes the distribution cramming into a small part of the graph. To make the histogram more informative, put the x-axis on a log scale.
ggplot(gapminder_1952, aes(x = pop)) +
  geom_histogram() +
  scale_x_log10()

# 4.5 Boxplot

# A boxplot is useful for comparing a distribution of values across several groups.Examine the distribution of GDP per capita by continent in 1952
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot()
# Since GDP per capita varies across several orders of magnitude, we'll need to put the y-axis on a log scale.
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10()
# Add a title to the graph: 
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) +
  geom_boxplot() +
  scale_y_log10() +
  ggtitle("Comparing GDP per capita across continents")