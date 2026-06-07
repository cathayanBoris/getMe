function [colorIndex] = getMeColorIndex(input,clims,N,logScale)
% please declare N: number of levels in colormap prior
% NOTE: better specify axes before calling


if nargin <=2 || ~exist("N","var") || isempty(N) || N == 0
    N = 256;
end
clims = sort(clims,"ascend");
hiLim = clims(2);
loLim = clims(1);
% clim(ax1,[loLim hiLim])

if ~exist('logScale','var') || isempty(logScale)
    cLtyp = get(gca,'colorscale');
    if cLtyp(1:3) == 'log'
        logScale = 1;
    end
end


if exist("logScale",'var') && logScale == 1
    colorIndex = (log10(input) - log10(loLim)) / (log10(hiLim) - log10(loLim));
else
    colorIndex = (input - loLim) / (hiLim - loLim);
end
colorIndex(colorIndex<=0) = 0; colorIndex(colorIndex>=1) = 1;
colorIndex = ceil(colorIndex*N);
colorIndex(colorIndex<=1) = 1; colorIndex(colorIndex>=N) = N;
end