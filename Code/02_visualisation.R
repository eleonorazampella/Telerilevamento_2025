# R code for visualazing satellite data 

# install.packages("devtools")
library(devtools)
install_github("ducciorocchini/imageRy")

library(terra)
library(imageRy)

im.list()

# for the whole corse we are going to make use of =instead of <-
b2 = im.import("sentinel.dolomites.b2.tif")
cl= colorRampPalette(c("black", "dark grey", "light gray"))(100)

plot(b2, col=cl)

# exercize :make your own color map 

cl= colorRampPalette(c("blue", "royalblue3", "red1"))(100)
plot(b2, col=cl)
