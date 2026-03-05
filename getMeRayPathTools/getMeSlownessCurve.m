% loop example
load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GULL&NCOM\TRW\rayTracing\forward\experimentSE\SE4\22D200KM-89.2E26.4N0.125HdT6.8802day30KMsmooth.mat")

% load C:\Users\Yan_J\OneDrive\Documents\MATLAB\GULL&NCOM\TRW\rayTracing\forward\experimentSE\SE4\18D200KM-89E26.4N0.125HdT5.224day30KMsmooth.mat

smoothKM = smoothing;
if ~exist('hg','var') || smoothingParameterInM ~= smoothKM*1000
    [xtopo,ytopo,ztopo] = getMeTopo(-92,-87,25,29);
    smoothingParameterInM = smoothKM*1000;
    [~,~,ztopoS] = getMeSmoothed(smoothingParameterInM,-92,-87,25,29);
    [hx,hy,hg] = getMeGradZ(xtopo,ytopo,-ztopoS);
end


[pathCg,pathCgx,pathCgy] = getMeGroupVelocities(startT,pathK,pathL,pathEi);

ultraviolet = [122 59 186];
blue = [40 49 147];
yellow = [250 194 8];
red = [184 0 0];
infrared = [109 0 0];
veryred = [60 37 2];

fs=20;
%%
function [kCurve,lCurve] = drawSlownessCurve(sig,Ei)

NB = Ei(7);
f = Ei(8);
beta = Ei(9);
pathHx = Ei(2);
pathHy = Ei(3);
h = Ei(1);  % note h is +ve, increasing with depth

% Nb = Ei(7);
% hx = Ei(2);
% hy = Ei(3);
% h = Ei(1);

% lat = Ei(8);
% f=sw_f(pathLat);
inc = 1000;
Kbox=2e-4*2;     % big box for wavelengths as short as 62.8 km
Kmid=Kbox/4;   % coarse steps for Kbox>Kmid; fine steps for K0<Kmid

ll1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
ll2 = [-Kmid:Kbox/(4*inc):Kmid];
ll3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
lCurve = [ll1 ll2 ll3];
Lll= length(lCurve);

difference =ones(1, length(lCurve));  %initialize size
kCurve=         ones(1, length(lCurve));

kk1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
kk2 = [-Kmid:Kbox/(4*inc):Kmid];
kk3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
kk = [kk1 kk2 kk3];
Lkk= length(kk);

lhs= ones(1, Lkk);   %initialize size
rhs= ones(1, Lkk);
xx=  ones(1, Lkk);

% run tanh fit

% Tdays = startT;
% T =Tdays.*24*60*60;        % T in seconds
% sig = 2.*pi./T*;
%%%%%%%%%%  START tanh fit   %%%%%%%%%%%
for jl = 1:Lll
    l = lCurve(jl);    % wavevector component l, choose small suite of 97 ll's
    clear lhs rhs;
    for jk = Lkk:-1:1 %fine comb search for best k fit, among big suite kk's
        k = kk(jk);         % wavevector component (inner optimization loop)
        %%%%%%%%%%   here is Kathy's way   %%%%%%%%%
        mub = sqrt((k.*k + l.*l + beta*k./sig).*NB.*NB./f./f);
        %     mub is okay because extra (NB/f) is inside sqrt
        KXgh= (pathHy.*k - pathHx.*l);

        %lhs
        lhs(jk)  = mub.*tanh(mub.*h);  % mub=(NB/f)*Kb
        rhs(jk) = KXgh.*NB.*NB./sig./f;
        %%%%% rearrange equation with mub on other side so both sides are O(1) %%%%
        % Kb  = sqrt(k.*k +l.*l + beta*k./sig);
        % %mub = Kb.*NB./f;
        % KXgh= (pathHy.*k - pathHx.*l);
        % lhs(jk)  = tanh(NB.*h.*Kb./f);
        % rhs(jk) =  NB.*KXgh./(sig.*Kb);
        %%%%%%%%%%%%%%
    end % for jk, inner optimization loop
    xx = abs(rhs-lhs);
    difference(jl) = min(abs(rhs-lhs));
    iwant = find(xx==min(xx));   % iwant = index of kk that best fits this ll
    kCurve(jl) = kk(iwant);          % kl is k(l,omega,Ei) for jl outer loop

    if difference(jl) > 1e-7 %1e-2  % was 1e-7 for KD's arrangement, factor Kb smaller
        kCurve(jl) = NaN;

    end %if

