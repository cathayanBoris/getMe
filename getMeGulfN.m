function [gulfNsfc,gulfNavg] = getMeGulfN(belowThis)
% belowThis = -1000;
qualification = [{'A2'},{'B1'}];
for h = 1:2 % number of CTD cruises
    if h == 1
        A = dir('C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\CTD\CTD20\*.nc');
        fileDir = 'C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\CTD\CTD20\';
    elseif h == 2
        A = dir('C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\CTD\CTD21\*.nc');
        fileDir = 'C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\CTD\CTD21\';
    end
    for i = 1:length(A)
        fileName(i) = convertCharsToStrings(A(i).name);

        convert = convertStringsToChars(fileName(i));
        fileToRead = [fileDir convert];

        % % % % if matches(convert(5:6),'A2') | matches(convert(5:6),'B1')
        % if ismember(convert(5:6),qualification)
        % 
        % else
        %     continue
        % end

        mapCtd(i,h) = convertCharsToStrings(convert([5:6]));
        % clear convert

        pressure = ncread(fileToRead,'pressure');
        if pressure(end) >= belowThis % only the CTDs 200m deeper qualify
            SA = gsw_SA_from_SP(ncread(fileToRead,'salinity'),pressure,ncread(fileToRead,'lon'),ncread(fileToRead,'lat'));
            CT = gsw_CT_from_t(SA,ncread(fileToRead,'temperature'),pressure);

            [b,a] = butter(8,0.05);
            CTs = filtfilt(b,a,CT);
            SAs = filtfilt(b,a,SA);
            % CTs = CT;
            % SAs = SA;

            [gswNsquared,pmid] = gsw_Nsquared(SAs,CTs,pressure,ncread(fileToRead,'lat'));
            meanLat(i,h) = mean(ncread(fileToRead,'lat'),"omitmissing");
            meanLon(i,h) = mean(ncread(fileToRead,'lon'),"omitmissing");
            theArray = gswNsquared(find(pmid >= abs(belowThis)));
            mapAvg(i,h) = sqrt(mean(theArray)); % the average N below the requested depth
            try
                mapRequested(i,h) = sqrt(theArray(1));
            catch
                mapRequested(i,h) = nan;
            end
            bruh = convertStringsToChars(fileName(i));
            mapLabel(i,h) = convertCharsToStrings(bruh(5:6));
        else
            meanLat(i,h) = nan;
            meanLon(i,h) = nan;
            mapAvg(i,h) = nan;
            mapRequested(i,h) = nan;
            mapLabel(i,h) = "";
        end
    end
end
% meanLat(find(meanLat(:,:) == 0)) = nan;
% meanLon(find(meanLon(:,:) == 0)) = nan;
mapLabel(find(ismissing(mapLabel(:,:)))) = "";
mapAvg(find(mapAvg(:,:) <= 0)) = nan;
mapRequested(find(mapRequested(:,:) <= 0)) = nan;
mapCtd(find(ismissing(mapCtd(:,:)))) = "";

scatterLabel = unique(mapCtd);
scatterLabel = scatterLabel(2:end);
scatterAvg = nan(length(scatterLabel),2);
scatterSfc = nan(length(scatterLabel),2);
% scatterLon = nan(length(scatterLabel),2);
% scatterLat = nan(length(scatterLabel),2);
for h = 1:2
    for i = 1:length(scatterLabel)
        n = find(scatterLabel(i) == mapLabel(:,h));
        if ~ismissing(n)
            scatterAvg(i,h) = mapAvg(n,h);
            scatterSfc(i,h) = mapRequested(n,h);
            % scatterLon(i,h) = meanLon(n,h);
            % scatterLat(i,h) = meanLat(n,h);
        end
    end
end

% [xtopo,ytopo,ztopo] = getMeTopo(-96,-84,20,30);
% scatterZ = nan(size(scatterLabel));
scatterNavg = nan(size(scatterLabel));
scatterNsfc = scatterNavg;
for h = 1:2
    for i = 1:length(scatterLabel)
        if ~ismissing(scatterAvg(i,h))
            % [~,iLon] = min(abs(xtopo-scatterLon(i,h)));
            % [~,iLat] = min(abs(ytopo-scatterLat(i,h)));
            if h == 1
                % scatterZ(i) = ztopo(iLon,iLat);
                scatterNavg(i) = scatterAvg(i,h);
                scatterNsfc(i) = scatterSfc(i,h);
            elseif h == 2
                % if scatterZ(i) ~= ztopo(iLon,iLat)
                %     scatterZ(i) = mean([scatterZ(i) ztopo(iLon,iLat)],"omitmissing");
                % elseif scatterZ(i) == ztopo(iLon,iLat)
                % end
                if scatterNavg(i) ~= scatterAvg(i,h)
                    scatterNavg(i) = mean([scatterNavg(i)  scatterAvg(i,h)],"omitmissing");
                elseif scatterNavg(i) == scatterAvg(i,h)
                end
                if scatterNsfc(i) ~= scatterSfc(i,h)
                    scatterNsfc(i) = mean([scatterNsfc(i)  scatterSfc(i,h)],"omitmissing");
                elseif scatterNsfc(i) == scatterSfc(i,h)
                end
            end
        else % if scatterArray(i,h) is missing
            if h == 1
                % scatterZ(i) = nan;
            elseif h == 2
                % if ~isnan(scatterZ(i))
                % else
                %     scatterZ(i) = nan;
                % end
                if ~isnan(scatterNavg(i))
                else
                    scatterNavg(i) = nan;
                end
                if ~isnan(scatterNsfc(i))
                else
                    scatterNsfc(i) = nan;
                end
            end
        end
    end
end

% figure(10)
% clf
% plot(scatterSfc(:,1),'LineWidth',3)
% hold on
% plot(scatterSfc(:,2))

% figure(3)
% clf
% hold on
% scatterArray = scatterSfc;
% scatter([1:length(scatterLabel)],scatterArray(:,1),"pentagram","LineWidth",2)
% scatter([1:length(scatterLabel)],scatterArray(:,2),"o","LineWidth",2)
% for i = 1:length(scatterLabel)
%     for h = 1:2
%         text(i,scatterArray(i,h),[num2str(10^4*round(scatterArray(i,h),4,"significant"))],'verticalalignment','bottom','HorizontalAlignment','center')
%     end
% end
% xticks(1:length(scatterLabel))
% xlim([0 length(scatterLabel) + 1])
% xticklabels(scatterLabel)
% grid on
% title(['Buoyancy frequency below ' num2str(belowThis) 'm,  (x10^{-4})' ],['Ring 2020, Star 2021'])
% ylabel('N (s^{-1})')
% xlabel('CTD Point')

% depths = scatterZ(find(~isnan(scatterZ)));
frequenciesAvg = scatterNavg(find(~isnan(scatterNavg)));
gulfNavg = mean(frequenciesAvg,"omitmissing");
frequenciesSfc = scatterNsfc(find(~isnan(scatterNsfc)));
gulfNsfc = mean(frequenciesSfc,"omitmissing");
% figure(4)
% clf
% hold on
% scatter(scatterZ,scatterN)
% scatter(depths,frequencies)
% fit = polyfit(depths,frequencies,1);
% fitN = polyval(fit,depths);
% yline(gulfN,"LineWidth",1);
% plot(depths,fitN);
% text(min(depths),min(frequencies),['N(Z)=',num2str(fit(1)),'xZ+',num2str(fit(2))])
% text(min(depths),gulfN,['avgN(Z)=',num2str(gulfN)])
% title(['Linear Fit N(Z) under ',num2str(belowThis),'m'])
% grid on