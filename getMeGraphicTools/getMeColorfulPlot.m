function [colorfulPlot] = getMeColorfulPlot(x,y,dependentVariable,lineWidth,lineStyle,edgeAlpha)
% for x-y plane use only so far
% for some reason MATLAB is unable to display legends properly if linewidth
% > 1.9 and not being solid line in surf() or surface() functions

% x and y shall be vector array
% plot varies color wrt the dependentVariable, can be x, y or a third
% quantity depending on axis clim

% default linewidth 0.5
if nargin <= 3 || lineWidth <= 0 || isempty(lineWidth)
    lineWidth = 0.5;
end

if nargin <= 4 
    lineStyle = '-';
end

if nargin <= 5 
    edgeAlpha = 1;
end


% dimension debugging+
[a,b] = size(dependentVariable);
if a>b
    dependentVariable = dependentVariable.';
end
if size(x) ~= size(dependentVariable)
    x = x.';
end
if size(y) ~= size(dependentVariable)
    y = y.';
end

% announce gca before use
z = zeros(size(x));
colorfulPlot = surf(gca,[x;x],[y;y],[z;z],[dependentVariable;dependentVariable], ...
    'FaceColor','none','EdgeColor','interp','LineWidth',lineWidth, ...
    'LineStyle',lineStyle,'EdgeAlpha',edgeAlpha);
view(0,90)
end