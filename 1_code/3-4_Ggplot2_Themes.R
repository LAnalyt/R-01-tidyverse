# 4. THEMES

# The themes layer enables to make publication quality plots directly in R.
# Load the tidyverse including gpplot2 package:
library(tidyverse)

# 4.1 Themes from scratch ####
# The themes layer controls all the non-data ink on the plot, which are all the visual elements that are not actually part of the data. Visual elements can be classified as on of the three different types: text, line or rectangle. Each type can be modified by the corresponding function: element_text(), element_line() and element_rect(). 
# Load and the built-in "iris" dataset in R:
data("iris")
# Make a starting plot:
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6)
# Adjust theme elements with theme() function, e.g, changing the text color of the axes. Within the theme() function we can manipulate size, color, alignment and angle of the text.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) + 
  theme(axis.title = element_text(color =  "blue"))
# The line elements include tick marks on the axes, the axis lines and all grid lines. These are modified by element_line argument.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) + 
  theme(axis.ticks = element_line(color = "blue"),
        panel.grid = element_line(color = "blue"))
# The remaining non-data ink on the plot are all rectangles of various sizes. Access rectangles using arguments in theme() and modify them using element_rect:
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) + 
  theme(plot.background = element_rect(color = "blue"),
        legend.box.background = element_rect(color = "blue"))
# Although we have access to every item, we don't need to modify them individually. They inherent from each other inherently. E.g, all text elements inherit from text, so if text argument is changed, all text elements will be changed.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) +
  theme(text = element_text(color = "blue"))

# element_blank(): removes any item in the plot.
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) +
  theme(text = element_blank(),
        line = element_blank(),
        rect = element_blank())

# Load and examine the "economics" dataset from the ggplot2 package, which contains a time series for unemployment and population statistics from the Federal Reserve Bank of St. Louis in the United States. 
data("economics")
head(economics)
# Make a line plot to see how unemployment rate changes over time:
ggplot(economics, aes(date, unemploy/pop)) +
  geom_line() 
# Add recession to the time series:
recess = read.csv("recession.csv", header = FALSE)
names(recess) <- c("begin","end")
recess$begin <- as.Date(recess$begin, format = c("%Y-%m-%d"))
recess$end <- as.Date(recess$end, format = c("%Y-%m-%d"))
# Plot the bars representing the recession time on the current plot:
plt_prop_unemployed_over_time <- 
  ggplot(economics, aes(date, unemploy/pop)) + 
  geom_rect(data = recess,
          aes(xmin = begin, xmax = end, 
              ymin = -Inf, ymax = +Inf),
          inherit.aes = FALSE, 
          fill = "red", 
          alpha = 0.2) +
  geom_line()
plt_prop_unemployed_over_time