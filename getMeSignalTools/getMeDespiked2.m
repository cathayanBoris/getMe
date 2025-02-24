function [complexOutput,timeOutput] = getMeDespiked2(timeSeries,timeInDatenum,surveyWidth,timeResolution)
% v = imag(timeSeries);
% n = mean(v,'omitmissing'); % n=1  is complex, n=0 is missing imaginary

dateVector = datevec(timeInDatenum); dateVectorYMD = dateVector(:,1:3); % length = # of entries in time series
dateNumber = datenum(dateVectorYMD); % length = # of entries in time series
dateNumberList = unique(dateNumber); % length = # of days in calendar
dateVectorList = datevec(dateNumberList); dateVectorList = dateVectorList(:,1:3); % length = # of days in calendar

u = real(timeSeries);
v = imag(timeSeries);
uDSPK = u;
vDSPK = v;
uSurvivors = u;
vSurvivors = v;

date1Number = find(dateNumber == dateNumberList(1));
if length(date1Number) < 24
    startDateNumber = dateNumberList(2);
    if length(date1Number) < surveyWidth
        date1Number = find(dateNumber == startDateNumber); % day 2
        firstToRun = date1Number(1) + surveyWidth;
    else % if date 1 has enough points to fill half of the window
        firstToRun = date1Number(1) + surveyWidth;
    end
else
    startDateNumber = dateNumberList(1);
    firstToRun = startDateNumber(1) + surveyWidth;
end
%%
n=0;
for indexAnchor = firstToRun:timeResolution:length(timeInDatenum)-surveyWidth % mark the hour indices to be centered at
    n=n+1;
    seleccionesDelDia = [indexAnchor-surveyWidth:indexAnchor+surveyWidth]; % indices of the selection of 2 x lengthOfSurvey + 1 data points in total
    tiempoNuevo(n) = timeInDatenum(indexAnchor);


    numeroDeLaSeleccion = length(seleccionesDelDia); % number of entries in today's selection, ususally 25
    quartileLength = floor(numeroDeLaSeleccion/4); % quartile length is the number of entries /4, rounded down
    % e.g. a selection of 25 entries have a quartile length of 6, [6 7 6 6]
    %      a selection of 23 entries have a quraitle length of 5, [5 7 6 5]

    uMedian = median(u(seleccionesDelDia),'omitmissing');
    vMedian = median(v(seleccionesDelDia),'omitmissing');
    [sortedU,~] = sort(u(seleccionesDelDia));
    [sortedV,~] = sort(v(seleccionesDelDia));
    pemissionRadiusOfU = sortedU((numeroDeLaSeleccion-quartileLength)) - ...
        sortedU((quartileLength+1));
    pemissionRadiusOfV = sortedV((numeroDeLaSeleccion-quartileLength)) - ...
        sortedV((quartileLength+1));

    problematicIndicesOfU = find(u(seleccionesDelDia)>(uMedian+pemissionRadiusOfU) ...
        | u(seleccionesDelDia)<(uMedian-pemissionRadiusOfU));
    problematicIndicesOfV = find(v(seleccionesDelDia)>(vMedian+pemissionRadiusOfV) ...
        | v(seleccionesDelDia)<(vMedian-pemissionRadiusOfV));

    uDSPK = u; % let re-qualified data points back into the median calculation
    vDSPK = v;

    uDSPK(seleccionesDelDia(problematicIndicesOfU)) = nan;
    uDSPK(seleccionesDelDia(problematicIndicesOfV)) = nan;
    vDSPK(seleccionesDelDia(problematicIndicesOfU)) = nan;
    vDSPK(seleccionesDelDia(problematicIndicesOfV)) = nan;

    uSurvivors(seleccionesDelDia(problematicIndicesOfU)) = nan;
    uSurvivors(seleccionesDelDia(problematicIndicesOfV)) = nan;
    vSurvivors(seleccionesDelDia(problematicIndicesOfU)) = nan;
    vSurvivors(seleccionesDelDia(problematicIndicesOfV)) = nan;

    if quartileLength < 1 % if quartile length is 0 (not enough entries (<4) to fill in)
        uMedianNuevo(n) = median(u(seleccionesDelDia),'omitmissing');
        vMedianNuevo(n) = median(v(seleccionesDelDia),'omitmissing');
    else % if quartileLength > 1, eventuallly selection >= 4
        if ismissing(uDSPK(seleccionesDelDia)) == 1 % if all uDSPK are missing
            uMedianNuevo(n) = median(u(seleccionesDelDia),'omitmissing');
        else
            uMedianNuevo(n) = median(uDSPK(seleccionesDelDia),'omitmissing');
        end

        if ismissing(vDSPK(seleccionesDelDia)) == 1 % if all vDSPK are missing
            vMedianNuevo(n) = median(v(seleccionesDelDia),'omitmissing');
        else
            vMedianNuevo(n) = median(vDSPK(seleccionesDelDia),'omitmissing');
        end
    end

end

% figure() % only total survivors are shown in the scatter plot. Those which re-joined DNQ.
% clf
% subplot(2,1,1)
% hold on
% plot(timeInDatenum,u)
% plot(tiempoNuevo,uMedianNuevo,'k','LineWidth',2)
% ylim([-1 1])
% xlim([timeInDatenum(1) timeInDatenum(end)])
% xticks(dateNumberList)
% datetick('x','keeplimits','keepticks')
% ylabel('u')
% subplot(2,1,2)
% hold on
% plot(timeInDatenum,v)
% plot(tiempoNuevo,vMedianNuevo,'k','LineWidth',2)
% ylim([-1 1])
% xlim([timeInDatenum(1) timeInDatenum(end)])
% xticks(dateNumberList)
% datetick('x','keepticks','keeplimits')
% ylabel('v')

complexOutput = uMedianNuevo + vMedianNuevo * 1i;
timeOutput = tiempoNuevo;