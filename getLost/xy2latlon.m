function [lat,lon]=xy2latlon(x,y,originlat,originlon)
%% function [lat,lon]=xy2latlon(x,y,originlat,originlon)
 DEG2NM=60.0;
 NM2M=1852.0;
lat=originlat + (y / NM2M) / DEG2NM;
lon= originlon + (x /  NM2M) ./ (DEG2NM  *cos(lat *pi/180)) ;
