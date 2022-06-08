library(tidyverse)
# Contingency Tables with two variables
# read in dataset
dt <- read.csv("./ibda/EBIS3103_week_4_R and Data/projects.csv")
# choose grade level and poverty level
dt %>% 
  select(grade_level, poverty_level) %>%
  table() %>%
  prop.table()
# three variables
# unlike two variables
# it will give several tables depends on different type of third one
dt %>%
  select(grade_level,poverty_level, resource_type) %>%
  table()

# Population: all item of interest for a particular decision or investigation
# Sample: a asubset of the population
# Sampling Frame:
# Sampling Frame is the list of cases in the target population 
# from which the sample is actually drawn
# An example:
# Sampling frame: the group of cutomers have tehe ability to contact with your survey
# Sample: The group of customers you actually contact with and who actually fill it out


# ------------ Some basic statistical variable
# mean, mode, median will not be discussed
# Midrange: This kind of variable is the average of largest and smallest value
# in the dataset
# Some drawback: extreme values easily distort the result (often use only on small sample sizes)

library(modeest)
dt %>% 
  rename(size = total_price_excluding_optional_support) %>%
  summarise(mean(size), median(size), mfv(size))

dt %>%
  rename(size = total_price_excluding_optional_support) %>%
  select(size) %>%
  filter(size < 3000) %>%
  ggplot(aes(x = size)) +
  geom_histogram() + 
  theme_classic()

# Dispersion refers to the degree of variation(numericla spread or compactness) in the data

# Range: the difference between maximum and minimum data values
# IQR: difference between the first and third quartiles 
# Variance
# Standard deviation: notice that std bigger, the function is more flattened

# Chebyshev's Theorem
# For any dataset, the proportion of values that lie within k(k>1),
# it's std of the mean is at least 1 - 1/k^2
# 举个例子，若k=2， 则至少有3/4 data 位于 two standard deviations of the mean 之间


# Empirical rules
# For normally distributed dataset
# For k = 1, about 68% of data lie with in one std of the mean
# For k = 2, about 95% of lie within two std of the mean
# For k = 3, about 99.7% of data lie within two std of the mean

# Standardized Values
# A standardized value, known as z-score, provides a relative measure of the distance
# and observation is from the mean
# formula: zi = (xi - x_bar)/s
# explanation:
# numerator represents the distance that xi is from the sample mean;
# a negative value indicates xi lies to the left of the mean
# a positive value indicates xi lies to the right of the mean
# dividing std, scale the distance from the mean to express it in units of 
# standard deviation.
# Thus, a z-score of 1.0 means that observation is one std to the right of mean
# a z-score of -1.5 means that the observation is 1.5 std to the left of the mean
dt %>%
  rename(size = total_price_excluding_optional_support) %>%
  select(size) %>%
  filter(size < 3000) %>%
  
  ggplot(aes(x=size)) +
  # The empirical cumulative distribution function (ECDF) provides an alternative visualisation of 
  # ECDF doesn't require any tuning parameters and handles both continuous and categorical variables.
  stat_ecdf(geom = "step") +
  theme_classic()

# some table
dt %>%
  rename(size = total_price_excluding_optional_support) %>%
  group_by(poverty_level) %>%
  summarise(mean(size), median(size), sd(size), max(size), min(size))

dt %>%
  group_by(poverty_level) %>%
  summarise(n = n()) %>%
  mutate(prop = n / sum(n))


# Coefficient of variation
# The coefficient of variation (CV) provides a relative measure of 
# dispersion in data relative to the mean
# formula:
# CV = std/Mean
# Return to risk = 1/CV , easier to interpret, especially in financial risk analysis
# The sharp ratio is a related measure in finance

# ---------- Skewness
# describes the lack of symmetry of data
# skew-right, skew-left or centralize
# Coefficient of Skewness(CS):
# Formula:
# CS = 1/N * sum(xi-u)**3 * 1/std**3
mean((d - mean(d))/sd(d)^3)
# 当cs是负数，代表 left skewed,即左边的数据多于右边
# 正数， 则代表 right skewed，即右边的数据多余左边
# |CS| > 1 代表high degree of skewness
# 0.5 <= |CS| <= 1 代表moderate(缓和的) skewness
# |CS| < 0.5 代表 relative symmetric

# Kurtosis 峰度
# refers to the peakedness(high, narrow) or flatness(short, flat-topped)
# of a histogram
# formula:
# CK = mean(xi - u)**4 / std**4
# CK<3 indicates the data is somewhat flat with a wide degree of dispersion
# CK>3 indicates the data is somewhat peaked with less dispersion

# --------------- Measure association
# covariance
# formula COV(x,y) = mean(xi - ux)(yi - uy)
# 见回归笔记, 协方差反映了变量之间的相关程度大小
dt %>%
  filter(total_price_excluding_optional_support < 3000) %>%
  ggplot(aes(total_price_including_optional_support, total_donations)) +
  geom_point(size = 0.5) +
  theme_classic() + 
  xlab("Requested") +
  ylab("Donated")

# Measure of association----- correleation
# explanation a measure of the linear association between two variables
# Formula:
# corr = cov(a,b) / std_a*stdb
# range in -1 to 1, where 0 means no linear relationship, 1 means positive,-1 means negative relationship

# --------- Pearson, Spearman and kendall
# For Pearson r correlation, both variables should be normally distributed 

# a perfect Spearman correlation indicates monotonic(单调的) relationship, whereas a
# perfect Pearson correlation indicates a linear relationship

# Kendall rank correlation is a non-parametric test that measures the 
# strength of dependence between two variables. If considerign two sapmles
# a, b, where each sample size is n, tgeb we know that the total number of pairing with 
# a,b is n*(n-1)/2
# formula: t = (n_c - n_d)/ 0.5*n*(n-1)
# where nc is number of concordant(ordered in the same way)
# nd = number of discordant(ordered in the different way)
# 即两个元素一致，对于a,b两个集合， ai>aj 且 bi>bj,则说明两个元素一致
# 否则不一致

# 比较: Kendall is more interpretable, it approaches a normal distribution
# more rapidly as sample size increases; thus, for small dataset, kendal is preferred
# Computation complexity:
# Kendall's: O(n^2)
# Spearmans: o(nlogn)

cov(dt$total_price_including_optional_support, dt$total_donations, use = "complete.obs")
# use method to point out different cov function 
cov(dt$total_price_including_optional_support, dt$total_donations, use = "complete.obs",method = "kendall")
cor(dt$total_price_including_optional_support, dt$total_donations, use="complete.obs")
library(psych)
# done some correlation test
corr.test(dt %>% select(students_reached, total_donations,num_donors, total_limited_base))

# draw correltaion matrix
library(GGally)
ggcorr(dt %>% select(students_reached, total_donations, num_donors, total_limited_base))

# outlier:
# an observation that lies an abnormal distance from other observations in a 
# random sample from a population

# some rules of thumbs
# z-scores >+3 or <-3 (<0.3% of total observations in a normal distribution)
# Extreme outliers are observations located outside of Q1 - 3 * IQR or Q3 + 3 * IQR
# Mild outliers are observations located outside of Q1 - 1.5 * IQR or Q3 + 1.5 * IQR
