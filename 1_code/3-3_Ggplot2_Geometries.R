# 3. GEOMETRIES

# A plot’s geometry dictates what visual elements will be used. Geometries can be accessed using geom_* function.
# Load the tidyverse including gpplot2 package:
library(tidyverse)

# 3.1 Scatter plot ####
# Load and examine the built-in "iris" dataset in R:
data("iris")
head(iris, 3)
# Each geom can accept specific aesthetic mappings, e.g. geom_point().
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_point()
# In additional to the essential aesthetics, we can also choose optional aesthetics like color, size, alpha, fill, shape or stroke.
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 col = Species)) + 
  geom_point()
# We can specify both geom-specific data and aesthetics. This allows us to control the information for each layer independently.
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(aes(col = Species))
# Display the summary statistics of the iris dataset on top of the data points.
iris.summary <- iris %>% group_by(Species) %>%
  summarise_all(mean) 
iris.summary # contains mean measurements for each of 3 species.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + # inherits both data and aes
  geom_point() +
  geom_point(data = iris.summary, # different data, but inherits aes
             shape = 15, 
             size = 5)
# The aesthetics inside the geom_point() can be controlled independently.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) +
  geom_point() +
  geom_point(data = iris.summary, 
             shape = 21, 
             size = 5,
             fill = "black",
             stroke = 2)
# geom_jitter() is a shortcut to using position argument to change the position from identity to jitter.
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_jitter() # geom_point() with position sets to jitter.
# To deal with overplotting of points, adjust the alpha-blending:
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) +
  geom_jitter(alpha = 0.6) # helps to see regions density.
# Another way to deal with overplotting is to change the symbol to a hollow circle, which is shape 1.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) +
  geom_jitter(shape = 1)
# It is always recommended to optimize shape, size and alpha blending of points in a scatter plot.

# 3.2 Overplotting ####
# Load the diamonds dataset from the ggplot2 package:
data("diamonds")
# Scatter plots are intuitive, easily understood, and very common, but we must always consider overplotting, particularly in the following four situations: 
# Large datasets: small points are suitable for large datasets with regions of high density (lots of overlapping).
ggplot(diamonds, aes(carat, price, 
                     color = clarity)) +
  geom_point()
# Change the points to tiny points with transparency:
ggplot(diamonds, aes(carat, price, 
                     col = clarity)) +
  geom_point(shape = ".",
             alpha = 0.5)
# Aligned values on a single axis: this occurs when one axis is continuous and the other is categorical, which can be overcome with some form of jittering.
# Load the mtcars dataset and transform cyl and am columns into categorical variables:
data("mtcars")
mtcars <- mtcars %>% 
  mutate(fcyl = as.factor(cyl), 
         fam = as.factor(am))
# Plot with default points:
ggplot(mtcars, aes(fcyl, mpg, 
                   col = fam)) +
  geom_point()
# Alter the point positions by jittering:
ggplot(mtcars, aes(fcyl, mpg, 
                   col = fam)) +
geom_point(position = position_jitter(width = 0.3))
# Alternatively jitter and dodge the point positions:
ggplot(mtcars, aes(fcyl, mpg, 
                   col = fam)) +
  geom_point(position = position_jitterdodge(jitter.width = 0.3,
                                             dodge.width = 0.3))
# Low-precision data: this results from low-resolution measurements like in the iris dataset, which is measured to 1mm precision. In this case we can jitter on both the x and y axis.
# jitter can be a geom itself, an argument in geom_point(), or a position function. 
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.5,
              width = 0.1)
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_point(alpha = 0.5,
              position = "jitter")
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_point(alpha = 0.5,
             position = position_jitter(width = 0.1))
# Integer data: this can be type integer or factor variables. You'll typically have a small, defined number of intersections between two variables, which is similar to low precision data.
# Load and examine the Vocab dataset from the carData package, which contains the years of education and vocabulary test scores from respondents to US General Social Surveys from 1972-2004:
library(carData)
data(Vocab)
str(Vocab)
# Draw a scatter plot of vocabulary vs. education:
ggplot(Vocab, aes(education, vocabulary)) +
  geom_point()