end % for jl, outer small suite of ll's
lCurve = lCurve(~isnan(kCurve));
kCurve = kCurve(~isnan(kCurve));
end

%%
cmap = cmocean('thermal');
if startT < 9
    coleur = ultraviolet;
elseif startT<15
    coleur = blue;
elseif startT<20
    coleur = yellow;
elseif startT<25
    coleur = red;
else
    coleur = veryred;
end
ii = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% writerObj = VideoWriter('slownessDemo.gif');
% % writerObj.FrameRate = 10;
% open(writerObj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for q =  1:abs(1/dt_hr):length(pathLon)
    wavelengths = [50:50:300];
    hx = pathEi(q,2); hy = pathEi(q,3);
    lon = pathLon(q); lat = pathLat(q);
    cgx = pathCgx(q); cgy = pathCgy(q);
    pK = pathK(q); pL = pathL(q);
    pCg = pathCg(q); K0=pathK0(q);
    scale = ceil(K0*1e4)/(1e4);

    figure(10)

    % colormap default
    % beta=pathEi(q,9);
    %
    % NB = pathEi(q,7);
    % hx = hx;
    % hy = hy;
    % h = pathEi(q,1);  % note h is +ve, increasing with depth
    % % f=sw_f(lat);
    % f = pathEi(q,8);
    %
    % inc = 500;
    % Kbox=1.5e-4;     % big box for wavelengths as short as 62.8 km
    % Kmid=Kbox/4;   % coarse steps for Kbox>Kmid; fine steps for K0<Kmid
    %
    % ll1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
    % ll2 = [-Kmid:Kbox/(4*inc):Kmid];
    % ll3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
    % ll = [ll1 ll2 ll3];
    % Lll= length(ll);
    %
    % difference =ones(1, length(ll));  %initialize size
    % kl=         ones(1, length(ll));
    %
    % kk1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
    % kk2 = [-Kmid:Kbox/(4*inc):Kmid];
    % kk3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
    % kk = [kk1 kk2 kk3];
    % Lkk= length(kk);
    %
    % lhs= ones(1, Lkk);   %initialize size
    % rhs= ones(1, Lkk);
    % xx=  ones(1, Lkk);
    %
    % % run tanh fit
    %
    % Tdays = startT;
    % T =Tdays.*24*60*60;        % T in seconds
    % sig = 2.*pi./T;
    % %%%%%%%%%%  START tanh fit   %%%%%%%%%%%
    % for jl = 1:Lll
    %     l = ll(jl);    % wavevector component l, choose small suite of 97 ll's
    %     clear lhs rhs;
    %     for jk = Lkk:-1:1 %fine comb search for best k fit, among big suite kk's
    %         k = kk(jk);         % wavevector component (inner optimization loop)
    %         %%%%%%%%%%   here is Kathy's way   %%%%%%%%%
    %         % mub = sqrt((k.*k + l.*l + beta*k./sig).*NB.*NB./f./f);
    %         % %     mub is okay because extra (NB/f) is inside sqrt
    %         % KXgh= (hy.*k - hx.*l);
    %         %
    %         % %lhs
    %         % lhs(jk)  = mub.*tanh(mub.*h);  % mub=(NB/f)*Kb
    %         % rhs(jk) = KXgh.*NB.*NB./sig./f;
    %         %%%%% rearrange equation with mub on other side so both sides are O(1) %%%%
    %         Kb  = sqrt(k.*k +l.*l + beta*k./sig);
    %         %mub = Kb.*NB./f;
    %         KXgh= (hy.*k - hx.*l);
    %         lhs(jk)  = tanh(NB.*h.*Kb./f);
    %         rhs(jk) =  NB.*KXgh./(sig.*Kb);
    %     end % for jk, inner optimization loop
    %     xx = abs(rhs-lhs);
    %     difference(jl) = min(abs(rhs-lhs));
    %     iwant = find(xx==min(xx));   % iwant = index of kk that best fits this ll
    %     kl(jl) = kk(iwant);          % kl is k(l,omega,Ei) for jl outer loop
    %     if difference(jl) > 5e-3 %1e-2  % was 1e-7 for KD's arrangement, factor Kb smaller
    %         kl(jl) = NaN;
    %     end %if
    % end % for jl, outer small suite of ll's
    % ang=1:89;
    % sinang=sind(ang); cosang=cosd(ang);

    [kl,ll] = drawSlownessCurve(2*pi./(startT*86400),pathEi(q,:));


    % debugScript

    figure(10)
    clf
    subplot(1,2,1) %%%
    v = -3300:100:0;
    hold on
    [~,zzzz]=contour(xtopo,ytopo,ztopoS',v,'k','ShowText','on','DisplayName','Topography');
    contour(xtopo,ytopo,ztopo',v,'-.','ShowText','off','EdgeAlpha',0.5);

    d = lat-0.3;
    u = lat+0.3;
    yRatio = getMeSimpleMercator([d u]);
    l = lon-0.3/yRatio;
    r = lon+0.3/yRatio;
    axis([l r d u]);
    xticks(round(l*10)/10:0.1:round(r*10)/10); yticks(round(d*10)/10:0.1:round(u*10)/10);
    factor = getMeAxisRatio;

    plot(pathLon(q+1:end),pathLat(q+1:end),'Color',[1 1 1]*0.6,'LineStyle','--','LineWidth',2);
    ci = getMeColorIndex(2*pi./(pathK0(q)*1000),[0 300],256);
    hhhh = scatter(pathLon(1:q),pathLat(1:q),50,2*pi./(pathK0(1:q)*1000),'filled','o');
    scatter(lon,lat,30,'o','MarkerEdgeColor',cmap(ci,:),"LineWidth",5);
    gradH = abs(hx + 1i*hy);
    cccc = quiver(lon-hx/gradH*0.1*factor,lat-hy/gradH*0.1,hx/gradH*0.22*factor,hy/gradH*0.22,"MaxHeadSize",0.5,"LineWidth",1.5,"Color",[0.66 0.5 0.35]); % topo gradient
    text(lon+hx./gradH*0.12*factor, lat+hy./gradH*0.12, ['\nablah'],"FontSize",fs-5,"Color",[0.66 0.5 0.35],'HorizontalAlignment','center')

    % magnitude = abs(cgx + 1i*cgy);
    % quiver(lon,lat,cgx./pCg.*0.1,cgy./pCg.*0.1,'Color',[0 0 0],"LineWidth",7,"MaxHeadSize",0.5);
    aaaa = plot([0 pK*factor]./K0*0.18+lon,[0 pL]./K0*0.18+lat,'-.','linewidth',3,'Color',coleur/255); % K

    bbbb = quiver(lon,lat,cgx./pCg.*0.18*factor,cgy./pCg.*0.18,'Color',coleur/255,"LineWidth",5,"MaxHeadSize",0.5);
    text(lon+cgx./pCg.*0.2*factor, lat+cgy./pCg.*0.2, ['Cg=', num2str(pCg,4),' m/s'],"FontSize",fs-5,'Color',coleur/255)


    colormap(cmap)
    clim([0 300])
    hold off
    grid on
    ax=gca;
    ax.FontSize = 12;
    lgd = legend(ax,[zzzz cccc hhhh aaaa bbbb],'Experiment Isobaths','Topography Tilt','Ray Path','Phase Direction','Group Direction');
    lgd.FontSize = fs-5;
    lgd.Location = "southwest";
    xlabel('Longitude',"FontSize",fs)
    ylabel('Latitude',"FontSize",fs)
    getMeEarthTix(ax)
    ax.XTickLabelRotation = 0;
    ax.YTickLabelRotation = 0;
    title(gca,sprintf(['Location at %ghr, %0.0fkm smoothed'],(q-1)*dt_hr,smoothing),"FontSize",fs)


    subplot(1,2,2) %%%
    xline(0); yline(0);
    hold on
    % circles in the back
    for iw = 1:length(wavelengths)
        kc=2*pi/(wavelengths(iw)*1000);

        circleColor = [wavelengths(iw)];
        getMeCirclePlot(0,0,kc,0.1,':',1,circleColor);
        hold on
    end

    % dH
    cccc = quiver(-hx/gradH*scale*0.9,-hy/gradH*scale*0.9,hx/gradH*scale*1.8,hy/gradH*scale*1.8,"MaxHeadSize",0.5,"LineWidth",1.5,"Color",[0.66 0.5 0.35]);
    hold on

    % slowness
    gh = getMeAtan(hx,hy,0,0);
    ang =  -pi-(gh-pi/2);
    [curve] = getMeSortedRing(kl,ll,ang);

    magnitudeCurve = 0.002*pi./[abs(curve)];
    kl = real(curve); ll = imag(curve);
    plot(kl,ll,'Color',coleur/255,'LineWidth',10)
    zzzz = getMeColorfulPlot(kl,ll,magnitudeCurve,7);
    % y=ll vs x=kl
    clim([0 wavelengths(end)])
    hold on

    circleColor = 2*pi./K0/1000;
    cirkle = getMeCirclePlot(0,0,K0,1,'--',1,circleColor);
    hold on

    % Cg
    bbbb = quiver(pK,pL,cgx./pCg.*scale/2,cgy./pCg.*scale/2,'Color',coleur/255,"LineWidth",5,"MaxHeadSize",0.5); % Cg
    text(pK+cgx./pCg.*scale*1.1/2,pL+cgy./pCg.*scale*1.1/2,sprintf('%.2gd',startT),'Color',coleur/255,'HorizontalAlignment','center','FontSize',fs-5)

    % K
    aaaa = plot([0 pK],[0 pL],'-.','linewidth',3,'Color',coleur/255); % K

    % wavelengths = 2*pi/abs(pK+1i*pL);
    % for i = length(wavelengths) %subsample KK0's by factor of 10 to plot K0 circles

    % end

    theta = acosd((pK*hx+pL*hy)/(pathK0(q)*sqrt(hx^2+hy^2)));
    % text(-18e-5, 8e-5,['Cross Product Angle (^o)= ', num2str(theta,4')])
    % text(-18e-5, 10e-5,['hx= ', num2str(hx,4'), ', hy= ', num2str(hy,4)])
    % text(-18e-5, 12e-5, ['h (m)= ', num2str(h,4)])

    text(K0,0,0,[' ', num2str(2*pi/1000/pathK0(q),4) ' km '],"VerticalAlignment","top","HorizontalAlignment","right")
    % text(-18e-5, 16e-5, ['Wavelength Circles (km): 25:25:600'])
    lgd = legend([cccc zzzz cirkle(1) aaaa bbbb ],"Topography Tilt","Slowness Curve","Wavenumber","Phase Solution","Group Direction");


    axis([-1 1 -1 1]*scale)
    xticks([-1:0.2:1]*scale);
    yticks([-1:0.2:1]*scale);
    cbar = colorbar(gca,"south"); xlabel(cbar,'Wavelength (km)')
    axis square
    ax = gca;
    colormap(gca,cmap)
    ax.FontSize = 12;
    cbar.FontSize = fs-5;
    lgd.FontSize = fs-5;
    title(['Wave Period = ', num2str(startT),' days'],'FontSize',fs)
    xlabel('k (radian m^{-1})',"FontSize",fs); ylabel('l (radian m^{-1})',"FontSize",fs);
    grid on
    hold off

    %%% generate GIF
    % exportgraphics(gcf,'tracingDemo.gif','Append',true);

    % alt method
    % ii = ii+1;
    % F(ii) = getframe(gcf);
    % im = frame2im(F(ii));
    % [imind,cm] = rgb2ind(im,256);
    % drawnow
    % if ii == 1
    %     imwrite(imind,cm,'test.gif', 'Loopcount',inf,'WriteMode','overwrite');
    % else
    %     imwrite(imind,cm,'test.gif','WriteMode','append');
    % end

    % imwrite(imind,cm,'test.png');
    pause(.01);
end

% write the frames to the video
% if exist("writerObj","var")
% for iF=1:length(F)
%     writeVideo(writerObj, F(iF));
% end
% close(writerObj)
%%
% for i = 1:length(F)
%     thisFrame = F(i);
%     % thisFrame = squeeze(thisFrame(:,:,1));
%     if i == 1
%     imwrite(frame2im(thisFrame), 'slownessDemo.gif', 'gif', 'LoopCount', Inf); % First frame
%     else
%     imwrite(frame2im(thisFrame), 'slownessDemo.gif', 'gif', 'WriteMode', 'append'); % Append frames
%     end
% end