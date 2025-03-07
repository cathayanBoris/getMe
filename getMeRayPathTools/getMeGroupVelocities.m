function [Cg,Cgx,Cgy,B,reSig] = getMeGroupVelocities(startT,pathK,pathL,pathEi)

pathH = pathEi(:,1);
pathHx = pathEi(:,2);
pathHy = pathEi(:,3);
% pathHxx = pathEi(:,4);
% pathHxy = pathEi(:,5);
% pathHyy = pathEi(:,6);
pathNB = pathEi(:,7);
pathF = pathEi(:,8);
pathBeta = pathEi(:,9);

sig = 2*pi/startT/86400;
pathKb = sqrt(pathK.^2 + pathL.^2 + pathK.*pathBeta./sig);
pathMju = pathNB.*pathKb./pathF;
Kxgh = pathK.*pathHy - pathL.*pathHx;
Tz = tanh(pathMju.*pathH);
TTT = (1-Tz.^2)./Tz;

Cgx = (pathHy./Kxgh - (pathK+pathBeta/(2*sig))./(pathKb.^2).*(1+pathMju.*pathH.*TTT)).*sig;
Cgy = (-pathHx./Kxgh - (pathL)./(pathKb.^2).*(1+pathMju.*pathH.*TTT)).*sig;
Cg = sqrt(Cgx.^2 + Cgy.^2);
B = 1./pathMju; % bottom trapping?
reSig = pathNB .* Kxgh ./ pathKb ./Tz;
end