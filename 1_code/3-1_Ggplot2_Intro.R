# 1. INTRODUCTION TO DATA VISUALIZATION WITH GGPLOT2

# 1.1 Data viz ####
# Data visualization is an essential skill for data scientists. It combines statistics in meaningful and appropriate ways.
# Load gpplot2 package:
library(ggplot2)
# Examine the mammals dataset from the MASS package, which contains the average brain and body weights of 62 land mammals.
library(MASS)
MASS::mammals
# To understand the relationship here, the most obvious first step is to make a scatter plot.
ggplot(mammals, aes(body, brain)) +
  geom_point()
# Applying here a linear model is a poor choice since a few extreme values have a large influence.
ggplot(mammals, aes(body, brain)) + 
  geom_point(alpha = 0.6) + 
  stat_smooth(method = "lm",
              color = "red",
              se = FALSE)
# A log transformation of both variables allows for a better fit.
ggplot(mammals, aes(body, brain)) + 
  geom_point(alpha = 0.6) + 
  coord_fixed() + 
  scale_x_log10() +
  scale_y_log10() +
  stat_smooth(method = "lm",
              color = "#C42126",
              se = FALSE,
              size = 1)

# 1.2 Aesthetic mappings ####
# Aesthetic elements tell us which scales we should map data onto.
# Load a built-in dataset "mtcars" in R, which contains information on 32 cars from 1973 issue of Motor Trend.
data("mtcars")
# Explore the structure of the dataset:
str(mtcars)
# Draw a plot example:
ggplot(mtcars, aes(cyl, mpg)) +  # cyl: number of cylinders.
  geom_point()
# ggplot2 treats cyl as a continuous variable, which is not quite right because it gives the impression that there is such a thing as 5- or 7- cyclinder car.
# Explicitly tell ggplot2 that cyl is a categorical variable
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_point() # x-axis doesn't contain 5 and 7 anymore, only the values that are present in the dataset.

# Add more layers to aesthetic mapping: 
ggplot(mtcars, aes(wt, mpg, 
                   color = disp)) +
  geom_point()
# Change color to a size aesthetics:
ggplot(mtcars, aes(wt, mpg, size = disp)) +
  geom_point() 
# Another argument of aes() is the shape of the points. There are finite number of shapes which ggplot() can automatically assign to the points. Therefor shape only makes sense with categorical data, not continuous.
ggplot(mtcars, aes(wt, mpg, shape = disp)) +
  geom_point() # return error.

# 1.3 Adding geometries ####
# Geometries layer allows us to choose how the plot will look like. 
# Explore this graphic layer with the diamond dataset also in ggplot2
data(diamonds) # contain details of 1000 diamonds.
str(diamonds) 
# Explore the relation between carat and price:
ggplot(diamonds, aes(carat, price)) +
  geom_point() # adds points as in scatter plot.
# Add a smooth trend curve with geom_smooth():
ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  geom_smooth() # geometries are added using the "+" operator.

# Mapping an aesthetic to data variable with multiple geoms will change all the geoms. 
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point() +
  geom_smooth()
# Make changes to individual geoms by passing arguments to the geom_*() functions:
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point(alpha = 0.4) + # alpha argument controls the opacity.
  geom_smooth()

# Saving plots as variables:
# Plots can be saved as variables, which can be added two later on using the "+" operator. This is really useful if you want to make multiple related plots from a common base.
plt_price_vs_carat <- ggplot(diamonds, aes(carat, price))
# Add point layer to the saved variable:
plt_price_vs_carat + geom_point()
# Add an alpha argument to the point layer to make the points 20% opaque:
plt_price_vs_carat_transparent <- plt_price_vs_carat + 
  geom_point(alpha = 0.2)
# Edit the plot to map color to clarity and save it to a new object:
plt_price_vs_carat_clarity <- plt_price_vs_carat +
  geom_point(aes(color = clarity))
# See the plot:
plt_price_vs_carat_clarity

# 1.4 ggplot2 layers ####
# The grammar of graphics is implemented in R using the ggplot2 package with two key functions: layer grammatical elements and aesthetic mapping.
# Use the classical iris dataset to illustrate this:
head(iris)
# Make a scatter plot with Sepal.Length mapped to x and Sepal.width to y aesthetics:
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
  geom_jitter()
# With three essential layers, there are enough instructions to make a basic scatter plot. To get a more meaningful and cleaner visualization, add the theme layer:
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_jitter() +
  labs(x = "Sepal Length (cm)", y = "Sepal Width (cm)") +
  theme_classic()