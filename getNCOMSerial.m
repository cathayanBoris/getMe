function [idx] = getNCOMSerial(degreeLon,degreeLat)
load ncom_grid

dst=sqrt((degreeLat-lat).^2+(degreeLon-lon).^2);
idx=find(min(dst)==dst);
idx=idx(1);
% TS.NCOMLAT=lat(idx);
% TS.NCOMLON=lon(idx);
% TS.DEPTH=h(idx);

sprintf('%5.5i',idx)