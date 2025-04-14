function beta = getMeBeta(latitude)
% beta = df/dy
omega=7.292e-5;   %% Earth's rotation rate(s-1)   A.E.Gill p.597
try
    beta = (gsw_f(latitude+0.001) - gsw_f(latitude-0.001))/(0.002*pi*6371000/180);
catch
    try
        beta = (sw_f(latitude+0.001) - sw_f(latitude-0.001))/(0.002*pi*6371000/180);
    catch
        beta = 2*omega*(sind(latitude+0.001) - sind(latitude-0.001)/(0.002*pi*6371000/180);
        % beta = 2*omega*cosd(latitude)/6371000;
    end
end