library("car")
library('dplyr')
data("iris")
names(iris)
X <- iris[ ,colnames(iris) %in% c("Sepal.Length", "Sepal.Width",  "Petal.Length", "Petal.Width")]
scatterplotMatrix(iris[,1:4], smooth=F, diagonal = TRUE)

species <- group_by(iris, Species)
scatterplotMatrix(X, smooth=F, diagonal = TRUE, groups = iris$Species)

