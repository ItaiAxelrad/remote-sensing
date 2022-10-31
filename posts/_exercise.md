---
title: Exercise
date: 2018-04-30
image: 'images/image13.png'
tags: ['R', 'vector', 'raster']
eleventyExcludeFromCollections: true
---

## Combining Raster and Vector

Please help me find out which "municipality" in the Netherlands is the greenest. You can use the MODIS NDVI data available here.

Hint: use `nlMunicipality <- getData('GADM',country='NLD', level=2)`

- Find the greenest Municipality:
  - In January
  - In August
  - On average over the year
- Make at least one map to visualize the results

Click here for more information about MODIS data used (i.e. MOD13A3)

Bonus: What about provinces (see `?raster::aggregate`), which province is the greenest in January?
