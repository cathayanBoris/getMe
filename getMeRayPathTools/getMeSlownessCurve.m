% loop example
load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\experimentSE\SE7\13D100KM-89.8E27.2N0.125HdT5day30KMsmooth.mat")

smoothKM = smoothing;
if ~exist('hg','var') || smoothingParameterInM ~= smoothKM*1000
    [xtopo,ytopo,ztopo] = getMeTopo(-92,-87,25,29);
    smoothingParameterInM = smoothKM*1000;
    [~,~,ztopoS] = getMeSmoothed(smoothingParameterInM,-92,-87,25,29);
    [hx,hy,hg] = getMeGradZ(xtopo,ytopo,-ztopoS);
end


[pathCg,pathCgx,pathCgy] = getMeGroupVelocities(startT,pathK,pathL,pathEi);
%%
cmap = flipud(parula);

for q = 1:abs(1/dt_hr):length(pathLon)
    wavelengths = 1000*[100:50:600];

    figure(11)
    % colormap default
    beta=2.0E-11;

    NB = pathEi(q,7);
    hx = pathEi(q,2);
    hy = pathEi(q,3);
    h = pathEi(q,1);  % note h is +ve, increasing with depth

    % Nb = pathEi(q,7);
    % hx = pathEi(q,2);
    % hy = pathEi(q,3);
    % h = pathEi(q,1);
    
    lat = pathEi(q,8);
    f=sw_f(pathLat(q));

    inc = 500;
    Kbox=1.5e-4;     % big box for wavelengths as short as 62.8 km
    Kmid=Kbox/4;   % coarse steps for Kbox>Kmid; fine steps for K0<Kmid

    ll1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
    ll2 = [-Kmid:Kbox/(4*inc):Kmid];
    ll3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
    ll = [ll1 ll2 ll3];
    Lll= length(ll);

    difference =ones(1, length(ll));  %initialize size
    kl=         ones(1, length(ll));

    kk1 = [-Kbox:Kbox/inc:-Kmid-Kbox/inc];
    kk2 = [-Kmid:Kbox/(4*inc):Kmid];
    kk3 = [Kmid+Kbox/inc:Kbox/inc:Kbox];
    kk = [kk1 kk2 kk3];
    Lkk= length(kk);

    lhs= ones(1, Lkk);   %initialize size
    rhs= ones(1, Lkk);
    xx=  ones(1, Lkk);

    % run tanh fit

    Tdays = startT;
    T =Tdays.*24*60*60;        % T in seconds
    sig = 2.*pi./T;
    %%%%%%%%%%  START tanh fit   %%%%%%%%%%%
    for jl = 1:Lll
        l = ll(jl);    % wavevector component l, choose small suite of 97 ll's
        clear lhs rhs;
        for jk = Lkk:-1:1 %fine comb search for best k fit, among big suite kk's
            k = kk(jk);         % wavevector component (inner optimization loop)
            %%%%%%%%%%   here is Kathy's way   %%%%%%%%%
            % mub = sqrt((k.*k + l.*l + beta*k./sig).*NB.*NB./f./f);
            % %     mub is okay because extra (NB/f) is inside sqrt
            % KXgh= (hy.*k - hx.*l);
            %
            % %lhs
            % lhs(jk)  = mub.*tanh(mub.*h);  % mub=(NB/f)*Kb
            % rhs(jk) = KXgh.*NB.*NB./sig./f;
            %%%%% rearrange equation with mub on other side so both sides are O(1) %%%%
            Kb  = sqrt(k.*k +l.*l + beta*k./sig);
            %mub = Kb.*NB./f;
            KXgh= (hy.*k - hx.*l);
            lhs(jk)  = tanh(NB.*h.*Kb./f);
            rhs(jk) =  NB.*KXgh./(sig.*Kb);
        end % for jk, inner optimization loop
        xx = abs(rhs-lhs);
        difference(jl) = min(abs(rhs-lhs));
        iwant = find(xx==min(xx));   % iwant = index of kk that best fits this ll
        kl(jl) = kk(iwant);          % kl is k(l,omega,Ei) for jl outer loop
        if difference(jl) > 5e-3 %1e-2  % was 1e-7 for KD's arrangement, factor Kb smaller
            kl(jl) = NaN;
        end %if
    end % for jl, outer small suite of ll's
    ang=1:89;
    sinang=sind(ang); cosang=cosd(ang);

    figure(11)
    clf
    subplot(1,2,1) %%%
    v = -3300:100:0;
    hold on
    [~,zzzz]=contour(xtopo,ytopo,ztopoS',v,'k','ShowText','on','DisplayName','Topography');
    contour(xtopo,ytopo,ztopo',v,'-.','ShowText','off','EdgeAlpha',0.5);
    % contour(xtopo,ytopo,ztopo',-0.1:0.1:0.1,'k');
    aaaa = scatter(pathLon,pathLat,10,'filled','o','MarkerEdgeColor',"#ff7d9d",'MarkerFaceColor',"#ff7d9d");
    scatter(pathLon(q),pathLat(q),5,'o','MarkerEdgeColor',"black","LineWidth",5);
    magnitude = abs(pathEi(q,2) + 1i*pathEi(q,3));
    cccc = quiver(pathLon(q)-pathEi(q,2)/magnitude*0.05,pathLat(q)-pathEi(q,3)/magnitude*0.05,pathEi(q,2)/magnitude*0.14,pathEi(q,3)/magnitude*0.14,"MaxHeadSize",0.5,"LineWidth",3,"Color","#ffb300"); % topo gradient
    magnitude = abs(pathCgx(q) + 1i*pathCgy(q));
    bbbb = quiver(pathLon(q),pathLat(q),pathCgx(q)./magnitude.*0.1,pathCgy(q)./magnitude.*0.1,'k',"MaxHeadSize",5,"LineWidth",3);
    text(pathLon(q)+pathCgx(q)./magnitude.*0.1+0.03, pathLat(q)+pathCgy(q)./magnitude.*0.1+0.01, ['Cg= ', num2str(pathCg(q),4),' m/s'])
    axis equal
    axis([pathLon(q)-0.4 pathLon(q)+0.4 pathLat(q)-0.4 pathLat(q)+0.4])
    hold off
    grid on
    ax=gca;
    ax.FontSize = 12;
    legend(ax,[zzzz bbbb aaaa cccc],'Experiment Topography','Energy Propagation','Ray path','Topo. Gradient ∇h')
    xlabel('Longitude ^oE',"FontSize",20)
    ylabel('Latitude ^oN',"FontSize",20)
    title(gca,sprintf(['Location at %ghr, %0.0fkm smoothed'],(q-1)*dt_hr,smoothing),"FontSize",20)
    
    subplot(1,2,2) %%%
    % figure(11)    % dispersion [k,l] curves
    colorIndex = 0.002*pi./[abs(kl+1i.*ll)];
    zzzz = scatter(kl,ll,30,colorIndex,'filled');    % y=ll vs x=kl
    clim([0 wavelengths(end)/1000])
    hold on
    magnitude = abs(pathCgx(q) + 1i*pathCgy(q));
    bbbb = quiver(pathK(q),pathL(q),pathCgx(q)./magnitude.*5e-5,pathCgy(q)./magnitude.*5e-5,'k',"MaxHeadSize",1,"LineWidth",3); % Cg
    magnitude = abs(pathEi(q,2) + 1i*pathEi(q,3));
    cccc = quiver(-pathEi(q,2)/magnitude*Kbox*0.7,-pathEi(q,3)/magnitude*Kbox*0.7,pathEi(q,2)/magnitude*Kbox*1.5,pathEi(q,3)/magnitude*Kbox*1.5,"MaxHeadSize",0.25,"LineWidth",3,"Color","#ffb300"); % topo gradient
    magnitude = abs(pathK(q) + 1i*pathL(q));
    aaaa = quiver(0,0,pathK(q),pathL(q),"off","Color","r","LineWidth",5,"MaxHeadSize",3); % K
    
    wavelengths = [wavelengths 2*pi/abs(pathK(q)+1i*pathL(q))];
    for i = length(wavelengths) %subsample KK0's by factor of 10 to plot K0 circles
        K0=2*pi/wavelengths(i);
        kcirc=K0*cosang;
        lcirc=K0*sinang;
        circleColor = 0.002*pi./abs(kcirc+1i*lcirc);

            % getMeColorfulPlot(kcirc,lcirc,circleColor,1,'--',1);
            % getMeColorfulPlot(-kcirc,lcirc,circleColor,1,'--',1);
            % getMeColorfulPlot(kcirc,-lcirc,circleColor,1,'--',1);
            % cirkle = getMeColorfulPlot(-kcirc,-lcirc,circleColor,1,'--',1);
            cirkle = getMeCirclePlot(0,0,K0,1,'--',1,circleColor);
    end
    theta = acosd((pathK(q)*pathEi(q,2)+pathL(q)*pathEi(q,3))/(pathK0(q)*sqrt(pathEi(q,2)^2+pathEi(q,3)^2)));
    % text(-18e-5, 8e-5,['Cross Product Angle (^o)= ', num2str(theta,4')])
    % text(-18e-5, 10e-5,['hx= ', num2str(hx,4'), ', hy= ', num2str(hy,4)])
    % text(-18e-5, 12e-5, ['h (m)= ', num2str(h,4)])
    text(mean(kcirc), -mean(kcirc), ['Wavelength ', num2str(2*pi/1000/pathK0(q),4) 'km'],"VerticalAlignment","top","HorizontalAlignment","left")
    % text(-18e-5, 16e-5, ['Wavelength Circles (km): 25:25:600'])
    legend([zzzz aaaa bbbb cccc cirkle(1)],"Slowness Curve", ... 
        ' Wavenumber K',"Group Velocity","Topo. Gradient","K Isocontour")
    axis([-Kbox +Kbox -Kbox +Kbox])
    cbar = colorbar(gca,"south"); xlabel(cbar,'Wavelength (km)')
    axis square
    ax = gca;
    colormap(gca,cmap)
    ax.FontSize = 12;
    title(['Wave Period = ', num2str(startT),' days'],"FontSize",20)
    xlabel('k (radian m^{-1})',"FontSize",20); ylabel('l (radian m^{-1})',"FontSize",20);
    grid on
    hold off

    %%% generate GIF
    % exportgraphics(gcf,'slowessDemo.gif','Append',true);

    pause(.01);
end
