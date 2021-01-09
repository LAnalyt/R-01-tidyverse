# 4. THEMES

# The themes layer enables to make publication quality plots directly in R.
# Load the tidyverse including gpplot2 package:
library(tidyverse)

# 4.1 Themes from scratch ####
# The themes layer controls all the non-data ink on the plot, which are all the visual elements that are not actually part of the data. Visual elements can be classified as on of the three different types: text, line or rectangle. Each type can be modified by the respective function: element_text(), element_line() and element_rect(). 
# Load and the built-in "iris" dataset in R:
data("iris")
# Make a starting plot:
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6)
# Adjust theme elements with theme() function, e.g, changing the text color of the axes. 
ggplot(iris, aes(Sepal.Length, Sepal.Width,
                 col = Species)) + 
  geom_jitter(alpha = 0.6) + 
  theme(axis.title = element_text(color = "blue"))
# Line elements include tick marks on the axes, the axis lines themselves and all grid lines, both major and minor. These are modified by element_line argument.
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
# Although we have access to every item, we don't need to modify them individually. They inherent from each other in a hierarchy. All text elements inherit from text, so if text argument is changed, all downstream arguments would be affected.
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
# Remove the axis ticks and the panel grid lines by making them a blank element:
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
# If there are too many plots within a presentation, we'll want to have a consistency in the style. Once you settle with a specific theme, we can apply it to all plots of the same type. Creating a theme from scratch is a detailed process, we don't want to repeat it for every plot. 
# Draw a scatter plot and save it as an object:
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
theme_recession <- theme(rect = element_rect(fill = "grey92"),
                         legend.key = element_rect(color = NA),
                         axis.ticks = element_blank(),
                         panel.grid = element_blank(),
                         panel.grid.major.y = element_line(
                           color = "white", 
                           size = 0.5, 
                           linetype = "dotted"),
                         axis.text = element_text(color = "grey25"),
                         plot.title = element_text(face = "italic",
                                                   size = 16),
                         legend.position = c(0.6, 0.1))
# Add the Tufte theme and theme_recession together:
theme_tufte_recession <- theme_tufte() + theme_recession
# Use the Tufte recession theme by adding it to the plot:
plt_prop_unemployed_over_time + theme_tufte_recession
# theme_set(): set your theme as the default using, e.g, set theme_tufte_recession as the default theme:
theme_set(theme_tufte_recession)
# Draw the plot (without explicitly adding a theme):
plt_prop_unemployed_over_time
# Set theme back to default in ggplot2:
theme_set(theme_gray())

# 4.5 Effective explanatory plots ####
# Load the Gapminder dataset:
library(gapminder)
data(gapminder)
# Prepare the data for comparing the life expectancy among the countries in 2007:
gm2007_full <- gapminder %>%
  filter(year == 2007) %>% 
  select(country, lifeExp, continent)
glimpse(gm2007_full)
# Draw a histogram for the first exploratory plot:
ggplot(gm2007_full, aes(lifeExp)) +
  geom_histogram()
# Alternative way is arranging the data according to life then plot that as an index, which allows us to see each point individually.
gm2007_full_arranged <- gm2007_full %>%
  arrange(lifeExp) %>%
  mutate(index = 1:nrow(gm2007_full))
ggplot(gm2007_full_arranged, aes(index, lifeExp,
                                 col = continent)) +
  geom_point() # this has the advantage that we can color each point according to the continent.
# After getting familiar with the data, reduce it to a compact and understandable format for a lay audience:
gm2007_high <- gm2007_full %>%
  arrange(lifeExp) %>%
  top_n(10, wt = lifeExp)
gm2007_low <- gm2007_full %>%
  arrange(lifeExp) %>%
  top_n(-10, wt = lifeExp)
gm2007 <- rbind(gm2007_low, gm2007_high)
glimpse(gm2007)
# Create an info-viz style, similar to the graphs in a magazine or website for a mostly lay audience. E.g, construct the lollipop plot style:
ggplot(gm2007, aes(lifeExp, country,
                   col = lifeExp)) + 
  geom_point(size = 4) +
  geom_segment(aes(xend = 30,         # adds line segments 
                   yend = country),
               size = 2) +
  geom_text(aes(label = lifeExp),     # add labels on the points.
                color = "white",
                size = 1.5)
# Set a color scale for more magazin-quality effect:
library(RColorBrewer)
palette <- brewer.pal(5, "RdYlBu")[-(2:4)]
# Modify the scales of the lollipop plot:
plt_country_vs_lifeExp <- 
  ggplot(gm2007, aes(lifeExp, country, 
                   col = lifeExp)) +
  geom_point(size = 4) +
  geom_segment(aes(xend = 30, 
                   yend = country), 
               size = 2) +
  geom_text(aes(label = round(lifeExp, 1)), 
            color = "white", 
            size = 1.5) +
  scale_x_continuous("", 
                     expand = c(0,0), 
                     limits = c(30,90), 
                     position = "top") +
  scale_color_gradientn(colors = palette) +
  labs(title = "Highest and lowest life expectancies, 2007", 
       caption = "Source: gapminder")
plt_country_vs_lifeExp
# The following values have been calculated for embellishments to the plot:
global_mean <- mean(gm2007_full$lifeExp)
x_start <- global_mean + 4
y_start <- 5.5
x_end <- global_mean
y_end <- 7.5
# Define the theme of the plot:
plt_country_vs_lifeExp <- plt_country_vs_lifeExp + 
  theme_classic() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text = element_text(color = "black"),
        axis.title = element_blank(),
        legend.position = "none")
plt_country_vs_lifeExp
# Use geom_vline() to add a vertical line:
plt_country_vs_lifeExp + 
  geom_vline(xintercept = global_mean, 
             color = "grey40", 
             linetype = 3) +
  # Use annotate() to add text and a curve to the plot:
  annotate("text", x = x_start, y = y_start,
           label = "The\nglobal\naverage",
           vjust = 1, 
           size = 3, 
           color = "grey40") +
  annotate("curve", x = x_start, y = y_start,
          xend = x_end, yend = y_end,
          arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
          color = "grey40")