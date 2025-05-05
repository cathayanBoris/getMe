function [wt1,wt2,f] = getMeCWT(timeSeries,timeInDays,periodLimitInDays)

if timeInDays(1) > 693962
    isDatenum = 1;
else
    isDatenum = 0;
end

if nargin <= 2
    existLimit = 0;
else
    existLimit = 1;
    if periodLimitInDays(1) < periodLimitInDays(end)
        periodLimitInDays = sort(periodLimitInDays,"descend");
    end
    frequencyBand = 1./periodLimitInDays/86400;
end


dt = mode(diff(timeInDays)); % sampling period in days

u = real(timeSeries);
v = imag(timeSeries);
n = 3 - ~mean(v,'omitmissing'); % n=3 is complex, n=2 is missing imaginary

% frequency f in Hz; 1./f/86400 turns it into days
if existLimit
    [wt1,f,coi]=cwt(u,'morse',1/(dt*86400),'FrequencyLimit',frequencyBand);
else
    [wt1,f,coi]=cwt(u,'morse',1/(dt*86400));
end

shg
subplot(n,1,1)
plot(timeInDays,u,'-')
xlim([min(timeInDays) max(timeInDays)])
ylim([-1 1]*max(abs(u),[],'all')*1.1)
if isDatenum
datetick('x',12,'keeplimits')
end
legend('Along Direction Quantity')
xlabel('Time')
if n==3
    hold on
    plot(timeInDays,v,'-')
    legend('Along Direction Quantity','Cross Direction Quantity')
end

subplot(n,1,2)
pcolor(timeInDays,(1./f)/86400,abs(wt1))
hold on
plot(timeInDays,1./coi/86400,'k--','linewidth',2); 
area(timeInDays,1./coi/86400,1./min(f)/86400,'EdgeColor','none','FaceColor',[1 1 1]*0.5,'FaceAlpha',0.5)
set(gca, 'YScale', 'log')
xlim([min(timeInDays) max(timeInDays)])
ylim([(1./max(f))/86400 (1./min(f))/86400])
shading flat
yline([5:5:50],'LineStyle',':','Color',[1 1 1]*0.4,'LineWidth',1)
yline([1 3 10 25 50 100 250 500],'LineStyle','-','Color',[1 1 1]*0.4,'LineWidth',2)
set(gca,'ydir','reverse','YScale','log')
yticks([1 3 10 25 50 100 250 500])
if isDatenum
datetick('x',12,'keeplimits')
end
ylabel('Along Direction CWT (Days)')
xlabel('Time')
colormap(gca,turbo)
cl = get(gca,'CLim');

% appear if timeSeries is Re+Im complex
if ~mean(v,'omitmissing') == 0
    if existLimit
    [wt2,~,~]=cwt(v,'morse',1/(dt*86400),'FrequencyLimit',frequencyBand);
    else
    [wt2,~,~]=cwt(v,'morse',1/(dt*86400));
    end
    subplot(n,1,3)
    pcolor(timeInDays,(1./f)/86400,abs(wt2))
    hold on
    plot(timeInDays,1./coi/86400,'k--','linewidth',2);
    area(timeInDays,1./coi/86400,1./min(f)/86400,'EdgeColor','none','FaceColor',[1 1 1]*0.5,'FaceAlpha',0.5)
    set(gca, 'YScale', 'log')
    xlim([min(timeInDays) max(timeInDays)])
    ylim([(1./max(f))/86400 (1./min(f))/86400])
    shading flat
    yline([5:5:50],'LineStyle',':','Color',[1 1 1]*0.4,'LineWidth',1)
    yline([1 3 10 25 50 100 250 500],'LineStyle','-','Color',[1 1 1]*0.4,'LineWidth',2)
    set(gca,'ydir','reverse','YScale','log')
    yticks([1 3 10 25 50 100 250 500])
    if isDatenum
    datetick('x',12,'keeplimits')
    end
    ylabel('Cross Direction CWT (Days)')
    xlabel('Time')
    colormap(gca,turbo)
    clim(gca,cl)
else
    wt2 = wt1;
end

subplot(n,1,1)

% figure(100)
% plot(timeInDays,1./coi/86400,'k--','linewidth',2); 
% set(gca, 'YScale', 'log')
end

% function [wt1,wt2,f] = getMeCWT(timeSeries,timeInDays)
% 
% if timeInDays(1) > 693962
%     isDatenum = 1;
% else
%     isDatenum = 0;
% end
% 
% dt = mode(diff(timeInDays)); % sampling period in days
% 
% u = real(timeSeries);
% v = imag(timeSeries);
% n = 3 - ~mean(v,'omitmissing'); % n=3 is complex, n=2 is missing imaginary
% 
% % frequency f in Hz; 1./f/86400 turns it into days
% [wt1,f,coi]=cwt(u,'morse',1/(dt*86400),'FrequencyLimits',1./(86400*[50 3]));
% 
% shg
% subplot(n,1,1)
% plot(timeInDays,u,'-')
% 
% xlim([min(timeInDays) max(timeInDays)])
% if isDatenum
% datetick('x',12,'keeplimits')
% end
% legend('Along Direction Quantity')
% 
% if n==3
%     hold on
%     plot(timeInDays,v,'-')
%     legend('Along Direction Quantity','Cross Direction Quantity')
% end
% 
% subplot(n,1,2)
% surface(timeInDays,(1./f)/86400,abs(wt1))
% hold on
% xlim([min(timeInDays) max(timeInDays)])
% ylim([(1./max(f))/86400 (1./min(f))/86400])
% shading flat
% yline(10*[0.1 1:0.5:5 10],'LineStyle',':','Color',[0 0 0],'LineWidth',1)
% plot(timeInDays,coi,'w--','linewidth',2);
% set(gca,'ydir','reverse','YScale','log')
% yticks([0:5:100])
% if isDatenum
% datetick('x',12,'keeplimits')
% end
% ylabel('Along Direction CWT (Days)')
% xlabel('Time')
% colormap(gca,turbo)
% 
% % appear if timeSeries is Re+Im complex
% if ~mean(v,'omitmissing') == 0
%     [wt2,~,~]=cwt(v,'morse',1/(dt*86400),'FrequencyLimits',1./(86400*[50 3]));
%     subplot(n,1,3)
%     surface(timeInDays,(1./f)/86400,abs(wt2))
%     xlim([min(timeInDays) max(timeInDays)])
%     ylim([(1./max(f))/86400 (1./min(f))/86400])
%     shading flat
%     yline(10*[0.1 1:0.5:5 10],'LineStyle',':','Color',[0 0 0],'LineWidth',1)
%     set(gca,'ydir','reverse','YScale','log')
%     yticks([0:5:100])
%     if isDatenum
%     datetick('x',12,'keeplimits')
%     end
%     ylabel('Cross Direction CWT (Days)')
%     xlabel('Time')
% else
%     wt2 = wt1;
% end
% colormap(gca,turbo)
% subplot(n,1,1)
% 
% figure(100)
% plot(timeInDays,1./coi/86400,'k--','linewidth',2);
% 
% end