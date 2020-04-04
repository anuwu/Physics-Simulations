g = 9.8 ;
R = input('Enter the radius of hemisphere\n') ;
h = 0.01 ;
w_step = 0.001 ;

anim = animatedline ('Marker' , 'o') ;

it = 1 ;
for l=(R*pi/200):(R*pi/200):(R*pi)  
    length(it) = l ;
    w_analstart(it) = (1/l) * sqrt((24*g*R)*((l/(2*R))*sin(l/(2*R)) + cos(l/(2*R)) - 1)) ;
    small_period(it) = (2*pi*l)/sqrt(12*g*R) ;
    dev_th(it) = 0 ;
    dev_w(it) = 0 ;
    dev_tp(it) = 0 ;

    w_der = @(th , w) (-th/(th^2 + ((l/R)^2)/12)) * (w^2 + (g/R)*cos(th)) ;
    th_der = @(w) w ;
    max_th_tip = (l/(2*R)) ;

    w = w_step ;
    cond_w = 1 ;
    cond_dev = 1 ;

    while cond_w == 1
        th_prev = 0 ;
        w_prev = w ;

        cond_tip = 1 ;
        cond_period = 1 ;
        time = 0 ;

        while cond_period == 1
            th_end = th_prev + h*th_der(w_prev) ;
            w_end = w_prev + h*w_der(th_prev , w_prev) ;
            mw_1 = w_der(th_prev , w_prev) ;
            mw_2 = w_der(th_end , w_end) ;
            mth_1 = th_der(w_prev) ;
            mth_2 = th_der(w_end) ;

            th_next = th_prev + h/2 * (mth_1 + mth_2) ;
            w_next = w_prev + h/2 * (mw_1 + mw_2) ;

            if cond_tip == 1
                if th_next < th_prev
                    tipping_angle = th_prev ;
                    cond_tip = 0 ;
                end
            end

            if cond_period == 1   
                if (th_next > 0 && th_prev < 0) || th_next == 0
                   tp = time + h/2 ;
                   cond_period = 0 ; 
                else
                    th_prev = th_next ;
                    w_prev = w_next ;
                    time = time + h ;
                end            
            end
        end

        if cond_dev == 1
            error = abs((tp-small_period(it))/small_period(it)*100) ;
            if error > 5
                dev_th(it) = tipping_angle ;
                dev_w(it) = w ;
                dev_tp(it) = tp ;
                cond_dev = 0 ;
            end
        end
        
        if tipping_angle > max_th_tip
            w_start(it) = w - w_step ;
            period_max(it) = tp ;
            cond_w = 0 ;
        else
            w = w + w_step ;   
        end
    end
     
    addpoints (anim , length(it) , w_start(it) * (180/pi)) ;
    xlabel ('Length') ;
    ylabel ('Angular velocity (degrees per second)') ;
    drawnow
    it = it + 1 ;
end

subplot (3,2,1) ;
plot (length , w_start * (180/pi) , length , w_analstart * (180/pi)) ;
title('Length of rod vs. Maximum starting angular velocity') ;
xlabel ('Length') ;
ylabel ('Angular velocity (degrees per second)') ;
grid on ;


subplot (3,2,2) ;
plot (length , period_max) ;
title('Length of rod vs. Time Period at maximum angular velocity') ;
xlabel ('Length') ;
ylabel ('Time (seconds)') ;
grid on ;


subplot (3,2,3) ;
plot (length , small_period, length , dev_tp) ;
title('Length of rod vs. Oscillation period') ;
xlabel ('Length') ;
ylabel ('Time (seconds)') ;
grid on ;

subplot (3,2,4) ;
plot (length , dev_th * (180/pi)) ;
title('Length of rod vs. Oscillation angle at which deviation kicks in') ;
xlabel ('Length') ;
ylabel ('Angle (degrees)') ;
grid on ;

subplot (3,2,5) ;
plot (length , dev_w * (180/pi)) ;
title('Length of rod vs. Initial angular velocity at which deviation kicks in') ;
xlabel ('Length') ;
ylabel ('Angle (degrees)') ;
grid on ;