# 5. STATISTICS

# There are 2 broad categories of functions in the statistic layer:  within a geom and independent. 

# 5.1 Stats with geoms ####
# All the statistical functions begin with "stat_". Even those called from within the the geom layer can be accessed independently this way. 
# Load the tidyverse including gpplot2 package:
library(tidyverse)
# Load and make at starting plot of the built-in "iris" dataset:
data("iris")
p <- ggplot(iris, aes(Sepal.Width))
p + geom_histogram()
# Under the hood of geom_histogram(), stat_bin summarizes the total count in each group. In geom_bar(), default stat is set to "bin". So the same plot can be produced with geom_bar().
p + geom_bar()

# Load and plot a starting plot of the mtcars dataset:
data("mtcars")
p <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(am)))
p + geom_bar()
# The same thing happens with geom_bar(), which just calls stat_count under the hood. stat_count() produces the same plot.
p + stat_count()
# Specific geoms and stat functions are related. E.g, stat_smooth can be accessed with geom_smooth(). 
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  geom_smooth()
# The standard error, which is shown as a gray ribbon, is by default, a 95% confidence interval. This can be removed by setting the se argument to FALSE.
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  geom_smooth(se = FALSE)
# loess: non-prametric smoothing algorithm that is used when we have less than 1000 observations. It works by calculating a weighted mean by passing a sliding window along the x-axis and is a valuable tool in exploratory data analysis. 
# The method argument can also define parametric models. For groups larger than 1000, the method default to "gam". Apply a linear model by setting method to "lm": 
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  geom_smooth(method = "lm", 
              se = FALSE)
# In both methods "loess" and "lm", the model is calculated on groups defined by color. By default, each model is bound to the limits of its own group. But for parametric methods, we can make the fullrange argument to make predictions over the entire range.
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  geom_smooth(method = "lm", 
              fullrange = TRUE) # the error increases the further away from the dataset.
# Access smoothing using stat_smooth():
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  stat_smooth(method = "lm",
              se = FALSE)
#  The color aesthetic defines an invisible group aesthetic. Defining the group aesthetic for a specific geom means we can overwrite that. Use a dummy variable to calculate the smoothing model for all values.
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  stat_smooth(group = 1, 
              method = "lm",
              se = FALSE) 
# The span argument in "loess" method controls the degree of smoothing, which is the size of the sliding window. Smaller spans are more noisy. Explore the effect of span argument of LOESS curves:
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  stat_smooth(method = "loess", color = "red", span = 0.9,
              se = FALSE) +
  stat_smooth(method = "loess", color = "green", span = 0.6,
              se = FALSE) +
  stat_smooth(method = "loess", color = "blue", span = 0.3,
              se = FALSE)
# Compare LOESS and linear regression smoothing on small regions of data:
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  stat_smooth(method = "loess", 
              se = FALSE) +
  stat_smooth(method = "lm", 
              se = FALSE)
# LOESS isn't great on very short sections of data. Compare the pieces of linear regression to LOESS over the whole thing:
ggplot(iris, aes(Sepal.Length, Sepal.Width, 
                 color = Species)) + 
  geom_point() +
  stat_smooth(aes(color = "All"), se = FALSE) +
  stat_smooth(method = "lm", 
              se = FALSE)
# The default span for LOESS is 0.9. A lower span will result in a better fit with more detail; but don't overdo it or you'll end up over-fitting!
