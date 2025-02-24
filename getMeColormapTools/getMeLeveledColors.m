function showSomeColors = getMeLeveledColors(colorList,nStep)
% # of total steps = colorList(nColor,3) x nStep
lengthList = length(colorList(:,1)); % number of colors
thisLevel = zeros(lengthList*nStep,3);
for level = 1:lengthList

    hiColors = colorList(level,:);
    loColors = round(hiColors / 3);

    for cc = 1:3
        thisLevel([1:nStep]+(level-1)*nStep,cc) = linspace(loColors(cc),hiColors(cc),nStep);
    end

end
showSomeColors = ((round(thisLevel)/255));
% showSomeColors = colormap((round(thisLevel)/255));
end