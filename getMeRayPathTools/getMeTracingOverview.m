%% need cmocean to run
[xtopo,ytopo,ztopoS] = getMeSmoothed(30000,-91.5,-87.5,25.8,27.8);

filePath = dir('C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\backward\*.mat');

choice = menu('Select Visualization Mode','Wavelength Mode','Time Span Mode', ...
    'Cg Mode','h Mode','∇h Mode','Period T Mode','Period T Discrepancy','dh/dt Mode');
lowClim = 0;
howManyDaysToSee = 15;
clear colorIndex


if choice == 1 % Wavelength
    hiClim = 600;
    cMap = cmocean('thermal');
elseif choice == 2 % Time span
    hiClim = howManyDaysToSee;
    cMap = prism(hiClim);
elseif choice == 3 % Cg
    hiClim = 0.5;
    cMap = hot;
elseif choice == 4 % Depth
    hiClim = -1000;
    lowClim = -3000;
    cMap = flipud(cmocean('dense'));
elseif choice == 5 % ∇h
    hiClim = 0.05;
    cMap = cmocean('algae');
elseif choice == 6
    hiClim = 40;
    cMap = spring(hiClim);
elseif choice == 7 % T reconstruction
    cMap = cmocean('diff',20);
elseif choice == 8 % dh/dt
    hiClim = 0;
    lowClim = -15;
    cMap = cmocean('thermal');
end
%%
figure(10)
clf
axesPosition = get(gca,'Position');
set(gca,'visible','off')
ax1 = axes('Position',axesPosition);
v = -3500:100:0;
labelColor = [1 1 1]*0.25;
[C,h] = contourf(ax1,xtopo,ytopo,ztopoS',v,'color',labelColor,'ShowText','off',"FaceAlpha",0.5,"LabelSpacing",350,'Linestyle',':');
clabel(C,h,[-3000:500:-2000 -1000],'color',labelColor+0.1)
% contourf(ax1,xtopo,ytopo,ztopo',v,'ShowText','off',"FaceAlpha",0.9,"LineStyle",":","LabelSpacing",350);
colormap(ax1,flipud(cmocean('deep')))
% cb1 = colorbar(ax1,"east",'Color','w');
% cb1.Limits = [-3500 0];
% cb1.Label.String = "Bathymetry Elevation (m)";
hold on

xlabel(ax1,'Longitude E')
ylabel(ax1,'Latitude N')
daspect(ax1,[1 1 1])
ylim(ax1,[25.8 27.8])
xlim(ax1,[-91.5 -87.5])
hold off

ax2 = axes('Position',axesPosition);

hold on
howManyDrawn = 0
for ii = 1:length(filePath)
    fileName = (filePath(ii).name);
    load(fileName)

    if startT ~= 0 && startLAM ~= 0  && startLat ~= 0 && startLon > -90 && dt_hr ~= 0 && days ~= 0
        colorIndex = zeros([length(pathLon) 3]);
        if choice == 1
            colorIndex = (0.002*pi./pathK0);
        elseif choice == 2
            colorIndex = ((timeHr/24));
        elseif choice == 3
            [~,~,colorIndex,~,~] = getMeGroupVelocities(startT,pathK,pathL,pathEi);
        elseif choice == 4
            colorIndex = -pathEi(:,1);
        elseif choice == 5
            colorIndex = sqrt(pathEi(:,2).^2+pathEi(:,3).^2);
        elseif choice == 6
            colorIndex = startT*ones(size(pathLon));
        elseif choice == 7
            [~,~,~,~,reSig] = getMeGroupVelocities(startT,pathK,pathL,pathEi);
            lowClim = -10;
            hiClim = 10;
            colorIndex = 2*pi./reSig./86400 - startT;
        elseif choice == 8
            colorIndex = [diff(pathEi(:,1)); 0] / dt_hr;
        end
        cb2 = colorbar(ax2,'east','Color','k');
        clim(ax2,[lowClim hiClim])
        if choice == 1
            cb2.Label.String = "Wavelength (km)";
        elseif choice == 2
            cb2.Label.String = "Time Elapsed (day)";
        elseif choice == 3
            cb2.Label.String = "Group Velocity (m/s)";
        elseif choice == 4
            cb2.Label.String = "Depth z=-h (m)";
        elseif choice == 5
            cb2.Label.String = "∇h (m/m)";
            elseif choice == 6
            cb2.Label.String = "Wave Period T (day)";
        elseif choice == 7
            cb2.Label.String = "Simulation period discrepancy (day)";
        elseif choice == 8
            cb2.Label.String = "dh/dt (m/h)";
        end
        pathScatter = scatter(ax2,pathLon,pathLat,15,colorIndex);
        howManyDrawn = howManyDrawn + 1
    else
    end
end
lonListP = [-89.2 -89.2 -89.165 -89.2 -89.35 -89.5 -89.65 -89.8 -89.98 -90.5];
latListP = [27.502 27.361 27.22 27.08 26.902 26.719 26.542 26.36 27.23 26.75];
a = scatter(ax2,lonListP(2*(1:4)-1), latListP(2*(1:4)-1),'markeredgecolor','k','markerfacecolor',[1 0.5 0]);
b = scatter(ax2,lonListP(2*(1:4)), latListP(2*(1:4)),'markeredgecolor','k','markerfacecolor','y');
scatter(ax2,-90.1, 26,'markeredgecolor','y')
c = scatter(ax2,[-89.98 -90.5],[27.23 26.75],'markerfacecolor','#fc03c6','markeredgecolor','k');

ax2.Visible = 'off';
ylim(ax2,[25.8 27.8])
xlim(ax2,[-91.5 -87.5])
daspect(ax2,[1 1 1])
colormap(ax2,cMap)
linkaxes([ax1 ax2]);
ax2.Visible = 'off';

% startMarks = scatter(ax1,pathLon(1),pathLat(1),10,'o','filled','MarkerEdgeColor',"black","MarkerFaceColor","yellow");
% pathMarks = scatter(ax1,pathLon(everyDayMarks),pathLat(everyDayMarks),10,'o','MarkerEdgeColor',"black");