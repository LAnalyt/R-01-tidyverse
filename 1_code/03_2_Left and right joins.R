# 2. LEFT AND RIGHT JOINS

# The left_join verb ####

# Load tidyverse including the dplyr package
library(tidyverse)
# Combine inventories and inventory_parts using inner_join
inventories <- readRDS("inventories.rds")
inventory_parts <- readRDS("inventory_parts.rds")
inventory_parts_joined <- inventories %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id"))
# For simplicity, remove the id and version variables since we don't need them. Arrange to sort in order of quantity, which represents how many of a piece appear in each set.
inventory_parts_joined <- inventory_parts_joined %>%
  select(-id, -version) %>%
  arrange(desc(quantity))
# Extract just 2 LEGO sets "Batmobile" and "Batwing" based on their set numbers 
batmobile <- inventory_parts_joined %>%
  filter(set_num == "7784-1") %>%
  select(-set_num)
batwing <- inventory_parts_joined %>%
  filter(set_num == "70916-1") %>%
  select(-set_num)
# This results in 2 new tables with each observation isn't just a part, but a combination of a part and color. Join them by combining 2 variables form the second table
batmobile %>%
  inner_join(batwing, by = c("part_num", "color_id"), # specify multiple columns to join in with "by = c("column 1", "column 2")".
             suffix = c("_batmobile", "_batwing")) # add suffixes to tell the quantity of batmobile and batwing apart.

# What if we just want to keep parts that are in the Batmobile but not the Batwing? An inner join keeps only observations that appear in both tables. Keep all the observations in one table with left_join verb
batmobile %>%
  left_join(batwing, by = c("part_num", "color_id"),
            suffix = c("_batmobile", "_batwing")) # the pieces that didn't appear in inner_join now show up in the first table.
# Left join means keeping all the observations in the first, or "left", of the two tables, whether or not it occurs in the second, or "right" table.

# Left joining two sets and colors ####

# Extract just 2 LEGO sets "Millennium Falcom" and "Star Destroyer" based on their set numbers
millennium_falcom <- inventory_parts_joined %>% 
  filter(set_num == "7965-1")
star_destroyer <- inventory_parts_joined %>%
  filter(set_num == "75190-1")
# Combine the two sets by part and color using left_join
millennium_falcom %>% 
  left_join(star_destroyer, by = c("part_num", "color_id"),
            suffix = c("_falcon", "_star_destroyer"))

# What if joining two datasets by color alone?
# Aggregate Millennium Falcon and Star Destroyer for the total quality in each part
millennium_falcom_colors <- millennium_falcom %>%
  group_by(color_id) %>%
  summarise(total_quantity = sum(quantity))
star_destroyer_colors <- star_destroyer %>%
  group_by(color_id) %>%
  summarise(total_quantity = sum(quantity))
# Left join two datasets using color_id
millennium_falcom_colors %>%
  left_join(star_destroyer_colors, by = "color_id",
            suffix = c("_falcon", "_star_destroyer"))

# Finding an observation that doesn't have a match ####

# Left joins are really great for testing your assumption about a dataset and ensuring your data has an interity. E.g, the "inventories" table has a "version" column, for when a LEGO kit gets some kind of change or update. Assume that all sets would have at least a version 1
inventories <- readRDS("inventories.rds")
sets <- readRDS("sets.rds")
inventory_version_1 <- inventories %>%
  filter(version == 1)
# Test the assumption by joining versions to sets
sets %>% left_join(inventory_version_1, by = "set_num") %>%
  # filter where version is na
  filter(is.na(version))

# The right_join verb ####

# The right joins are mirror images of left joins. A right join keeps all the observations in the second (or "right") table, whether or not they appear in the first table.
batmobile %>%
  right_join(batwing, by = c("part_num", "color_id"),
             suffix = c("_batmobile", "_batwing"))

# Count and sort ####

# Calculate the number of sets that has each theme id
sets %>%
  count(theme_id, sort = TRUE)
# The useful information for "theme_id" is in another table called "themes". Import and examine this table
themes <- readRDS("themes.rds")
# Add theme name for more infos
sets %>%
  count(theme_id, sort = TRUE) %>%
  inner_join(themes, by = c("theme_id" = "id"))
# Specifically, any themes that never occurred in any set in this database would not appear. A right join would keep those themes that never occurred.
sets %>%
  count(theme_id, sort = TRUE) %>%
  right_join(themes, by = c("theme_id" = "id"))
# Replace NA with zero
sets %>%
  count(theme_id, sort = TRUE) %>%
  right_join(themes, by = c("theme_id" = "id")) %>%
  replace_na(list(n = 0))

# Counting part colors ####

# Import the tables "parts" and "part_categories"
parts <- readRDS("parts.rds")
part_categories <- readRDS("part_categories.rds")
# Sometimes you'll want to do some processing before you do a join, and prioritize keeping the second (right) table's rows instead
parts %>%
  count(part_cat_id, sort = TRUE) %>%
  # count before right join because we don't only want to knowt the count of part_cat_id in "parts" but we also want to know if there is any part_cat_id not presents in "parts"
  right_join(part_categories, by = c("part_cat_id" = "id")) %>%
  # filter for where the column n is NA
  filter(is.na(n == TRUE ))
# Replace NA with zero
parts %>%
  count(part_cat_id, sort = TRUE) %>%
  right_join(part_categories, by = c("part_cat_id" = "id")) %>%
  replace_na(list(n = 0))

# Joining tables to themeselves ####

# In the themes table, beside theme_id and name, there's also a parent_id column. This indicates a hierarchiral table. By joining a table to itself we can explore the relationship between themes and parents
themes %>%
  inner_join(themes, by = c("parent_id" = "id"),
             suffix = c("_child", "_parent"))
# E.g, there're LEGO sets that are themed around the fantasy series "The Lords of the Rings"
themes %>%
  inner_join(themes, by = c("parent_id" = "id"),
             suffix = c("_child", "_parent")) %>%
  filter(name_child == "The Lord of the Rings")
# Find out all of the children of that theme instead
themes %>%
  inner_join(themes, by = c("parent_id" = "id"),
             suffix = c("_child", "_parent")) %>%
  filter(name_parent == "The Lord of the Rings")
# Based on all this, we start understanding the shape of the data.

# Discover what children of the "Harry Potter" theme are
themes %>%
  inner_join(themes, by = c("parent_id" = "id"),
             suffix = c("_child", "_parent")) %>%
  filter(name_parent == "Harry Potter")

# Some themes might not have any children at all, which means they won't be included in the inner join. Left join a table to itself
themes %>%
  left_join(themes, by = c("id" = "parent_id"), suffix = c("_parent", "_child")) %>%
  filter(is.na(id_child) == TRUE)

# Joining themes to their grandchildren ####

# Go one step further by inner joining themes to a filtered version of itself again to establish a connection between the last join's children and their children (or parents' grandchildren)
themes %>%
  inner_join(themes, by = c("id" = "parent_id"), 
             suffix = c("_parent", "_child")) %>%
  inner_join(themes, by = c("id_child" = "parent_id"), 
             suffix = c("_parent", "_grandchild"))