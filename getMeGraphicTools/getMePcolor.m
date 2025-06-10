function [output] = getMePcolor(X,Y,C)

% only suit for flat shading 

[m,n] = size(X); [o,p] = size(Y); [q,r] = size(C);

% if ismatrix(X) || ismatrix(Y)
%     if m ~= o || n ~= p
%         Y = Y.';
%     end
%     X = X(:,1);
%     Y = Y(1,:);
% end

if isvector(X) || isvector(Y)
    if m>n
        X = X.';
    end
    if o>p
        Y = Y.';
    end

    X = [X 2*X(end)-X(end-1)];
    Y = [Y 2*Y(end)-Y(end-1)];
end


Cexpanded = nan([q+1,r+1]);
Cexpanded(1:q,1:r) = C;
Cexpanded(q+1,1:r) =C(q,1:r);
Cexpanded(1:q,r+1) = C(1:q,r);
Cexpanded(q+1,r+1) = C(q,r);

dX = diff(X); dX = [dX dX(end)]/2;
dY = diff(Y); dY = [dY dY(end)]/2;


Xshifted = X-dX;
Yshifted = Y-dY;

output = pcolor(gca,Xshifted,Yshifted,Cexpanded);
shading flat
xticks(X(1:end)); yticks(Y(1:end));
end