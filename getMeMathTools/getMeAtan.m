function angleInRadian = getMeAtan(x,y,x0,y0)

if nargin == 2 || isempty(x0) || isempty(y0)
    % x and y are cartesian distance to reference pt (x0,y0) in x-dir and y-dir
elseif nargin == 4 && ~isempty(x0) && ~isempty(y0)
    % provide your own referene point (x0,y0)
    x = x-x0;
    y = y-y0;
end

for ii = 1:length(x)
    if x(ii) == 0
        if y > 0
            angleInRadian(ii) = pi/2;
        elseif y < 0
            angleInRadian(ii) = -pi/2;
        else
            angleInRadian(ii) = [nan];
        end
    else
        angleInRadian(ii) = atan(y(ii)./x(ii));
        if x(ii) < 0 && y(ii) > 0
            angleInRadian(ii) = angleInRadian(ii) + pi;
        elseif x(ii) < 0 && y(ii) < 0
            angleInRadian(ii) = angleInRadian(ii) + pi;
        elseif x(ii) > 0 && y(ii) < 0
            angleInRadian(ii) = angleInRadian(ii) + pi*2;
        end
    end
end

angleInRadian(angleInRadian>=pi) = angleInRadian(angleInRadian>=pi) - 2*pi;