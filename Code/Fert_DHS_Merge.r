#######################################################################
# Author: Dietz Vollrath
# 
# Merge the created spatial datasets together to one file for use in Stata
#
#######################################################################

message(sprintf("--Merge cluster data files together: %s\n", survey))

atlas <- read.csv(file.path(workdir, paste0(survey,"-atlas.csv")), header=TRUE)
dmsp <- read.csv(file.path(workdir, paste0(survey,"-dmsp.csv")), header=TRUE)
suit <- read.csv(file.path(workdir, paste0(survey,"-suit.csv")), header=TRUE)
csi <- read.csv(file.path(workdir, paste0(survey,"-csi.csv")), header=TRUE)
terr <- read.csv(file.path(workdir, paste0(survey,"-terrain.csv")), header=TRUE)
kg <- read.csv(file.path(workdir, paste0(survey,"-kg.csv")), header=TRUE)
grump <- read.csv(file.path(workdir, paste0(survey,"-grump.csv")), header=TRUE)

out <- merge(atlas,dmsp)
out <- merge(out,suit)
out <- merge(out,csi)
out <- merge(out,terr)
out <- merge(out,kg)
out <- merge(out,grump)

write.csv(out,file.path(workdir,paste0(survey,"-all-spatial.csv")),row.names=FALSE, na="")
