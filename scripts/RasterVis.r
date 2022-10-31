# install required packages
install.packages('devtools')
install_github('loicdtx/bfastSpatial')
install.packages("rgdal")
install.packages("raster")
# load packages
require("devtools")
require("bfastSpatial")
require("rgdal")
require("raster")
require("tools")
# Define the input and output directory
indir <- "PATH TO THE DATA"
outdir <- "PATH TO THE OUTPUT"
#PC example: indir <- "C:/my/data/directory"
#Mac or Linux example: indir <- "/my/data/directory"
dir.create(outdir, showWarning = FALSE)
crop_file <- "PATH TO THE SHAPEFILE CO5.shp"
# Locate the tar files to be processed
mylist <- list.files(indir, full.names = TRUE, pattern = "*.gz")
# Read the shapefile to crop the data into the desired extent
crop_name <- file_path_sans_ext(basename(crop_file))
crop_obj <- readOGR(dsn = crop_file, crop_name, verbose = FALSE)
# Generate NDVI for the first archived file
processLandsat(x = mylist[1], vi = 'ndvi', outdir = outdir, srdir = outdir, delete = TRUE, mask = 'fmask', keep = 0, e = extent(crop_obj), overwrite = TRUE)
# Lets plot that imagery
list <- list.files(outdir, pattern = glob2rx('*.grd'), full.names = TRUE)
plot(r <- mask(raster(list[1]), crop_obj))

# Creating a multi-temporal raster object
# Create a new sub-directory to store the raster stack
outdir2 <- paste0(outdir, "/", "stack_new")
dir.create(outdir2, showWarnings = FALSE)
# Generate a file name for the output stack
stackName <- file.path(outdir2, 'CO5_Stack.grd')
# Stack the layers
s <- timeStack(x = list, filename = stackName, datatype = 'INT2S', overwrite = TRUE)
# Visualize both layers
plot(s)
# Processed to mask out the unwanted regions using the crop_obj
plot(mask(s, crop_obj))