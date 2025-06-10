function [reorientedComplexTSOutput,radianAppliedToWin,ratio] = getMeReoriented(complexTS,mode)

% modes:
% Meanflow
% Variance - u> direction of biggest variance
% Ratio - 'most elongated' pretty much the same as Variance

division  = 3600;

if exist('mode','var') == 0
    error('Bruh you forgot to select your mode of rotation.')
end

% point positive u in the direction of...
if mode(2:4) == 'ean' % mean flow
    radianAppliedToWin = -angle(mean(complexTS,'omitmissing'));
end

if mode(2:4) == 'ari'  % largest variance
    steve = 0;
    radianAppliedToWin = 0;
    for theta = -pi/2:pi/division:pi/2  %0.05 interval
        rotationAttempt = complexTS(:,:).*exp(1i*theta);
        if std(real(rotationAttempt),'omitmissing')>steve
            steve = std(real(rotationAttempt),'omitmissing');
            radianAppliedToWin=theta;
        elseif std(real(rotationAttempt),'omitmissing')==steve
            radianAppliedToWin=[radianAppliedToWin theta];
        end
    end
end

if mode(2:4) == 'ati'  % largest variance ratio
    stever = 1;
    radianAppliedToWin = 0;
    for theta = -pi/2:pi/division:pi/2  %0.05 interval
        rotationAttempt = complexTS(:,:).*exp(1i*theta);
        if std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing')>stever
            stever = std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing');
            radianAppliedToWin=theta;
        elseif std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing')==stever
            radianAppliedToWin=[radianAppliedToWin theta];
        end
    end
end

% rotationRAD is the angle in radians applied on TS to align u> with x>
try % if there is only one winner
    reorientedComplexTSOutput = complexTS .* exp(1i * radianAppliedToWin);
    ratio = std(real(reorientedComplexTSOutput),'omitmissing')/std(imag(reorientedComplexTSOutput),'omitmissing');
catch % if there are multiple winners
    if std(abs(radianAppliedToWin)) == 0 || sum(radianAppliedToWin) == 0 % if they are exactly opposite angles
        try
            radianAppliedToWin = max(radianAppliedToWin(radianAppliedToWin<0));
        catch
            radianAppliedToWin = min(radianAppliedToWin(radianAppliedToWin>0));
        end
    else
        [~,index] = min(abs(radianAppliedToWin));
        radianAppliedToWin = radianAppliedToWin(index); % find the rotation of least effort

    end
end
reorientedComplexTSOutput = complexTS .* exp(1i * radianAppliedToWin);
ratio = std(real(reorientedComplexTSOutput),'omitmissing')/std(imag(reorientedComplexTSOutput),'omitmissing');
end