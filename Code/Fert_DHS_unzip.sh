#!/bin/bash

cd /Users/dietz/Dropbox/Project/Fertility/Data/DHS/

AL_2008-09_DHS_06122018_1313_121554.zip

# Extract GAEZ crop suitability indices
for x in *_06122018_*_121554.zip
do
    unzip -o $x 
done