# Replace the point layer with a jitter layer and change the transparency.
ggplot(Vocab, aes(education, vocabulary)) +
  geom_jitter(alpha = 0.2)

# 3.3 Histograms ####
# A histogram is a special type of bar plot that shows the binned distribution of a continuous variable.
ggplot(iris, aes(Sepal.Width)) + # only needs X aesthetic.
  geom_histogram()
# The geom_histogram is associated with a specific statistic (stat bin). The bin argument takes the default value of 30. Default bin width can be calculated:
diff(range(iris$Sepal.Width))/30
# Changing the binwidth to 0.1 give us more intuitive impression of the data.
ggplot(iris, aes(Sepal.Width)) + 
  geom_histogram(binwidth = 0.1) # no space between the bars.
# Re-position tick marks:
ggplot(iris, aes(Sepal.Width)) + 
  geom_histogram(binwidth = 0.1,
                 center = 0.05)
# Fill the bars according to each species:
ggplot(iris, aes(Sepal.Width,
                 fill = Species)) +
  geom_histogram(binwidth = 0.1,
                 center = 0.05)
# The default position is "stack", which is not clear in this case. Alternate the position to "dodge":
ggplot(iris, aes(Sepal.Width,
                 fill = Species)) +
  geom_histogram(binwidth = 0.1,
                 center = 0.05,
                 position = "dodge")
# The "fill" position normalizes each bin to represent the proportion of all observations in each bin.
ggplot(iris, aes(Sepal.Width,
                 fill = Species)) +
  geom_histogram(binwidth = 0.1,
                 center = 0.05,
                 position = "fill")
# Histograms cut up a continuous variable into discrete bins and, by default, maps the internally calculated count variable onto the y aesthetic. An internal variable "density" can be accessed by using the ".." notation.
ggplot(mtcars, aes(mpg, ..density..)) +
  geom_histogram(binwidth = 1, 
                 fill = "blue") # shows the relative frequency, which is the height times the width of each bin.
# geom_histogram() is a special case of geom_bar() with a position argument that can take on different values:
# stack (default): bars for different groups are stacked on top of each other.
ggplot(mtcars, aes(mpg,
                   fill = fam)) +
  geom_histogram(binwidth = 1)
# dodge: bars for different groups are placed side by side.
ggplot(mtcars, aes(mpg,
                   fill = fam)) +
  geom_histogram(binwidth = 1,
                 position = "dodge")
# fill: bars for different groups are shown as proportions.
ggplot(mtcars, aes(mpg,
                   fill = fam)) +
  geom_histogram(binwidth = 1,
                 position = "fill")
# identity: plot the values as they appear in the dataset.
ggplot(mtcars, aes(mpg,
                   fill = fam)) +
  geom_histogram(binwidth = 1,
                 position = "identity",
                 alpha = 0.4)

# 3.4 Bar plots ####
# Histograms are a specialized version of bar plots, where a continuous X-axis is binned. Classic bar plots refer to a categorical X-axis, which uses either geom_bar() or geom_col().
# geom_bar(): counts the number of cases in each category of the variable mapped to the X-axis.
# geom_col(): plots the actual values.
# Load the "msleep" dataset from the ggplot2 package:
data("msleep") # contains the information on the REM sleep time and eating habits of a variety of mammals.
str(msleep)
# Making a bar plot splitting the dataset according to eating behavior:
ggplot(msleep, aes(vore)) +
  geom_bar()
# Plot the distribution instead of absolute counts with descriptive statistics on the fly: 
iris_summ_long <- iris %>% 
  select(Species, Sepal.Width) %>%
  gather(key, value, -Species) %>%
  group_by(Species) %>%
  summarise(avg = mean(value),
            stdev = sd(value))
