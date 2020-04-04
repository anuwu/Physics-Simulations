g = 9.8 ;
m = input('Enter the mass of the plank\n') ;
R = input('Enter the radius of hemisphere\n') ;
l = input(['Enter the length of plank (less than ' , num2str(R*pi) , ')\n']) ;

w_der = @(th , w) (-th/(th^2 + ((l/R)^2)/12)) * (w^2 + (g/R)*cos(th)) ;
th_der = @(w) w ;

max_th_tip = (l/(2*R)) ;
it = 1 ;
for th=0:(l/(200*R)):max_th_tip
   anal_th(it) = th ;
   anal_wstart(it) = sqrt(24*g*R * (th*sin(th) + cos(th) - 1))/l ;
   it = it + 1 ;
end

anim = animatedline('Marker' , 'o') ;
h = 0.01 ;
w_step = 0.01 ;
w = w_step ;
cond_w = 1 ;
small_angle_period = (2*pi*l)/sqrt(12*g*R) ;
max_w = (1/l) * sqrt((24*g*R)*((l/(2*R))*sin(l/(2*R)) + cos(l/(2*R)) - 1)) ;
max_w_deg = max_w * (180/pi) ;
max_pth = m*((l^2)/12 + (R^2)*((pi/2)^2)) * max_w ;
max_pth = max_pth/2 ;
dev_w = 0 ;
dev_th = 0 ;

phase_figure_omega = figure('Name' , 'Phase Space in Generalised Velocity') ;
phase_figure_pth = figure('Name' , 'Phase Space in Canonical Momentum') ;
plot_figure = figure('Name' , 'Plots') ;

it = 1 ;
while cond_w == 1
    
    th_prev = 0 ;
    w_prev = w ;
    
    cond_tip = 1 ;
    cond_period = 1 ;
    
    w_start(it) = w ;
    th_tip(it) = 0;
    period(it) = 0;
    time = 0 ;
    
    wit = 1 ;
    th_phase(wit) = 0 ;
    w_phase(wit) = w_prev ;
    pth_phase(wit) = m*((l^2)/12 + (R^2)*((th_phase(wit))^2))*w_phase(wit) ;
    
    while cond_period == 1
        th_end = th_prev + h*th_der(w_prev) ;
        w_end = w_prev + h*w_der(th_prev , w_prev) ;
        mw_1 = w_der(th_prev , w_prev) ;
        mw_2 = w_der(th_end , w_end) ;
        mth_1 = th_der(w_prev) ;
        mth_2 = th_der(w_end) ;

        th_next = th_prev + h/2 * (mth_1 + mth_2) ;
        w_next = w_prev + h/2 * (mw_1 + mw_2) ;
        
        wit = wit+1 ;
        th_phase(wit) = th_next ;
        w_phase(wit) = w_next ;
        pth_phase(wit) = m*((l^2)/12 + (R^2)*((th_phase(wit))^2))*w_phase(wit) ;
        
        
        if cond_tip == 1
            if th_next < th_prev
                th_tip(it) = th_prev ;
                cond_tip = 0 ;
            end
        end
        
        if cond_period == 1   
            if (th_next > 0 && th_prev < 0) || th_next == 0
               period(it) = time + h/2 ;
               cond_period = 0 ; 
               
            else
                th_prev = th_next ;
                w_prev = w_next ;
                time = time + h ;
            end                   
        end
    end
   
    if th_tip(it) > max_th_tip
        cond_w = 0 ;
        w_start(end) = [] ;
        th_tip(end) = [] ;
        period(end) = [] ;
    else
        figure(phase_figure_omega) ;
        plot(th_phase * (180/pi) , w_phase * (180/pi)) ;
        xlabel ('Theta') ;
        ylabel ('Omega') ;
        title(['Starting angular velocity = ' , num2str(w*(180/pi)) , ' degrees per second']) ;
        xlim([-100,100]) ;
        ylim([-max_w_deg-10,max_w_deg+10]) ;
        grid on ;
        drawnow ;
               
               %disp([num2str(length(th_phase)) , ' ' , num2str(length(w_phase))]) ;
               
        figure(phase_figure_pth) ;
        plot(th_phase * (180/pi) , pth_phase) ;
        xlabel ('Theta') ;
        ylabel ('Angular Momentum') ;
        title(['Starting angular velocity = ' , num2str(w*(180/pi)) , ' degrees per second']) ;
        xlim([-100,100]) ;
        ylim([-max_pth , max_pth]) ;
        grid on ;
        drawnow ;
        
        it = it+1 ;
        w = w + w_step ;   
    end
end

max_w_start = w_start(end) ;

for dummy_it=1:1:length(w_start)
    dummy_w_start(dummy_it) = w_start(dummy_it) ;
    dummy_period(dummy_it) = small_angle_period ;
end


for dummy_it=1:1:length(th_tip)
    dummy_th_tip(dummy_it) = th_tip(dummy_it) ;
    dummy_period(dummy_it) = small_angle_period ;
end

for it=1:1:length(period)
    error = abs((period(it) - small_angle_period)*100/small_angle_period) ;
    if error > 5
        dev_w = w_start(it) ;
        dev_th = th_tip(it) ;
        break ;
    end
end

figure (plot_figure) ;
subplot (2,2,1) ;
%{
plot (w_start * (180/pi) , th_tip * (180/pi)) ;
title('Initial Angular Velocity vs. Tipping Angle') ;
xlabel ('Angular Velocity (Degrees per second)') ;
ylabel ('Tipping Angle (Degrees)') ;
grid on ;
%}
plot (th_tip * (180/pi) , w_start * (180/pi)) ;
title('Tipping Angle vs. Initial Angular Velocity') ;
xlabel ('Tipping Angle (Degrees)') ;
ylabel ('Angular Velocity (Degrees per second)') ;
grid on ;

subplot (2,2,3) ;
plot(anal_th *(180/pi) , anal_wstart * (180/pi)) ;
title('Tipping Angle vs. Initial Angular Velocity (Analytically Obtained)') ;
xlabel ('Tipping Angle (Degrees)') ;
ylabel ('Angular Velocity (Degrees per second)') ;
grid on ;



subplot (2,2,2) ;
plot (w_start * (180/pi) , period, dummy_w_start * (180/pi), dummy_period) ;
title ('Initial Angular Velocity vs. Time Period') ;
xlabel ('Angular Velocity (Degrees per second)') ;
ylabel ('Period (seconds)') ;
grid on ;

subplot(2,2,4) ;
plot (th_tip * (180/pi) , period, dummy_th_tip * (180/pi), dummy_period) ;
title ('Angle of Oscillation vs. Time Period') ;
xlabel ('Angle (Degrees)') ;
ylabel ('Period (seconds)') ;
grid on ;

disp(['Maximum tipping angle = ' , num2str(max_th_tip * (180/pi)) , ' degrees']) ;
disp(['Initial angular velocity required for achieiving max tipping angle = ' , num2str(max_w_start * (180/pi)) , ' degrees per second']) ;
if dev_w == 0
    disp(['The tipping angle is small enough for pure oscillations']) ;
else
    disp(['Initial angular velocity at which error in time period is 5% = ' , num2str(dev_w * (180/pi))]) ;
    disp(['Angle of oscillation at which error in time period is 5% = ' , num2str(dev_th * (180/pi))]) ;
end


