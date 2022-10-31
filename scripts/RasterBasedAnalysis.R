#install / load the raster package 
install.packages("raster")
install.packages("rgdal")
library(rgdal)
library(raster)
r <- raster(ncol=40, nrow=20) 
class(r)
# Simply typing the object name displays its general properties / metadata 
r
# Using the previously generated RasterLayer object
# Let's first put some values in the cells of the layer
r[] <- rnorm(n=ncell(r))
# Create a RasterStack object with 3 layers
s <- stack(x=c(r, r*2, r))
# The exact same procedure works for creating a RasterBrick 
b <- brick(x=c(r, r*2, r))
# Let's look at the properties of of one of these two objects 
b
# Start by making sure that your working directory is properly set
# If not you can set it using setwd()
getwd()
download.file(url = '../data/gewata.zip', destfile = 'gewata.zip', method = 'auto')
# In case the download code doesn't work, use method = 'wget'
unzip('gewata.zip')
# When passed without arguments, list.files() returns a character vector, listi ng the content of the working directory
list.files()
# To get only the files with .tif extension
list.files(pattern = glob2rx('*.tif'))
# Or if you are familiar with regular expressions
list.files(pattern = '^.*\\.tif$')
gewata <- brick('LE71700552001036SGS00_SR_Gewata_INT1U.tif')
gewata
gewataB1 <- raster('LE71700552001036SGS00_SR_Gewata_INT1U.tif') 
gewataB1
plot(gewata, 1)
e <- drawExtent(show=TRUE)
gewataSub <- crop(gewata, e)
plot(gewataSub, 1)
# Again, make sure that your working directory is properly set
getwd()
list <- list.files(path='tura/', full.names=TRUE)
plot(raster(list[1]))
turaStack <- stack(list) 
turaStac
# Write this file at the root of the working directory
writeRaster(x=turaStack, filename='turaStack.grd', datatype='INT2S')
ndvi <- (gewata[[4]] - gewata[[3]]) / (gewata[[4]] + gewata[[3]])
plot(ndvi)
## Define the function to calculate NDVI from 
ndvCalc <- function(x) {
ndvi <- (x[[4]] - x[[3]]) / (x[[4]] + x[[3]]) return(ndvi)
}
ndvi2 <- calc(x=gewata, fun=ndvCalc)
ndvOver <- function(x, y) { ndvi <- (y - x) / (x + y) return(ndvi)
}
ndvi3 <- overlay(x=gewata[[3]], y=gewata[[4]], fun=ndvOver)
all.equal(ndvi, ndvi2) 
## [1] TRUE 
all.equal(ndvi, ndvi3) 
## [1] TRUE
## One single line is sufficient to project any raster to any projection 
ndviLL <- projectRaster(ndvi, crs='+proj=longlat')
# Since this function will write a file to your working directory
# you want to make sure that it is set where you want the file to be written
# It can be changed using setwd()
getwd()
# Note that we are using the filename argument, contained in the ellipsis (...) of
# the function, since we want to write the output directly to file.
KML(x=ndviLL, filename='gewataNDVI.kml')
## Download the data 
download.file(url='../data/tahiti.zip', destfile='tahiti.zip', method='auto') unzip(zipfile='tahiti.zip')
## Load the data as a RasterBrick object and investigate its content 
tahiti <- brick('LE70530722000126_sub.grd')
tahiti
## Display names of each individual layer
names(tahiti)
## Visualize the data 
plotRGB(tahiti, 3,4,5)
plot(tahiti, 7)
## Extract cloud layer from the brick 
cloud <- tahiti[[7]]
## Replace 'clear land' with 'NA' 
cloud[cloud == 0] <- NA
## Plot the stack and the cloud mask on top of each other 
plotRGB(tahiti, 3,4,5)
plot(cloud, add = TRUE, legend = FALSE)
## Extract cloud mask RasterLayer
fmask <- tahiti[[7]]
## Remove fmask layer from the Landsat stack 
tahiti6 <- dropLayer(tahiti, 7)
## Perform value replacement
tahiti6[fmask != 0] <- NA
## First define a value replacement function 
cloud2NA <- function(x, y){
x[y != 0] <- NA
return(x) }
# Let's create a new 6 layers object since tahiti6 has been masked already
tahiti6_2 <- dropLayer(tahiti, 7)
## Apply the function on the two raster objects using overlay
tahitiCloudFree <- overlay(x = tahiti6_2, y = fmask, fun = cloud2NA)
## Visualize the output 
plotRGB(tahitiCloudFree, 3,4,5)

