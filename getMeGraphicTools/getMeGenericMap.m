function [ax,C,h] = getMeGenericMap(position,longitude,latitude,altitude,intervals,labels,clims,alpha)
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

if nargin <=7 || isempty(clims) || ~exist('clims','var') % if faceAlpha are not provided
    alpha = 1;
else
end

if nargin == 4 || isempty(intervals) || ~exist('intervals','var') % intervals are not provided
    [C,h]=contourf(ax,longitude,latitude,altitude,'EdgeColor','auto','FaceAlpha',alpha,'EdgeAlpha',alpha);
else % intervals are provided
    [C,h]=contourf(ax,longitude,latitude,altitude,intervals,'EdgeColor','auto','FaceAlpha',alpha,'EdgeAlpha',alpha*0.01);
end

if nargin <= 5 || isempty(labels) || ~exist('labels','var') % labels are not provided
    
else % labels are provided
    [Cl,hl]=contour(ax,longitude,latitude,altitude,labels,':','EdgeColor',[1 1 1]*(1-alpha),'FaceAlpha',alpha,'EdgeAlpha',alpha);
    clabel(Cl,hl,labels,'labelspacing',300,'Color',[1 1 1]*(1-alpha))
end 

if nargin <=6 || isempty(clims) || ~exist('clims','var') % if clims are not provided

else
    clim(ax,clims);
end

set(ax,'Color','none','Visible','off')
hold(ax,"off")
end