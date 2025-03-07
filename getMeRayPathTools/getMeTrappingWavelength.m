function [wavelengths] = getMeTrappingWavelength(upperU,lowerU,upperDepth,lowerDepth,latitude)
% U = sqrt(u.^2+v.^2)

ratio = regress(upperU,lowerU);

bSet = [10:10:10000];
ratioSet = zeros(size(bSet));
for kk = 1:length(bSet)
    ratioSet(kk) = cosh(upperDepth/bSet(kk)) / cosh(lowerDepth/bSet(kk));
end

errorSet = abs(ratio - ratioSet);
[~,minPosition] = min(errorSet);
bValue = bSet(minPosition);
try
    wavelengths = 2*pi*bValue/1000.*NBh(abs(mean([lowerDepth upperDepth])))/gsw_f(latitude);
catch
    omega = 7.292e-5;
    wavelengths = 2*pi*bValue/1000.*NBh(abs(mean([lowerDepth upperDepth])))/(2*omega*sind(latitude));
end

%% NBh supplementary function
    function NB = NBh(h)
        % function NB = NBh(h)
        % make buoyancy freq NB depend in exponental downward decay with depth h
        %       NB =NN*exp(-h/HH)
        % the two constants NN and HH are fitted by two value-depth pairs
        % hi,Ni,TB_hr =(1500, 8e-4, 2.2) &(3000, 2.4e-4, 7.3); Aryan and Boris profiles
        % test point from (hi,Ni,TB_hr) = (2500, 2.7e-4, 6.5);
        %   HH= -(h2-h1)/ln(N2/N1);  %  NN= N1*exp(h1/HH); % fits the two constants
        %  NB= NN*exp(-h/HH);

        h = h-500;
        h1=1500; N1=8e-4;
        h2=3000; N2=2.4e-4;
        HH= -(h2-h1)/log(N2/N1);
        NN= N1*exp(h1/HH);
        % NB= NN*exp(-[1500:500:3000]/HH)     %test values look good
        NB =NN*exp(-h/HH);
    end
end