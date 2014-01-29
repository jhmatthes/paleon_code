#based on 30-year running climatology, calculate anomalies
#Jaclyn Hatala Matthes, 10/7/13

#load libraries
library(abind,lib.loc='/usr4/spclpgm/jmatthes/')
library(maps,lib.loc='/usr4/spclpgm/jmatthes/')
library(spam,lib.loc='/usr4/spclpgm/jmatthes/')
library(fields,lib.loc='/usr4/spclpgm/jmatthes/')
library(ncdf,lib.loc='/usr4/spclpgm/jmatthes/')

#data paths
datpath  <- '/projectnb/paleon/met_climatology/dat/'
savefile <- 'PalEON_clim_08501900.Rdata'
saveanom <- 'PalEON_anom_08501900.Rdata'
metpath  <- '/projectnb/paleon/met_climatology/met_data/tair/'
plotpath <- '/projectnb/paleon/met_climatology/plots/anomalies/'

load(paste(datpath,savefile,sep=''))

#points <- read.delim('/Users/jhmatthes/Dropbox/BU/ED/climate_points.txt',header=TRUE)

#I/O PalEON met netCDF files 
files <- list.files(metpath,full.names=FALSE,recursive=TRUE,pattern = "\\.nc$") 
filesplit <- strsplit(files,"_")

# #get climatology for points
# point.clim <- point.clim.long <- list()
# for(p in 1:nrow(points)){
#   lon.ind <- which(lon==points$lon[p])
#   lat.ind <- which(lat==points$lat[p])
#   point.clim[[p]] <- matrix(nrow=length(clim.all),ncol=12)
#   point.clim.long[[p]] <- vector(length=length(clim.all)*12)
#   for(y in 1:length(clim.all)){
#     for(m in 1:12){
#       point.clim[[p]][y,m] <- clim.all[[y]][lon.ind,lat.ind,m] 
#     }
#     long.ind <- seq(((y-1)*12+1),y*12,1)
#     point.clim.long[[p]][long.ind] <- clim.all[[y]][lon.ind,lat.ind,]
#   }
# }


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
yrs <- as.numeric(years)

#structures
anom.all <- list()

for(v in 1:length(vars)){
  for(y in 1:(length(yrs))){
    for(m in 1:12){
      #Calculate the monthly mean
      file <- open.ncdf(paste(metpath,vars[v],"_",years[y],"_",months[m],".nc",sep=""))
      data <- get.var.ncdf(file,vars[v])
      fillvalue <- att.get.ncdf(file,vars[v],'_FillValue')
      data[data==fillvalue$value] <- NA
      close.ncdf(file)
      dat.mean <- apply(data,c(1,2),mean,na.rm=TRUE) 
      
      #Calculate the standardized anomaly
      brk<- seq(-4,4,by=0.1)
      anomaly = (dat.mean - clim.all[[y]][,,m])/sqrt(clim.all.var[[y]][,,m])
      png(paste(plotpath,'clim_anom_',vars[v],'_',years[y],'_',months[m],'.png',sep=''),width=1000,height=600)
      image.plot(lon,lat,anomaly,zlim=c(min(brk),max(brk)))
      map("state",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))
      map("world",interior=TRUE,add=TRUE,xlim=range(lon),ylim=range(lat))
      dev.off()
      
      #save output
      if(m==1){
        anom.y  <- anomaly
      }else{
        anom.y  <- abind(anom.y,anomaly,along = 3)      
      }
    }
    anom.all[[y]] <- anom.y       #yearly anomaly
  }
}

save(anom.all,lat,lon,file=paste(datpath,saveanom,sep=''))



