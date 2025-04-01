function showSomeColors = getMeLeveledRandomColors(nColor,nStep)
% gets you a colormap of nStep x nColor levels, colors are randomized

if nStep == 0
    nStep = round(255/nColor); % smooth gradient
end
% # of total steps = nColor x nStep
thisLevel = zeros(nColor*nStep,3);
for level = 1:nColor
    a = 150;
    b = 240;

    hiColors = (a + (b-a).*rand(1,3))+15;
    loColors = round(hiColors / 2.5);

    for cc = 1:3
        thisLevel([1:nStep]+(level-1)*nStep,cc) = linspace(loColors(cc),hiColors(cc),nStep);
    end

end
showSomeColors = ((round(thisLevel)/255));
% showSomeColors = colormap((round(thisLevel)/255));
end