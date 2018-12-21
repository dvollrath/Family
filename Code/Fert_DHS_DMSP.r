#######################################################################
# Author: Dietz Vollrath
# 
# Extract DMSP lights data for DHS clusters
# 1. Find closest year to DHS survey
#
#######################################################################

message(sprintf("--Extract DMSP light data for: %s", survey))

suit <- header # copy header information

year = substr(suit[1,1],3,6) # extract year from DHSID (not all files have year field)

if(year<=1997) { # select a DMSP light file with year close to the year of DHS survey
  dmsp <- raster(file.path(dmspdir,"F12_19960316-19970212_rad_v4.avg_vis.tif"))
} else if(year==1998 | year==1999) {
  dmsp <- raster(file.path(dmspdir,"F12_19990119-19991211_rad_v4.avg_vis.tif"))
} else if(year==2000 | year==2001) {
  dmsp <- raster(file.path(dmspdir,"F12-F15_20000103-20001229_rad_v4.avg_vis.tif"))
} else if(year==2002 | year==2003) {
  dmsp <- raster(file.path(dmspdir,"F14-F15_20021230-20031127_rad_v4.avg_vis.tif"))
} else if(year==2004 | year==2005) {
  dmsp <- raster(file.path(dmspdir,"F14_20040118-20041216_rad_v4.avg_vis.tif"))
} else if(year==2006 | year==2007 | year==2008) {
  dmsp <- raster(file.path(dmspdir,"F16_20051128-20061224_rad_v4.avg_vis.tif"))
} else {
  dmsp <- raster(file.path(dmspdir,"F16_20100111-20110731_rad_v4.avg_vis.tif"))
}

extr <- extract(dmsp,shape,method='bilinear',df=TRUE) # extract csi for points
colnames(extr) <- c("ID","dmsp_light_mean") # rename columns of extracted data
suit <- data.frame(suit,extr[2]) # merge with suit data

write.csv(suit,file.path(workdir,paste0(survey,"-dmsp.csv")),row.names=FALSE, na="")
