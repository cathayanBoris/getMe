% getMeRequestedLocations
% specify an empty figure before calling this script
shg
clf
% hold on
% contourf(xtopo,ytopo,ztopo',[-4000:100:0]);
% contour(xtopo,ytopo,ztopo',[-4000:100:0]);
% [C,h]=contour(xtopo,ytopo,ztopo',[-4000:500:0],':k');
% clabel(C,h,[-4000:500:0],'labelspacing',300)
% colormap(gca,"parula")
% clabel(C,h,[-3000 -2000])
% cmocean('topo')
% hold on
% clim(4000*[-1 1])
% axis(mapLims)
% xlim([-91.5 -87.5]), ylim([25.8 27.8])
% daspect([1 1 1])

smoothKM = 30;
if ~exist('hg','var') || smoothingParameterInM ~= smoothKM*1000
    [xtopo,ytopo,ztopo] = getMeTopo(-92,-87,25,29);
    % smoothingParameterInM = smoothKM*1000;
    % [~,~,ztopoS] = getMeSmoothed(smoothingParameterInM,-92,-87,25,29);
    % [hx,hy,hg] = getMeGradZ(xtopo,ytopo,-ztopoS);
end

set(gca,'Visible','off','Color','none')
[ax1] = getMeGenericMap(gca,xtopo,ytopo,ztopo',[-4000:100:0],[-3000:1000:-1000]);

colormap(ax1,cmocean('topo'))
hold on
clim(4000*[-1 1])
mapLims = [-91.4 -87.6 25.9 27.7];
axis(ax1,mapLims);

hold on
scatter(ax1,requestLon,requestLat,150,'markerfacecolor','y','LineWidth',3,'MarkerEdgeColor','g')
for tt = 1:length(requestLon)
    text(ax1,requestLon(tt),requestLat(tt),num2str(tt),"HorizontalAlignment","center",'VerticalAlignment','middle','FontWeight','bold')
end
ax1.Visible = 'on';
getMeEarthTix(ax1)