# Draw some map data
# loading library
library(ggplot2)
library(tidyverse)
library(cowplot)
# read in csv as dataframe
EUvax <- read.csv("./ibda/Week 3 - codes and data/EUvaccine.csv")
view(EUvax)

# using ggplot2 read in map data
mapdata <- map_data("world")
View(mapdata)
mapdata <- left_join(mapdata, EUvax, by = "region")
# select map data whether vaccinated is not na
mapdata1 <- mapdata %>%
  filter(!is.na(mapdata$Perc_vaccinated))
View(mapdata1)

# use ggplot draw the graph
map1 <- ggplot(mapdata1, aes(x = long, y = lat, group = group)) + 
  # 画多边形
  geom_polygon(aes(fill = Perc_vaccinated), color = "black")
map1
# 改变地图1的变化方式，低为黄色，高位红色，na为灰色
# 主题中x和y轴的文字不做更改，标记号不做更改，后面的矩形的各项元素也为空
map2 <- map1 + scale_fill_gradient(name = "% vaccinated", low = "yellow", high =  "red", na.value = "grey50")+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        rect = element_blank())
map2
#添加一些图例
ggdraw() +
  draw_image("vac.jpg",  x = 0.4, y = 0.25, scale = .1) +
  draw_plot(map2)
