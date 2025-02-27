function getMeColorfulPlot(x,y,dependentVariable,lineWidth)
% x and y shall be array
% plot varies color wrt the dependentVariable, can be x, y or a third
% quantity depending on axis clim
if nargin <= 3 || lineWidth <= 0
    lineWidth = 0.5;
end

z = zeros(size(x));
surface([x;x],[y;y],[z;z],[dependentVariable;dependentVariable],'FaceColor','none','EdgeColor','interp','LineWidth',lineWidth);
end