% getMeNCOMsampler
lonSpan = -91:0.2:-88;
lengthLonSpan = length(lonSpan);
latSpan = 27.6:-0.2:26;
lengthLatSpan = length(latSpan);
requestLon = repmat(lonSpan,1,lengthLatSpan);
requestLat = [];
for lls = 1:lengthLatSpan
    requestLat = [requestLat repmat(latSpan(lls),1,lengthLonSpan)];
end
%
request = [(7:8)*16+1 (6:8)*16+2 (5:8)*16+3 (3:8)*16+4 (2:8)*16+5 (2:8)*16+6 (1:8)*16+7 ...
    (1:8)*16+8 (0:8)*16+9 (0:8)*16+10 (0:8)*16+11 (0:8)*16+12 (0:8)*16+13 (0:8)*16+14 ...
    (0:8)*16+15 (0:8)*16+16];

requestLon = requestLon(request);
requestLat = requestLat(request);

% daratio = [1 1 1];

% can be visualized ny:

% figure(99)
% getMeRequestedLocations;

% which is eventually this:
% if ~exist('ztopoS','var')
%     [xtopo,ytopo,ztopo] = getMeTopo(-92,-87,25,29);
%     smoothingParameterInM = 30000;
%     [~,~,ztopoS] = getMeSmoothed(smoothingParameterInM,-92,-87,25,29);
% end
% 
% figure(98)
% clf
% set(gca,'Visible','off','Color','none')
% [ax1] = getMeGenericMap(gca,xtopo,ytopo,ztopo',[-4000:100:0],[-3000:1000:-1000]);
% 
% colormap(ax1,cmocean('topo'))
% hold on
% clim(4000*[-1 1])
% mapLims = [-91.4 -87.6 25.9 27.7];
% axis(ax1,mapLims);
% % daspect(daratio)
% hold on
% 
% % scatter(ax1,requestLon,requestLat,150,'markerfacecolor','w','LineWidth',3,'MarkerEdgeColor','r')
% scatter(ax1,requestLon,requestLat,150,'markerfacecolor','y','LineWidth',3,'MarkerEdgeColor','g')
% for ll = 1:length(requestLon)
%     %     maxVarVector(ll) = 1 * exp(1i*radianNeeded(ll));
%     % quiver(ax1,requestLon(ll),requestLat(ll),real(maxVarVector(ll)),imag(maxVarVector(ll)),'off','k','LineWidth',3,'ShowArrowHead','off')
%     hold on
%     text(requestLon(ll),requestLat(ll),num2str(ll),'Color','k',"HorizontalAlignment","center",'VerticalAlignment','middle','FontWeight','bold')
% end
% 
% ax1.Visible = 'on';
% getMeEarthTix(gca)