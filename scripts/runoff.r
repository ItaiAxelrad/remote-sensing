rm(list=ls())
# set working directory
setwd("/Users/<user>/Desktop/.../Data/")
# load required libraries
library("raster")
# load the GRACE data
grace=brick("GRCTellus.JPL.200204_201701.LND.RL05_1.DSTvSCS1411.nc")
# rotate the GRACE data
grace = rotate(grace)

# AMAZON river basin
# load the required shapefile
shp_amazon = shapefile("amazon.shp")
# add projection to shapefile
projection(shp_amazon) = projection(grace)
# extract the mean values
grace_amazon = extract(grace, shp_amazon, mean, na.rm=TRUE)
grace_amazon = c(grace_amazon)
grace_amazon = grace_amazon[19:54]
# ds/dt
grace_dsdt = diff(grace_amazon)
View(grace_amazon)
View(grace_dsdt)

# NILE river basin
# load the required shapefile
shp_nile = shapefile("nile_el_ek.shp")
# add projection to shapefile
projection(shp_nile) = projection(grace)
# extract the mean values
grace_nile = extract(grace, shp_nile, mean, na.rm=TRUE)
grace_nile = c(grace_nile)
grace_nile = grace_nile[19:54]
# ds/dt
grace_dsdt = diff(grace_nile)
View(grace_nile)
View(grace_dsdt)

# MISSISSIPPI river basin
# load the required shapefile
shp_mississippi = shapefile("mississippi.shp")
# add projection to shapefile
projection(shp_mississippi) = projection(grace)
# extract the mean values
grace_mississippi = extract(grace, shp_mississippi, mean, na.rm=TRUE)
grace_mississippi = c(grace_mississippi)
grace_mississippi = grace_mississippi[19:54]
# ds/dt
grace_dsdt = diff(grace_mississippi)
View(grace_mississippi)
View(grace_dsdt)