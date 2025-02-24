function showSomeColors = getMeColors(rgbStart,rgbEnd,n)

% https://www.rapidtables.com/web/color/RGB_Color.html

if n == 0
    n = 256;
end

colors = 1/255 *[linspace(rgbStart(1), rgbEnd(1), n)', linspace(rgbStart(2), rgbEnd(2), n)', linspace(rgbStart(3), rgbEnd(3), n)'];
showSomeColors = colors;
% showSomeColors = colormap(colors);

% cbar = colorbar;
% cbar.Title.String  = "Your Colors";