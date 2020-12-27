# 2. AESTHETICS

# 2.1 Visisble aesthetics ####
# Load the tidyverse including gpplot2 package:
library(tidyverse)
# Load the built-in "iris" dataset in R:
data("iris")
# Mapping onto the X and Y axes:
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) + 
  geom_point() # each mapped variable is its own column variable in the dataframe.
# We do not need to specify x =... and y =..., since the first two arguments inside aes() are by default aesthetic mapping for X and Y axis.
# Mapping onto color:
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() # Species, a dataframe column, is mapped onto colors, a visible aesthetics.
# Aesthetics could be called in the geom layer:
ggplot(iris) + geom_point(aes(Sepal.Length, Sepal.Width, 
                 color = Species)) # shows the same result.
# However, this is typically only done if we don't want all layers to inherit the same aesthetics or we're mixing different data sources.

# Typical visible aesthetics:
# x: X axis position
# y: Y axis position
# fill: fill color
# color: color of points, outlines of other geoms
# size: area or radius of points, thickness of lines
# alpha: transparency
# linetype: line dash pattern
# labels: texts on a plot or axes
# shape: shape of a point
# Many of these aesthetics function as both aesthetic mappings as well as attributes, and one of the most common mistake is confusing the two or overwriting aesthetic mappings with fixed attributes. 

# 2.2 Color, fill, shape and size ####
# Examine again the mtcars dataset:
data(mtcars)
# Transform cyl and am columns into categorical variables: 
mtcars <- mtcars %>% 
  mutate(fcyl = as.factor(cyl), 
         fam = as.factor(am))
# One common convention is that you don't name the x and y arguments to aes(), since they almost always come first, but you do name other arguments.
# Map mpg (miles per gallon) onto the x aesthetic, and fcyl onto the y:
ggplot(mtcars, aes(mpg, fcyl)) +
  geom_point()
# Swap the mappings: fcyl onto the x aesthetic, and mpg onto the y.
ggplot(mtcars, aes(fcyl, mpg)) +
  geom_point()
# Map wt (weight) onto x, mpg onto y, and fcyl onto color:
ggplot(mtcars, aes(wt, mpg, 
                   color = fcyl)) +
  geom_point()
# Modify the point layer by changing the shape and increasing the size:
ggplot(mtcars, aes(wt, mpg, 
                   color = fcyl)) +
  geom_point(shape = 1, 
             size = 4)
# Typically, the color aesthetic changes the outline of a geom and the fill aesthetic changes the inside. geom_point() is an exception: it uses color (not fill) for the point color. 
ggplot(mtcars, aes(wt, mpg, 
                   fill = fcyl)) +
  geom_point(shape = 1, 
             size = 4) # mapping a categorical variable onto fill doesn't change the colors, although a legend is generated. This is because the default shape for points only has a color attribute and not a fill attribute!
# The default geom_point() uses shape = 19: a solid circle. An alternative is shape = 21: a circle that allow you to use both fill for the inside and color for the outline. 
ggplot(mtcars, aes(wt, mpg, 
                   fill = fcyl)) +
  geom_point(shape = 21, 
             size = 4, 
             alpha = 0.6) 
# Any time you use a solid color, make sure to use alpha blending to account for over plotting.
ggplot(mtcars, aes(wt, mpg, 
                   fill = fcyl, 
                   color = fam)) +
  geom_point(shape = 21, 
             size = 4, 
             alpha = 0.6)

# Comparing aesthetics: first create a base layer that maps mpg to y and wt to x:
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))
# Add a point layer, mapping the categorical number of cylinders, fcyl, onto size:
plt_mpg_vs_wt + geom_point(aes(size = fcyl))
# Change the mapping of fcyl to alpha:
plt_mpg_vs_wt + geom_point(aes(alpha = fcyl))
# Change the mapping of fcyl to shape:
plt_mpg_vs_wt + geom_point(aes(shape = fcyl))
# Swap the geom layer: change points to text.
plt_mpg_vs_wt + geom_text(aes(label = fcyl))
# Many of the aesthetics can accept either continuous or categorical variables, but some are restricted to categorical data, like label and shape.

# 2.3 Attributes ####
# One of the most confusing parts of ggplot2 is that all the visible aesthetics also exist as attributes.
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(color = "red")
# Attributes are always called in the geom layer, like color, size and shape.
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point(color = "red", 
             size = 4, 
             shape = 4)
# The distinction between aesthetics and attributes is subtle but important.
# All the aesthetics can be used as attributes. E.g, add attributes to the geom layer for the plot of mtcars:
plt_mpg_vs_wt + geom_point(color = "blue",
                           shape = 24)
# Add a text layer with label rownames and color red:
plt_mpg_vs_wt + geom_text(label = rownames(mtcars), 
                          color = "red")
# Colors in R can be specified by using hex codes. 
my_blue <- "#4ABEFF"
plt_mpg_vs_wt + 
  geom_point(color = my_blue, 
             alpha = 0.6)
