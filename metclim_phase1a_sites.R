#look at the oldest 100 PalEON years (0850-0869) and newest CRUNCEP data (1901-2010) to 
#find best match for new PalEON Phase 1a sites
#Jaclyn Hatala Matthes, 12/19/13

library(ncdf)
library(abind)

old.path <- '/Users/jhmatthes/Documents/PalEONData/climate_space/oldest100/'
new.path <- '/Users/jhmatthes/Documents/PalEONData/climate_space/CRUNCEP/'

old.tair.files <- list.files(paste(old.path,'tair/',sep=''),
                             full.names=TRUE,recursive=FALSE,pattern = "\\.nc$") 
old.precipf.files <- list.files(paste(old.path,'precipf/',sep=''),
                                full.names=TRUE,recursive=FALSE,pattern = "\\.nc$") 
new.tair.files <- list.files(paste(new.path,'tair/',sep=''),
                             full.names=TRUE,recursive=FALSE,pattern = "\\.nc$") 
new.precipf.files <- list.files(paste(new.path,'precipf/',sep=''),
                                full.names=TRUE,recursive=FALSE,pattern = "\\.nc$") 

#loop over tair files & calculate 850-949 climatology 
for(f in 1:length(old.tair.files)){
  file <- open.ncdf(old.tair.files[f])
  data <- get.var.ncdf(file,'tair')
  fillvalue <- att.get.ncdf(file,'tair','_FillValue')
  data[data==fillvalue$value] <- NA
  close.ncdf(file)
  dat.mean <- apply(data,c(1,2),mean,na.rm=TRUE) #calculate monthly mean
  dat.var  <- apply(data,c(1,2),var,na.rm=TRUE) #calculate monthly var
  if(f==1){
    huge.mean <- dat.mean
    huge.var  <- dat.var
  }else{
    huge.mean <- abind(huge.mean,dat.mean,along = 3)
    huge.var  <- abind(huge.var,dat.var,along=3)
  }
}
old.tair.mean <- apply(huge.mean,c(1,2),mean,na.rm=TRUE)-273.15
old.tair.var  <- apply(huge.var,c(1,2),var,na.rm=TRUE)

#loop over precipf files & calculate 850-869 
for(f in 1:length(old.precipf.files)){
  file <- open.ncdf(old.precipf.files[f])
  data <- get.var.ncdf(file,'precipf')
  fillvalue <- att.get.ncdf(file,'precipf','_FillValue')
  data[data==fillvalue$value] <- NA
  close.ncdf(file)
  dat.mean <- apply(data,c(1,2),mean,na.rm=TRUE) #calculate monthly mean
  dat.var  <- apply(data,c(1,2),var,na.rm=TRUE) #calculate monthly var
  if(f==1){
    huge.mean <- dat.mean
    huge.var  <- dat.var
  }else{
    huge.mean <- abind(huge.mean,dat.mean,along = 3)
    huge.var  <- abind(huge.var,dat.var,along=3)
  }
}
old.precipf.mean <- apply(huge.mean,c(1,2),mean,na.rm=TRUE)
old.precipf.var  <- apply(huge.var,c(1,2),var,na.rm=TRUE)

#loop over tair files & calculate 1901-2010 climatology 
for(f in 1:length(new.tair.files)){
  file <- open.ncdf(new.tair.files[f])
  data <- get.var.ncdf(file,'tair')
  fillvalue <- att.get.ncdf(file,'tair','_FillValue')
  data[data==fillvalue$value] <- NA
  close.ncdf(file)
  dat.mean <- apply(data,c(1,2),mean,na.rm=TRUE) #calculate monthly mean
  dat.var  <- apply(data,c(1,2),var,na.rm=TRUE) #calculate monthly var
  if(f==1){
    huge.mean <- dat.mean
    huge.var  <- dat.var
  }else{
    huge.mean <- abind(huge.mean,dat.mean,along = 3)
    huge.var  <- abind(huge.var,dat.var,along=3)
  }
}
new.tair.mean <- apply(huge.mean,c(1,2),mean,na.rm=TRUE)-273.15
new.tair.var  <- apply(huge.var,c(1,2),var,na.rm=TRUE)

