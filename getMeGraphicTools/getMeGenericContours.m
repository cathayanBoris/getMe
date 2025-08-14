function [ax,C,h] = getMeGenericContours(position,longitude,latitude,altitude,intervals,labels)
% this should set an additional axes automatically for you

switch length(position)
    case 1 % position is an axis
        ax = axes("Position",get(position,'Position'));  % postision = axes
        ax.ALim = get(position,'ALim');
    case 4
        ax = axes("Position",position); % position = coordinates
    otherwise
        error('Position must be an existing axis or a 4-element array.')
end


if nargin == 4 || isempty(intervals) % intervals are not provided
    [C,h] = contour(ax,longitude,latitude,altitude,'Color',[1 1 1]*0.5);
else % intervals are provided
    [C,h] = contour(ax,longitude,latitude,altitude,intervals,'Color',[1 1 1]*0.5);
end

if nargin <= 5 || isempty(labels) % labels are not provided
    
else % labels are provided
    clabel(C,h,labels,'Color',[1 1 1]*0.5) 
end 

set(ax,'Color','w','Visible','off')
end