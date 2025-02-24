%%
% load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\backward\15D25KM-89.98E27.23N-0.125HdT20day20KMsmooth.mat")
% load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\backward\25D75KM-89.95E27.2N-0.125HdT1day20KMsmooth.mat")
load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\experimentSE\40D90KM-88.8E26.75N0.125HdT15day20KMsmooth.mat")

clear kF lF sigF

kF = nan([1 length(timeHr)]);
lF = nan([1 length(timeHr)]);
sigF = nan([1 length(timeHr)]);
for n = 1:abs(24/dt_hr):length(timeHr)
[kF(n),lF(n), sigF(n)]=klcirclefitp(2*pi/(startT*86400),pathK0(n),pathEi(n,:),-1);
end
%%
figure(99)
clf
subplot(5,2,1)
plot(timeHr,2*pi./pathK0/1000)
hold on
K0f = sqrt(kF.^2+lF.^2);
scatter(timeHr,2*pi./K0f/1000,"x")
hold off
ylabel('Wavelength')

subplot(5,2,2)
plot(timeHr,2*pi./pathK/1000)
hold on
scatter(timeHr,2*pi./kF/1000,"x")
hold off
ylabel('2pi/k')
ylim([-1 1]*10000)

subplot(5,2,3)
plot(timeHr,2*pi./pathL/1000)
hold on
scatter(timeHr,2*pi./lF/1000,"x")
hold off
ylabel('2pi/l')

subplot(5,2,4) %
pathN = pathEi(:,7);
pathKXgh = pathEi(:,3).*pathK - pathEi(:,2).*pathL;
pathKb = sqrt(pathK0.^2+pathK*2E-11/(2*pi/(startT*86400)));
pathMjuh = (pathN.*pathKb./pathEi(:,8)).*pathEi(:,1);
pathTz = tanh(pathMjuh);
pathSig = (pathN.*pathKXgh./(pathKb.*pathTz));
plot(timeHr,2*pi./pathSig/86400);
hold on
kxghF = pathEi(:,3).*kF'-pathEi(:,2).*lF';
kbF = sqrt((kF.^2+lF.^2)+kF*2E-11/(2*pi/(startT*86400)));
mjuhF = (pathN.*kbF'./pathEi(:,8)).*pathEi(:,1);
tzF = tanh(mjuhF');
sigFF = pathN .* kxghF ./ kbF' ./ tzF';
[~,~,~,~,sigFFF] = getMeGroupVelocities(startT,pathK,pathL,pathEi);
scatter(timeHr,2*pi./sigFFF/86400,"x")
yline(startT*ones(size(timeHr)))
hold off
ylim([-1 1]*10+startT)
ylabel('Sigfit Period')

subplot(5,2,5)
plot(timeHr,2*pi./pathKb/1000)
hold on
scatter(timeHr,2*pi./kbF/1000,"x")
hold off
ylabel('2pi/Kb')

subplot(5,2,6)
plot(timeHr,pathKXgh)
hold on
scatter(timeHr,kxghF,"x")
hold off

ylabel('KXgh')

subplot(5,2,7)
plot(timeHr,pathTz)
hold on
scatter(timeHr,tzF,"x")
hold off
ylabel('tanh(NhKb/f)')

subplot(5,2,8)
pathTTT = 1 + pathMjuh.*((1-pathTz.^2)./pathTz);
tttF = 1 + mjuhF.*((1-tzF'.^2)./tzF');
pathCgx = pathSig.*(pathEi(:,3)./pathKXgh - (pathK+2E-11/2./pathSig)./(pathKb.^2).*pathTTT);
pathCgy = pathSig.*(-pathEi(:,2)./pathKXgh - (pathL)./(pathKb.^2).*pathTTT); 
cgxF = sigFF .* (pathEi(:,3)./kxghF - (kF'+2E-11/2./sigFF)./(kbF.^2)'.*tttF);
cgyF = sigFF .* (-pathEi(:,2)./kxghF - (lF)'./(kbF.^2)'.*tttF);
plot(timeHr,pathCgx)
hold on
scatter(timeHr,cgxF,"x")
ylabel('CgX')

subplot(5,2,9)
plot(timeHr,pathCgy)
hold on
scatter(timeHr,cgyF,"x")
ylabel('CgY')

subplot(5,2,10)
plot(timeHr,sqrt(pathCgy.^2+pathCgx.^2))
hold on
scatter(timeHr,sqrt(cgxF.^2+cgyF.^2),"x")
ylabel('Cg')