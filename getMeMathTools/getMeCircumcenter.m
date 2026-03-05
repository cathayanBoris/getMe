function [c] = getMeCircumcenter(x,y)

x1 = x(1); x2 = x(2); x3 = x(3);
y1 = y(1); y2 = y(2); y3 = y(3);

D = ((x1*(y2-y3)) + (x2*(y3 - y1)) + (x3*(y1-y2)))*2;

cx = ((x1^2+y1^2)*(y2-y3) + (x2^2+y2^2)*(y3-y1) + (x3^2+y3^2)*(y1-y2)) / D;
cy = ((x1^2+y1^2)*(x3-x2) + (x2^2+y2^2)*(x1-x3) + (x3^2+y3^2)*(x2-x1)) / D;

c = [cx cy];

% figure(99)
% clf 
% scatter(x,y)
% hold on
% quiver(x,y,cx-x,cy-y,'off')
% scatter(cx,cy,200,'filled')