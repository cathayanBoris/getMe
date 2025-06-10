function [circlePlot] = getMeCirclePlot(xorigin,yorigin,radius,lineWidth,lineStyle,alpha,colorIndex)
ang=1:89;
sinang=sind(ang); cosang=cosd(ang);
xcirc=radius*cosang;
ycirc=radius*sinang;

if nargin <= 3 % full auto
    lineWidth = 0.5;
    lineStyle = '-';
    alpha = 1;
    colorIndex = 'k';
end

if isempty(lineWidth) || ~exist('lineWidth','var')
    lineWidth = 0.5;
end

if isempty(lineStyle) || ~exist('lineStyle','var')
    lineStyle = '-';
end

if isempty(alpha) || ~exist('alpha','var')
    alpha = 0;
end

if isempty(colorIndex) || ~exist('colorIndex','var')
    colorIndex = 'k';
end

if isa(colorIndex,'char') || isa(colorIndex,'string')
    hold(gca,"on")
    a = plot(gca,xcirc+xorigin,ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    b = plot(gca,-xcirc+xorigin,ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    c = plot(gca,xcirc+xorigin,ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
    d = plot(gca,-xcirc+xorigin,-ycirc+yorigin,'LineWidth',lineWidth,'LineStyle',lineStyle,'Color',colorIndex);
else
    hold(gca,"on")
    a = getMeColorfulPlot(xcirc+xorigin,ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    b = getMeColorfulPlot(-xcirc+xorigin,ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    c = getMeColorfulPlot(xcirc+xorigin,-ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
    d = getMeColorfulPlot(-xcirc+xorigin,-ycirc+yorigin,colorIndex,lineWidth,lineStyle,alpha);
end
circlePlot = [a b c d];
hold(gca,"off")
end