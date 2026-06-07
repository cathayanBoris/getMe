function yRatio = getMeSimpleMercator(ylim)
try
    yRatio = cosd(mean(ylim));
catch
    yRatio = cosd(mean(get(gca,'YLim')));
end
daspect([1 yRatio 1]);
% L = xlim(1);
% R = xlim(2);
% D = ylim(1);
% U = ylim(2);
% axis([L R D U]);
end