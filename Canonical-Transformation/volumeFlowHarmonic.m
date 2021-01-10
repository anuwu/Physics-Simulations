% Credits to https://www.swharden.com/wp/2008-11-17-linear-data-smoothing-in-python/ for Gaussian smoothing of data points
% Credits to https://tex.stackexchange.com/questions/144654/how-to-generate-random-closed-shape-and-draw-a-line-bisecting-it for generating a random blob.

m = 1 ;
omega = 2 ;
c = 1.5 ;

p_der = @(q,p) - m*omega*omega*q ;
q_der = @(p) p/m ;

P_der = @(Q,P) P*cos(Q)*sin(Q)*(4*c/m - m*omega*omega/c)  ;
Q_der = @(K,P) K/P ;


points = 100 ;

[qAll,pAll] = blobGen(0,0.4, points) ;
QAll = atan (2*c * qAll ./ pAll) ;
PAll = (pAll.^2 + 4*c^2* qAll .^2)/(4*c) ;
KAll = (2*c/m) * cos(QAll) .* cos(QAll) .* PAll + (m*omega*omega/(2*c))* PAll.*sin(QAll).*sin(QAll) ;


figure ('Name' , 'Phase Space') ;

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
        
        % ---------------------------------------------------------------------------------------
        
        Q_start = QAll(particle) ;
        P_start = PAll(particle) ;
        Q_end = Q_start + h*Q_der(KAll(particle), P_start) ;
        P_end = P_start + h*P_der(Q_start , P_start) ;
        QAll(particle) = QAll(particle) + h/2 * (Q_der(KAll(particle), P_start) + Q_der(KAll(particle), P_end)) ;
        PAll(particle) = PAll(particle) + h/2 * (P_der(Q_start, P_start) + P_der(Q_end, P_end)) ;
        
    end
    
    k = boundary(qAll.',pAll.');
    qArea = qAll(k).' ;
    pArea = pAll(k).' ;
    Area1 = polyarea (qArea,pArea) ; area1(it) = Area1 ;
    titleStr = "Step = " + string(it) + " Phase Area = " + string(Area1) ;
    
    subplot (2, 1, 1) ;
    plot (qAll , pAll) ;
    title (titleStr) ;
    xlabel ('q') ;
    ylabel ('p') ;
    xlim([-10,10]) ;
    ylim([-10,10]) ;
    grid on ;
    
    % ---------------------------------------------------------------------------------------
    
    k = boundary(QAll.',PAll.');
    QArea = QAll(k).' ;
    PArea = PAll(k).' ;
    Area2 = polyarea (QArea,PArea) ; area2(it) = Area2 ;
    titleStr = "Step = " + string(it) + " Phase Area = " + string(Area2) ;

    subplot (2, 1, 2) ;
    plot (QAll - floor(QAll/(2*pi))*2*pi , PAll) ;
    title (titleStr) ;
    xlabel ('Q') ;
    ylabel ('P') ;
    xlim([0,2*pi]) ;
    ylim([0,25]) ;
    grid on ;
    
    drawnow ;
    
    time(it) = t ;
    it = it + 1 ;
end


figure ('Name', 'Volume') ;
subplot (2, 1 ,1) ;
plot (time, area1);
title ("Variation in volume over steps, mean = " + string(mean(area1)) + " stddev = " + string(std(area1))) ;
xlabel ("Steps") ;
ylabel ("Volume") ;


subplot (2, 1 ,2) ;
plot (time, area2);
title ("Variation in volume over steps, mean = " + string(mean(area2)) + " stddev = " + string(std(area2))) ;
xlabel ("Steps") ;
ylabel ("Volume") ;





