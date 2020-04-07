% Credits to https://www.swharden.com/wp/2008-11-17-linear-data-smoothing-in-python/ for Gaussian smoothing of data points
% Credits to https://tex.stackexchange.com/questions/144654/how-to-generate-random-closed-shape-and-draw-a-line-bisecting-it for generating a random blob.

m = 1 ;
omega = 2 ;

p_der = @(q,p) - m*omega*omega*q ;
q_der = @(p) p/m ;

points = 100 ;

[qAll,pAll] = blobGen(0,0.4, points) ;
figure ('Name' , 'Phase Space') ;
%plot (qAll , pAll) ;

xlim([-10,10]) ;
ylim([-10,10]) ;

h = 0.005 ;
it = 1 ;

for t = 0 : h : 1000*h
    %hold on ;
    for particle = 1 : 1 : length(qAll) 
       
        q_start = qAll(particle) ;
        p_start = pAll(particle) ;
        q_end = q_start + h*q_der(p_start) ;
        p_end = p_start + h*p_der(q_start , p_start) ;
        qAll(particle) = qAll(particle) + h/2 * (q_der(p_start) + q_der(p_end)) ;
        pAll(particle) = pAll(particle) + h/2 * (p_der(q_start, p_start) + p_der(q_end, p_end)) ;
    end
    
    time(it) = t ;
    
    k = boundary(qAll.',pAll.');
    QArea = qAll(k).' ;
    PArea = pAll(k).' ;
    Area = polyarea (QArea,PArea) ; area(it) = Area ;
    titleStr = "Step = " + string(it) + " Phase Area = " + string(Area) ;
    it = it + 1 ;
    
    plot (qAll , pAll) ;
    title (titleStr) ;
    xlabel ('q') ;
    ylabel ('p') ;
    xlim([-10,10]) ;
    ylim([-10,10]) ;
    grid on ;
    drawnow ;
    %hold off ;
end


plot (time, area);
title ("Variation in volume over steps, mean = " + string(mean(area)) + " stddev = " + string(std(area))) ;
xlabel ("Steps") ;
ylabel ("Volume") ;
%display("mean = " + string(mean(area))) ;
%display("stddev = " + string(std(area))) ;




