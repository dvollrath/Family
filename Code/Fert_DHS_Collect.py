######################################################################################
# Collect raw DHS files from surveys to single folders for each survey round
######################################################################################

# Import modules
import os
import shutil

# Set locations for DHS raw input data and DHS collected output data
DHSCollect = '/users/dietz/Dropbox/Project/Fertility/Data/CollectDHS'
DHSInput   = '/users/dietz/Dropbox/Project/Fertility/Data/DHS'

# Walk DHS raw input directory and organize data files by country/version
for dirpath, dirnames, files in os.walk(DHSInput):
    for folder in dirnames: # for each folder found
        CC = folder[0:2] # country code
        V  = folder[4:5] # DHS version
        R  = folder[5:6] # DHS release within that version (can be multiple)

        # Assign my own survey code based on the ranges given by DHS
        # There are multiple values for R within each survey code, as the DHS uses this R code
        # also as a means of tracking release versions (updates to results, new recodes, etc.)
        if R in ['1','2','3','4','5','6','7','8','9','0']:
            Survey = '1'
        if R in ['A','B','C','D','E','F','G','H']:
            Survey = '2'
        if R in ['I','J','K','L','M','N','O','P','Q']:
            Survey = '3'
        if R in ['R','S','T','U','V','W','X','Y','Z']:
            Survey = '4'

        # Build name of folder for a given DHS survey
        # 'DHS' is just text holder, CC gives the country code, V give the DHS version (I through VII),
        # and Survey is 1-4 to indicate which survey wave within a version this is
        # Example: DHSUG43 is the DHS survey data from Uganda from DHS version 4, the third survey in that version
        COLLfolder = 'DHS' + CC + V + Survey 
        COLLpath  = os.path.join(DHSCollect,COLLfolder)
        DHSpath   = os.path.join(dirpath,folder)

        if not os.path.isdir(COLLpath): # if the collection folder doesn't exist, create it
            os.makedirs(COLLpath)

        for dumpath, dumname, files in os.walk(DHSpath): # get files in the given folder
            for f in files: # for each file in the given folder
                name, extension = os.path.splitext(f) # get file name and extension separately                
                if extension in ['.DTA','.csv','.dbf','.prj','.sbn','.sbx','.shp','.xml','.shx']:
                    if extension in ['.DTA']: # convert DTA to dta, or Stata throws up
                        build = name + '.dta'
                    else:
                        build = f # just use existing name for all other types of files

                    old = os.path.join(dirpath,folder,f) # existing path for file name
                    new = os.path.join(DHSCollect,COLLfolder,build) # new path for file name
                    print build 
                    shutil.copy(old,new) # copy file from DHS input to DHS collection

