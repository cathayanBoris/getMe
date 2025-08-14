function [hxt,hyt,hgradient,dx,dy] = getMeGradZ(xtopo,ytopo,ztopo)
m = size(ztopo);
if m(1) == length(xtopo) || m(2) == length(ytopo)
    ztopo = ztopo';
end

% [n m] = size(ztopo);

% if sum(diff(diff(xtopo)))<=0
%     fprintf(fid,'even lon grid %.3f\n',xtopo(2)-xtopo(1));
% end
% 
% 
% if sum(diff(diff(ytopo)))<=0
%     fprintf(fid,'even lat grid %.3f\n',ytopo(1)-ytopo(2));
% end

[hx,hy] = gradient(ztopo);
alat = ytopo;
dlon = xtopo(2)-xtopo(1);
rlat = alat * pi/180;
p = 111415.13 * cos(rlat) - 94.55 * cos(3 * rlat);
dx = dlon .* p;
% give dx right dimentions...
% dx = repmat(dx,1,length(xtopo));
rlat = mean(ytopo) * pi/180;
m = 111132.09 * ones(size(rlat)) - ...
    566.05 * cos(2 * rlat) + 1.2 * cos(4 * rlat);
dy = -(ytopo(1)-ytopo(2)) .* m ;

% size(hx)
% size(dx2)
% size(hy)
% size(dy)

hxt = hx./dx;
hyt = hy./dy; %stays same!
hgradient = sqrt(hxt.*hxt + hyt.*hyt);
% size(hgradient2)
hgradient = hgradient';
dx = dx(:,1);
dy = abs(dy.* ones(length(hgradient(:,1)),1));
hxt = hxt';
hyt = hyt';

% ibad = find(ztopo>0); % nan land out.
% hgradient2(ibad) = NaN;

%%
% ztopo = ztopo';
% hx = nan(size(ztopo));
% hy = nan(size(ztopo));
% 
% distanceX = nan(size(ztopo));
% distanceY = nan(size(ztopo));
% 
% xtopo = deg2rad(xtopo);
% ytopo = deg2rad(ytopo);
% for i = 2:length(xtopo)-1
%     for j = 2:length(ytopo)-1
%         distanceX(i,j) = (6378*acos((sin(ytopo(j))*sin(ytopo(j)))+cos(ytopo(j))*cos(ytopo(j))*cos(xtopo(i+1)-xtopo(i-1))));
%         distanceY(i,j) = (6378*acos((sin(ytopo(j-1))*sin(ytopo(j+1)))+cos(ytopo(j-1))*cos(ytopo(j+1))*cos(xtopo(i)-xtopo(i))));
%         hx(i,j) = (ztopo(i+1,j)-ztopo(i-1,j))/distanceX(i,j);
%         hy(i,j) = (ztopo(i,j-1)-ztopo(i,j+1))/distanceY(i,j);
%     end
% end
% xtopo = rad2deg(xtopo);
% ytopo = rad2deg(ytopo);