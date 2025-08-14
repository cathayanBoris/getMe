function ellipseComplex = getMeEllipse(axisX,axisY,tiltRadian)
% to use: plot(real,imag)

t=-pi:0.01:pi;
x=axisX*cos(t);
y=axisY*sin(t);
ellipseComplex = (x+1i*y)*exp(1i*tiltRadian);

end