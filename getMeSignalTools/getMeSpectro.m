function [S1,S2,F,T] = getMeSpectro(timeSeries,timeInDays,windowWidth,nOverlap,nfft,periodLimitsInDays)
clf
if timeInDays(1) > 693962
    isDatenum = 1;
else
    isDatenum = 0;
end

if nargin <= 5 || isempty(periodLimitsInDays)
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

input = [nanmean(u)*ones(size(u)); u ; nanmean(u)*ones(size(u))];

timeExtended = [timeInDays-timeInDays(end)+timeInDays(1)-nanmean(diff(timeInDays)) timeInDays timeInDays+timeInDays(end)-timeInDays(1)+nanmean(diff(timeInDays))];
nOverlap = [round(windowWidth/2)];
fs = 1./mode(diff(timeInDays))/86400;

[S1,F,T] = spectrogram(input,windowWidth,nOverlap,nfft,fs);

subplot(n,1,1)
u(mark) = nan;
input = [nan*ones(size(u)); u ; nan*ones(size(u))];

plot(timeExtended,input)
xlim([min(timeInDays) max(timeInDays)])
ylim([-1 1]*max([max(abs(u)) max(abs(v))],[],'all')*1.1)

if isDatenum
    datetick('x',12,'keeplimits')
end
legend('Along Direction Quantity')
xlabel('Time')

subplot(n,1,2)
periodInDays = 1./(F*86400);

if existLimit
    [~,a]=(min(abs(periodInDays-periodLimitsInDays(1))));
    [~,b]=(min(abs(periodInDays-periodLimitsInDays(2))));

    enteringT = T/86400+timeExtended(1)-mode(diff(T/86400))/2;
    [~,c]=min(abs(enteringT-timeInDays(1)));
    [~,d]=min(abs(enteringT-timeInDays(end)));
    if enteringT(c) > timeInDays(1)
        c = c-1;
    end
    if enteringT(d) < timeInDays(end)
        d = d+1;
    end
    enteringT = enteringT(c:d);
    enteringP = periodInDays(a-1:b+1) - diff(periodInDays(a-2:b+1))/2;

    pcolor(enteringT,enteringP,(abs(S1(a-1:b+1,c:d))))
    ylim(sort(periodLimitsInDays,'ascend'))
else
    enteringT = T/86400+timeExtended(1) - mode(diff(T/86400))/2;
    [~,c]=min(abs(enteringT-timeInDays(1)));
    [~,d]=min(abs(enteringT-timeInDays(end)));
    if enteringT(c) > timeInDays(1)
        c = c-1;
    end
    if enteringT(d) < timeInDays(end)
        d = d+1;
    end
    enteringT = enteringT(c:d);
    adjustment = diff(periodInDays());
    enteringP = periodInDays() - [adjustment(1); adjustment]/2;

    pcolor(enteringT,enteringP,(abs(S1(:,c:d))))
    ylim([(1./max(F))/86400 (1./min(F))/86400])
end
shading flat
xlim([min(timeInDays) max(timeInDays)])
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
    input = [nanmean(v)*ones(size(v)); v ; nanmean(v)*ones(size(v))];
    [S2,~,~] = spectrogram(input,windowWidth,nOverlap,nfft,fs);

    subplot(n,1,1)
    hold on
    % hide nan substitutes
    v(marc) = nan;
    input = [nan*ones(size(v)); v ; nan*ones(size(v))];
    plot(timeExtended,input)
    xlim([min(timeInDays) max(timeInDays)])
    ylim([-1 1]*max([max(abs(u)) max(abs(v))],[],'all')*1.1)
    legend('Along Direction Quantity','Cross Direction Quantity')

    subplot(n,1,3)
    periodInDays = 1./(F*86400);
    if existLimit
        [~,a]=(min(abs(periodInDays-periodLimitsInDays(1))));
        [~,b]=(min(abs(periodInDays-periodLimitsInDays(2))));
        enteringT = T/86400+timeExtended(1)-mode(diff(T/86400))/2;
        [~,c]=min(abs(enteringT-timeInDays(1)));
        [~,d]=min(abs(enteringT-timeInDays(end)));
        if enteringT(c) > timeInDays(1)
            c = c-1;
        end
        if enteringT(d) < timeInDays(end)
            d = d+1;
        end
        enteringT = enteringT(c:d);
        enteringP = periodInDays(a-1:b+1) - diff(periodInDays(a-2:b+1))/2;
        pcolor(enteringT,enteringP,(abs(S2(a-1:b+1,c:d))))
        ylim(sort(periodLimitsInDays,'ascend'))
    else
        enteringT = T/86400+timeExtended(1)-mode(diff(T/86400))/2;
        [~,c]=min(abs(enteringT-timeInDays(1)));
        [~,d]=min(abs(enteringT-timeInDays(end)));
        if enteringT(c) > timeInDays(1)
            c = c-1;
        end
        if enteringT(d) < timeInDays(end)
            d = d+1;
        end
        enteringT = enteringT(c:d);
        adjustment = diff(periodInDays());
        enteringP = periodInDays()- [adjustment(1); adjustment]/2;
        pcolor(enteringT,enteringP,(abs(S2(:,c:d))))
        ylim([(1./max(F))/86400 (1./min(F))/86400])
    end
    shading flat
    xlim([min(timeInDays) max(timeInDays)])
    yline([5:5:50 60:10:100],'LineStyle',':','Color',[1 1 1]*0.4,'LineWidth',1)
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
    S2 = S1;
end
subplot(n,1,1)
end