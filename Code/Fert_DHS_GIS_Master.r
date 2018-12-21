#######################################################################
# Date: 2016-11-08
# Author: Dietz Vollrath
# 
# Set reference directories for all other scripts to use
# 1. Clears existing environment
# 2. Sets directories
# 3. Calls sub-routines to create datasets
#
#######################################################################

## Clear out existing environment
rm(list = ls()) 

## Set master directory where all sub-directories are located
mdir <- "~/dropbox/project/family"

## Set working directories
workdir  <- paste0(mdir,"/Work") # working files and end data
codedir <- paste0(mdir,"/Code") # code

## Set data directories
datadir <- paste0(mdir,"/data") # overall data directory
dhsdir <- paste0(mdir,"/data/CollectDHS") # Administrative polygons
gaezdir <- paste0(mdir,"/data/GAEZ") # GAEZ agro-climatic data
csidir <- paste0(mdir,"/data/CSI") # Caloric suitability index
dmspdir <- paste0(mdir,"/data/DMSP") # Caloric suitability index
grumdir <- paste0(mdir,"/data/GRUMP") # GRUMP data
kgdir <- paste0(mdir,"/data/Koeppen-Geiger-GIS") # KG data

## Libraries for use
library(raster)
library(rgdal)
library(maptools)
library(rgeos)
library(geosphere)

## Set working directory
setwd(workdir)

## Load some spatial datasets to save time
extent <- raster(file.path(grumdir,"glurextents.asc"))

## Loop through all surveys, creating data
surveys <- list.dirs(path=dhsdir, recursive=FALSE, full.names = FALSE) # get list of all folders in DHS folder

for (survey in surveys) { # for each survey
  message(sprintf("\nSurvey: %s", survey))
  surveyshp <- list.files(path=paste0(dhsdir,"/",survey),pattern = "^.*\\.shp$", recursive=FALSE, full.names=TRUE)
  message(sprintf("Shape file: %s", surveyshp))
  shape <- shapefile(surveyshp) # open shape file for DHS survey
  
  if ("DHSID" %in% names(shape)) { # check for DHSID field
    header <- data.frame("DHSID" = shape$DHSID,
                       "folder" = survey,
                       "ccode" = shape$DHSCC,
                       "cluster" = shape$DHSCLUST)
  }
  if ("SPAID" %in% names(shape)) { # it may be named SPAID
    header <- data.frame("DHSID" = shape$SPAID,
                       "folder" = survey,
                       "ccode" = shape$DHSCC,
                       "cluster" = shape$DHSCLUST)
  }
  
  source(file.path(codedir,"Fert_DHS_EthAtlas.r")) # call Ethnic Atlas neighbor routine
  source(file.path(codedir,"Fert_DHS_GAEZ.r")) # call GAEZ routine
  source(file.path(codedir,"Fert_DHS_CSI.r")) # call CSI routine
  source(file.path(codedir,"Fert_DHS_DMSP.r")) # call DMSP routine
  source(file.path(codedir,"Fert_DHS_Terrain.r")) # call Ethnic Atlas neighbor routine
  source(file.path(codedir,"Fert_DHS_GRUMP.r")) # call GRUMP routine to find urban/rural extents
  source(file.path(codedir,"Fert_DHS_KG.r")) # call KG routine to find KG climate zones
  source(file.path(codedir,"Fert_DHS_Merge.r")) # call merge routine to create single file
}