# Change the color both in aesthetics mapping and attributes:
ggplot(mtcars, aes(wt, mpg, 
                   fill = fcyl)) +
  geom_point(color = my_blue, 
             size = 10, 
             shape = 1) # the fill mapping overrides the color attribute in geom_point().
# Explore more features of the cars in the **mtcars** dataset: 
ggplot(mtcars, aes(mpg, qsec,         # qsec: 1/4 mile time
                   color = fcyl,      
                   shape = fam,
                   size = hp/wt)) +   # hp: Gross horsepower.
  geom_point()

# 2.4 Modifying aesthetics ####
# Adding more aesthetic layers to the plot will increase the complexity and decrease the readability.
ggplot(mtcars, aes(mpg, qsec, color = fcyl, 
                   shape = fam, 
                   size = hp/wt)) +
  geom_point()
# Position specifies how ggplot will adjust for overlapping bars or points on a single layer. The most straightforward position is "identity" which is a default position for a scatter plot.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point() # the value in the data frame is exactly where the value is positioned in the plot. 
# There is an issue with the precision of this data set. The sepals were measured to the nearest millimeter. Although there're only 150 points, it'll be too much overplotting to distinguish them. Add some random noise on both x and y axes to see regions of high density - "jittering":
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter")
# Each position can be accessed as a function
posn_j <- position_jitter(0.1)
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = posn_j)
# This has advantages, as we can set the  specific arguments for the position and the position function allows to use the parameter throughout the plotting, which maintains the consistency across plots and layers.
posn_j <- position_jitter(0.2, seed = 136) # "seed" defines how much random noise should be added.
# Run the plot again.

# 2.5  Scale functions ####
# Each of the aesthetics is a scale which is mapped onto the data. Scale functions has the syntax scale_*_*, with the 2nd part defines which scale we want to modify, and the 3rd matches type of data.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") + 
  scale_x_continuous("Sepal Length") + 
  scale_color_discrete("Species") 
# There are many arguments for the scale functions.Limits argument describes the scale's range. 
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") + 
  scale_x_continuous("Sepal Length", 
                     limits = c(2, 8)) + 
  scale_color_discrete("Species") 
# break argument controls the tick mark positions.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") + 
  scale_x_continuous("Sepal Length", limits = c(2, 8), 
                     breaks = seq(2, 8, 3)) + 
  scale_color_discrete("Species") 
# expand argument is a numeric vector of length 2, giving a multiplicative and additive constant used to expand the scales so that there is a small gap between the data and the axes.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") + 
  scale_x_continuous("Sepal Length", limits = c(2, 8), 
                     breaks = seq(2, 8, 3),
                     expand = c(0, 0)) + 
  scale_color_discrete("Species")
# labels argument adjust the category names
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") + 
  scale_x_continuous("Sepal Length", limits = c(2, 8), 
                     breaks = seq(2, 8, 3),
                     expand = c(0, 0)) + 
  scale_color_discrete("Species",
                       labels = c("Setosa", "Versicolor", "Virginica"))
# labs(): changes the label of the axes quickly.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point(position = "jitter") +
  labs(x = "Sepal length", y = "Sepal width")

# Modify some aesthetics to make a bar plot of the number of cylinders for cars with different types of transmission in the mtcars dataset.
mtcars_gg <- ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar()
# Set the axis labels:
mtcars_gg <- mtcars_gg +
  labs(x = "Number of Cyclinders", y = "Count")
# Implement a custom fill color scale using scale_fill_manual():
palette <- c("#377EB8", "#E41A1C")
mtcars_gg + scale_fill_manual("Transmission", values = palette,
                              labels = c("automatic", "manual"))
# Modify the position so that the bars for transmission are displayed side by side:
ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar(position = "dodge") +
  labs(x = "Number of Cyclinders", y = "Count") +
  scale_fill_manual("Transmission", values = palette,
                    labels = c("automatic", "manual"))

# Setting a dummy aesthetics:
mtcars_dummy <- ggplot(mtcars, aes(mpg, 0)) +
  geom_point(position = "jitter")
# When using setting y-axis limits, you can specify the limits as separate arguments, ylim(lo, hi) or as a single numeric vector, ylim(c(lo, hi))
mtcars_dummy + ylim(-2, 2)

# 2.6 Aesthetic best practice ####
# How do we choose the right visual aesthetics? The best choices for aesthetics are those which are both efficient, in that they are faster than numeric summaries, and accurate, in that they minimize this information loss.
# The choice of aesthetic mapping depends on the type of variable. The scatter plot is so easy to understand because it maps data as position on a common scale.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point()
# If we switch the aesthetic mappings for x and color, it becomes neither accurate nor efficient.
ggplot(iris, aes(color = Sepal.Width, 
                 y = Sepal.Width, 
                 x = Species)) +
  geom_point()

ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point()