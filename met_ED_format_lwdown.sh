#!/bin/bash
#Process PalEON met drivers for ED input, JHM 8/20/13

#Un-tar all files and remove .tar files
for f in *.tar
do tar xf $f
done 
rm *.tar

#Replace FillValues from 1e30 to the mean of year 850 (output from met_avg_forfillval.R) and
#Rename variables to match ED met drivers
for f in lwdown*.nc
do 
    ncatted -O -a _FillValue,lwdown,o,f,288.58 $f
    ncrename -h -O -v lwdown,dlwrf $f
done

for f in precipf*.nc
do 
    ncatted -O -a _FillValue,precipf,o,f,2.5e-05 $f
    ncrename -h -O -v precipf,prate $f
done

for f in psurf*.nc
do 
    ncatted -O -a _FillValue,psurf,o,f,98052 $f
    ncrename -h -O -v psurf,pres $f
done

for f in qair*.nc
do 
    ncatted -O -a _FillValue,qair,o,f,0.004469 $f
    ncrename -h -O -v qair,sh $f
done

for f in swdown*.nc
do 
    ncatted -O -a _FillValue,swdown,o,f,193.8 $f
    ncrename -h -O -v swdown,vbdsf $f
done

for f in tair*.nc
do 
    ncatted -O -a _FillValue,tair,o,f,281.8 $f
    ncrename -h -O -v tair,tmp $f 
done

for f in wind*.nc
do 
    ncatted -O -a _FillValue,wind,o,f,3.55 $f
    ncrename -h -O -v wind,ugrd $f
done

#Convert files from netCDF-3 to netCDF-4 classic, and
#rearrange variable order for input into ED
for f in *.nc
do 
    ncks -O --fl_fmt=netcdf4_classic $f $f
    ncpdq -a lat,lon,time $f $f
done

#Rename files for ED input
for j in *_01.nc
do 
    mv $j ${j%_01.nc}JAN.h5
done

for j in *_02.nc
do 
    mv $j ${j%_02.nc}FEB.h5
done

for j in *_03.nc
do 
    mv $j ${j%_03.nc}MAR.h5
done

for j in *_04.nc
do 
    mv $j ${j%_04.nc}APR.h5
done

for j in *_05.nc
do 
    mv $j ${j%_05.nc}MAY.h5
done

for j in *_06.nc
do 
    mv $j ${j%_06.nc}JUN.h5
done

for j in *_07.nc
do 
    mv $j ${j%_07.nc}JUL.h5
done

for j in *_08.nc
do 
    mv $j ${j%_08.nc}AUG.h5
done

for j in *_09.nc
do 
    mv $j ${j%_09.nc}SEP.h5
done

for j in *_10.nc
do 
    mv $j ${j%_10.nc}OCT.h5
done

for j in *_11.nc
do 
    mv $j ${j%_11.nc}NOV.h5
done

for j in *_12.nc
do 
    mv $j ${j%_12.nc}DEC.h5
done
