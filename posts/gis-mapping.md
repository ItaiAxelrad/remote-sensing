---
title: GIS Mapping
---
## Introduction

There are many software solutions that will allow you to make a map. Some of them are free and open source (_e.g._ [GRASS](grass.osgeo.org/)) or not (_e.g._ [ArcGIS](http://www.arcgis.com/features/)). The argument between R and something that isn't free is pretty self-explanatory, but why would we want to do our GIS tasks in R over something else like GRASS that was designed for this purpose? My usual answer is that I prefer a nice workflow all in R - I like the continuity. I also like leveraging my R programming know-how (e.g. data manipulation, loops, etc) to do complex and/or repeated operations that might take longer to click through or learn how to automate in some other program.

You just need to find the right tool for the job, sometimes that will be R, and other times it will be a dedicated GIS program. Also, R and GRASS can [interact](http://grasswiki.osgeo.org/wiki/R_statistics) providing an intermediate solution. All that being said, it helps to know what R can do when you're choosing your tool.

## Load Packages

Load the required packages (also `install.packages()` if necessary)

```r
library(maptools)
library(rgdal)
```

Plus these packages if you want to go through the examples at the bottom:

```r
library(raster)
library(maps)
library(mapdata)
library(ggmap)
library(marmap)
library(lattice)
```

## Getting your data off your GPS

If your GPS can export to `.gpx` format, you can read the file directly as lines (i.e. `tracks`), points (i.e. `track_points`), and a few other formats you can find in the help for `readOGR`. To download the example `.gpx`, click [here](http://www.wolferonline.de/uploads/run.gpx)

```r
run <- readOGR(dsn="run.gpx",layer="tracks")
plot(run)

run <- readOGR(dsn="run.gpx",layer="track_points")
plot(run)
```

If your GPS cannot save in `.gpx` format, you will have to resort to [GPSBabel](http://www.gpsbabel.org/) to convert your file(s) from the proprietary file format to `.gpx`. Interestingly, to streamline your workflow and make your work reproducible, R can interact with GPSBabel directly through the [`readGPS()`](http://www.inside-r.org/packages/cran/maptools/docs/readGPS) function which is in the `maptools` package

## Getting a base map

There are a few ways to get this type of thing in R, I'll cover many of these in a future lesson, but for now let's just use a simple world map from the `maptools` package:

```r
data(wrld_simpl)
```

Let's plot that to see what we have

```r
plot(wrld_simpl)
```

Or we can 'zoom in' on a particular spot if we provide limits

```r
xlim=c(-130,-60)
ylim=c(45,80)
plot(wrld_simpl,xlim=xlim,ylim=ylim)
```

We can also give it some color

```r
plot(wrld_simpl,xlim=xlim,ylim=ylim,col='olivedrab3',bg='lightblue')
```
![Image bathymetry](/images/Canada.png)

I know, the map projection is not awesome, we're going to cover that in another future lesson. 

> **Challenge problem 1**
>
> Can you zoom in to your home town?
>

## Exporting and Importing

Now that we know how to get a super basic map in R, let's look at how we can export and import data. The `writeOGR()` function will write an ArcGIS compatible shapefile, in one of many different formats - you just need to find the correct driver.

```r
writeOGR(wrld_simpl,dsn=getwd(), layer = "world_test", driver = "ESRI Shapefile", overwrite_layer = TRUE)
```

Now we could open `world_test.shp` in ArcGIS, but we can also import shapefiles back into R, let's use that same file

```r
world_shp <- readOGR(dsn = getwd(),layer = "world_test")
plot(world_shp)
```

## Spatial data types in R

### Vector-based (points, lines, and polygons)

Creating spatial data from scratch in R seems a little convoluted to me, but once you understand the pattern, it gets easier.

#### SpatialPointsDataFrame

Let's plot points on Simon Fraser University and the University of Toronto.

```r
coords <- matrix(c(-122.92,-79.4, 49.277,43.66),ncol=2)
coords <- coordinates(coords)
spoints <- SpatialPoints(coords)
df <- data.frame(location=c("SFU","UofT"))
spointsdf <- SpatialPointsDataFrame(spoints,df)
plot(spointsdf,add=T,col=c('red','blue'),pch=16)
```

![Image bathymetry](/images/worldwithpoints.png)

#### SpatialLinesDataFrame

Let's plot the borders of the province of Saskatchewan because they're easy to draw (but not to spell).

```r 
coords <- matrix(c(-110,-102,-102,-110,-110,60,60,49,49,60), ncol=2)
l <- Line(coords)
ls <- Lines(list(l),ID="1")
sls <- SpatialLines(list(ls))
df <- data.frame(province="Saskatchewan")
sldf <- SpatialLinesDataFrame(sls,df)
plot(sldf,add=T,col='black')
```

![Image bathymetry](/images/worldwithlines.png)

#### SpatialPolygonsDataFrame

Let's plot the province of Saskatchewan because it's easy to draw (but not to spell).

```r
coords <- matrix(c(-110,-102,-102,-110,-110,60,60,49,49,60),ncol=2)
p <- Polygon(coords)
ps <- Polygons(list(p),ID="1")
sps <- SpatialPolygons(list(ps))
df <- data.frame(province="Saskatchewan")
spdf <- SpatialPolygonsDataFrame(sps,df)
plot(spdf,add=T,col='red')  
```

![Image bathymetry](/images/worldwithpoly.png)

> **Challenge problem 2**
>
> Can you plot a point on your home town?
>

## Making nicer maps

The `raster` package for basic maps that interact well with spatial objects we used above, unlike many other packages, this method 'plays nice' with another spatial object from the `sp` package and can use proper projections. We can download polygons for Canada from [GADM](http://gadm.org/about) (amongst other sources) with the country code `"CAN"`, and level=1 indicates provinces, `0` would be the whole country.

```r
Canada <- getData('GADM', country="CAN", level=1)
plot(Canada)
```

![Image bathymetry](/images/CanadaGADM.png)

We can manipulate this `SpatialPolygonDataFrame` by looking at what is inside its dataframe.

```r
Canada
```

We can see that the names of the provinces are in `Canada$NAME_1, so let's use that to extract provinces.

```r
NS <- Canada[Canada$NAME_1=="Nova Scotia",]
plot(NS,col="blue")

NB <- Canada[Canada$NAME_1=="New Brunswick",]
plot(NB,col="yellow",add=TRUE)

PEI <- Canada[Canada$NAME_1=="Prince Edward Island",]
plot(PEI,col="red",add=TRUE)
```

Let's plot points in Moncton, Halifax, and Charlottetown.

```r
coords <- matrix(cbind(lon=c(-64.77,-63.57,-63.14),lat=c(46.13,44.65,46.24)),ncol=2)
coords <- coordinates(coords)
spoints <- SpatialPoints(coords)
df <- data.frame(location=c("Moncton","Halifax","Charlottetown"),pop=c(138644,390095,34562))
spointsdf <- SpatialPointsDataFrame(spoints,df)
scalefactor <- sqrt(spointsdf$pop)/sqrt(max(spointsdf$pop))
plot(spointsdf,add=TRUE,col='black',pch=16,cex=scalefactor*10)    
```

![Image bathymetry](/images/maritimes.png)

##### The `maps` and `mapdata` packages for basic maps

Coordinates that highlight the scale of the map.

```r
Lat.lim=c(42.5,49)
Long.lim=c(-69,-59)
```

Locations of interest - these examples correspond to the tips of PEI and the province's best city

```r
Site.Longs=c(-61.9,-64,-63.8)
Site.Lats=c(46.5,47.2,46.4)
Site.Names=c("Souris","Tignish","Summerside")
```

Make the map. Here you can play with the fill color (now grey) and a few other tweaks.

```r
map("worldHires", xlim=Long.lim, ylim=Lat.lim, col="grey", fill=TRUE, resolution=0);map.axes();
map.scale(ratio=FALSE) # do you want a scale?

points(Site.Longs,  Site.Lats,pch=19) #Add points if you have data in Site.Longs and Site.lats
points(-61.6,47.7,pch = 8 ) # this will add point a single point (*) to the Maggies 
text(Site.Longs,Site.Lats,labels=Site.Names,pos=4, offset=0.3) # add labels
text(-61.6,47.7,labels="Ilse de Madeleine",pos=4, offset=0.3) # add label to an individual plot
```

![Image bathymetry](/images/maritimes2.png)

> **Challenge problem 3**
>
> Can you label your home town?
>

##### The `ggmap` package for Google Maps

This package is great particularly if you are familiar with the `ggplot2` plotting grammar. You may also come across the `RgoogleMaps` package, but I do not recommend using it because it seems to have a grammar unique to that package (i.e. not compatible with base plotting or `ggplot2`) and has strange scaling behavior.

```r
google <- get_map(location = c(-64.4,45.08), zoom = 10, maptype = "satellite")
p <- ggmap(google)
p + geom_point(aes(x=c(-64.36,-64.4),y=c(45.08,45.1)),colour='yellow',size=3)
```

![Image bathymetry](/images/google.png)

##### The `marmap` package for bathymetry

If you're an oceanographer like myself, you will love this package! It can query and plot NOAA's bathymetry databases. Let's define some colors for sea and land:

```r 
blues <- colorRampPalette(c("darkblue", "cyan"))
greys <- colorRampPalette(c(grey(0.4),grey(0.99)))
```

We can query the NOAA databases for bathymetry at a 1-minute resolution, but let's do 10 to keep download speeds reasonable.

```r
atl<- getNOAA.bathy(-75,-50,30,60,resolution=10)
```

After that's done we can plot some nice 2d and 3d plots (we will cover the details in a later study group)

```r
plot.bathy(atl,
           image = TRUE,
           land = TRUE,
           n=0,
           bpal = list(c(0, max(atl), greys(100)),
                       c(min(atl), 0, blues(100))))
```

![Image bathymetry](/images/bathy.jpg)

```r   
wireframe(unclass(atl), drape = TRUE,
          aspect = c(1, 0.1),
          scales = list(draw=F,arrows=F),
          xlab="",ylab="",zlab="",
          at=c(min(atl)/100*(99:0),max(atl)/100*(1:99)),
          col.regions = c(blues(100),greys(100)),
          col='transparent')
```

![Image 3d bathymetry](/images/bathy3d.jpg)

```r
wireframe(unclass(atl), shade = TRUE,
          aspect = c(1, 0.1),
          scales = list(draw=F,arrows=F),
          xlab="",ylab="",zlab="")
```

![Image shaded 3d bathymetry](/images/bathy3dshaded.jpg)
  
## Other great resources

- <http://pakillo.github.io/R-GIS-tutorial/#plot>
- <http://www.milanor.net/blog/?p=594>
- <http://www.kevjohnson.org/making-maps-in-r-part-2/>
