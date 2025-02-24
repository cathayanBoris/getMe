function [gulfN,fit] = getMeGulfN(belowThis)

for h = 1:2 % number of CTD cruises
    if h == 1
        A = dir('GoM\CTD\CTD20\');
    elseif h == 2
        A = dir('GoM\CTD\CTD21\');
    end
    for i = 1:length(A)-2 % number of files
        fileName(i) = convertCharsToStrings(A(i+2).name);

                convert = convertStringsToChars(fileName(i));
        mapCtd(i,h) = convertCharsToStrings(convert([5:6]));
        clear convert

        pressure = ncread(fileName(i),'pressure');
        if pressure(end) >= belowThis+200 % only the CTDs 200m deeper qualify
            SA = gsw_SA_from_SP(ncread(fileName(i),'salinity'),pressure,ncread(fileName(i),'lon'),ncread(fileName(i),'lat'));
            CT = gsw_CT_from_t(SA,ncread(fileName(i),'temperature'),pressure);

            [b,a] = butter(8,0.05);
            CTs = filtfilt(b,a,CT);
            SAs = filtfilt(b,a,SA);

            [gswNsquared,pmid] = gsw_Nsquared(SAs,CTs,pressure,ncread(fileName(i),'lat'));
            meanLat(i,h) = mean(ncread(fileName(i),'lat'),"omitmissing");
            meanLon(i,h) = mean(ncread(fileName(i),'lon'),"omitmissing");
            theArray = gswNsquared(find(pmid >= belowThis));
            mapAvg(i,h) = sqrt(mean(theArray));
            bruh = convertStringsToChars(fileName(i));
            mapLabel(i,h) = convertCharsToStrings(bruh(5:6));
        else
            meanLat(i,h) = nan;
            meanLon(i,h) = nan;
            mapAvg(i,h) = nan;
            mapLabel(i,h) = "";
        end
    end
end
meanLat(find(meanLat(:,:) == 0)) = nan;
meanLon(find(meanLon(:,:) == 0)) = nan;
mapLabel(find(ismissing(mapLabel(:,:)))) = "";
mapAvg(find(mapAvg(:,:) == 0)) = nan;

mapCtd(find(ismissing(mapCtd(:,:)))) = "";

scatterLabel = unique(mapCtd);
scatterLabel = scatterLabel(2:end);
scatterArray = nan(length(scatterLabel),2);
scatterLon = nan(length(scatterLabel),2);
scatterLat = nan(length(scatterLabel),2);
for h = 1:2
    for i = 1:length(scatterLabel)
        n = find(scatterLabel(i) == mapLabel(:,h));
        if ~ismissing(n)
            scatterArray(i,h) = mapAvg(n,h);
            scatterLon(i,h) = meanLon(n,h);
            scatterLat(i,h) = meanLat(n,h);
        end
    end
end

[xtopo,ytopo,ztopo] = getMeTopo(-96,-84,20,30);
scatterZ = nan(size(scatterLabel));
scatterN = nan(size(scatterLabel));
for h = 1:2
    for i = 1:length(scatterLabel)
        if ~ismissing(scatterArray(i,h))
            [~,iLon] = min(abs(xtopo-scatterLon(i,h)));
            [~,iLat] = min(abs(ytopo-scatterLat(i,h)));
            if h == 1
                scatterZ(i) = ztopo(iLon,iLat);
                scatterN(i) = scatterArray(i,h);
            elseif h == 2
                if scatterZ(i) ~= ztopo(iLon,iLat)
                    scatterZ(i) = mean([scatterZ(i) ztopo(iLon,iLat)],"omitmissing");
                elseif scatterZ(i) == ztopo(iLon,iLat)
                end
                if scatterN(i) ~= scatterArray(i,h)
                    scatterN(i) = mean([scatterN(i)  scatterArray(i,h)],"omitmissing");
                elseif scatterN(i) == scatterArray(i,h)
                end
            end
        else % if scatterArray(i,h) is missing
            if h == 1
                scatterZ(i) = nan;
            elseif h == 2
                if ~isnan(scatterZ(i))
                else
                    scatterZ(i) = nan;
                end
                if ~isnan(scatterN(i))
                else
                    scatterN(i) = nan;
                end
            end
        end
    end
end

figure
hold on
scatter([1:length(scatterLabel)],scatterArray(:,1),"pentagram","LineWidth",2)
scatter([1:length(scatterLabel)],scatterArray(:,2),"o","LineWidth",2)
for i = 1:length(scatterLabel)
    for h = 1:2
        text(i-0.5,scatterArray(i,h)+0.000005,[num2str(10^4*round(scatterArray(i,h),4,"significant"))])
    end
end
xticks(1:length(scatterLabel))
xlim([1 length(scatterLabel)])
xticklabels(scatterLabel)
grid on
title(['Buoyancy frequency below ' num2str(belowThis) 'm,  (x10^{-4})' ],['Ring 2020, Star 2021'])
ylabel('N (s^{-1})')
xlabel('CTD Point')

depths = scatterZ(find(~isnan(scatterZ)));
frequencies = scatterN(find(~isnan(scatterN)));
gulfN = mean(frequencies,"omitmissing");
figure
hold on
scatter(scatterZ,scatterN)
scatter(depths,frequencies)
fit = polyfit(depths,frequencies,1);
fitN = polyval(fit,depths);
yline(gulfN,"LineWidth",1);
plot(depths,fitN);
text(min(depths),min(frequencies),['N(Z)=',num2str(fit(1)),'xZ+',num2str(fit(2))])
text(min(depths),gulfN,['avgN(Z)=',num2str(gulfN)])
title(['Linear Fit N(Z) under ',num2str(belowThis),'m'])
grid on