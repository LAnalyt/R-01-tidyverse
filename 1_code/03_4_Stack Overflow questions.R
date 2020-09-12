# 4. CASE STUDY: STACK OVERFLOW QUESTIONS

# Load tidyverse
library(tidyverse) 
# Load the and examine the Stack Overflow questions about the programming language R
questions <- readRDS("questions.rds") 
questions # there are almost 300.000 questions that are tagged with R.

# To get information on the tags, we need to join tables
question_tags <- readRDS("question_tags.rds")
question_tags # matches each question, based on an ID, to a tag, which also has an ID>
tags <- readRDS("tags.rds")
tags # links tags ID to tag names.
# Joining question_tags with questions, then joining tags
questions_with_tags <- questions %>%
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  inner_join(tags, by = c("tag_id" = "id")) %>%
  #replace NAs with "only-R"
  replace_na(list(tag_name = "only-r"))
# Examine the joined table
questions_with_tags # since the questions can have multiple tags, there are 500.000 question-tag pairs in this table.

# This joined table reveals much more information. Do some analysis.
# Find out most common tags
questions_with_tags %>% 
  count(tag_name, sort = TRUE)
# Compare scores across tags
questions_with_tags %>%
  group_by(tag_name) %>%
  summarise(score = mean(score), num_questions = n()) %>%
  arrange(desc(num_questions))
# What tags never appear on R questions?
tags %>%
  anti_join(question_tags, by = c("id" = "tag_id"))

# Next load and examine the answer table
answers <- readRDS("answers.rds")
answers # Stack Overflow questions are answered by other users on the site, each could zero or multiple answers, which means "one-to-many" relationship.
# Join questions and answers together
questions %>%
  inner_join(answers, by = c("id" = "question_id"),
             suffix = c("_question", "_answer"))

# Finding gaps between questions and answers
