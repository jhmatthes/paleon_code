#!bin/bash

#This file parses the yearly CRUNCEP files for the PalEON grid into monthly files
#Jaclyn Hatala Matthes, 9/26/13

filedir='/projectnb/paleon/met_drivers/'

years=`ls *.nc | cut -c 6-9 | uniq`
dpermonth=(124 236 360 480 604 724 848 972 1092 1216 1336 1460)


for ((y=1901;y<=2010;y++)) #loop over years
do
    file=`echo ls *${y}.nc`
    for ((m=1;m<=12;m++)) #loop over months
    do 
	echo ${file}
	echo ${m}
	

    done
done
