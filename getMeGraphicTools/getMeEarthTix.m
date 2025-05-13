function getMeEarthTix(ax)
% Note: this feature loses the precision when zoomed in
% use this function after finished developing the map
xt = xticks(ax);

for ii = 1:length(xt)
    if xt(ii) > 0
        out(ii) = compose('%G\\circE',abs(xt(ii)));
    elseif xt(ii) < 0
        out(ii) = compose('%G\\circW',abs(xt(ii)));
    else
        out(ii) = compose('%G\\circ',abs(xt(ii)));
    end
end
    set(ax,'xtickLabel',out);

    yt = yticks(ax);

for ii = 1:length(yt)
    if yt(ii) > 0
        out(ii) = compose('%G\\circN',abs(yt(ii)));
    elseif yt(ii) < 0
        out(ii) = compose('%G\\circS',abs(yt(ii)));
    else
        out(ii) = compose('%G\\circ',abs(yt(ii)));
    end
end
    set(ax,'ytickLabel',out);

end