# geom_errorbar(): adds error bars
ggplot(iris_summ_long, aes(Species, avg)) +
  geom_col() + 
  geom_errorbar(aes(ymin = avg - stdev,
                    ymax = avg + stdev),
                width = 0.1)
# This is typical plots in scientific publications, which are actually strongly discouraged for many reasons.

# Position in bar and col plots:
# stack: default
ggplot(mtcars, aes(fcyl, 
                   fill = fam)) +
  geom_bar()
# dodge: preferred
ggplot(mtcars, aes(fcyl,
                   fill = fam)) +
  geom_bar(position = "dodge")
# fill: to show proportions
ggplot(mtcars, aes(fcyl,
                   fill = fam)) +
  geom_bar(position = "fill")
# Customize bar plots further by adjusting the dodging so that the bars partially overlap each other:
ggplot(mtcars, aes(fcyl,
                   fill = fam)) +
  geom_bar(position = position_dodge(width = 0.2),
           alpha = 0.6)
# Fill each segment of the bar plot according to an ordinal variable with a sequential color palette:
ggplot(Vocab, aes(education,
                  fill = as.factor(vocabulary))) +
  geom_bar(position = "fill") +
  scale_fill_brewer()

# 3.5 Line plots ####
# Line plots are very common and well-suited in time series. 
# Load the beavers dataset, which contains body temperature series of 2 beavers.
data(beavers) # includes 2 datasets of 2 beavers: beaver 1 and 2.
# Combine into a larger dataset:
beaver <- rbind(data.frame(beaver1, id = factor("beaver1")),
                data.frame(beaver2, id = factor("beaver2")))
str(beaver)
# Plot the body temperature of the 2 beavers over the time:
ggplot(beaver, aes(time, temp, 
                   col = id)) +
  geom_line()

# Load and examine the economics dataset from ggplot2 package:
data("economics")
str(economics) # contains a time series for unemployment and population statistics from the Federal Reserve Bank of St. Louis in the United States. 
# Plot a line plot to see how the unemployment rate changes over time:
ggplot(economics, aes(date, unemploy/pop)) +
         geom_line()

# Load the "fish" dataset which contains "fish.species", "fish.tidy" and "fish.year":
load("fish.RData")
# fish.species contains the global capture rates of seven salmon species from 1950–2010. 
str(fish.species)
# Plot the Rainbow Salmon time series:
ggplot(fish.species, aes(Year, Rainbow)) +
  geom_line()
# Plot the Pink Salmon time series:
ggplot(fish.species, aes(Year, Pink)) +
  geom_line()
# fish.tidy contains the same data, but in three columns: Species, Year, and Capture:
str(fish.tidy)
# When there are multiple lines, we have to consider which aesthetics is more appropriate in allowing us to distinguish individual trends.
ggplot(fish.tidy, aes(Year, Capture,
                      linetype = Species)) + 
  geom_line() # difficult to distinguish.
# Using size is even worse:
ggplot(fish.tidy, aes(Year, Capture,
                      size = Species)) + 
  geom_line()
# Using color allows for easily distinguishable groups:
ggplot(fish.tidy, aes(Year, Capture,
                      col = Species)) + 
  geom_line()
# Use an area fill with geom_area():
ggplot(fish.tidy, aes(Year, Capture,
                      fill = Species)) + 
  geom_area() # default position: stack.
# With "fill" position:
ggplot(fish.tidy, aes(Year, Capture,
                      fill = Species)) + 
  geom_area(position = "fill") # proportion of the total fish capture.
# geom_ribbon() for overlapping area plot:
ggplot(fish.tidy, aes(Year, Capture,
                      fill = Species)) + 
  geom_ribbon(aes(ymax = Capture,
                  ymin = 0),
              alpha = 0.3)
# Plot multiple time-series by coloring by species:
ggplot(fish.tidy, aes(Year, Capture,
                      color = Species)) +
  geom_line(aes(group = Species))