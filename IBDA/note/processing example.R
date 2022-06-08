library(dplyr)
library(readr)
library(ggplot2)
dt <- read.csv("ibda/Week 3 - codes and data/donors.csv")
# draw histogram
dt %>% 
  select(state) %>%
  group_by(state) %>% 
  summarise(n = n()) %>%
  sample_n(10) %>%
  ggplot(aes(state,n) + 
  geom_bar(stat = "identity") +
  theme_classic())

# calculate relative frequency
dt %>% 
  select(state) %>%
  group_by(state) %>% 
  summarise(n = n()) %>%
  mutate(freq = n/sum(n)) %>%
  sample_n(10) %>%
  ggplot(aes(state,freq)) + 
  geom_bar(stat = "identity") +
    theme_classic()

# Histogram
# for numerical data
dt %>% filter(num_projects <= 10) %>%
  ggplot(aes(x = num_projects)) + 
  geom_histogram() +
  theme_classic()

# use cut to divide donation into range
dt %>% filter(total_donations < 2000) %>% 
  mutate(bins = cut(total_donations, breaks = 10, dig.lab = 4)) %>% 
  group_by(bins) %>%
  summarise(count = n()) %>%
  arrange(bins) %>%
  mutate(cumulative_freq = cumsum(count), relative_cum_freq = cumulative_freq / sum(count))
  