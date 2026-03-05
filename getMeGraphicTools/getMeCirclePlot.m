function [circlePlot] = getMeCirclePlot(xorigin,yorigin,radius,lineWidth,lineStyle,alpha,colorIndex)
% for x-y plane use only so far
% for some reason MATLAB is unable to display legends properly if linewidth
% > 1.9 and not being solid line in surf() or surface() functions

ang= 0.1:0.1:89.9;
sinang=sind(ang); cosang=cosd(ang);
xcirc=radius*cosang;
ycirc=radius*sinang;

if nargin <= 3 % full auto
    lineWidth = 0.5;
    lineStyle = '-';
    alpha = 1;
    colorIndex = [0 0 0];
end

if  ~exist('lineWidth','var') || isempty(lineWidth)
    lineWidth = 0.5;
end

if ~exist('lineStyle','var') || isempty(lineStyle)
    lineStyle = '-';
end

if ~exist('alpha','var') || isempty(alpha)
    alpha = 0;
end

if ~exist('colorIndex','var') || isempty(colorIndex)
    colorIndex = [0 0 0];
end



circlePlot = plot([1 2 3],[3 5 7]);

if isa(colorIndex,'char') || isa(colorIndex,'string') || length(colorIndex) == 3
    % alpha seems not working in this case

    a = plot(gca,xcirc+xorigin,ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    hold(gca,"on")
    b = plot(gca,-xcirc+xorigin,ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    c = plot(gca,xcirc+xorigin,-ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    d = plot(gca,-xcirc+xorigin,-ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
else
    if isscalar(colorIndex)
        colorIndex = colorIndex.*ones(size(ang));
    end
    a = getMeColorfulPlot(xcirc+xorigin,ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    hold(gca,"on")
    b = getMeColorfulPlot(-xcirc+xorigin,ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    c = getMeColorfulPlot(xcirc+xorigin,-ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    d = getMeColorfulPlot(-xcirc+xorigin,-ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
end
circlePlot = [a b c d];


hold(gca,"off")
end