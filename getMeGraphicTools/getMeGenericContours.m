function [ax,C,h] = getMeGenericContours(pos,longitude,latitude,altitude,cv,cl)
% this should set an additional axes automatically for you
ax = axes("Position",pos);
[C,h] = contour(ax,longitude,latitude,altitude,cv,'Color',[1 1 1]*0.5);
set(ax,"color","none")
if nargin <= 5 || isempty(cl)

else
    clabel(C,h,cl,'Color',[1 1 1]*0.5)
end
set(ax,'Color','w','Visible','off')
end