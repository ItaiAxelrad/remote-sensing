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

# --- CROP AND MASK --- #
# Download, unzip and load the data
download.file(url = '../data/wageningenWater.zip', destfile = 'wageningenWater.zip', method = 'auto')
unzip('wageningenWater.zip')
# Check the names of the layers for input in readOGR() ogrListLayers('Water.shp')
water <- readOGR('Water.shp', layer = 'Water')
waterUTM <- spTransform(water, CRS(proj4string(wagLandsat)))
wagLandsatSubW <- mask(wagLandsatSub, mask = waterUTM, inverse = TRUE)
plotRGB(wagLandsatSubW, 5, 4, 3)
plot(waterUTM, col = 'blue', add = TRUE, border = 'blue', lwd = 2)
# Change to the correct file path and layer name
samples <- readOGR('sampleLongLat.kml', layer = 'sampleLongLat')
# Re-project SpatialPointsDataFrame
samplesUTM <- spTransform(samples, CRS(proj4string(wagLandsatCrop)))
# The extract function does not understand why the object would have 3 coord co lumns, so we need to edit this field
samplesUTM@coords <- coordinates(samplesUTM)[, -3]
# Extract the surface reflectance
calib <- extract(wagLandsatCrop, samplesUTM, df = TRUE)
# df=TRUE i.e. return as a data.frame
# Combine the newly created dataframe to the description column of the calibration dataset
calib2 <- cbind(samplesUTM$Description, calib)
# Change the name of the first column, for convienience
colnames(calib2)[1] <- 'lc'
# Inspect the structure of the dataframe
str(calib2)
# Calibrate model
model <- randomForest(lc ~ band1 + band2 + band3 + band4 + band5 + band6 + band7, data = calib2)
# Use the model to predict land cover
lcMap <- predict(wagLandsatCrop, model = model)
levelplot(lcMap, col.regions = c('green', 'brown', 'darkgreen', 'lightgreen', ' grey', 'blue'))
# Download data
bel <- getData('alt', country = 'BEL', mask = TRUE)
# Display metadata
bel
plot(bel)
line <- drawLine()
alt <- extract(bel, line, along = TRUE)
plot(alt[[1]], type = 'l', ylab = "Altitude (m)")
# Calculate great circle distance between the two ends of the line
dist <- distHaversine(coordinates(line)[[1]][[1]][1,], coordinates(line)[[1]][[1]][2,])
# Format an array for use as x axis index with the same length as the alt[[1]] array
distanceVector <- seq(0, dist, along.with = alt[[1]])
# Visualize the output
plot(bel, main = 'Altitude (m)')
plot(line, add = TRUE)
plot(distanceVector / 1000, alt[[1]], type = 'l',
                            main = 'Altitude transect Belgium',
                            xlab = 'Distance (Km)',
                            ylab = 'Altitude (m)',
                            las = 1)
# You can choose your own country here
bel <- getData('alt', country = 'BEL', mask = TRUE) # SRTM 90m height data 
belshp <- getData('GADM', country = 'BEL', level = 2) # administrative boundaries
# Sample the raster randomly with 40 points
sRandomBel <- sampleRandom(bel, na.rm = TRUE, sp = TRUE, size = 40)
# Create a data.frame containing relevant info 
sRandomData <- data.frame(altitude = sRandomBel@data[[1]],
latitude = sRandomBel@coords[, 'y'],
longitude = sRandomBel@coords[, 'x'])
plot(bel) # Plot
plot(belshp, add = TRUE)
plot(sRandomBel, add = TRUE, col = "red")
# Plot altitude versus latitude 
plot(sRandomData$latitude, sRandomData$altitude, ylab = "Altitude (m)", xlab = " Latitude (degrees)")
