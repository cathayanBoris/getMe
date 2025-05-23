function showSomeColors = getMeRandomColors(n)
% gets you a colormap of n randomized different colors
a = 0;
b = 255;
colors = (a + (b-a).*rand(n,3))/255;
colors(colors >= 254/255) = 254/255;
colors(colors <= 1/255) = 1/255;
showSomeColors = colors;
% showSomeColors = colormap(colors);
end