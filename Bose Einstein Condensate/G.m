function val = G(nu , z)
    
    val = 0 ;
    
    for i=1:1:10000
    val = val + (z^i)/(i^nu) ;   
    end
end

