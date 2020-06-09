#######################################################################
# Author: Dietz Vollrath
# 
# Find nearest neightbor Eth Atlas societies for each DHS cluster
# 1. Load the EA data
# 2. Load DHS data
# 3. Compute distances
#
#######################################################################

message(sprintf("--Get GADM district identifiers: %s\n", survey))

suit <- header # get header information for DHS cluster villages

## Extract GADM district OBJECTID from the raster for each village in DHS
extr <- over(shape,gadm) # get GADM shape data for points in DHS shape file
suit <- data.frame(suit,extr) # combine DHS header data with GADM data

colnames(extr) <- c("ID","OBJECTID") # rename columns of extracted data
out <- data.frame(suit,extr[2]) # merge GADM identifier with DHS header data

# Write merged data to file based on survey name
write.csv(out,file.path(workdir,paste0(survey,"-gadm.csv")),row.names=FALSE, na="")