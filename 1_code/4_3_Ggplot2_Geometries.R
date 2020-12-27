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
# In additional to the essential aesthetics, we can also choose optional aesthetics like color, size, alpha, fill, shape or stroke. We can specify both geom-specific data and aesthetics. This allows us to control the information for each layer independently. 
# E.g, we want to display the summary statistics of the iris dataset on top of the data points.
iris.summary <- iris %>% group_by(Species) %>%
  summarise_all(mean) 
iris.summary # contains mean measurements for each of 3 species.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) + # inherits both data and aes
  geom_point() +
  geom_point(data = iris.summary, # differen data, but inherits aes.
             shape = 15, 
             size = 5)
# The aesthetics inside the geom_point() can be controlled independently.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_point() +
  geom_point(data = iris.summary, 
             shape = 21, 
             size = 5,
             fill = "black",
             stroke = 2)
# geom_jitter() is a shortcut to using position argument to change the position from identity to jitter.
ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_jitter() # geom_point() with position sets to jitter.
# To deal with overplotting of points, we adjust the alpha-blending:
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_jitter(alpha = 0.6) # this helps to see the regionsof density.
# Another way to deal with overplotting is to change the symbol to a hollow circle, which is shape 1.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) +
  geom_jitter(shape = 1)

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
                     color = clarity)) +
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
                   color = fam)) +
  geom_point()
# Alter the point positions by jittering:
ggplot(mtcars, aes(fcyl, mpg, 
                   color = fam)) +
geom_point(position = position_jitter(width = 0.3))
# Alternatively jitter and dodge the point positions:
ggplot(mtcars, aes(fcyl, mpg, 
                   color = fam)) +
  geom_point(position = position_jitterdodge(jitter.width = 0.3,
                                             dodge.width = 0.3))
# Low-precision data: this results from low-resolution measurements like in the iris dataset, which is measured to 1mm precision. In this case we can jitter on both the x and y axis.
# jitter can be a geom itself, an argument in geom_point(), or a position function. 
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) + 
  geom_jitter(alpha = 0.5,
              width = 0.1)
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) + 
  geom_point(alpha = 0.5,
              position = "jitter")
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 color = Species)) + 
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