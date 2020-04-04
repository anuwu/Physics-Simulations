m = 1 ;
omega = 2 ;

p_der = @(q,p) - m*omega*omega*q ;
q_der = @(p) p/m ;

q(1) = 0 ;
p(1) = 1 ;
time(1) = 0 ;
h = 0.01 ;

it = 1 ;

for t = 0 : h : 6*pi - h 
    q_start = q(it) ;
    p_start = p(it) ;
    q_end = q_start + h*q_der(p_start) ;
    p_end = p_start + h*p_der(q_start , p_start) ;
    
    q(it + 1) = q(it) + h/2 * (q_der(p_start) + q_der(p_end)) ;
    p(it + 1) = p(it) + h/2 * (p_der(q_start, p_start) + p_der(q_end, p_end)) ;
    
    it = it + 1 ;
    time(it) = t + h ;
end

figure ('Name' , 'Phase Space') ;
hold on ;
plot (q , p) ;
xlabel ('q') ;
ylabel ('p') ;
xlim([-2,2]) ;
ylim([-2,2]) ;
grid on ;
