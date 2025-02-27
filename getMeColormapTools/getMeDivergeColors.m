function showSomeColors = getMeDivergeColors(rgbStart,rgbEnd,rgbStart2,rgbEnd2,n)
% if n is odd, end1 and start2 must be the same
% https://www.rapidtables.com/web/color/RGB_Color.html

if nargin <= 4 || n == 0
    n = 256;
end

if (-1)^n < 0 % odd
    colors(1:round(n/2),:) = 1/255 *[linspace(rgbStart(1), rgbEnd(1), round(n/2))', linspace(rgbStart(2), rgbEnd(2), round(n/2))', linspace(rgbStart(3), rgbEnd(3), round(n/2))'];
    colors(round(n/2):n,:) = 1/255 *[linspace(rgbStart2(1), rgbEnd2(1), round(n/2))', linspace(rgbStart2(2), rgbEnd2(2), round(n/2))', linspace(rgbStart2(3), rgbEnd2(3), round(n/2))'];

elseif (-1)^n > 0 % even
    colors(1:n/2,:) = 1/255 *[linspace(rgbStart(1), rgbEnd(1), n/2)', linspace(rgbStart(2), rgbEnd(2), n/2)', linspace(rgbStart(3), rgbEnd(3), n/2)'];
    colors(n/2+1:n,:) = 1/255 *[linspace(rgbStart2(1), rgbEnd2(1), n/2)', linspace(rgbStart2(2), rgbEnd2(2), n/2)', linspace(rgbStart2(3), rgbEnd2(3), n/2)'];
end
showSomeColors = colors;
% showSomeColors = colormap(colors);

% cbar = colorbar;
% cbar.Title.String  = "Your  Colors";