function [processedBinComplex,timeOutput] = getMeProcessedBin(timeSeries,timeInDatenum, ...
    surveyWidth,timeResolution,tukeyTolerance,rotationRadian)

% DSPK
[complexOutput,timeOutput] = getMeDespiked2(timeSeries,timeInDatenum,surveyWidth,timeResolution); % length = DSPK output only
% % Rotation
complexOutput = complexOutput.*exp(1i*rotationRadian); % length = DSPK output only
outputU = real(complexOutput);
outputV = imag(complexOutput);
% TUKEY53H
[outputU,~] = IES_TUKEY53H(outputU,tukeyTolerance); % length = DSPK output only
[outputV,~] = IES_TUKEY53H(outputV,tukeyTolerance);
% restore TUKEY NaNs
outputU(isnan(outputU)) = real(complexOutput(isnan(outputU)));
outputV(isnan(outputV)) = imag(complexOutput(isnan(outputV)));
% 3-day low pass
[outputU] = getMeLowPassed(outputU,4,3,0.25);
[outputV] = getMeLowPassed(outputV,4,3,0.25);
% output
processedBinComplex = outputU + 1i*outputV;