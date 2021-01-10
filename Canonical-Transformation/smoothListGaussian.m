function smoothed = smoothListGaussian(list, degree)
 window = degree*2 - 1 ;
 weight = ones(1,window) ;
 
 for i = 1 : 1 : window
     it = i ;
     ic = i - degree + 1 ;
     frac = ic/window ;
     gauss = 1/exp((4*frac)^2) ;
     weightGauss(it) = gauss ;
 end
 
 weight = weightGauss .* weight ;
 smoothed = zeros(1, length(list)-window) ;
 
 for i = 1 : 1 : length(smoothed)
    smoothed(i) =  sum(list(i:i+window-1) .* weight)/sum(weight) ;
 end
 
end