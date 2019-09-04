require('ncdf4')
library(OceanView)
dataUrl<-"http://hfrnet-tds.ucsd.edu/thredds/dodsC/HFR/USWC/6km/hourly/RTV/HFRADAR_US_West_Coast_6km_Resolution_Hourly_RTV_best.ncd"
data<-ncdf4::nc_open(dataUrl)
cat("Print netCDF library version\n")
cat(ncdf4::nc_version(),"\n")
#print(names(data$var))
#print(names(data$dim))
cat("Print Variables and Dimensions\n")
for (var in names(data$dim)){
  cat(var,':',data$dim[[var]]['len'][[1]])
  cat("\n")
}
for (var in names(data$var)){
  cat(var,':',data$var[[var]]['size'][[1]])
  cat("\n")
}
lat<-ncvar_get(data,"lat")
lon<-ncvar_get(data,"lon")
time<-ncvar_get(data,"time")
timeUnits<-data$dim$time$units
latest_time_index<-data$dim$time$len-5
u<-ncvar_get(data,'u',start=c(1,1,latest_time_index),count=c(length(lon),length(lat),1))
v<-ncvar_get(data,'v',start=c(1,1,latest_time_index),count=c(length(lon),length(lat),1))
quiver2D(u,v,x=lon,y=lat,colvar=sqrt(u**2+v**2),scale=.2)