function angleInRadian = getMeAtan(x,y,x0,y0)

if nargin == 2 || isempty(x0) || isempty(y0)
    % x and y are cartesian distance to reference pt (x0,y0) in x-dir and y-dir
elseif nargin == 4 && ~isempty(x0) && ~isempty(y0)
    % provide your own referene point (x0,y0)
    x = x-x0;
    y = y-y0;
end

for ii = 1:length(x(:,1))
    for jj = 1:length(x(1,:))
    if x(ii,jj) == 0
        if y(ii,jj) > 0
            angleInRadian(ii,jj) = pi/2;
        elseif y(ii,jj) < 0
            angleInRadian(ii,jj) = -pi/2;
        else
            angleInRadian(ii,jj) = [nan];
        end
    else
        angleInRadian(ii,jj) = atan(y(ii,jj)./x(ii,jj));
        if x(ii,jj) < 0 && y(ii,jj) > 0
            angleInRadian(ii,jj) = angleInRadian(ii,jj) + pi;
        elseif x(ii,jj) < 0 && y(ii,jj) < 0
            angleInRadian(ii,jj) = angleInRadian(ii,jj) + pi;
        elseif x(ii,jj) > 0 && y(ii,jj) < 0
            angleInRadian(ii,jj) = angleInRadian(ii,jj) + pi*2;
        end
    end
    end 
end

angleInRadian(angleInRadian>=pi) = angleInRadian(angleInRadian>=pi) - 2*pi;