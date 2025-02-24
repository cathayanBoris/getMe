% obsolete - turn to getMeTracingOverview

%  load sites.mat
load bathyGOM.mat;
howManyDaysToSee = 15;
howManyDayStep = 1/4; % 
choice = 2; % colorbar switch: 1=wavelength 2=elapsed time

figure(11)
clf
lowClim = 0;
clear colormap
clear colorIndex

if choice == 1
    hiClim = 400;
    cMap = colormap("hot");
elseif choice == 2
    hiClim = howManyDaysToSee;
    cMap = colormap("jet");
end


ax1 = axes;
v = -3300:100:0;
% contourf(ax1,xtopo,ytopo,ztopo',v,'ShowText','off',"FaceAlpha",0.9,"LineStyle",":","LabelSpacing",350);
colormap(ax1,flipud(cmocean('deep')))
cb1 = colorbar(ax1,"southoutside");
cb1.Limits = [-3300 0];
cb1.Label.String = "Bathymetry Elevation (m)";
hold on
[C,h] = contourf(ax1,xtopo,ytopo,ztopoS',v,'k','ShowText','on',"FaceAlpha",0.9,"LabelSpacing",400);
% clabel(C,h,'labelspacing',400)
xlabel(ax1,'Longitude E')
ylabel(ax1,'Latitude N')
axis equal
ylim(ax1,[26.2 28])
xlim(ax1,[-91 -89])
% pies = scatter(ax1,cpies.lon,cpies.lat,'filled','MarkerEdgeColor','k','MarkerFaceColor','g');
lon3 = [-89.2 -89.2 -89.2 ];
lat3 = [26.45 26.8 27.15 ];
lonS1S2 = [-89.98 -90.5];
latS1S2 = [27.23 26.75];
scatter(ax1,lonS1S2, latS1S2,'filled','MarkerEdgeColor','k','MarkerFaceColor','y')
itemLat = [27.5 27.36 27.22 27.08 26.9 26.72 26.54 26.36 26.18 26];
itemLon = [-89.2 -89.2 -89.2 -89.2 -89.35 -89.5 -89.65 -89.8 -89.95 -90.1];
scatter(ax1,itemLon,itemLat,'filled','MarkerEdgeColor','k','MarkerFaceColor','y')
ax1.FontSize = 20;

ax2 = axes;
axis equal
ylim(ax2,[26.2 28])
xlim(ax2,[-91 -89])
ax2.Visible = 'off';
ax2.FontSize = 15;
% cb2 = colorbar(ax2,'Position',[.77 .11 .014 .815]);
cb2 = colorbar(ax2,'eastoutside');
clim(ax2,[lowClim hiClim])
if choice == 1
    cb2.Label.String = "Wavelength (km)";
elseif choice == 2
    cb2.Label.String = "Time Elapsed (day)";
end
colormap(ax2,cMap)


nDay = [0:0.125:howManyDaysToSee*24]/24; % create an array of nDay in hours
warning off

indicesExamined = 1;
% everyday 192
% every hour 8
for indicesElapsed = 1:192*howManyDayStep:length(nDay) % length nDay = n x 192 + 1
    everyDayMarks = (0:floor(nDay(indicesElapsed)))*192+1;

    filePath = dir('C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\south\');
    filePath = filePath(3:end);

    for i = 1:length(filePath)
        fileName = (filePath(i).name);
        load(fileName)
        % Here
        if startT == 25  && startLAM > 200  && startLat ~= 0 && startLon ~= 0 && dt_hr == 0.125 && days ~= 0
            for q = indicesExamined:indicesElapsed

                % choose colorbar mode
                if choice == 1
                    r = round(255 * ((0.002*pi/pathK0(q) - lowClim) / (hiClim-lowClim))) + 1;
                elseif choice == 2
                    r = round(255* (time(q)/24) / (howManyDaysToSee)) + 1;
                end

                if r <= 1
                    colorIndex(q,:) = cMap(1,:);
                elseif r > 256
                    colorIndex(q,:) = cMap(256,:);
                else
                    colorIndex(q,:) = cMap(r,:);
                end
            end
            if pathLon(q(1)) > -90.6
                pathScatter = scatter(ax1,pathLon(indicesExamined:indicesElapsed),pathLat(indicesExamined:indicesElapsed),8,colorIndex(indicesExamined:indicesElapsed,:));
                startMarks = scatter(ax1,pathLon(1),pathLat(1),10,'o','filled','MarkerEdgeColor',"black","MarkerFaceColor","yellow");
                pathMarks = scatter(ax1,pathLon(everyDayMarks),pathLat(everyDayMarks),10,'o','MarkerEdgeColor',"black");
            end
        end
        title(ax1,['Time elapsed ',num2str(sign(dt_hr)*(indicesElapsed-1)/192),' day(s)']);
        % title(ax1,['Time elapsed ',num2str(sign(dt_hr)*(indicesElapsed-1)/8),' hour(s)']);
    end


    pause(1)
    indicesExamined = indicesElapsed;
end

lonS1S2 = [-89.98 -90.5];
latS1S2 = [27.23 26.75];
scatter(ax1,lonS1S2, latS1S2,'filled','MarkerEdgeColor','k','MarkerFaceColor','y')
itemLat = [27.5 27.36 27.22 27.08 26.9 26.72 26.54 26.36 26.18 26];
itemLon = [-89.2 -89.2 -89.2 -89.2 -89.35 -89.5 -89.65 -89.8 -89.95 -90.1];
scatter(ax1,itemLon,itemLat,'filled','MarkerEdgeColor','k','MarkerFaceColor','y')

linkaxes([ax1 ax2]);