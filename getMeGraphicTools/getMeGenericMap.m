function [ax,C,h] = getMeGenericMap(position,longitude,latitude,altitude,intervals,labels,clims)
% this should set an additional axes automatically for you

switch length(position)
    case 1 % position is an axis
        ax = axes("Position",get(position,'Position')); % postision = axes
    case 4
        ax = axes("Position",position); % position = coordinates
    otherwise
        error('Position must be an existing axis or a 4-element array.')
end

hold(ax,"on")

if nargin == 4 || isempty(intervals) || ~exist('intervals','var') % intervals are not provided
    contourf(ax,longitude,latitude,altitude);
    contour(ax,longitude,latitude,altitude);
    [C,h] = contour(ax,longitude,latitude,altitude);
else % intervals are provided
    contourf(ax,longitude,latitude,altitude,intervals);
    contour(ax,longitude,latitude,altitude,intervals);
end

if nargin <= 5 || isempty(labels) || ~exist('labels','var') % labels are not provided
    
else % labels are provided
    [C,h] = contour(ax,longitude,latitude,altitude,labels,':k');
    clabel(C,h,labels,'labelspacing',300)
end 

if nargin <=6 || isempty(clims) || ~exist('clims','var')

else
    clim(ax,clims);
end

set(ax,'Color','none','Visible','off')
hold(ax,"off")
end