#loop over precipf files & calculate annual precip 1901-2010
years <- 1981:2010
mean.rain <- yr.rain <- list()
for(y in 1:length(years)){
  yrfiles <- new.precipf.files[grep(years[y],new.precipf.files)]
  for(f in 1:length(yrfiles)){
    file <- open.ncdf(yrfiles[f])
    data <- get.var.ncdf(file,'precipf')
    fillvalue <- att.get.ncdf(file,'precipf','_FillValue')
    data[data==fillvalue$value] <- NA
    
    if(f==1){
      pr_run <- data
    }else{
      pr_tmp <- data
      pr_run <- abind(pr_run,pr_tmp,along=3)
    }
    close.ncdf(file)
  }
  yr.rain[[y]] <- apply(pr_run,c(1,2),sum)*60*60*6 #kg m-2 s-1 --> kg m-2 6hr-1
}
tmp <- abind(yr.rain,along=3)
mean_rain <- apply(abind(yr.rain,along=3),c(1,2),mean)


new.precipf.mean <- apply(huge.mean,c(1,2),mean,na.rm=TRUE)
new.precipf.var  <- apply(huge.var,c(1,2),var,na.rm=TRUE)

#plot HIPS and high-res pollen sites
Ha1 <- c(-72.25,42.75)
Ho1 <- c(-68.75,45.25)
Und <- c(-89.25,46.25)
BLa <- c(-94.75,46.25) #Billy's Lake
DLa <- c(-95.25,47.25) #Deming Lake
LPo <- c(-71.75,42.25) #Little Pond
MBo <- c(-82.75,43.75) #Minden Bog

file <- open.ncdf(new.precipf.files[1])
lon <- get.var.ncdf(file,"lon")
lat <- get.var.ncdf(file,"lat")

Ha1.new.tair <- new.tair.mean[which(Ha1[1]==lon),which(Ha1[2]==lat)]
Ho1.new.tair <- new.tair.mean[which(Ho1[1]==lon),which(Ho1[2]==lat)]
Und.new.tair <- new.tair.mean[which(Und[1]==lon),which(Und[2]==lat)]
BLa.new.tair <- new.tair.mean[which(BLa[1]==lon),which(BLa[2]==lat)]
DLa.new.tair <- new.tair.mean[which(DLa[1]==lon),which(DLa[2]==lat)]
LPo.new.tair <- new.tair.mean[which(LPo[1]==lon),which(LPo[2]==lat)]
MBo.new.tair <- new.tair.mean[which(MBo[1]==lon),which(MBo[2]==lat)]

Ha1.new.precipf <- mean_rain[which(Ha1[1]==lon),which(Ha1[2]==lat)]
Ho1.new.precipf <- mean_rain[which(Ho1[1]==lon),which(Ho1[2]==lat)]
Und.new.precipf <- mean_rain[which(Und[1]==lon),which(Und[2]==lat)]
BLa.new.precipf <- mean_rain[which(BLa[1]==lon),which(BLa[2]==lat)]
DLa.new.precipf <- mean_rain[which(DLa[1]==lon),which(DLa[2]==lat)]
LPo.new.precipf <- mean_rain[which(LPo[1]==lon),which(LPo[2]==lat)]
MBo.new.precipf <- mean_rain[which(MBo[1]==lon),which(MBo[2]==lat)]

plot(mean_rain,new.tair.mean,xlab="Annual precipitation [mm/yr]",
     ylab="Mean annual temperature [C]",main="CRUNCEP 1981-2010 climate space")
points(Ha1.new.precipf,Ha1.new.tair,pch="H",col="red",cex=2)
points(Ho1.new.precipf,Ho1.new.tair,pch="O",col="red",cex=2)
points(Und.new.precipf,Und.new.tair,pch="U",col="red",cex=2)
points(BLa.new.precipf,BLa.new.tair,pch="B",col="red",cex=2)
points(DLa.new.precipf,DLa.new.tair,pch="D",col="red",cex=2)
points(LPo.new.precipf,LPo.new.tair,pch="L",col="red",cex=2)
points(MBo.new.precipf,MBo.new.tair,pch="M",col="red",cex=2)

