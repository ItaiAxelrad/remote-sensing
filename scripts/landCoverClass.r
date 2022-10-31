#install / load the raster package 
if (!require(raster)) { install.packages("raster") }
if (!require(rgdal)) { install.packages("rgdal") }
if (!require(rasterVis)) { install.packages("rasterVis") }
if (!require(geosphere)) { install.packages("geosphere") }
if (!require(randomForest)) { install.packages("randomForest") }
library(rgdal)
library(raster)
library(rasterVis)
library(geosphere)
library(randomForest)

# --- LAND COVER CLASSIFICATION --- #
# Download, unzip and load the data
download.file(url = '../data/landsat8.zip', destfile = 'landsat8.zip', method = 'auto')
unzip('landsat8.zip')
# Identify the right file
landsatPath <- list.files(pattern = glob2rx('LC8*.grd'), full.names = TRUE)
wagLandsat <- brick(landsatPath)
# Loading required package: sp
# plotRGB does not support negative values, so they need to be removed
wagLandsat[wagLandsat < 0] <- NA
plotRGB(wagLandsat, 5, 4, 3)
# Download municipality boundaries
nlCity <- raster::getData('GADM', country = 'NLD', level = 2)
class(nlCity)
# Investigate the structure of the object 
head(nlCity@data)
nlCity@data <- nlCity@data[!is.na(nlCity$NAME_2),]
# Remove rows with NA
wagContour <- nlCity[nlCity$NAME_2 == 'Wageningen',]
wagContourUTM <- spTransform(wagContour, CRS(proj4string(wagLandsat)))
wagLandsatCrop <- crop(wagLandsat, wagContourUTM)
wagLandsatSub <- mask(wagLandsat, wagContourUTM)
# Set graphical parameters (one row and two columns)
opar <- par(mfrow = c(1, 2))
plotRGB(wagLandsatCrop, 5, 4, 3, main = 'Crop()')
plotRGB(wagLandsatSub, 5, 4, 3, main = 'Mask()')
plot(wagContourUTM, add = TRUE, border = "green", lwd = 3) # Reset graphical parameters
par(opar)