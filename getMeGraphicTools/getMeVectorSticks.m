function vectorStickPlot = getMeVectorSticks(X,Y,U,V,xlimits,ylimits)
% call the axes before using this function, assumes gca

% X, Y, U, V same inputs as quiver()

if nargin < 5 || isempty(xlimits)
    xlimits = get(gca,'XLim');
    ylimits = get(gca,'YLim');
end
    % pbr = get(gca,'PlotBoxAspectRatio');
    % 
    % factor = 1/diff(ylimits)*diff(xlimits)*pbr(2)/pbr(1);
    factor = getMeAxisRatio(xlimits,ylimits);
    vectorStickPlot = quiver(X,Y,U*factor,V,0,'ShowArrowHead','off');
    xlim(xlimits);
    ylim(ylimits);

end