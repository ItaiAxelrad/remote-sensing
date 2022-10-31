# clear workspace
rm(list=ls())
#set working directory
setwd("/Users/<username>/Desktop/data-location/...")
#install the packages 
if(!require(raster)) { install.packages("raster")}
if(!require(rgdal)) { install.packages("rgdal")}
if(!require(rasterVis)) { install.packages("rasterVis")}
if(!require(geosphere)) { install.packages("geosphere")}
if(!require(randomForest)) { install.packages("randomForest")}
if(!require(ncdf4)) { install.packages("ncdf4")}
# load packages
library(rgdal)
library(raster)
library(rasterVis)
library(geosphere)
library(randomForest)
library(ncdf4)

## --- Step I - Preprocessing of datasets --- ##

# load precipitation data
Centrends = brick("CenTrends_v1_monthly.nc",varname ="precip")
GPCC= brick("precip.mon.total.v7.nc")
TRMM = brick("prcp_trmm_2004.nc")
# Load Omogibe shapefile
gibe_shp = shapefile("omogibe.shp")
# extract only 2004 data from centrends and gpcc
dates_Centrends = names(Centrends)
dates_GPCC = names(GPCC)
# find year 2004
index_Centrends=grep("2004" ,dates_Centrends)
index_GPCC = grep("2004" ,dates_GPCC)
# subset the data to 2004
Centrends = Centrends[[index_Centrends]]
GPCC = GPCC[[index_GPCC]]
# fix the coordinates of GPCC and TRMM
# rotate gpcc and trmm data, but centrends is correct(no need to rotate)
GPCC = rotate(GPCC)
TRMM = rotate(TRMM)
# crop the datasets to Omogibe catchment
centrends_gibe = crop(Centrends,gibe_shp) 
gpcc_gibe = crop(GPCC,gibe_shp) 
trmm_gibe = crop(TRMM,gibe_shp)

## --- Step II - Comparison of datasets --- ##

#extract mean value from the 3 datasets
centrends_avg = extract(centrends_gibe,gibe_shp,mean,na.rm=TRUE)
gpcc_avg = extract(gpcc_gibe,gibe_shp,mean,na.rm=TRUE)
trmm_avg = extract(trmm_gibe,gibe_shp,mean,na.rm=TRUE)
# create dataframe of mean values
data_mean = data.frame(Centrends = c(centrends_avg), 
                       GPCC = c(gpcc_avg), TRMM = c(trmm_avg))
# create a plot of the 3 precipitation data
plot(c(1:12) ,data_mean[ ,"Centrends"],type="l", 
     xlab="month", ylab="RF in mm/month", col="red")
lines(data_mean[,"TRMM"],col="blue")
lines(data_mean[,"GPCC"],col="black")
#Comparingrasterdata(spatially)
#equalizetheresolutionofthedatasets
centrends_gibe = projectRaster(centrends_gibe,trmm_gibe)
gpcc_gibe = projectRaster(gpcc_gibe,trmm_gibe)
#plotthreerasterstogether
#1=row,3=columns
par(mfrow=c(1,3))
plot(centrends_gibe[[1]])
title("centrends")
plot(gpcc_gibe[[1]])
title("gpcc")
plot(trmm_gibe[[1]])
title("trmm")

## --- Step III - Evaluation of datasets --- ###

# calculation of RMSE error
GT = data_mean[,"Centrends"] #ground truth
RS = data_mean[,"TRMM"] #remote sensing data
# RMSE
rmse = sqrt(mean((GT-RS)^2))
# calculation of MAE
mae=mean(abs(GT-RS))
# correlation(values varies b/n 1 and -1)
correlation = cor(GT,RS)
# calculation of spatial errors
gt = centrends_gibe
rs = trmm_gibe
# step 1 calculate the difference b/n GT and RS data
diff_raster=gt-rs
# step 2 calculate the square of the difference
square_raster=(gt-rs)^2
# step 3 calculate the mean
mean_raster=stackApply(square_raster,c(1,1,1,1,1,1,1,1,1,1,1,1),mean,na.rm = TRUE)
# step4 calculate rmse for each pixel
rmse_raster=sqrt(mean_raster)
# calculation of of spatial MAE
diff_raster=gt-rs
abs_raster = abs(diff_raster)
mae_raster= stackApply(abs_raster,c(1,1,1,1,1,1,1,1,1,1,1,1),mean,na.rm = TRUE)
# export the data tables and values
write.table(dates_Centrends, "/Users/<username>/Desktop/output/dates_Centrends.txt", sep="\t")
write.table(dates_GPCC, "/Users/<username>/Desktop/output/dates_GPCC.txt", sep="\t")
# print data and values
centrends_avg
gpcc_avg
trmm_avg
correlation
GT
index_Centrends
index_GPCC
mae
rmse
RS