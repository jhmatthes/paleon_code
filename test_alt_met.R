#This script tests alternate CCSM4 met runs (r1i1p1) from the historic period.
#It compares the values of the new runs to the old runs & CRUNCEP.
#Jaclyn Hatala Matthes, 1/21/14

library(ncdf)
library(zoo)

vars <- c("lwdown","qair","tair","precipf")
new.ccsm4.vars <- c("rlds","huss","tas","pr")
plot.vars <- c("Incoming long-wave","Specific humidity","Air temperature","Precipitation")
Ha1 <- c(-72.25,42.75) #Harvard Forest site coordinates

pre.dir  <- "/Users/jhmatthes/Dropbox/BU/PalEON/bias_correction/prebias_met/" #old CCSM4
alt.dir <- "/Users/jhmatthes/Documents/alt_met/"
alt.files <- list.files(alt.dir,pattern = "\\.nc$")
match.dir <- "/Users/jhmatthes/Dropbox/BU/PalEON/bias_correction/match_snapshot/"

for(v in 1:length(vars)){
  
  #open old CCSM4 model file (pre-bias correction)
  tmp <- open.ncdf(paste(pre.dir,"Ha1_",vars[v],"_cat.nc",sep=""))
  var <- get.var.ncdf(tmp,vars[v])
  close.ncdf(tmp)
  pre.var <- var[1417660:length(var)] #clip from year 1820-2005
  Ha1.pre.av<-rollmean(pre.var,14600,fill = list(NA, NULL, NA)) #10-yr running mean
  
  #open new CCSM4 model file (r1i1p1 2013)
  file <- alt.files[grep(new.ccsm4.vars[v],alt.files)]
  tmp <- open.ncdf(paste(alt.dir,file,sep=""))
  var <- get.var.ncdf(tmp,new.ccsm4.vars[v])
  lat <- get.var.ncdf(tmp,"lat")
  lon <- get.var.ncdf(tmp,"lon")
  close.ncdf(tmp)
  
  lon <- 180-lon
  lon.ind <- which(abs(lon-Ha1[1])==min(abs(lon-Ha1[1])))
  lat.ind <- which(abs(lat-Ha1[2])==min(abs(lat-Ha1[2])))
  new.var <- var[lon.ind,lat.ind,]
  Ha1.new.av <- rollmean(new.var,120,fill = list(NA, NULL, NA)) #10-yr running mean
  
  #open CRUNCEP data file
  tmp <- open.ncdf(paste(match.dir,"Ha1_",vars[v],"_cru_yrs.nc",sep=""))
  var <- get.var.ncdf(tmp,vars[v])
  close.ncdf(tmp)
  Ha1.cru.av<-rollmean(var,14600,fill = list(NA, NULL, NA))
  
  #plot three models for comparison
  old.dates  <- seq(as.Date("1820-01-01"), as.Date("2005-12-13"), length=length(Ha1.pre.av))
  hist.dates <- seq(as.Date("1850-01-01"), as.Date("2005-12-13"), length=length(Ha1.new.av))
  cru.dates  <- seq(as.Date("1961-01-01"), as.Date("1990-12-13"), length=length(Ha1.cru.av))

  y.range <- range(Ha1.cru.av,Ha1.new.av,Ha1.pre.av,na.rm=TRUE)
  plot(old.dates,Ha1.pre.av,ylab=plot.vars[v],ylim=y.range,
       main=paste(plot.vars[v],": black=original CCSM4, red=new CCSM4, blue=CRUNCEP",sep=""))
  points(hist.dates,Ha1.new.av,col="red")
  points(cru.dates,Ha1.cru.av,col="blue")
}

