function [colorIndex] = getMeColorIndex(input,clims,N)
% please declare N: number of levels in colormap prior

if nargin <=2 || ~exist("N","var") || isempty(N) || N == 0
    N = 256;
end
clims = sort(clims,"ascend");
hiLim = clims(2);
loLim = clims(1);
% clim(ax1,[loLim hiLim])
colorIndex = (input - loLim) / (hiLim - loLim);
colorIndex(colorIndex<=0) = 0; colorIndex(colorIndex>=1) = 1;
colorIndex = round(colorIndex*N);
colorIndex(colorIndex<=1) = 1; colorIndex(colorIndex>=N) = N;
end