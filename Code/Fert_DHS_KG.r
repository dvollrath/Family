#######################################################################
# Author: Dietz Vollrath
# 
# Extract Terrain data
#######################################################################

message(sprintf("--Extract KG Climate data for: %s\n", survey))

suit <- header # copy header information

kg <- raster(file.path(kgdir,"kg_raster_gadm2.tif"))

extr <- extract(kg,shape,method='simple',df=TRUE) # extract value at points
colnames(extr) <- c("ID","kg_code") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with existing suitability data

write.csv(suit,file.path(workdir,paste0(survey,"-kg.csv")),row.names=FALSE, na="")
