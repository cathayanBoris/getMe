function showSomeColors = getMeRandomLeveledColors(nColor,nStep)
% gets you a colormap of nStep x nColor levels, colors are randomized

if nStep == 0
    nStep = round(255/nColor); % smooth gradient
end
% # of total steps = nColor x nStep
thisLevel = zeros(nColor*nStep,3);
for level = 1:nColor
    a = 50;
    b = 250;

    hiColors = (a + (b-a).*rand(1,3)) + 80*rand(1,3);
    hiColors(hiColors>=255) = 255;
    loColors = round(hiColors / 4);

    for cc = 1:3
        thisLevel([1:nStep]+(level-1)*nStep,cc) = linspace(loColors(cc),hiColors(cc),nStep);
    end

end
colors = ((round(thisLevel)/255));
colors(colors >= 254/255) = 254/255;
colors(colors <= 1/255) = 1/255;

showSomeColors = colors; 
% showSomeColors = colormap((round(thisLevel)/255));
end