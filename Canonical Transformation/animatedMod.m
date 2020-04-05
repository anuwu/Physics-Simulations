m = 1 ;
omega = 2 ;
c = 1.3 ;

q(1) = 0 ;
p(1) = 1 ;
Q(1) = atan (2*c*q(1)/p(1)) ;  
P(1) = (p(1)*p(1) + 4*c*c*q(1)*q(1))/(4*c) ;
K = 2*P(1)*c/m ;

p_der = @(q,p) - m*omega*omega*q ;
q_der = @(p) p/m ;
P_der = @(Q,P) P*cos(Q)*sin(Q)*(4*c/m - m*omega*omega/c)  ;
Q_der = @(P) K/P ;

subplot (2, 1 , 1) ;
axis([-2 2 -2 2]) ;
xlabel ('q') ;
ylabel ('p') ;
aline = animatedline ;
grid on ;

subplot (2, 1 , 2) ;
axis([0 2*pi 0 1]) ;
xlabel ('Q') ;
ylabel ('P') ;
bline = animatedline('Color', 'b') ;
grid on ;


it = 1 ;
time(1) = 0 ;
h = (2*pi/omega)/10^5 ;

transformedSum = 0 ;
Sum = 0 ;


for t = 0 : h : (2*pi/omega)-h
    q_start = q(it) ;
    p_start = p(it) ;
    q_end = q_start + h*q_der(p_start) ;
    p_end = p_start + h*p_der(q_start , p_start) ;
    q(it + 1) = q(it) + h/2 * (q_der(p_start) + q_der(p_end)) ;
    p(it + 1) = p(it) + h/2 * (p_der(q_start, p_start) + p_der(q_end, p_end)) ;
    
    Sum = Sum + abs(p(it+1)*(q(it+1)-q(it))) ;
    
    % ---------------------------------------------------------------------------------
    
    Q_start = Q(it) ;
    P_start = P(it) ;
    Q_end = Q_start + h * Q_der(P_start) ;
    P_end = P_start + h * P_der(Q_start , P_start) ;
    Q(it + 1) = Q(it) + h/2 * (Q_der(P_start) + Q_der(P_end)) ;
    %Q(it + 1) = Q(it + 1) - floor (Q(it+1)/(2*pi)) * 2 * pi ;
    P(it + 1) = P(it) + h/2 * (P_der(Q_start, P_start) + P_der(Q_end, P_end)) ;
    
    transformedSum = transformedSum + P(it+1)*(Q(it+1) - Q(it)) ;
    
    addpoints (aline , q(it+1), p(it+1)) ;
    addpoints (bline, Q(it+1), P(it+1)) ;
    drawnow limitrate ;
    
    it = it + 1 ;
    time(it) = t + h ;
end

display("Phase space volume in (q,p) space = " + string(Sum)) ;
display("Phase space in (Q,p) space = " + string(transformedSum)) ;

%plot (q , p) ;

