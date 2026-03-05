function [sortedXY,sortedRad] = getMeSortedRing(X,Y,sortBy)
% from -180 to <180 wrt weighted mean among X,Y
% first reorient X,Y to an angle of input "sortBy"




cog = [mean([max(X) min(X)]) mean([max(Y) min(Y)])];
com = [mean(X) mean(Y)];
radianRef = getMeAtan(cog(1),cog(2),0,0);

if ~exist("sortBy","var") || isempty(sortBy)
    radianApplied = 0;
elseif isnumeric(sortBy)
    radianApplied = sortBy;
elseif ischar(sortBy) || isstring(sortBy)
    [~,radianApplied] = getMeReoriented((X)+1i.*(Y),sortBy); % add rA to level the ring in requested way
% if use mean X,Y no difference geometrically, iirc
end

rotatedXY = (X+1i.*Y).*exp(1i.*radianApplied);
Xr = real(rotatedXY); Yr = imag(rotatedXY);
% then use a point in the loop (if applicable) meanXr,0 may do
% to start angle sequencing
crf = [mean([max(Xr) min(Xr)]) 0];

for ii = 1:length(Xr)
    distance =  norm([Xr(ii) Yr(ii)] - crf); % problem
    cosang =  (Xr(ii) - crf(1)) ./ distance;
    sinang =  (Yr(ii) - crf(2)) ./ distance;

    if sinang < 0
        rad(ii) = -acos(cosang);
    elseif sinang > 0
        rad(ii) = acos(cosang);
    else
        if cosang > 0
            rad(ii) = 0;
        elseif cosang < 0
            rad(ii) = -pi;
        else % sinang==0 && cosang==0
            error('A member lands on the mean.')
        end
    end
end


% rad = rad+radianApplied+radianRef;
rad(rad<-pi) = rad(rad<-pi)+2*pi;
rad(rad>=pi) = rad(rad>=pi)-2*pi;

[~,in] = sort(rad,'ascend');
sortedX = X(in);
sortedY = Y(in);
sortedRad = rad(in);
sortedXY = sortedX + 1i.*sortedY;
% sortedX = [sortedX sortedX(1)];
% sortedY = [sortedY sortedY(1)];
% sortedRad = [sortedRad sortedRad(1)+2*pi];

end
