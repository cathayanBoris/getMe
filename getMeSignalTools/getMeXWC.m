function [wcoh,wcs,f] = getMeXWC(timeSeriesA,timeSeriesB,timeInDays,periodLimitsInDays,xLim)
clf
if timeInDays(1) > 693962
    isDatenum = 1;
else
    isDatenum = 0;
end

if nargin <= 2 ||~exist('periodLimitsInDays','var') || isempty(periodLimitsInDays)
    existLimit = 0;
else
    existLimit = 1;
    if periodLimitsInDays(1) < periodLimitsInDays(end)
        periodLimitsInDays = sort(periodLimitsInDays,"descend");
    end
    frequencyBand = 1./periodLimitsInDays/86400;
end

dt = mode(diff(timeInDays)); % sampling period in days

u = timeSeriesA;
v = timeSeriesB;
mark = isnan(u);
marc = isnan(v);
u(mark) = nanmean(u);
v(marc) = nanmean(v);

% n = 3 - ~mean(v,'omitmissing'); % n=3 is complex, n=2 is missing imaginary

% frequency f in Hz; 1./f/86400 turns it into days
if existLimit
    [wcoh,wcs,f,coi]=wcoherence(u,v,1/(dt*86400),'FrequencyLimits',frequencyBand);
else
    [wcoh,wcs,f,coi]=wcoherence(u,v,1/(dt*86400));
end


% pcolor(timeInDays,(1./f)/86400,abs(wt1))
getMePcolor(timeInDays,(1./f)/86400,abs(wcoh));
hold on
% plot(timeInDays,1./coi/86400,'k--','linewidth',2);

area(timeInDays,1./coi/86400,1./min(f)/86400,'EdgeColor','k','lineWidth',2,'LineStyle','--','FaceColor',[1 1 1]*0.5,'FaceAlpha',0.5)
set(gca, 'YScale', 'log')
xlim([min(timeInDays) max(timeInDays)])
% if existLimit
%     tL = sort(periodLimitsInDays,'ascend');
%     ylim([(1./max(f))/86400 (1./min(f))/86400])
% else
%     ylim([(1./max(f))/86400 (1./min(f))/86400])
% end
ylim([(1./max(f))/86400 (1./min(f))/86400])
shading flat
yline([5:5:50 60:10:100],'LineStyle',':','Color',[1 1 1]*0.4,'LineWidth',1)
yline([1 3 10 20 50 100 250 500],'LineStyle','-','Color',[1 1 1]*0.4,'LineWidth',2)
set(gca,'ydir','reverse','YScale','log')
yticks([1 3 10 20 50 100 250 500])

ylabel('Period Along Direction (Days)')
xlabel('Time')
colormap(gca,turbo)
cl = get(gca,'CLim');
clim(gca,[0 1])


theta = angle(wcs);
theta(wcoh<0.5) = nan;

tspace = ceil(size(theta,2)/40);
pspace = round(2^log2(size(theta,1)/12/2));
tax = timeInDays(1:tspace:size(theta,2));
pax = f(1:pspace:size(theta,1));
[tgrid,pgrid]=meshgrid(tax,1./(86400*pax));

theta = theta(1:pspace:size(theta,1),1:tspace:size(theta,2));

idx = find(~any(isnan([tgrid(:) pgrid(:) theta(:)]),2));

tgrid = tgrid(idx);
pgrid = pgrid(idx);
theta = theta(idx);


arrowpatch = [-1 0 0 1 0 0 -1; 0.1 0.1 0.5 0 -0.5 -0.1 -0.1]';

% arrowpatch = [-1 -1 1 1; -1 1 1 -1]'; % for testing purpose

scale = 3; %* (diff(get(gca,'YLim')) / 100);

if ~exist('xLim','var') || isempty(xLim)
else
    xlim(xLim)
end
yL = get(gca,'YLim');
yr = getMeAxisRatio(get(gca,'XLim'),yL);

for nn=numel(tgrid):-1:1

    ap = arrowpatch;
    % Multiply each arrow by the rotation matrix for the given theta
    rotarrow = ap*[cos(theta(nn)) sin(theta(nn));...
        -sin(theta(nn)) cos(theta(nn))];

    rotarrow(:,1) = rotarrow(:,1)*scale;
    rotarrow(:,2) = rotarrow(:,2)*scale * (pgrid(nn)/10^(mean(log10(yL)))) / log10(yL(2)/yL(1)) / yr;
    patch(tgrid(nn)+rotarrow(:,1),pgrid(nn)-rotarrow(:,2),[0 0 0],...
        'edgecolor','none');
    % text(tgrid(nn),pgrid(nn),num2str(nn))
end

if isDatenum
    datetick('x',12,'keeplimits')
end
