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

    Xextended = [X 2*X(end)-X(end-1)];
    Yextended = [Y 2*Y(end)-Y(end-1)];

else % is a matrix
    error(['X and Y need to be vectors.']);
end


Cexpanded = nan([q+1,r+1]);
Cexpanded(1:q,1:r) = C;
Cexpanded(q+1,1:r) =C(q,1:r);
Cexpanded(1:q,r+1) = C(1:q,r);
Cexpanded(q+1,r+1) = C(q,r);

dX = diff(Xextended); dX = [dX dX(end)]/2;
dY = diff(Yextended); dY = [dY dY(end)]/2;


Xshifted = Xextended-dX;
Yshifted = Yextended-dY;

output = pcolor(gca,Xshifted,Yshifted,Cexpanded);

X
% xticks(X(1:end-1)); yticks(Y(1:end-1));
end