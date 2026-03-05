function rgb = getMeRGBfromHSL(hsl)

h = hsl(1);
s = hsl(2);
l = hsl(3);

c = (1-abs(2*l-1))*s;
hh = h./60;
x = c.*(1 - abs(mod(hh,2)-1));
m = l-c/2;

switch floor(hh)
    case 0
        rrggbb = [c x 0];
    case 1
        rrggbb = [x c 0];
    case 2
        rrggbb = [0 c x];
    case 3
        rrggbb = [0 x c];
    case 4
        rrggbb = [x 0 c];
    case 5
        rrggbb = [c 0 x];
end

rgb = (rrggbb + m) * (255);
rgb(rgb<=0) = rgb(rgb<=0) + 1e-13;
rgb(rgb>=255-1e-13) = rgb(rgb>=255-1e-13) - 1e-13;


end