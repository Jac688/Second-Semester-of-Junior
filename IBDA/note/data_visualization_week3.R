# data visualization part
# using ggplot2 to draw some graphs
library(tidyverse)
library(lubridate)
dt <- read.csv("ibda/Week 3 - codes and data/projects.csv")
colnames(dt)

# draw the piechart 
# First done some basic preprocessing
dt %>% 
  select(id,poverty_level, total_price_excluding_optional_support)

# use these three kinds of value to draw a pie chart
dt %>%
  select(id,poverty_level,total_price_excluding_optional_support) %>%
  group_by(poverty_level) %>% 
  summarise(n = n()) %>%#give the current group size by using n = n()
  ggplot(aes(x="", y=n, fill = poverty_level)) +
  geom_bar(width = 1, stat = "identity") + 
  coord_polar("y", start = 0) +#change to ¼«×ø±ê
  theme_classic()

# draw a cluster bar chart, for multiple data 

dt %>% 
  select(id, poverty_level, funding_status) %>%
  ggplot(aes(x = poverty_level, fill = poverty_level)) + 
  geom_bar() + 
  facet_grid(. ~ funding_status) + 
  theme_classic()

# stacked bar chart
# better for comparing data
dt %>% 
  select(id, poverty_level, funding_status) %>%
  group_by(poverty_level,funding_status) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = funding_status, y = n,fill = poverty_level)) + 
  geom_bar(stat = "identity") + 
  theme_classic()

# Horizontal Grouped Barplot
dt %>% 
  select(id, poverty_level, funding_status) %>%
  ggplot(aes(x = poverty_level,fill = poverty_level)) + 
  geom_bar() + 
  facet_grid(. ~ funding_status) +
  coord_flip() +
  theme_classic()

# Line Charts
dt %>%
  select(total_price_excluding_optional_support, date_posted) %>%
  mutate(year = year(mdy(date_posted))) %>%
  group_by(year) %>%
  summarize(avg_size = mean(total_price_excluding_optional_support)) %>%
  ggplot(aes(year,avg_size)) + 
  geom_line() +
  theme_classic()

# Grouped Line Charts
dt %>%
  select(total_price_excluding_optional_support, poverty_level, date_posted) %>%
  mutate(year = year(mdy(date_posted))) %>%
  group_by(year,poverty_level) %>%
  summarize(avg_size = mean(total_price_excluding_optional_support)) %>%
  ggplot(aes(year, avg_size, colour = poverty_level)) + 
  geom_line() + 
  theme_classic()

# Area charts
# This kind of charts combine both pie chart and line chart
# This kind of graph present more information than pie or line charts
# but may clutter the observers' mind with too many details if too many data 
# series are used
dt %>%
  select(total_price_excluding_optional_support, total_price_including_optional_support, date_posted) %>%
  mutate(year = year(mdy(date_posted))) %>%
  group_by(year) %>%
  summarize(total_size = sum(total_price_excluding_optional_support),
            total_optional = sum(total_price_including_optional_support)) %>%
  #gather function put columns as data frame data, and given a new column name
  gather("var", "value", -year) %>%
  ggplot(aes(year,value, fill = var)) + 
  geom_area(alpha = 0.6) + 
  theme_classic()

# scatter chart 
# it's easier to show relationship between two variables
dt %>%
  sample_n(50) %>%
  ggplot(aes(total_price_excluding_optional_support, num_donors)) +
  geom_point() + 
  theme_classic()

# Bubble Charts
# This kind of chart is a specific scatter chart, in which size of data
# marker corresponds to values of a third variable
# means it can use sth like size or color to represent another dimension
# in two dimension graph
dt %>%
  sample_n(50) %>%
  ggplot(aes(total_price_excluding_optional_support, num_donors, size = num_donors)) +
  geom_point() + 
  theme_classic()

# box plot
# same as what we learn in statistic
boxplot(dt$num_donors, main="Box Plot", ylab="number of donors")

boxplot(num_donors~poverty_level,data=dt,
        main="Number of Donors", 
        xlab="Poverty Level", 
        ylab="Number of Donars")
boxplot(num_donors~poverty_level,data=dt, 
        notch=TRUE, 
        varwidth=TRUE,
        col="red",
        main="Number of Donors", 
        xlab="Poverty Level", 
        ylab="Number of Donars")

