function [reorientedComplexTSOutput,radianAppliedToWin,major,minor,ratio] = getMeReoriented(complexTS,mode)

% radianAppliedToWin: radian needed to have the request axis as u

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
    try

        % % % covariance 'princax'
        indValid=find(isfinite(complexTS));
        temporary=complexTS;
        complexTS=complexTS(indValid);
        % find covariance matrix
        covarianceMatrix=cov([real(complexTS(:)) imag(complexTS(:))]);
        % find direction of maximum variance
        theta=0.5*atan2(2.*covarianceMatrix(2,1),(covarianceMatrix(1,1)-covarianceMatrix(2,2)) );
        % the radian needed to apply
        radianAppliedToWin = -theta;
        % find major and minor axis amplitudes
        term1=(covarianceMatrix(1,1)+covarianceMatrix(2,2));
        term2=sqrt((covarianceMatrix(1,1)-covarianceMatrix(2,2)).^2 + 4.*covarianceMatrix(2,1).^2);
        major=sqrt(.5*(term1+term2));
        minor=sqrt(.5*(term1-term2));
        ratio = major/minor;
        complexTS = temporary;
        % rotate into principal ellipse orientation
        % wr(indValid)=complexTS.*exp(1i*radianAppliedToWin;
        % wr(ind)=w.*exp(-i*theta);
        % theta=theta*180./pi;
    catch
        % % % trial and error - inefficient and inaccurate
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
end

% if mode(2:4) == 'ati'  % largest variance ratio
%     stever = 1;
%     radianAppliedToWin = 0;
%     for theta = -pi/2:pi/division:pi/2  %0.05 interval
%         rotationAttempt = complexTS(:,:).*exp(1i*theta);
%         if std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing')>stever
%             stever = std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing');
%             radianAppliedToWin=theta;
%         elseif std(real(rotationAttempt),'omitmissing')/std(imag(rotationAttempt),'omitmissing')==stever
%             radianAppliedToWin=[radianAppliedToWin theta];
%         end
%     end
% end

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
if ~exist("minorVariance",'var')
    if mode(2:4) == 'ari'
    major = std(real(reorientedComplexTSOutput),'omitmissing');
    minor = std(imag(reorientedComplexTSOutput),'omitmissing');
    % ratio = std(real(reorientedComplexTSOutput),'omitmissing')/std(imag(reorientedComplexTSOutput),'omitmissing');
    end
    if mode(2:4) == 'ean' % mean flow
    major = mean(real(reorientedComplexTSOutput),'omitmissing');
    minor = nan;
end
    
    ratio = major./minor';
end
end