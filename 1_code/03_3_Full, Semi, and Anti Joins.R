# 3. FULL, SEMI AND ANTI JOINS

# The full join ####

# Load tidyverse including the dplyr package
library(tidyverse)
# Combine inventories and inventory_parts using inner_join
inventories <- readRDS("inventories.rds")
inventory_parts <- readRDS("inventory_parts.rds")
inventory_parts_joined <- inventories %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  select(-id, -version) %>%
  arrange(desc(quantity))
# Extract again just 2 LEGO sets "Batmobile" and "Batwing" 
batmobile <- inventory_parts_joined %>%
  filter(set_num == "7784-1") %>%
  select(-set_num)
batwing <- inventory_parts_joined %>%
  filter(set_num == "70916-1") %>%
  select(-set_num)
# Instead of left join or right join, what if you want to keep all observations in both tables, whether or not they match to each other?
batmobile %>%
  full_join(batwing, by = c("part_num", "color_id"), 
            suffix = c("_batmobile", "_batwing")) # it's like opening 2 boxes and pour them out next to each other.
# Replace NAs in quantity batmobible and batwing columns with zeros
batmobile %>%
  full_join(batwing, by = c("part_num", "color_id"), 
            suffix = c("_batmobile", "_batwing")) %>%
  replace_na(list(quantity_batmobile = 0, quantity_batwing = 0)) # replace NAs in multiple variables by separating them with commas.

# Compare Batman and Star Wars ####

# Now compare two themes, each is made up of many sets
themes <- readRDS("themes.rds")
sets <- readRDS("sets.rds")
# Combine the sets table with inventory_parts_joined, then combine themes
inventory_parts_joined %>%
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"),
             suffix = c("_set", "_theme"))
inventory_sets_themes <- inventory_parts_joined %>% 
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"), 
             suffix = c("_set", "_theme"))
# Before comparing the tables, aggregrate the data to learn more about the pieces that are a part of each theme, as well as the colors of those pieces.
batman <- inventory_sets_themes %>%
  filter(name_theme == "Batman")
star_wars <- inventory_sets_themes %>%
  filter(name_theme == "Star Wars")
# Count the part number and color id, weight by quantity
batman_parts <- batman %>%
  count(part_num, color_id, wt = quantity)
star_wars_parts <- star_wars %>%
  count(part_num, color_id, wt = quantity)
# Now that we've got separate tables for the pieces in the batman and star_wars themes, combine them to see any similarities or differences between two themes
parts_joined <- batman_parts %>%
  full_join(star_wars_parts, by = c("part_num", "color_id"),
            suffix = c("_batman", "_star_wars")) %>% 
  replace_na(list(n_batman = 0, n_star_wars = 0))
# Gaining more information about the parts by combining this with other table
parts_joined %>%
  arrange(desc(n_star_wars)) %>%
  inner_join(colors, by = c("color_id" = "id")) %>%
  inner_join(parts, by = "part_num", suffix = c("_color", "_part"))
