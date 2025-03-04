function beta = getMeBeta(latitude)
% beta = df/dy
omega=7.292e-5;   %% Earth's rotation rate(s-1)   A.E.Gill p.597
try
beta = (gsw_f(latitude+0.01) - gsw_f(latitude-0.01))/(0.02*pi*6371000/180);
catch
beta = 2*omega*(sind(latitude+0.01) - sind(latitude-0.01))/(0.02*pi*6371000/180);
end