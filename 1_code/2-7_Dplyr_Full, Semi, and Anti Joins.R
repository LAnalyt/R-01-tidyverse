# 7. FULL, SEMI AND ANTI JOINS

# Load the tidyverse packages:
library(tidyverse)
# Combine inventories and inventory_parts using inner_join:
inventories <- readRDS("inventories.rds")
inventory_parts <- readRDS("inventory_parts.rds")
inventory_parts_joined <- inventories %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  select(-id, -version) %>%
  arrange(desc(quantity))
# Extract again just 2 LEGO sets "Batmobile" and "Batwing":
batmobile <- inventory_parts_joined %>%
  filter(set_num == "7784-1") %>%
  select(-set_num)
batwing <- inventory_parts_joined %>%
  filter(set_num == "70916-1") %>%
  select(-set_num)

# 7.1 The full join ####

# With left join or right join, we can see which pieces were in one but not the other? What if you want to keep all observations in both tables, whether or not they match to each other? 
batmobile %>%
  full_join(batwing, by = c("part_num", "color_id"), 
            suffix = c("_batmobile", "_batwing")) # it's like opening 2 boxes and pour them out next to each other.
# Replace NAs in quantity batmobible and batwing columns with zeros:
batmobile %>%
  full_join(batwing, by = c("part_num", "color_id"), 
            suffix = c("_batmobile", "_batwing")) %>%
  replace_na(list(quantity_batmobile = 0, quantity_batwing = 0)) # replace NAs in multiple variables by separating them with commas.

# 7.2 Compare Batman and Star Wars ####

# Now compare two themes, each is made up of many sets:
themes <- readRDS("themes.rds")
sets <- readRDS("sets.rds")
# Combine the sets table with inventory_parts_joined, then combine themes:
inventory_parts_joined %>%
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"),
             suffix = c("_set", "_theme"))
inventory_sets_themes <- inventory_parts_joined %>% 
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"), 
             suffix = c("_set", "_theme"))
# Before comparing the tables, aggregate the data to learn more about the pieces that are a part of each theme, as well as the colors of those pieces.
batman <- inventory_sets_themes %>%
  filter(name_theme == "Batman")
star_wars <- inventory_sets_themes %>%
  filter(name_theme == "Star Wars")
# Count the part number and color id, weight by quantity:
batman_parts <- batman %>%
  count(part_num, color_id, wt = quantity)
star_wars_parts <- star_wars %>%
  count(part_num, color_id, wt = quantity)
# Now that we've got separate tables for the pieces in the batman and star_wars themes, combine them to see any similarities or differences between two themes.
parts_joined <- batman_parts %>%
  full_join(star_wars_parts, by = c("part_num", "color_id"),
            suffix = c("_batman", "_star_wars")) %>% 
  replace_na(list(n_batman = 0, n_star_wars = 0))
# Gaining more information about the parts by combining this with other tables:
colors <-readRDS("colors.rds")
parts <- readRDS("parts.rds")
parts_joined %>%
  arrange(desc(n_star_wars)) %>%
  inner_join(colors, by = c("color_id" = "id")) %>%
  inner_join(parts, by = "part_num", suffix = c("_color", "_part"))

# 7.3 Semi and Anti join ####

# All the verbs inner_join, left_join, right_join and full_join belong to the mutating verbs; they combine variables from two tables. Another class of verbs is the filtering joins. A filtering join keeps observations from the first table but doesn't add new variables.

# semi-join: ask the question "What observations in 1st table are also in 2nd table?"
batmobile %>% # What parts are used in Batmobile are also used in Batwing?
  semi_join(batwing, by = c("color_id", "part_num")) 
# We still have the same variables, but the number of observations is reduced. This is useful when we want to filter down a table without modifying it further.

# anti-join: opposite of semi-join, asking the question "What observations in the 1st table are not in the 2nd table?"
# What pieces are in the Batmobile set but not in the Batwing?
batmobile %>%
  anti_join(batwing, by = c("color_id", "part_num"))

