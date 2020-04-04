V = input('Enter the volume of the box\n') ;
N = input('Enter the total number of particles\n') ;
v = V/N ;
it = 1 ;

for zed=0:0.001:1-0.001
    z(it) = zed ;
    zfunc(it) = zed/(1-zed) ;
    g_val(it) = G(3/2 , zed) ;
    total(it) = zfunc(it) + g_val(it) ;
    
    it = it + 1 ;
end

plot (z , zfunc) ;
xlim([0 , 2]) ;
ylim([0 , 5]) ;