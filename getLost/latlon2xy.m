function [x,y]=latlon2xy(lat,lon,originlat,originlon)
%  function [x,y]=latlon2xy(lat,lon,originlat,originlon)
 DEG2NM=60.0;
 NM2M=1852.0;
 y=(lat - originlat)  * DEG2NM * NM2M;
 x=(lon - originlon) * DEG2NM * NM2M .*cos(lat *pi/180);
