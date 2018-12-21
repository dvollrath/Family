#######################################################################
# Author: Dietz Vollrath
# 
# Extract GAEZ data for a given set of points from DHS survey
# 1. Clears existing environment
# 2. Sets directories
# 3. Calls sub-routines to create datasets
#
#######################################################################

#survey = "DHSZW71"
#surveyshp = "~/dropbox/project/family/data/CollectDHS/DHSAM71/AMGE71FL.shp"

message(sprintf("--Extract CSI suitability data for: %s", survey))

suit <- header # copy header information

# CSI summary data
message(sprintf("--Average calories:"))
csi <- raster(file.path(paste0(csidir,"/CaloricSuitabilityIndex"),"post1500AverageCaloriesNo0.tif")) # load raster for CSI
extr <- extract(csi,shape,method='bilinear',df=TRUE) # extract csi for points
colnames(extr) <- c("ID","csi_average") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with suit data

message(sprintf("--Optimal calories:"))
csi <- raster(file.path(paste0(csidir,"/CaloricSuitabilityIndex"),"post1500OptCaloriesNo0.tif")) # load raster for CSI
extr <- extract(csi,shape,method='bilinear',df=TRUE) # extract csi for points
colnames(extr) <- c("ID","csi_optimal") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with suit data

message(sprintf("--Plow potential:"))
csi <- raster(file.path(paste0(csidir,"/PlowCSI/change"),"plowpotpost1500en00.tif")) # load raster for CSI
extr <- extract(csi,shape,method='bilinear',df=TRUE) # extract csi for points
colnames(extr) <- c("ID","csi_plowpot") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with suit data

message(sprintf("--Plow potential mean:"))
csi <- raster(file.path(paste0(csidir,"/PlowCSI/change"),"plowpotpost1500enmean00.tif")) # load raster for CSI
extr <- extract(csi,shape,method='bilinear',df=TRUE) # extract csi for points
colnames(extr) <- c("ID","csi_plowpot_mean") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with suit data

write.csv(suit,file.path(workdir,paste0(survey,"-csi.csv")),row.names=FALSE, na="")
