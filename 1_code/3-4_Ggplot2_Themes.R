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
# Add recession to the time series with the lubridate package:
library(lubridate)
recess <- data.frame(
  begin = c("1969-12-01","1973-11-01","1980-01-01","1981-07-01","1990-07-01","2001-03-01", "2007-12-01"), 
  end = c("1970-11-01","1975-03-01","1980-07-01","1982-11-01","1991-03-01","2001-11-01", "2009-06-01"),
  stringsAsFactors = F
)
recess$begin <- ymd (recess$begin)
recess$end <- ymd (recess$end)
# Plot the bars representing the recession time on the current plot:
plt_prop_unemployed_over_time <- 
  ggplot(economics, aes(date, unemploy/pop)) + 
  geom_rect(data = recess,
          aes(xmin = begin, xmax = end, 
              ymin = -Inf, ymax = +Inf),
          inherit.aes = FALSE, 
          fill = "red", 
          alpha = 0.2) +
  geom_line() +
  labs(title = "The percentage of unemployed Americans increases sharply during recession")
plt_prop_unemployed_over_time
# Many plot elements have multiple properties that can be set.
plt_prop_unemployed_over_time + 
  theme(axis.line = element_line(color = "red", 
                                 linetype = "dashed"),
        rect = element_rect(fill = "grey92")) # very pale gray
# Remove the axis ticks and the panel gridlines by making them a blank element:
plt_prop_unemployed_over_time +
  theme(axis.ticks = element_blank(), 
        panel.grid = element_blank())
# Add the major horizontal grid lines back to the plot:
plt_prop_unemployed_over_time +
  theme(panel.grid.major.y = element_line(color = "white",
                                          size = 0.5,
                                          linetype = "dotted"))
# Adjust the axis tick labels' text and title:
plt_prop_unemployed_over_time +
  theme(axis.text = element_text(color = "grey25"),
        plot.title = element_text(size = 16, 
                                  face = "italic"))

# Load and plot a scatter plot of the mtcars dataset:
data("mtcars")
plt_mpg_vs_wt_by_cyl <-
  ggplot(mtcars, aes(wt, mpg,
                     col = factor(cyl))) +
  geom_point()
plt_mpg_vs_wt_by_cyl
# Whitespace means all the non-visible margins and spacing in the plot. To set a single whitespace value, use unit(x, unit), where x is the amount and unit is the unit of measure. 
plt_mpg_vs_wt_by_cyl +
  theme(axis.ticks.length = unit(2, "lines"),
        legend.key.size = unit(3, "cm")) 
# The default unit is "pt" (points), which scales well with text. Other options include "cm", "in" (inches) and "lines" (of text).
# Borders require you to set 4 positions with margin(top, right, bottom, left, unit).
plt_mpg_vs_wt_by_cyl +
  theme(legend.margin = margin(20, 30, 40, 50, "pt"),
        plot.margin = margin(10, 30, 50, 70, "mm"))

# 4.2 Theme flexibility ####
# If there are too many plots within a presentation, we'll want to have a consistency in the style. Once you settle with a specific theme, we can apply it to all plots of the same type. Creating a theme from scratch is a detailed process, we don't want to repeat it for every plot we make. 
# Defining theme objects:
z <- ggplot(iris, aes(Sepal.Length, Sepal.Width,
                      col = Species)) +
  geom_jitter(alpha = 0.6) +
  scale_x_continuous("Sepal Length (cm)",
                     limits = c(4, 8),
                     expand = c(0, 0)) +
  scale_y_continuous("Sepal Width (cm)", 
                     limits = c(1.5, 5), 
                     expand = c(0, 0)) +
  scale_color_brewer("Species", 
                     palette = "Dark2",
                     labels = c("Setosa", "Versicolor", "Virginica"))
z
# Adjust specific theme arguments to get the desired plot style:
z + theme(text = element_text(family = "serif",
                              size = 14),
          rect = element_blank(),
          panel.grid = element_blank(),
          title = element_text(color = "#8b0000"),
          axis.line = element_line(color = "black"))
# Save this layer as a theme object to reuse it later:
theme_iris <- theme(text = element_text(family = "serif",
                                        size = 14),
                    rect = element_blank(),
                    panel.grid = element_blank(),
                    title = element_text(color = "#8b0000"),
                    axis.line = element_line(color = "black"))
z + theme_iris
# Reuse the theme with a histogram:
ggplot(iris, aes(Sepal.Width)) +
  geom_histogram(binwidth = 0.1,
                 center = 0.05) +
  theme_iris
# The histogram now has the same style as the scatter plot, without having to type the whole theme layer.
# Add another theme layer which will override the previous setting:
ggplot(iris, aes(Sepal.Width)) +
  geom_histogram(binwidth = 0.1,
                 center = 0.05) +
  theme_iris +
  theme(axis.line.x = element_blank()) # remove the x axis.

# 4.3 Built-in themes ####
# built-in theme functions start with theme_*, e.g, theme_gray() is the default theme.
# Access theme_classic() template, which is great for publication-quality:
z + theme_classic()
# theme_bw() is useful with transparency.
plt_prop_unemployed_over_time + theme_bw()
# theme_void() removes everything but the data.
plt_prop_unemployed_over_time + theme_void()

# Outside of ggplot2, another source of built-in themes is the ggthemes package.
install.packages("ggthemes")
library(ggthemes)
# The tufte theme mimics Tufte's classic style, which removes all non-data ink and sets the font to a serif typeface.
z + theme_tufte()
# Add the fivethirtyeight.com theme to the plot:
plt_prop_unemployed_over_time + theme_fivethirtyeight()
# Use the Wall Street Journal theme:
plt_prop_unemployed_over_time + theme_wsj()

# 4.4 Updating themes ####
# Reusing a theme across many plots helps to provide a consistent style. There are several options for this.
# Assign the theme to a variable, and add it to each plot. theme_update() commands updates the default theme and saves the current default. 
original <- theme_update(text = element_text(family = "serif",
                                             size = 14),
                         rect = element_blank(),
                         panel.grid = element_blank(),
                         title = element_text(color = "#8b0000"),
                         axis.line = element_line(color = "black"))
# Now all plots have the same theme.
z
# Save the theme for the economics dataset as theme_recession:
theme_recession <- theme(
  rect = element_rect(fill = "grey92"),
  legend.key = element_rect(color = NA),
  axis.ticks = element_blank(),
  panel.grid = element_blank(),
  panel.grid.major.y = element_line(color = "white", 
                                    size = 0.5, 
                                    linetype = "dotted"),
  axis.text = element_text(color = "grey25"),
  plot.title = element_text(face = "italic", size = 16),
  legend.position = c(0.6, 0.1)
)
# Add the Tufte theme and theme_recession together:
theme_tufte_recession <- theme_tufte() + theme_recession
# Use the Tufte recession theme by adding it to the plot:
plt_prop_unemployed_over_time + theme_tufte_recession

# theme_set(): set your theme as the default using, e.g, set theme_tufte_recession as the default theme:
theme_set(theme_tufte_recession)
# Draw the plot (without explicitly adding a theme):
plt_prop_unemployed_over_time
