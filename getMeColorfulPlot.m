function getMeColorfulPlot(x,y,dependentVariable,lineWidth)
% x and y shall be array
% plot varies color wrt the dependentVariable, can be x, y or a third
% quantity depending on axis clim

% default linewidth 0.5
if nargin <= 3 || lineWidth <= 0
    lineWidth = 0.5;
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


whos x
whos y
whos dependentVariable

z = zeros(size(x));
surface([x;x],[y;y],[z;z],[dependentVariable;dependentVariable],'FaceColor','none','EdgeColor','interp','LineWidth',lineWidth);
end