#######################################################################
# Author: Dietz Vollrath
# 
# Extract GAEZ data for a given set of points from DHS survey
# 1. Clears existing environment
# 2. Sets directories
# 3. Calls sub-routines to create datasets
#
#######################################################################

message(sprintf("--Extract GAEZ suitability data for: %s\n", survey))

suit <- header # copy header information

# Crop suitability data
crops <- c("brl","bck","rye","oat","wpo","whe","csv","cow","pml","spo","rcw","yam")

for (c in crops) { # for every crop given
  message(sprintf("--Processing: %s", c))
  name <- paste0("res03_crav6190l_sxlr_",c,".tif") # build file name for crop
  gaez <- raster(file.path(gaezdir,name)) # load raster for crop suitability
  #extr <- extract(gaez,shapelist,buffer=1000,fun=mean,small=TRUE,df=TRUE,progress='text') # extract suitability for points
  extr <- extract(gaez,shape,method='bilinear',df=TRUE) # extract suitability for points
  colnames(extr) <- c("ID",paste0("suit_",c)) # rename columns of extracted data
  suit <- data.frame(suit,extr[2]) # merge with existing suitability data
}

# Agro-climatic constrant data
constraints <- c("sq1b","sq2b","sq3b","sq4b","sq5b","sq6b","sq7b")

for (c in constraints) {
  message(sprintf("--Processing: %s", c))
  name <- paste0("lr_soi_",c,"_mze.tif") # build file name for crop
  gaez <- raster(file.path(gaezdir,name)) # load raster for crop suitability
  extr <- extract(gaez,shape,method='bilinear',df=TRUE) # extract suitability for points
  colnames(extr) <- c("ID",paste0("agro_",c)) # rename columns of extracted data
  suit <- data.frame(suit,extr[2]) # merge with existing suitability data
}

constraints <- c("et0","lgd","lt2","lt3","n2c","prc","ric")

for (c in constraints) {
  message(sprintf("--Processing: %s", c))
  name <- paste0("res01_",c,"_crav6190.tif") # build file name for crop
  gaez <- raster(file.path(gaezdir,name)) # load raster for crop suitability
  extr <- extract(gaez,shape,method='bilinear',df=TRUE) # extract suitability for points
  colnames(extr) <- c("ID",paste0("agro_",c)) # rename columns of extracted data
  suit <- data.frame(suit,extr[2]) # merge with existing suitability data
}

write.csv(suit,file.path(workdir,paste0(survey,"-suit.csv")),row.names=FALSE, na="")
