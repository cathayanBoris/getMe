function rgbOutput = getMeSaturated(rgb,saturation,lightness)

if max(rgb)>1
rgb = rgb./255;
end

hsl = getMeHSLfromRGB(rgb);
if exist('saturation','var') && ~isempty(saturation)
hsl(2) = saturation;
end
if exist('lightness','var') && ~isempty(lightness)
hsl(3) = lightness;
end
rgbOutput = getMeRGBfromHSL(hsl);
end




