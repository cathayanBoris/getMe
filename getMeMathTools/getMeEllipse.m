function ellipseComplex = getMeEllipse(axis1,axis2,tiltRad)

t=-pi:0.01:pi;
x=axis1*cos(t);
y=axis2*sin(t);
ellipseComplex = (x+1i*y)*exp(1i*tiltRad);

end