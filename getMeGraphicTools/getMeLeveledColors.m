function showSomeColors = getMeLeveledColors(colorList,nStep)
% % gets you a colormap of nStep x nColor levels, colors are specified
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

colors = ((round(thisLevel)/255));
colors(colors >= 254/255) = 254/255;
colors(colors <= 1/255) = 1/255;

showSomeColors = colors; 
% showSomeColors = colormap((round(thisLevel)/255));
end