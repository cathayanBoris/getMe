function [ax,C,h,Cl,hl] = getMeGenericMap(position,longitude,latitude,altitude,intervals,labels,clims,alpha)
% this should set an additional axes automatically for you

%%% EXAMPLE %%%%
% figure(1)
% clf
% set(gca,'Visible','off')
% ax1=getMeGenericMap(gca,xtopo,ytopo,ztopo',[-4000:100:4000],[-3000:1000:-1000],[-1 1]*4000,1);
% axis(ax1,mapLims);
% getMeSimpleMercator([mapLims(3) mapLims(4)]);
% xticks(ax1,unique(getMeRounded(xtopo,0.5)));
% yticks(ax1,unique(getMeRounded(ytopo,0.5)));
% ax1.Visible = 'on';
% ax1.FontSize=fs;
% getMeEarthTix(ax1)
%%%%%%%%%%%%%%%%


if isempty(position)
    ax = axes("Position",get(gca,'Position'));
else
    switch length(position)
        case 1 % position is an axis
            ax = axes("Position",get(position,'Position')); % postision = axes
        case 4
            ax = axes("Position",position); % position = coordinates
        otherwise
            error('Position must be an existing axis or a 4-element array.')
    end
end

hold(ax,"on")
warning off % default contouf does not fill area below interval loLim, suppress a flat loLim background here

if nargin <=7  || ~exist('clims','var') || isempty(clims) % if faceAlpha are not provided
    alpha = 1;
else
end

if nargin == 4  || ~exist('intervals','var')|| isempty(intervals) % intervals are not provided
    contourf(ax,longitude,latitude,ones(size(altitude))*min(altitude,[],'all'),'EdgeColor','auto','FaceAlpha',alpha,'EdgeAlpha',alpha);
    [C,h]=contourf(ax,longitude,latitude,altitude,'EdgeColor','none','FaceAlpha',alpha,'EdgeAlpha',alpha);
else % intervals are provided
    [~,~]=contourf(ax,longitude,latitude,ones(size(altitude))*min(intervals,[],'all'),intervals,'EdgeColor','auto','FaceAlpha',alpha,'EdgeAlpha',alpha*0.01);
    [C,h]=contourf(ax,longitude,latitude,altitude,intervals,'EdgeColor','none','FaceAlpha',alpha,'EdgeAlpha',alpha*0.01);
end

if nargin <= 5  || ~exist('labels','var') || isempty(labels)% labels are not provided

else % labels are provided
    [Cl,hl]=contour(ax,longitude,latitude,altitude,labels,':','EdgeColor',[1 1 1]*(1-alpha),'FaceAlpha',alpha,'EdgeAlpha',alpha);
    clabel(Cl,hl,labels,'labelspacing',300,'Color',[1 1 1]*(1-alpha))
end

if nargin <=6  || ~exist('clims','var') || isempty(clims) % if clims are not provided

else
    clim(ax,clims); % this line resets clim per request but any unassigned space lower than interval loLim stays blank
end

set(ax,'Color','none','Visible','off')
hold(ax,"off")
warning on
end