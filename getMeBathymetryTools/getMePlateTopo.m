function [output] = getMePlateTopo(H,gradH,xtopo,ytopo,ztopo)

ix = floor(0.5*(length(xtopo)));
iy = floor(0.5*(length(ytopo)));
for i = 1:length(xtopo)
    for j = 1:length(ytopo)
        degDist = cosd(mean([ytopo(1) ytopo(end)])) * 2*pi * 6378000 * 1/360;
        lonDiff = xtopo(i) - xtopo(ix);
        latDiff = ytopo(j) - ytopo(iy);
        ztopo(i,j) = H + ((1/sqrt(2)) * gradH * lonDiff * degDist) - ((1/sqrt(2)) * gradH * latDiff * degDist);
    end
end

output = -ztopo;