# These verbs aren't just useful to compare batman's rides, they could be used to filter down the other tables we've work with. E.g, you may want to know what themes ever appear in a set.
themes %>%
  semi_join(sets, by = c("id" = "theme_id"))
# Conversely, find themes that never appear in a set in the database:
themes %>%
  anti_join(sets, by = c("id" = "theme_id"))
# What colors are included in at least one set?
colors %>%
  semi_join(inventory_parts, by = c("id" = "color_id"))
# Which set is missing version 1?
version_1_inventories <- inventories %>% 
  filter(version == 1)
sets %>% 
  anti_join(version_1_inventories, by = "set_num")

# 7.4 Visualize set differences ####

# Examine and compare colors using in Batmobile and Batwing: first aggregate each set into colors.
batmobile_colors <- batmobile %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity))
batwing_colors <- batwing %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity))
# Combine two tables and replace NAs with zero:
colors_joined <- batmobile_colors %>%
  full_join(batwing_colors, by = "color_id",
            suffix = c("_batmobile", "_batwing")) %>%
  replace_na((list(total_batmobile = 0, total_batwing = 0))) 
# Bring the color by combining with the colors table
colors_joined <- colors_joined %>%
  inner_join(colors, by = c("color_id" = "id")) 
# The two quantities are still hard to compare because the two sets have different total numbers of pieces. Normalize each of the colors by turning them into fraction of the total:
colors_joined <- colors_joined %>% 
  mutate(total_batmobile = total_batmobile/sum(total_batmobile),
         total_batwing = total_batwing/sum(total_batwing),
         difference = total_batmobile - total_batwing) # difference between two fractions.
# See the result after processing the joined data: 
colors_joined # easily see which colors are more represented in one set or the other.

# Visualizing data using ggplot2 and forcats in tidyverse packages
color_palette <- setNames(colors_joined$rgb, colors_joined$name)
colors_joined %>%
  mutate(name = fct_reorder(name, difference)) %>%
  ggplot(aes(name, difference, fill = name)) + 
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = color_palette, guide = FALSE)
# The color bars on the right have positive differences, meaning they are more common in the Batmobile set. The colors on the left are more common in the Batwing set.

# 7.5 Compare Batman and Star Wars sets ####

# To compare two individual sets, and the kinds of LEGO pieces that comprise them, we'll need to aggregate the data into separate themes.
inventory_parts_themes <- inventories %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  arrange(desc(quantity)) %>%
  select(-id, -version) %>%
  inner_join(sets, by = "set_num") %>%
  inner_join(themes, by = c("theme_id" = "id"), suffix = c("_set", "_theme"))
# Examine and compare colors using in Batman and Star Wars sets
batman_colors <- inventory_parts_themes %>%
  filter(name_theme == "Batman") %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity)) %>%
 # add a percent column of the total divided by the sum of the total
  mutate(percent = total/sum(total))
# Repeat the steps to filter and aggregate the Star Wars set:
star_wars_colors <- inventory_parts_themes %>%
  filter(name_theme == "Star Wars") %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity)) %>%
  mutate(percent = total/sum(total))
# Combining these two sets to be able to compare the themes' colors:
colors_joined <- batman_colors %>%
  full_join(star_wars_colors, by = "color_id",
            suffix = c("_batman", "_star_wars")) %>%
  replace_na(list(total_batman = 0, total_star_wars = 0)) %>%
  inner_join(colors, by = c("color_id" = "id")) %>%
  # create the difference and total columns
  mutate(difference = percent_batman - percent_star_wars, 
         total = total_batman + total_star_wars) %>%
  # add a filter to select observations where total is at least 200
  filter(total >= 200) %>%
  mutate(name = fct_reorder(name, difference)) 
# With this combined table that contains all the information from the batman_colors and star_wars_colors tables, you can now create an informative visualization to compare the colors of these sets. 
ggplot(colors_joined, 
       aes(name, difference,
           fill = name)) + 
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = color_palette, guide = FALSE) +
  labs(y = "Difference: Batman - Star Wars")