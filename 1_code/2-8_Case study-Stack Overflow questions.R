# 8. CASE STUDY: STACK OVERFLOW QUESTIONS

# 8.1. The Stack Overflow tables ####
# Load tidyverse
library(tidyverse) 
# Load the and examine the Stack Overflow questions about the programming language R:
questions <- readRDS("questions.rds") 
questions # almost 300,000 questions that are tagged with R.

# To get information on the tags, we need to join tables.
question_tags <- readRDS("question_tags.rds")
question_tags # matches each question, based on an ID, to a tag, which also has an ID.
tags <- readRDS("tags.rds")
tags # links tags ID to tag names.
# Joining question_tags with questions, then joining tags:
questions_with_tags <- questions %>%
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  inner_join(tags, by = c("tag_id" = "id")) 
questions_with_tags # since the questions can have multiple tags, there are 500.000 question-tag pairs in this table.
# To ensure we keep all questions, even those without a corresponding tag, use left join instead.
questions_with_tags <- questions %>%
  left_join(question_tags, by = c("id" = "question_id")) %>%
  left_join(tags, by = c("tag_id" = "id")) 
questions_with_tags # the table now has 545,684 rows.
# Since we know the questions data is all R data, we want to replace N"A with "only-R".
questions_with_tags %>% 
  replace_na(list(tag_name = "only-r"))
# This joined table reveals much more information. Do some analysis. E.g, find out most common tags:
questions_with_tags %>% 
  count(tag_name, sort = TRUE)
# Compare scores across tags:
questions_with_tags %>%
  group_by(tag_name) %>%
  summarise(score = mean(score), num_questions = n()) %>%
  arrange(desc(num_questions))
# What tags never appear on R questions?
tags %>%
  anti_join(question_tags, by = c("id" = "tag_id"))

# 8.2 Joining questions and answers ####
# Next load and examine the answer table:
answers <- readRDS("answers.rds")
answers # Stack Overflow questions are answered by other users on the site, each could zero or multiple answers, which means "one-to-many" relationship.
# Join questions and answers together:
question_answer_joined <- questions %>%
  inner_join(answers, by = c("id" = "question_id"),
             suffix = c("_question", "_answer"))
# Finding how long it takes to answer different questions:
question_answer_joined <- question_answer_joined %>%
  mutate(gap = as.integer(creation_date_answer - creation_date_question))
# See which question has the most answers and which has none:
answer_counts <- answers %>%
  count(question_id, sort = TRUE)
question_answer_counts <- questions %>% 
  left_join(answer_counts, by = c("id" = "question_id")) %>%
  replace_na(list(n = 0))
# Adding tags to identify which R topics get the most traction:
tagged_answers <- question_answer_counts %>%
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  inner_join(tags, by = c("tag_id" = "id"))
# Determine how many answers each question gets on average:
tagged_answers %>% group_by(tag_name) %>%
  summarise(questions = n(), average_answers = mean(n)) %>%
  arrange(desc(questions))

# 8.3 The bind_rows verb ####
# In some situations, instead of joining one variable next to each other, we may want to stack one on top of the other by binding rows.
posts <- questions %>%
  bind_rows(answers) # the question_id column of first observations has NA because those are questions originally, and only the answers table has that column.
# Keep track of which observations are questions and which are answers
questions_type <- questions %>%
  mutate(type = "question")
answers_type <- answers %>%
  mutate(type = "answer")
posts <- questions_type %>%
  bind_rows(answers_type)
# Aggregate the new table:
posts %>%
  group_by(type) %>%
  summarise(average_score = mean(score)) # average score is higher.
# Creating a date variable using lubridate package:
library(lubridate)
# year(): takes a date and turns it into a relevant year.
questions_answers_year <- posts %>%
  mutate(year = year(creation_date)) %>%
  count(year, type) # find number of posts of each type by year.
# Plotting the date variable:
ggplot(questions_answers_year, 
       aes(year, n, 
           color = type)) +
  geom_line()

# Joining questions and answers with tags: 
questions_with_tags <- questions %>%
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  inner_join(tags, by = c("tag_id" = "id"))
answers_with_tags <- answers %>%
  inner_join(question_tags, by = "question_id") %>%
  inner_join(tags, by = c("tag_id" = "id"))
# Binding and counting posts with tags:
post_with_tags <- bind_rows(questions_with_tags %>% 
                              mutate(type="question"), 
                            answers_with_tags %>% 
                              mutate(type = "answer"))
# Add a year column, then aggregate by type, year, and tag_name:
by_type_year_tag <- post_with_tags %>% 
  mutate(year = year(creation_date)) %>%
  count(type, year, tag_name)
# Visualize questions and answers for the dplyr and ggplot2 tag names: 
by_type_year_tag_filtered <- by_type_year_tag %>%
  filter(tag_name == "dplyr" | tag_name == "ggplot2")
# Create a line plot faceted by the tag name 
ggplot(by_type_year_tag_filtered, aes(year, n, color = type)) +
  geom_line() +
  facet_wrap(~ tag_name) # the plot shows dplyr has more answer than ggplot2.
