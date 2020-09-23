# 1. INTRO TO DATA VISUALIZATION WITH GGPLOT2

# Data visualization is an essential skill for data scientitsts. It combines satatistics in meaningful and appropriate ways.

# ggplot2 and built-in datasets ####

# Load gpplot2 in Tidyverse package
library(ggplot2)
# Load a built-in dataset "mtcars" in R, which contains information on 32 cars from 1973 issue of Motor Trend
data("mtcars")
# Explore the structure of the dataset
str(mtcars)
# Draw a plot example
ggplot(mtcars, aes(cyl, mpg)) +  # cyl: number of cylinders
  geom_point()
# ggplot2 treats cyl as a continuous variable, which is not quite right because it gives the impression that there is such a thing as 5- or 7- cyclinder car.
# Explicitly tell ggplot2 that cyl is a categorical variable
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_point() # x-axis doesn't contain 5 and 7 anymore, only the values that are present in the dataset.

# Aesthetic mappings ####

# Aesthetic elements tell us which scales we should map our data onto.
# Mapping data column to aesthetics
ggplot(mtcars, aes(wt, mpg, color = disp)) +
  geom_point()
# Change color to a size aesthetics
ggplot(mtcars, aes(wt, mpg, size = disp)) +
  geom_point() 
# Another argument of aes() is the shape of the points. There are finite number of shapes which ggplot() can automatically assign to the points. Therefor shape only makes sense with categorical data, not continuous 
ggplot(mtcars, aes(wt, mpg, shape = disp)) +
  geom_point() # return error.

# Adding geometries ####

# Geometries layer allows us to choose how the plot will look like. 
# Explore this graphic layer with the diamond dataset also in ggplot2
data(diamonds) # contain details of 1000 diamonds.
str(diamonds) 
# Explore the relation between carat and price
ggplot(diamonds, aes(carat, price)) +
  geom_point() # adds points as in scatter plot.
# Add a smooth trend curve with geom_smooth()
ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  geom_smooth() # geometries are added using the + operator

# Mapping an aesthetic to data variable with multiple geoms will change all the geoms. 
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point() +
  geom_smooth()
#Make changes to individual geoms by passing arguments to the geom_*() functions.
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point(alpha = 0.4) + # alpha argument controls the opacity.
  geom_smooth()

# Saving plots as variables ####

# Plots can be saved as variables, which can be added two later on using the + operator. This is really useful if you want to make multiple related plots from a common base.
plt_price_vs_carat <- ggplot(diamonds, aes(carat, price))
# Add point layer to the saved variable
plt_price_vs_carat + geom_point()
# Add an alpha argument to the point layer to make the points 20% opaque
plt_price_vs_carat_transparent <- plt_price_vs_carat + 
  geom_point(alpha = 0.2)
# Edit the plot to map color to clarity and save it to a new object
plt_price_vs_carat_clarity <- plt_price_vs_carat +
  geom_point(aes(color = clarity))
# See the plot
plt_price_vs_carat_clarity