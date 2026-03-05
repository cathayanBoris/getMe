function [hsl] = getMeHSLfromRGB(rgb)

if max(rgb) > 1
    rgb = rgb/255;
end


[cmax,ii] = max(rgb);
cmin = min(rgb);
del = cmax-cmin;

l = (cmax+cmin)/2;

if cmax == cmin
    s = 0;
    h = 0;
else
    s = (cmax-cmin)./ (1-abs(2.*l-1));
    switch ii
        case 1
            h = 60*mod((rgb(2)-rgb(3))/del,6);
        case 2
            h = 60*((rgb(3)-rgb(1))/del+2);
        case 3
            h = 60*((rgb(1)-rgb(2))/del+4);
    end
    if h < 0
        h = h+360;
    end
end

hsl = [h s l];

end

