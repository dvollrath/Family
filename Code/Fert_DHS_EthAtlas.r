#######################################################################
# Author: Dietz Vollrath
# 
# Find nearest neightbor Eth Atlas societies for each DHS cluster
# 1. Load the EA data
# 2. Load DHS data
# 3. Compute distances
#
#######################################################################

message(sprintf("--Extract Ethnic Atlas neighbors: %s\n", survey))

suit <- header # copy header information

atlas  <- read.csv(file.path(datadir, "ethatlas-id.csv"), header=TRUE) # load EA location data
atlasid <- data.frame(atlas$ea_name,atlas$ea_id) # get EA ID's
atlasxy <- cbind(as.numeric(atlas$ea_longitude),as.numeric(atlas$ea_latitude)) # get EA long/lat

dist <- pointDistance(shape,atlasxy,lonlat=TRUE,allpairs=TRUE) # calculate matrix of distances btwn all clusters and all EA societies

minid <- t(apply(dist,1,function(x) order(x))) # get matrix of ID's of EA entries, ordered from closest to farthest

mindist <- t(apply(dist,1,sort)) # get matrix of actual distances of EA entries, ordered from closest to farthest

# Pull the three closest locations - ID and distance - from the cluster
min <- data.frame("ea_name_close1" = atlasid$atlas.ea_name[minid[,1]], 
                  "ea_id_close1" = atlasid$atlas.ea_id[minid[,1]], 
                  "ea_dist_close1" = mindist[,1],
                  "ea_name_close2" = atlasid$atlas.ea_name[minid[,2]], 
                  "ea_id_close2" = atlasid$atlas.ea_id[minid[,2]], 
                  "ea_dist_close2" = mindist[,2],
                  "ea_name_close3" = atlasid$atlas.ea_name[minid[,3]], 
                  "ea_id_close3" = atlasid$atlas.ea_id[minid[,3]], 
                  "ea_dist_close3" = mindist[,3])

out <- data.frame(suit,min)

# Write the matched data on closest EA societies to file - use "survey" passed to script to name
write.csv(out,file.path(workdir,paste0(survey,"-atlas.csv")),row.names=FALSE, na="")