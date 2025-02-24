function [outputSignal]=getMeBandPassed(inputSignal,order,period1,period2,samplingPeriod)
%
% function [out]=butterfilt_bandpass(in,order,filtThi,filtTlo,sampT);
%
% This function is designed to do lowpass filtering of any vector of 
% data.  It uses a  Butterworth filter and does the 
% filtering twice, once forward and once in the reverse direction.  
%
% INPUTS:
%        in    -- the data vector
%	 filtThi -- the longer period of band
% filtTlo -- the shorter period of band
%	 sampT -- the sample period
%        order -- of the butterworth filter
%
%  NOTE:  filtT and sampT must be entered in the same units!!!!!
%


%
% First remove a ramp so that the first and last points are zero.  
% This minimizes the filter transients at the ends of the record.  
%

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

sorted = sort([period1 period2]);
shortPeriod = sorted(1);
longPeriod = sorted(2);

Wnlo=(2/shortPeriod)*samplingPeriod;
Wnhi=(2/longPeriod)*samplingPeriod;
Wn=[Wnhi Wnlo]; 
[b,a]=butter(order,Wn);

%
% Third, filter the data both forward and reverse.  
%
if ~isempty(find(isnan(inputSignal),1))
 error('Bruh there are NaNs in this data set')
end

outputSignal=filtfilt(b,a,inputSignal);
%

%
% Finally return the linear trend removed earlier.
%
outputSignal=outputSignal+lineartrend;
%
%
