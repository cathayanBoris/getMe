function [ax,C,h] = getMeGenericContours(position,longitude,latitude,altitude,intervals,labels,labelGreyscale)
% this should set an additional axes automatically for you

switch length(position)
    case 1 % position is an axis
        ax = axes;  % postision = axes
        ax.Position = get(position,'Position');
    case 4
        ax = axes("Position",position); % position = coordinates
    otherwise
        error('Position must be an existing axis or a 4-element array.')
end

if ~exist('labelGreyscale','var') || isempty(labelGreyscale)
    labelGreyscale = 0.5*[1 1 1];
else
    labelGreyscale(labelGreyscale<0) = 0;

    if isscalar(labelGreyscale) == 1
        if max(labelGreyscale) > 1
            labelGreyscale = labelGreyscale./100;
        end
        labelGreyscale = [1 1 1]*labelGreyscale;
    elseif length(labelGreyscale) == 3
        if max(labelGreyscale) > 1
            labelGreyscale = labelGreyscale./255;
        end
    end
end


if nargin == 4 || isempty(intervals) % intervals are not provided
    [C,h] = contour(ax,longitude,latitude,altitude,'Color',labelGreyscale);
else % intervals are provided
    [C,h] = contour(ax,longitude,latitude,altitude,intervals,'Color',labelGreyscale);
end

if nargin <= 5 || isempty(labels) % labels are not provided

else % labels are provided
    clabel(C,h,labels,'Color',labelGreyscale)
end

set(ax,'Color','w','Visible','off')

if length(position) == 1
    ax.XLim = get(position,'XLim');
    ax.YLim = get(position,'YLim');
end

end