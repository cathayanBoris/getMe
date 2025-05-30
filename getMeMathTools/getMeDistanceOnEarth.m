function [distance,dx,dy] = getMeDistanceOnEarth(coordinate1,coordinate2)

% coordinate in [longitude latitude] format

alat = mean([coordinate1(2) coordinate2(2)]); % average latitude in between
dlon = diff([coordinate1(1) coordinate2(1)]);
dlat = diff([coordinate1(2) coordinate2(2)]);

rlat = alat * pi/180;
p = 111415.13 * cos(rlat) - 94.55 * cos(3 * rlat);
dx = dlon .* p / 1000;

% rlat = mean(ytopo) * pi/180;
m = 111132.09 * ones(size(rlat)) - ...
    566.05 * cos(2 * rlat) + 1.2 * cos(4 * rlat);
dy = dlat .* m / 1000;

distance = abs(dx+1i.*dy);
end