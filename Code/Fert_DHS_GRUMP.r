#######################################################################
# Author: Dietz Vollrath
# 
# Extract Terrain data
#######################################################################

message(sprintf("--Extract GRUMP extent data for: %s\n", survey))

suit <- header # copy header information

extr <- extract(extent,shape,method='bilinear',df=TRUE) # extract value at points
colnames(extr) <- c("ID","grump_code") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with existing suitability data

write.csv(suit,file.path(workdir,paste0(survey,"-grump.csv")),row.names=FALSE, na="")
