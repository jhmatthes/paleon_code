#format CRUNCEP data to match the rest of PalEON met
#Jaclyn Hatala Matthes

library(ncdf,lib.loc="/usr4/spclpgm/jmatthes/")

path  <- "/projectnb/paleon/met_climatology/met_data/CRUNCEP_format/"
files <- list.files(path,full.names=TRUE,recursive=TRUE,pattern = "\\.nc$") 
dpm=c(31,28,31,30,31,30,31,31,30,31,30,31) # No. of days per month
fillv=1e30    # Missing value

for(f in 1:length(files)){
  tmp  <- strsplit(files[f],"_")
  y    <- tmp[[1]][5]
  m    <- substring(tmp[[1]][6],1,2)
  tmp2 <- strsplit(filesplit[[1]][4],"/")
  variable <- tmp2[[1]][3]
  
  ncfile <- open.ncdf(files[f]) # Initialize file
  
  # Specify time units for this year and month
  nc_time_units=paste('days since ', sprintf('%04i',y), '-',
                      sprintf('%02i',m), '-01 00:00:00', sep='')
  
  # Declare time dimension
  time=dim.def.ncdf( "time", nc_time_units,
                     as.single(seq(from=0, to=dpm[m]-0.25, length.out=dpm[m]*4)),
                     unlim=TRUE )
  
  #get lon, lat
  lon  <- get.var.ncdf(ncfile,lon)
  lat  <- get.var.ncdf(ncfile,lat)
  
  if (variable == 'lwdown') {
    data=get.var.ncdf(ncfile,'Incoming_Long_Wave_Radiation')
    nc_variable_long_name=paste('Incident (downwelling) longwave ',
                                'radiation averaged over the time step of the forcing data', sep='')
    nc_variable_units='W m-2'
  }
  else if (variable == 'precipf') {
    data=get.var.ncdf(ncfile,'Total_Precipitation')
    nc_variable_long_name=paste('The per unit area and time ',
                                'precipitation representing the sum of convective rainfall, ',
                                'stratiform rainfall, and snowfall', sep='')
    nc_variable_units='kg m-2 s-1'
  }
  else if (variable == 'psurf') {
    data=get.var.ncdf(ncfile,'Pressure')
    nc_variable_long_name='Pressure at the surface'
    nc_variable_units='Pa'
  }
  else if (variable == 'qair') {
    data=get.var.ncdf(ncfile,'Air_Specific_Humidity')
    nc_variable_long_name=
      'Specific humidity measured at the lowest level of the atmosphere'
    nc_variable_units='kg kg-1'
  }
  else if (variable == 'swdown') {
    data=get.var.ncdf(ncfile,'Incoming_Short_Wave_Radiation')
    nc_variable_long_name=paste('Incident (downwelling) radiation in ',
                                'the shortwave part of the spectrum averaged over the time ',
                                'step of the forcing data', sep='')
    nc_variable_units='W m-2'
  }
  else if (variable == 'tair') {
    data=get.var.ncdf(ncfile,'Temperature')
    nc_variable_long_name='2 meter air temperature'
    nc_variable_units='K'
    
  }
  else if (variable == 'wind') {
    data=get.var.ncdf(ncfile,'Wind')
    nc_variable_long_name='Wind speed'
    nc_variable_units='m s-1'
  }
  
  att.put.ncdf( ncfile, time, 'calendar', '365_day')
  att.put.ncdf( ncfile, lon, 'description', 'center of grid cell')
  att.put.ncdf( ncfile, lat, 'description', 'center of grid cell')
  att.put.ncdf( ncfile, lon, 'standard_name', 'longitude')
  att.put.ncdf( ncfile, lat, 'standard_name', 'latitude')
  att.put.ncdf( ncfile, lon, 'long_name', 'longitude')
  att.put.ncdf( ncfile, lat, 'long_name', 'latitude')
  att.put.ncdf( ncfile, lon, 'axis', 'X')
  att.put.ncdf( ncfile, lat, 'axis', 'Y')
  
  # Add global attributes
  att.put.ncdf( ncfile, 0, 'description','CRUNCEP data reformatted to PalEON. ')
  
  # Time should go last since it's an unlimited dimension
  nc_var=var.def.ncdf(variable,nc_variable_units,
                      list(lon,lat,time), fillv, longname=nc_variable_long_name)
  put.var.ncdf(ncfile, nc_var, data) # Write netCDF file
  
 
  close.ncdf(ncfile) # Close netCDF file
  
}
