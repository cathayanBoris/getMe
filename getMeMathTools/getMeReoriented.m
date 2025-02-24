function [reorientedComplexTSOutput,radianAppliedToWin] = getMeReoriented(complexTS,mode)

% modes:
% Meanflow
% Variance
% Ratio - pretty much the same as Variance

if exist('mode','var') == 0
    error('Bruh you forgot to select your mode of rotation')
end

% point positive u in the direction of...
if mode(2:4) == 'ean' % mean flow
    radianAppliedToWin = -angle(mean(complexTS,'omitmissing'));
end

if mode(2:4) == 'ari'  % largest variance
    steve = 0;
    for theta = -pi/2:2*pi/7200:pi/2
        rotationAttempt = complexTS(:,:).*exp(1i*theta);
        if std(real(rotationAttempt),'omitmissing')>steve
            steve = std(real(rotationAttempt),'omitmissing');
            radianAppliedToWin=theta;
        end
    end
end

if mode(2:4) == 'ati'  % largest variance ratio
    stever = 1;
    for theta = -pi/2:2*pi/7200:pi/2
        rotationAttempt = complexTS(:,:).*exp(1i*theta);
        if std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing')>stever
            stever = std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing');
            radianAppliedToWin=theta;
        end
    end
end

% rotationRAD is the angle in radians applied on TS to align u> with x>
reorientedComplexTSOutput = complexTS .* exp(1i * radianAppliedToWin);