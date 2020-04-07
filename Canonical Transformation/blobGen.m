it=1 ; 
r = 5 ; 
for theta= 0 : (2*pi)/10000 : 2*pi 
rad = r*(1 - theta*(theta-2*pi)/(pi*pi)) ;
x(it) = rad * + cos(theta) ;
y(it) = rad * sin(theta);
it = it+1;
end
x(it) = x(1) ;
y(it) = y(1) ;

plot(x,y) ;