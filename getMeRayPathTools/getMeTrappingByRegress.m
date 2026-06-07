function [scale,slopes] = getMeTrappingByRegress(timeSeries,depths)

[m,n] = size(timeSeries);

if m<n % ensure dimension 1 is the longest, dimension 2 is the layers
    timeSeries = timeSeries.';
end


for ii = 1:size(timeSeries,2)
    [slopes(ii),BINT,R,RINT] = regress(timeSeries(:,ii),timeSeries(:,end));
    b = 10:10:10000;
    for ib = 1:length(b);
        r(ib) = cosh(depths(ii)./b(ib))./cosh(depths(end)./b(ib));
    end
    [~,iwant] = min(abs(r-slopes(ii)));

    b_trapping(ii) = b(iwant);
end

modelfun=@(b,x)(cosh(x./b)./cosh(depths(end)./b));
x = depths;
beta0 = mean(b_trapping(1:end-1));


while size(slopes) ~= size(x)
    slopes = slopes.';
end

mdl = fitnlm(x,slopes,modelfun,beta0);

scale = mdl.Coefficients;
scale = abs(scale.Estimate);
