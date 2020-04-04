

m = 1 ;
omega = 2 ;
c = 3.0 ;
figure ('Name' , 'Phase Space') ;

q = 0 ;
p = 1 ;
h = animatedline ;

for p = 0 : 0.25 : 7

    Q(1) = atan (2*c*q/p) ;  % atan(2cq/p)
    P(1) = (p*p + 4*c*c*q*q)/(4*c) ;
    K = 2*P(1)*c/m ;

    P_der = @(Q,P) P*cos(Q)*sin(Q)*(4*c/m - m*omega*omega/c)  ;
    Q_der = @(P) K/P ;

    time(1) = 0 ;
    h = 0.01 ;
    it = 1 ;

    for t = 0 : h : 2*pi - h 
        Q_start = Q(it) ;
        P_start = P(it) ;
        Q_end = Q_start + h*Q_der(P_start) ;
        P_end = P_start + h*P_der(Q_start , P_start) ;

        Q(it + 1) = Q(it) + h/2 * (Q_der(P_start) + Q_der(P_end)) ;
        P(it + 1) = P(it) + h/2 * (P_der(Q_start, P_start) + P_der(Q_end, P_end)) ;

        it = it + 1 ;
        time(it) = t + h ;
    end

    %addpoints (h, Q , P)
    plot (Q, P) ;
    hold on 
    xlim ([0,2*pi]) ;
    ylim([0,4]) ;
    drawnow
    
    str = "c = " + string(c) ;
    title (str);
    xlabel ('Q') ;
    ylabel ('P') ;
    grid on ;

    
end


