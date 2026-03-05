function pieChart = getMePieChart(requestX,requestY,data,labels,scale,colorList,alpha,explode)

if ~exist("explode",'var') || isempty(explode)
    explode = zeros(size(data));
end

if ~exist("labels",'var') || isempty(labels) % no labeling
    pieChart = pie(data,explode,repmat({''},size(data)));
elseif length(labels) ~= length(data) % show percentage, {''} will do the trick
    pieChart = pie(data,explode);
else
    pieChart = pie(data,explode,labels);
end
if ~exist("scale",'var') || isempty(scale)
    scale = 1;
end
cc = 0;
for ii = 1:length(pieChart)
    if pieChart(ii).Type=="patch"
        XData = pieChart(ii).XData;
        YData = pieChart(ii).YData;
        factor = getMeAxisRatio();
        set(pieChart(ii),'XData', XData*scale*factor + requestX);
        set(pieChart(ii),'YData', YData*scale + requestY);

        cc = cc+1;
        if ~exist("colorList",'var') || isempty(colorList)
        else
            try
                set(pieChart(ii),'FaceColor',colorList(cc,:))
            catch
                set(pieChart(ii),'FaceColor','flat')
            end

        end
        if ~exist("alpha",'var') || isempty(alpha)
        else
            set(pieChart(ii),'FaceAlpha', alpha);
        end
    else
        pos = pieChart(ii).Position;
        pieChart(ii).Position = [pos(1)*factor pos(2) pos(3)]*scale + [requestX requestY 0];
    end
end
