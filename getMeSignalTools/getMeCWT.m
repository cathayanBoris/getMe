function [wt1,wt2,f] = getMeCWT(timeSeries,timeInDatenum)

dt = mode(diff(timeInDatenum)); % sampling period in days

u = real(timeSeries);
v = imag(timeSeries);
n = 3 - ~mean(v,'omitmissing'); % n=3 is complex, n=2 is missing imaginary

% frequency f in Hz; 1./f/86400 turns it into days
[wt1,f,~]=cwt(u,'morse',1/(dt*86400),'FrequencyLimimits',1./(86400*[50 3]));

shg
subplot(n,1,1)
plot(timeInDatenum,u,'-')

xlim([min(timeInDatenum) max(timeInDatenum)])
datetick('x',12,'keeplimits')
legend('Along Direction Velocity')

if n==3
    hold on
    plot(timeInDatenum,v,'-')
    legend('Along Direction Velocity','Cross Direction Velocity')
end

subplot(n,1,2)
surface(timeInDatenum,(1./f)/86400,abs(wt1))
xlim([min(timeInDatenum) max(timeInDatenum)])
ylim([(1./max(f))/86400 (1./min(f))/86400])
shading flat
yline(10*[0.1 1:0.5:5 10],'LineStyle',':','Color',[0 0 0],'LineWidth',1)
set(gca,'ydir','reverse','YScale','log')
yticks([0:5:100])
datetick('x',12,'keeplimits')
ylabel('Along Direction CWT (Days)')

% appear if timeSeries is complex
if ~mean(v,'omitmissing') == 0
    [wt2,~,~]=cwt(v,'morse',1/(dt*86400),'FrequencyLimimits',1./(86400*[50 3]));
    subplot(n,1,3)
    surface(timeInDatenum,(1./f)/86400,abs(wt2))
    xlim([min(timeInDatenum) max(timeInDatenum)])
    ylim([(1./max(f))/86400 (1./min(f))/86400])
    shading flat
    yline(10*[0.1 1:0.5:5 10],'LineStyle',':','Color',[0 0 0],'LineWidth',1)
    set(gca,'ydir','reverse','YScale','log')
    yticks([0:5:100])
    datetick('x',12,'keeplimits')
    ylabel('Cross Direction CWT (Days)')
else
    wt2 = wt1;
end

subplot(n,1,1)