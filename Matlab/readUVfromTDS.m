% script to read RTV data from HFRnet TDS 
% set url to data url from OPeNDap page for selected dataset

%url='http://hfrnet-tds.ucsd.edu/thredds/dodsC/HFR/USEGC/2km/hourly/RTV/HFRADAR_US_East_and_Gulf_Coast_2km_Resolution_Hourly_RTV_best.ncd';
url='http://hfrnet-tds.ucsd.edu/thredds/dodsC/HFR/USWC/6km/hourly/RTV/HFRADAR_US_West_Coast_6km_Resolution_Hourly_RTV_best.ncd';%
datatype='RTV'

% Long Term Averages (LTA)
% Note that variable names differ between LTA and RTV
%url='http://hfrnet-tds.ucsd.edu/thredds/dodsC/USWC-month-LTA-6km.nc';
%datatype='LTA'

%% uncomment to display info on all netcdf variables
%ncdisp(url)

%% uncomment to display info on specific netcdf variable
%ncdisp(url,'time')

% retrieve lat and lon variables
lat=ncread(url,'lat');
lon=ncread(url,'lon');

% handle time variable
if strcmp(datatype,'LTA')
    timebase=erase(ncreadatt(url,'time','units'),'seconds since ');
    time=ncread(url,'time')/(3600*24) + datenum(timebase,'yyyy-mm-dd');    
else
% timebase varies between datasets
    timebase=erase(ncreadatt(url,'time','units'),'hours since ');
    time=ncread(url,'time')/24 + datenum(timebase,'yyyy-mm-dd HH:MM:SS');
end
    
% view date string of start and end time
datestr(double(time([1 end])))

% set geographical limits
lat_max=35;
lat_min=32;

lon_max=-116;
lon_min=-120;

% plot the latest realtime vector map
lon_j = find(lon >= lon_min & lon <= lon_max);
lat_j = find(lat >= lat_min & lat <= lat_max);

% read in 3hr old data values
% typically most recent data is sparse as it takes a few hours
% for data to be reported from all stations
mytime=length(time)-3;

if strcmp(datatype,'LTA')
    u=ncread(url, 'u_mean', [lon_j(1) lat_j(1) mytime], [lon_j(end)-lon_j(1)+1 lat_j(end)-lat_j(1)+1 1]);
    v=ncread(url, 'v_mean', [lon_j(1) lat_j(1) mytime], [lon_j(end)-lon_j(1)+1 lat_j(end)-lat_j(1)+1 1]);
else
    u=ncread(url, 'u', [lon_j(1) lat_j(1) mytime], [lon_j(end)-lon_j(1)+1 lat_j(end)-lat_j(1)+1 1]);
    v=ncread(url, 'v', [lon_j(1) lat_j(1) mytime], [lon_j(end)-lon_j(1)+1 lat_j(end)-lat_j(1)+1 1]);
end

[LN,LT]=meshgrid(lon(lon_j),lat(lat_j));
quiver(LN,LT,u',v');
