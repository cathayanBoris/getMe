function [outputSignal] = getMeLowPassed(inputSignal,order,lowPassPeriod,samplingPeriod)
% make sure low-pass and sampling period have the same unit
% 4th-order Butterworth
%
% First remove a ramp so that the first and last points are zero.  
% This minimizes the filter transients at the ends of the record.  

P=polyfit([1 length(inputSignal)],[inputSignal(1) inputSignal(end)],1);
dumx=[1:length(inputSignal)];
lineartrend=polyval(P,dumx);

if size(lineartrend) ~= size(inputSignal)
    lineartrend = lineartrend';
end

inputSignal=inputSignal-lineartrend;

%
% Second, create the Butterworth filter.  
%

Wn=(2/lowPassPeriod)*samplingPeriod;
[b,a]=butter(order,Wn);

%
% Third, filter the data both forward and reverse.  
%

if ~isempty(find(isnan(inputSignal),1))
 error('Bruh there are NaNs in this data set')
end
outputSignal=filtfilt(b,a,inputSignal);


%
% Finally return the linear trend removed earlier.
%
outputSignal=outputSignal+lineartrend;

