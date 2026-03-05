function showText = getMeCurvedText(x,y,txt)


x1 = x(1); x2 = x(2); x3 = x(3);
y1 = y(1); y2 = y(2); y3 = y(3);
c = getMeCircumcenter(x,y);
cx = c(1);
cy = c(2);
dx = x-cx;
dy = y-cy;


rad = mean(abs(dx + 1i*dy));
endx = [dx(1) dx(3)];
endy = [dy(1) dy(3)];

clear angle
ifLongArc = 0;
ifClockwise = 0;
angle = getMeAtan(dx,dy); % all values are positive

if angle(2) > angle(1)
    while ~issorted(angle)
        angle(3) = angle(3) + 2*pi;
    end
elseif angle(2) < angle(1)
    while ~issorted(-angle)
        angle(3) = angle(3) - 2*pi;
    end
end

% % is now sorted
% if sum(abs(diff(angle))) > pi
% ifLongArc = 1;
% end

if sum(abs(diff(angle))) > 2*pi % don't want a loop over 2pi
        angle(1) = angle(1) + sign(angle(3)-angle(1))*2*pi;
        angle(3) = angle(3) - sign(angle(3)-angle(1))*2*pi;
end

% sgn = (any(abs(diff(angle))>pi,'all')*(-2)+1); % if sgn is -1 take the longer arc

angle = [angle(1) angle(end)];
interval = (diff(angle)./(length(txt)-1));

angle = angle(1):interval:angle(end);
arcx = rad*cos(angle)+cx;
arcy = rad*sin(angle)+cy;
crossProduct = cross([arcx(2)-arcx(1) arcy(2)-arcy(1) 0],[arcx(3)-arcx(2) arcy(3)-arcy(2) 0]);
if crossProduct(3)<0
    ifClockwise = 1;
end

factor = getMeAxisRatio(get(gca,'XLim'),get(gca,'YLim'));
r = getMeAtan((arcx-cx)*factor,arcy-cy); 
for ii = 1:length(txt)
    rotAng = 90+r(ii)*180/pi;
    if  ifClockwise 
      
        rotAng = rotAng+180;
    end
    showText(ii) = text(gca,arcx(ii),arcy(ii),txt(ii),'Rotation',rotAng,'HorizontalAlignment','center','VerticalAlignment','middle');
end