function showSomeColors = getMeRandomColors(n)
a = 0;
b = 255;
colors = (a + (b-a).*rand(n,3))/255;
showSomeColors = colors;
% showSomeColors = colormap(colors);
end