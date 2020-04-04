function [val] = integrator(f , a , b , n)     %n should be a MULTIPLE of 4.

h = (b - a)/n ;
i = 1 ;
val = 14*h/45 * (f(a) + f(b)) ;     %Check formula

while i < n 
    if mod(i,4) == 1 || mod(i,4) == 3 
        val = val + (64*h/45)*f(a+i*h) ;
    else if mod(i,4) == 2
        val = val + (24*h/45)*f(a+i*h) ;   
    else
        val = val + (28*h/45)*f(a+i*h) ;        
    end
end
    
     i = i + 1 ;   
end
