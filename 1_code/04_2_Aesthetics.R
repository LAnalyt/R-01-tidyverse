# 2. AESTHETICS

# Aesthetic mappings are the cornerstone of the grammar of graphics plotting concept. This is where the magic happens - converting continuous and categorical data into visual scales that provide access to a large amount of information in a very short time. 

# Visisble aesthetics ####

# Load Tidyverse package which includes gpplot2 
library(tidyverse)
# Load a built-in dataset "iris" in R which gives the measurements in centimeters of the variables sepal length and width and petal length and width, respectively, for 50 flowers from each of 3 species of iris.
data("iris")
# Mapping onto the X and Y axes
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width)) + 
  geom_point() # Each mapped variable is its own column variable in the dataframe.
# Mapping onto color
ggplot(iris, aes(x = Sepal.Length, 
                 y = Sepal.Width, 
                 color = Species)) + 
  geom_point() # Species, a dataframe column, is mapped is mapped onto colors, a visible aesthetics.
# Aesthetics could be called in the geom layer
ggplot(iris) + geom_point(aes(x = Sepal.Length, 
                 y = Sepal.Width, 
                 color = Species)) # shows the same result.
# However, this is typically only done if we don't want all layers to inherit the same aesthetics or we're mixing different data sources.

# Typical visible aesthetics:
# x: X axis position
# y: Y axis position
# fill: fill color
# color: color of points, outlines of other geoms
# size: area or radius of points, thickness of lines
# alpha: transparency
# linetype: line das pattern
# labels: texts on a plot or axes
# shape: shape of a point
# Many of these aesthetics function as both aesthetic mappings as well as attributes, and one of the most common mistake is confusing the two or overwriting aesthetic mappings with fixed attributes. 

# Color, fill, shape and size ####

# Examine again the mtcars dataset
data("mtcars")
# Transform cyl and am columns into categorical variables 
mtcars <- mtcars %>% 
  mutate(fcyl = as.factor(cyl), fam = as.factor(am))
# One common convention is that you don't name the x and y arguments to aes(), since they almost always come first, but you do name other arguments.
# Map mpg onto the x aesthetic, and fcyl onto the y
ggplot(mtcars, aes(mpg, fcyl)) +
  geom_point()
# Swap the mappings: fcyl onto the x aesthetic, and mpg onto the y
ggplot(mtcars, aes(fcyl, mpg)) +
  geom_point()
# Map wt onto x, mpg onto y, and fcyl onto color
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  geom_point()
# Modify the point layer by changing the shape and increasing the size
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  geom_point(shape = 1, size = 4)
# Typically, the color aesthetic changes the outline of a geom and the fill aesthetic changes the inside. geom_point() is an exception: it uses color (not fill) for the point color. 
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  geom_point(shape = 1, size = 4) # mapping a categorical variable onto fill doesn't change the colors, although a legend is generated. This is because the default shape for points only has a color attribute and not a fill attribute!
# The default geom_point() uses shape = 19: a solid circle. An alternative is shape = 21: a circle that allow you to use both fill for the inside and color for the outline. 
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  geom_point(shape = 21, size = 4, alpha = 0.6) 
# In the ggplot() aesthetics, map fam to color
ggplot(mtcars, aes(wt, mpg, fill = fcyl, color = fam)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)
# Any time you use a solid color, make sure to use alpha blending to account for over plotting.
             