# 1 TIDY DATA

# 1.1 Tidy data ####
# A data table is in tidy format if each row represents one observation and columns. The data structure is easy to manipulate and visualize through the tidyverse package.
library(tidyverse) 
# The tidy data format has a rectangular shape with columns, rows and cells just like in a spreadsheet. For a rectangular data to be tidy, there are three conditions:
# Each column sould hold a single variable.
# Each row should hold a single observation.
# Each cell should hold a single value. 

# Examine some built-in datasets:
data("ChickWeight") # experiment on the effect of diet on early growth of chicks.
head(ChickWeight)
# ChickWeight is in tidy data format. Each observation (a weight) is represented by one row. The chick from which this measurement came is one of the variables.
data(co2) # atmospheric concentrations of CO2 are expressed in parts per million (ppm) and reported in the preliminary 1997 SIO manometric mole fraction scale.
glimpse(co2) # is a time series, not tidy data.

# 1.2 tibble ####
# Tidy data must be stored in data frames. tbl, known as tibble, is a modern version of data frame.
# Load the "murders" dataset from the dslabs package:
library(dslabs)
data(murders)
murders
# Convert the data into tibble to compare:
as_tibble(murders)
# tibbles display better than data frames. The result fits nicely with the screen display. 
# Subsets of tibbles are tibbles. If you subset the columns of a data frame, you may get back an object that is not a data frame.
class(murders[,4]) # not a data frame.
class(as_tibble(murders)[4,])
# This is useful in tidyverse since the functions require data frames as input. 
# If you want to access the vector that defines a column, and not get back a data frame, you need to use the accessor $:
class(as_tibble(murders)$population)
# tibbles will give you a warning if you try to access a column that does not exist. 
as_tibble(murders)$Population
murders$Population # just returns NULL without warning, which can make it harder to debug.

# While data frame columns need to be vectors of numbers, strings, or logical values, tibbles can have more complex objects, such as lists or functions. Also, we can create tibbles with functions:
tibble(id = c(1, 2, 3),
       func = c(mean, median, sd))
# Create a data frame in a tibble format:
character_df <- tibble(name = c("Skywalker", "R2-D2", "Obi-Wan"),
                       homeworld = c("Tatooine", "Naboo", "Stewjon"),
                       species = c("Human", "Droid", "Human"))
character_df
# We can easily perform dplyr on a tibble.
character_df %>% 
  select(name, homeworld) # result is a tibble.
character_df %>%
  filter(homeworld == "Tatooine")
character_df %>%
  mutate(is_human = species == "Human")

# 1.3 tidyr ####
