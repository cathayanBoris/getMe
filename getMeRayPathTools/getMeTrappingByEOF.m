function [scale,slopes,percentage] = getMeTrappingByEOF(timeSeries,depths,mode)

% usage : make the bottom layer as the end row of timeSeries and depths

if ~exist('mode','var') || isempty(mode)
    mode = 1;
end

[m,n] = size(timeSeries);

if m<n % ensure dimension 1 is the longest, dimension 2 is the layers
    timeSeries = timeSeries.';
end

[evect,evals] = getMeEOF(timeSeries);

slopes = evect(:,mode)./evect(end,mode);
percentage = evals(mode)*100;

% figure(1000)
% clf
% for ii = 1:3
%     subplot(1,3,ii)
%     plot(evect(:,ii)./evect(end,ii),depths,'-o')
%     title(sprintf('%.1f%%',evals(ii)*100))
%     set(gca,'FontSize',20)
% end

%
% for ii = 1:size(timeSeries,2)
%     [slopes(ii),BINT,R,RINT] = regress(timeSeries(:,ii),timeSeries(:,end));
%     b = 1000:10:7000;
%     for ib = 1:length(b);
%         r(ib) = cosh(depths(ii)./b(ib))./cosh(depths(end)./b(ib));
%     end
%     [~,iwant] = min(abs(r-slopes(ii)));
% 
%     b_trapping(ii) = b(iwant);
% end

modelfun=@(b,x)(cosh(x./b)./cosh(depths(end)./b));
x = depths;

while size(slopes) ~= size(x)
    slopes = slopes.';
end

mdl = fitnlm(x,slopes,modelfun,5000);

scale = mdl.Coefficients;
scale = abs(scale.Estimate);
