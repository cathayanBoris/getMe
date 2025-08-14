function [wt1,wt2,f] = getMeCWT(timeSeries,timeInDays,periodLimitsInDays)
clf
if timeInDays(1) > 693962
    isDatenum = 1;
else
    isDatenum = 0;
end

if nargin <= 2 || isempty(periodLimitsInDays)
    existLimit = 0;
else
    existLimit = 1;
    if periodLimitsInDays(1) < periodLimitsInDays(end)
        periodLimitsInDays = sort(periodLimitsInDays,"descend");
    end
    frequencyBand = 1./periodLimitsInDays/86400;
end


dt = mode(diff(timeInDays)); % sampling period in days

u = real(timeSeries);
v = imag(timeSeries);
mark = isnan(u);
marc = isnan(v);
u(mark) = nanmean(u);
v(marc) = nanmean(v);

n = 3 - ~mean(v,'omitmissing'); % n=3 is complex, n=2 is missing imaginary

% frequency f in Hz; 1./f/86400 turns it into days
if existLimit
    [wt1,f,coi]=cwt(u,'morse',1/(dt*86400),'FrequencyLimit',frequencyBand);
else
    [wt1,f,coi]=cwt(u,'morse',1/(dt*86400));
end

subplot(n,1,2)
% pcolor(timeInDays,(1./f)/86400,abs(wt1))
getMePcolor(timeInDays,(1./f)/86400,abs(wt1));
hold on
% plot(timeInDays,1./coi/86400,'k--','linewidth',2);
yL = get(gca,'YLim');
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
if isDatenum
    datetick('x',12,'keeplimits')
end
ylabel('Along Direction (Days)')
xlabel('Time')
colormap(gca,turbo)
cl = get(gca,'CLim');

% appear if timeSeries is Re+Im complex
if n == 3
    if existLimit
        [wt2,~,~]=cwt(v,'morse',1/(dt*86400),'FrequencyLimit',frequencyBand);
    else
        [wt2,~,~]=cwt(v,'morse',1/(dt*86400));
    end
    subplot(n,1,3)
    % pcolor(timeInDays,(1./f)/86400,abs(wt2))
    getMePcolor(timeInDays,(1./f)/86400,abs(wt2));
    hold on
    % plot(timeInDays,1./coi/86400,'k--','linewidth',2);
    area(timeInDays,1./coi/86400,1./min(f)/86400,'EdgeColor','k','lineWidth',2,'LineStyle','--','FaceColor',[1 1 1]*0.5,'FaceAlpha',0.5)
    set(gca, 'YScale', 'log')
    xlim([min(timeInDays) max(timeInDays)])
    % if existLimit
    %     ylim(sort(periodLimitsInDays,'ascend'))
    % else
    %     ylim([(1./max(f))/86400 (1./min(f))/86400])
    % end
    ylim([(1./max(f))/86400 (1./min(f))/86400])
    shading flat
    yline([5:5:50],'LineStyle',':','Color',[1 1 1]*0.4,'LineWidth',1)
    yline([1 3 10 20 50 100 250 500],'LineStyle','-','Color',[1 1 1]*0.4,'LineWidth',2)
    set(gca,'ydir','reverse','YScale','log')
    yticks([1 3 10 20 50 100 250 500])
    if isDatenum
        datetick('x',12,'keeplimits')
    end
    ylabel('Cross Direction (Days)')
    xlabel('Time')
    colormap(gca,turbo)
    clim(gca,cl)
else
    wt2 = wt1;
end

subplot(n,1,1)
u(mark) = nan;
v(mark) = nan;
plot(timeInDays,u,'-')
xlim([min(timeInDays) max(timeInDays)])
ylim([-1 1]*max([max(abs(u)) max(abs(v))],[],'all')*1.1)
if isDatenum
    datetick('x',12,'keeplimits')
end
legend('Along Direction Quantity')
xlabel('Time')
if n == 3
    hold on
    plot(timeInDays,v,'-')
    legend('Along Direction Quantity','Cross Direction Quantity')
end
% figure(100)
% plot(timeInDays,1./coi/86400,'k--','linewidth',2);
% set(gca, 'YScale', 'log')
end
