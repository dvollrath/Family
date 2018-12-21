#######################################################################
# Author: Dietz Vollrath
# 
# Extract Terrain data
#######################################################################

message(sprintf("--Extract GAEZ terrain data for: %s\n", survey))

suit <- header # copy header information

# three types of terrain maps
maps <- c("gaez-slope-index", "gaez-slope-class", "gaez-mean-altitude")

for (m in maps) { # for every crop given
  message(sprintf("--Processing: %s", m))
  d <- paste0(gaezdir,"/",m) # build file name for crop
  gaez <- raster(file.path(d,"data.asc")) # load raster for crop suitability
  extr <- extract(gaez,shape,method='bilinear',df=TRUE) # extract value at points
  colnames(extr) <- c("ID",m) # rename columns of extracted data
  suit <- data.frame(suit,extr[2]) # merge with existing suitability data
}

write.csv(suit,file.path(workdir,paste0(survey,"-terrain.csv")),row.names=FALSE, na="")
