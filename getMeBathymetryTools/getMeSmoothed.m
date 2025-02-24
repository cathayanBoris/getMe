function [xtopo,ytopo,smoothedProduct] = getMeSmoothed(smoothDistance,L,R,D,U)

[xtopo,ytopo,ztopo] = getMeTopo(L,R,D,U);

if smoothDistance == 0
    smoothedProduct = ztopo;
    return
end

[~,~,~,dx,dy] = getMeGradZ(xtopo,ytopo,ztopo);
avgdx = mean(dx,'omitnan');
avgdy = mean(dy,'omitnan');
%x then y
[b,a] = butter(4,2*avgdx/smoothDistance);
for y = 1:length(ytopo)
    smoothedZonal(:,y) = filtfilt(b,a,ztopo(:,y));
end
[b,a] = butter(4,2*avgdy/smoothDistance);
for x = 1:length(xtopo)
    smoothedProduct(x,:) = filtfilt(b,a,smoothedZonal(x,:));
end
%%
% for y = 1:length(ytopo)
%     [b,a] = butter(4,2*dx(y)/smoothDistance);
%     smoothedZonal(:,y) = filtfilt(b,a,ztopo(:,y));
% end
%
% for x = 1:length(xtopo)
%     [b,a] = butter(4,2*avgdy/smoothDistance);
%     smoothedProduct2(x,:) = filtfilt(b,a,smoothedZonal(x,:));
% end

% figure()
% contour(xtopo,ytopo,ztopo',[-10000:100:10000],':k',"ShowText","on")
% hold on
% contour(xtopo,ytopo,smoothedProduct',[-10000:100:10000],'-k');
% grid on
% %rectangle("Position",[xtopo(iL) ytopo(iD) xtopo(iR)-xtopo(iL) ytopo(iU)-ytopo(iD)],"LineStyle","--",'LineWidth',2)
% title(['Smoothed Product ',num2str(smoothDistance), ' m'])
% legend('Original','Smoothed',"Location","northeast")
% xlim([xtopo(1) xtopo(end)]);
% ylim([ytopo(1) ytopo(end)]);