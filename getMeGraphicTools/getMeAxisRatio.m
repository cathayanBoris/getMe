function factor = getMeAxisRatio(xlimits,ylimits)
% use as a factor to stretch x-dir * factor or y-dir ./ factor
if nargin < 1 || isempty(xlimits)
    xlimits = get(gca,'XLim');
    ylimits = get(gca,'YLim');
    if nargin == 1 % 'xlimits is the designated axis
        xlimits = get(xlimits,'XLim');
        ylimits = get(xlimits,'YLim');
    end
end
pbr = get(gca,'PlotBoxAspectRatio');
factor = 1/diff(ylimits)*diff(xlimits)*pbr(2)/pbr(1);
end