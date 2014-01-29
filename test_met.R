metpath  <- '/Users/jhmatthes/Documents/PalEONData/new_met/wind/'
#metpath  <- '/projectnb/paleon/met_climatology/met_data/tair/'
plotpath <- '/Users/jhmatthes/Documents/PalEONData/PalEON_met/plots/'
#plotpath <- '/projectnb/paleon/met_climatology/plots/'
datpath  <- '/Users/jhmatthes/Documents/PalEONData/PalEON_met/dat/'
#datpath  <- '/projectnb/paleon/met_climatology/dat/'
savefile <- 'PalEON_clim_08501900.Rdata'

#I/O PalEON met netCDF files 
files <- list.files(metpath,full.names=FALSE,recursive=FALSE,pattern = "\\.nc$") #list all *landCoverFrac*.nc files
filesplit <- strsplit(files,"_")

#get unique variables and years from file names
vars <- years <- months <- vector(length=length(filesplit))
for(i in 1:length(filesplit)){
  vars[i]   <- filesplit[[i]][1]
  years[i]  <- filesplit[[i]][2]
  months[i] <- substring(filesplit[[i]][3],1,2)
}
vars   <- unique(vars)
years  <- unique(years)
months <- unique(months)

#get TA for points
point.clim <- list()
v <- 1
for(p in 1:nrow(points)){
  lon.ind <- which(lon==points$lon[p])
  lat.ind <- which(lat==points$lat[p])
  point.clim[[p]] <- matrix(nrow=365*4,ncol=length(years))
  for(y in 1:4){
    for(m in 1:12){
      
      file <- open.ncdf(paste(metpath,vars[v],"_",years[y],"_",months[m],".nc",sep=""))
      data <- get.var.ncdf(file,vars[v])
      fillvalue <- att.get.ncdf(file,vars[v],'_FillValue')
      data[data==fillvalue$value] <- NA
      close.ncdf(file)
      
      if(m==1){
        huge.data <- data
      }else{
        huge.data <- abind(huge.data,data,along = 3)
      }
      
    }
    point.clim[[p]][,y] <- huge.data[lon.ind,lat.ind,] 
  }
}

par(mfrow=c(2,2))
plot(seq(1,365.75,by=0.25),point.clim[[1]][,1],ylim=range(point.clim[[1]],na.rm=TRUE),main='MI Upper Peninsula: UNDERC',
     xlab='Day of year',ylab=vars[v])
for(y in 2:4){
  points(seq(1,365.75,by=0.25),point.clim[[1]][,y],col=y)
}
legend(0,300,c(years[1:4]),col=1:4,pch=1)
plot(seq(1,365.75,by=0.25),point.clim[[12]][,1],ylim=range(point.clim[[12]],na.rm=TRUE),main='Northern New Hampshire',
     xlab='Day of year',ylab=vars[v])
for(y in 2:4){
  points(seq(1,365.75,by=0.25),point.clim[[12]][,y],col=y)
}
plot(seq(1,365.75,by=0.25),point.clim[[5]][,1],ylim=range(point.clim[[5]],na.rm=TRUE),main='Central Illinois',
     xlab='Day of year',ylab=vars[v])
for(y in 2:4){
  points(seq(1,365.75,by=0.25),point.clim[[5]][,y],col=y)
}
plot(seq(1,365.75,by=0.25),point.clim[[16]][,1],ylim=range(point.clim[[16]],na.rm=TRUE),main='Northern Virginia',
     xlab='Day of year',ylab=vars[v])
for(y in 2:4){
  points(seq(1,365.75,by=0.25),point.clim[[16]][,y],col=y)
}




#plot(seq(1,365.75,by=0.25),point.clim[[1]][,1]-273.15,ylim=range(point.clim[[1]])-273.15)
# points(seq(1,365.75,by=0.25),point.clim[[1]][,2]-273.15,col=2)
# points(seq(1,365.75,by=0.25),point.clim[[1]][,3]-273.15,col=3)
# points(seq(1,365.75,by=0.25),point.clim[[1]][,4]-273.15,col=4)
# 
# plot(point.clim[[1]][,1:4])
# 


