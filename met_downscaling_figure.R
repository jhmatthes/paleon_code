library(maps)
library(ncdf)
library(fields)

#lat/long bounding box for PalEON domain
latmin <- 35
latmax <- 50
lonmin <- -100
lonmax <- -60

#make box showing PalEON domain
plot(rep(-100,2),c(35,50),type='l',lwd=4,col='red',xlim=c(-125,-50),
     ylim=c(30,53),xlab='',ylab='')
lines(rep(-65,2),c(35,50),type='l',lwd=4,col='red',xlim=c(-125,-50),ylim=c(30,53))
lines(c(-100,-65),rep(35,2),type='l',lwd=4,col='red',xlim=c(-125,-50),ylim=c(30,53))
lines(c(-100,-65),rep(50,2),type='l',lwd=4,col='red',xlim=c(-125,-50),ylim=c(30,53))
map("state",interior=TRUE,add=TRUE,xlim=c(-125,-50),ylim=c(30,53))
map("world",interior=TRUE,add=TRUE,xlim=c(-125,-50),ylim=c(30,53))

#load CCSM4 data
ccsm4 <- open.ncdf('/Users/jhatala/Documents/tas_Amon_CCSM4_historical_r1i1p1_185001-200512.nc')
ccsm4_dat <- get.var.ncdf(ccsm4,'tas')
ccsm4_lat <- get.var.ncdf(ccsm4,'lat')
ccsm4_lon <- get.var.ncdf(ccsm4,'lon')
ccsm4_lon <- ccsm4_lon-360

lonmin_ind <- which(abs(ccsm4_lon-lonmin)==min(abs(ccsm4_lon-lonmin)))
lonmax_ind <- which(abs(ccsm4_lon-lonmax)==min(abs(ccsm4_lon-lonmax)))
latmin_ind <- which(abs(ccsm4_lat-latmin)==min(abs(ccsm4_lat-latmin)))
latmax_ind <- which(abs(ccsm4_lat-latmax)==min(abs(ccsm4_lat-latmax)))
lat.pal <- ccsm4_lat[latmin_ind:latmax_ind]
lon.pal <- ccsm4_lon[lonmin_ind:lonmax_ind]
land.data <- ccsm4_dat[lonmin_ind:lonmax_ind,latmin_ind:latmax_ind,]

brk<- seq(min(c(as.vector(land.data[,,3]),as.vector(newland[,,3])),na.rm=TRUE),
              max(c(as.vector(land.data[,,3]),as.vector(newland[,,3])),na.rm=TRUE),by=0.1)
image.plot(lon.pal,lat.pal,land.data[,,3],zlim=c(min(brk),max(brk)),
           ylab='latitude [degrees]',xlab='longitude [degrees]',
           main='CCSM4 model temperature: March 0850AD')
map("state",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))
map("world",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))

newdat <- open.ncdf('/Users/jhatala/Documents/tair_1850_03.nc')
newland <- get.var.ncdf(newdat,'tair')
newlat <- get.var.ncdf(newdat,'lat')
newlon <- get.var.ncdf(newdat,'lon')

image.plot(newlon,newlat,newland[,,3],zlim=c(min(brk),max(brk)),
           ylab='latitude [degrees]',xlab='longitude [degrees]',
           main='Down-scaled model temperature: 1 March 0850AD 18:00')
map("state",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))
map("world",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))


