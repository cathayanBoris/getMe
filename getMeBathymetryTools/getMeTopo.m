function [xtopo,ytopo,ztopo] = getMeTopo(L,R,D,U)

struct25 = getMeNc('ETOPO_2022_v1_60s_N90W180_bed.nc');
% https://www.ncei.noaa.gov/products/etopo-global-relief-model
% https://www.ngdc.noaa.gov/thredds/catalog/global/ETOPO2022/60s/60s_bed_elev_netcdf/catalog.html?dataset=globalDatasetScan/ETOPO2022/60s/60s_bed_elev_netcdf/ETOPO_2022_v1_60s_N90W180_bed.nc

% struct25 = getMeNc('topo_25.1.nc');
% https://topex.ucsd.edu/pub/global_topo_1min/

[~,U7] = min(abs(struct25.lat-U));
[~,D7] = min(abs(struct25.lat-D));
[~,L7] = min(abs(struct25.lon-L));
[~,R7] = min(abs(struct25.lon-R));

xtopo = struct25.lon(L7:R7);
ytopo = struct25.lat(D7:U7);
ztopo = struct25.z(L7:R7,D7:U7);

% load GOMTopography.mat
% to use etopo6 = 0,1,0, to use GOMTopography.mat = 1,0,0
% to use topo_25.1.nc, = 0,0,1
%% 
% L = xtopo(1)
% R = xtopo(end)
% U = ytopo(1)
% D = ytopo(end)
% 
% if useEtopo6 == 1
%     fixetopo6;
%     [~,U7] = min(abs(lat7-U));
%     [~,D7] = min(abs(lat7-D));
%     [~,L7] = min(abs(lon7-L));
%     [~,R7] = min(abs(lon7-R));
% 
%     xtopo = lon7(L7:R7);
%     ytopo = lat7(D7:U7);
%     ztopo = bath7(D7:U7,L7:R7);
% elseif useTopo25 == 1
%     struct25 = getMeNc('topo_25.1.nc');
%     [~,U7] = min(abs(struct25.lat-U));
%     [~,D7] = min(abs(struct25.lat-D));
%     [~,L7] = min(abs(struct25.lon-L));
%     [~,R7] = min(abs(struct25.lon-R));
% 
%     xtopo = struct25.lon(L7:R7);
%     ytopo = struct25.lat(D7:U7);
%     ztopo = struct25.z(L7:R7,D7:U7);   
% end

% for i = 1:length(xtopo)
%     for j = 1:length(ytopo)
%         if ztopo(j,i) > 0
%             ztopo(j,i) = nan;
%         else
% 
%         end
%     end
% end
