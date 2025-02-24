load bathyGOM.mat
wavelengths = 1000*[25:25:400];

% copy in file name
% load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\mayTwentyfirst\25D200KM-89.2E27.36N0.125HdT5day20KMsmooth.mat")

% loop example
% load('C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\backward\threeDts\15D25KM-89.98E27.23N-0.125HdT20day20KMsmooth.mat')
load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\experimentSE\40D200KM-88.65E26.6N0.125HdT15day20KMsmooth.mat")
% load("C:\Users\Yan_J\OneDrive\Documents\MATLAB\GoM\TRW\rayTracing\forward\15D145.3KM-89.2984E26.8477N0.125HdT3day20KMsmooth.mat")

[pathCgx,pathCgy,pathCg] = getMeGroupVelocities(startT,pathK,pathL,pathEi);
%%
for q = 1:abs(6/dt_hr):length(pathLon)
    figure(11)
    % clf
    colormap default
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

    inc = 1000;
    Kbox=2e-4;     % big box for wavelengths as short as 62.8 km
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
        if difference(jl) > 1e-2 %1e-2  % was 1e-7 for KD's arrangement, factor Kb smaller
            kl(jl) = NaN;
        end %if
    end % for jl, outer small suite of ll's
    ang=1:89;
    sinang=sind(ang); cosang=cosd(ang);
    figure(11)
    subplot(1,2,1)
    v = -3300:100:0;
    contour(xtopo,ytopo,ztopo',v,'-.','ShowText','on');
    hold on
    contour(xtopo,ytopo,ztopoS',v,'k','ShowText','off');
    contour(xtopo,ytopo,ztopo',-0.1:0.1:0.1,'k');
    scatter(pathLon,pathLat,8,'o','MarkerEdgeColor',"#ff7d9d");
    scatter(pathLon(q),pathLat(q),5,'o','MarkerEdgeColor',"black","LineWidth",5);
    quiver(pathLon(q),pathLat(q),pathCgx(q),pathCgy(q),0.1,'k',"MaxHeadSize",100,"LineWidth",3);
    axis equal
    axis([pathLon(q)-0.4 pathLon(q)+0.4 pathLat(q)-0.4 pathLat(q)+0.4])
    text(pathLon(q)+0.01, pathLat(q), ['Cg= ', num2str(pathCg(q),4),' m/s'])
    hold off
    grid on
    ax=gca;
    ax.FontSize = 15;
    xlabel('Longitude E',"FontSize",20)
    ylabel('Latitude N',"FontSize",20)
    title(['Location at ',num2str((q-1)*dt_hr), ' hr, 20km smoothed'],"FontSize",20)
    
    subplot(1,2,2)
    % figure(11)    % dispersion [k,l] curves
    plot(kl,ll,'b.');    % y=ll vs x=kl
    hold on
    bbbb = quiver(pathK(q),pathL(q),pathCgx(q),pathCgy(q),'k',"LineWidth",3,"AutoScale","off");
    cccc = quiver(0,0,pathEi(q,2),pathEi(q,3),"LineWidth",3,"AutoScale","off","Color","#ffb300");
    aaaa = quiver(0,0,pathK(q),pathL(q),"Color","#D95319","LineWidth",3,"MaxHeadSize",3,"AutoScale","off");

    for i = 1:length(wavelengths) %subsample KK0's by factor of 10 to plot K0 circles
        K0=2*pi/wavelengths(i);
        kcirc=K0*cosang;
        lcirc=K0*sinang;
        plot(kcirc,lcirc,'m-', kcirc,-lcirc,'m-',...
            -kcirc,lcirc,'m-',-kcirc,-lcirc,'m-')
    end
    theta = acosd((pathK(q)*pathEi(q,2)+pathL(q)*pathEi(q,3))/(pathK0(q)*sqrt(pathEi(q,2)^2+pathEi(q,3)^2)));
    text(-18e-5, 8e-5,['theta (^o)= ', num2str(theta,4')])
    text(-18e-5, 10e-5,['hx= ', num2str(hx,4'), ', hy= ', num2str(hy,4)])
    text(-18e-5, 12e-5, ['h (m)= ', num2str(h,4)])
    % text(-18e-5, 14e-5, ['K0= ', num2str(pathK0(q),4)])
    text(-18e-5, 14e-5, ['Wavelengh (km)= ', num2str(2*pi/1000/pathK0(q),4)])
    text(-18e-5, 16e-5, ['Wavelength Cicles (km): 25:25:400'])
    legend([aaaa bbbb cccc],"Wavenumber K0","Group Velocity","Bathy. Gradient")
    axis([-Kbox +Kbox -Kbox +Kbox])
    axis square
    ax=gca;
    ax.FontSize = 15;
    title(['Period = ', num2str(startT),' days'],"FontSize",20)
    xlabel('k (1/m)',"FontSize",20); ylabel('l (1/m)',"FontSize",20);
    grid on
    hold off
    % pause(.01);
end
