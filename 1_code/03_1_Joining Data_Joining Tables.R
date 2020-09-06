# 1. JOINING DATA WITH DPLYR

# The information for data analysis is not always confined in a data table. Often you'll need to join multiple tables together, so that they can be analyzed in a combination.

# The LEGO Datasets ####

# The LEGO dataset is about the contrucstion toys known as LEGOs, which contains information about the sets, parts, themes, and colors that make up LEGO history. The dataset is spreaded across many tables.
# Import the "parts" table in form of .rds file in 0_data
sets <- readRDS("sets.rds") # contains one row for each of the 4977 LEGO sets.
# Examine the table
head(sets) # theme_id is not useful on its own.
# The useful information for "theme_id" is in another table called "themes". Import and examine this table
themes <- readRDS("themes.rds")
head(themes) 
# The theme_id variable in sets table links to the id variable in the themes table. For any individual set, we could find a theme that matches it.
# To see the theme that each set is associated with, we'll need to join the two tables with the inner_join verb from dplyr package.

# Load tidyverse including the dplyr package
library(tidyverse) 
# Use inner_join to join the table "sets" to the table "themes"
sets %>%
  inner_join(themes, by = c("theme_id" = "id")) # the argument tells how to match the tables: linking theme_id in the first table to id in second table.

# The output shows a combined table, combining each set with its theme, but becaue both variable had a variable called "name", the new combined table results in "name.x" and "name.y". 
# Customize inner_join so that it's more readable
sets %>%
  inner_join(themes, by = c("theme_id" = "id"),
             suffix = c("_set", "_theme"))

# Find out the most common theme in LEGO are
sets %>%
  inner_join(themes, by = c("theme_id" = "id"),
             suffix = c("_set", "_theme")) %>%
  count(name_theme, sort = TRUE)

# Joining with a one-to-many relationship ####

# Not all the tables have exactly the same observations like sets and themes, or parts and part_categories. Import and examine a new table
inventories <- readRDS("inventories.rds") # An inventory represents a product that's made up of some combination of parts.
head(inventories) # "set_num" variable suggests it links to the sets table.
# Join sets to inventories
sets %>%
  inner_join(inventories, by = "set_num") # when the joining variables have the same name.
# The sets table starts with 4977 observations, but after joining now has 5056, because each set can have multiple versions, each of which gets its own inventory item. Filter this joined table for only the first version
sets %>%
  inner_join(inventories, by = "set_num") %>%
  filter(version == 1) # results a table with 4976 observations, comparied to 4977 in sets table. This means there's 1 set that doesn't have version 1, which is probably a data quality issue.
# An inner_join keeps only an observation if it has an exact match between the first and the second tables. Paying attention to the number of rows before and after a join is an important part of understanding data.

# Import and examine the tables "parts" and "part_categories"
parts <- readRDS("parts.rds")
head(parts)
part_categories <- readRDS("part_categories.rds")
head(part_categories)
# The part_cat_id variable in parts table links to the id variable in the part_categories table. Join 2 tables and add a suffix to distinguish the names
parts %>%
  inner_join(part_categories, by = c("part_cat_id" = "id"),
             suffix = c("_part", "_category"))
# Each LEGO piece has another attribute besides its part, its color, which are found in inventory_parts table. Import and examine
inventory_parts <- readRDS("inventory_parts.rds")
head(inventory_parts)
#  The colors table tells the color of each part in each set
colors <- readRDS("colors.rds")
head(colors)
# Connect the parts and inventory_parts tables by their part numbers 
parts %>%
  inner_join(inventory_parts, by = "part_num") # results in one-to-many relationship.
# An inner_join works the same way with either table in either position
inventory_parts %>%
  inner_join(parts, by = "part_num")

# Joining three or more tables ####

# Multiple tables could be joined using inner_join and pipe %>%
sets %>%
  inner_join(inventories, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"), suffix = c("_set","_theme"))
# Now connect sets, a table that tells us about each LEGO kit, with inventories, a table that tells us the specific version of a given set, and finally to inventory_parts, a table which tells us how many of each part is available in each LEGO kit, and colors. Find out which color is the most common of a LEGO piece.
sets %>%
  inner_join(inventories, by = "set_num") %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  inner_join(colors, by = c("color_id" = "id"), suffix = c("_set", "_color")) %>%
  count(name_color, sort = TRUE)