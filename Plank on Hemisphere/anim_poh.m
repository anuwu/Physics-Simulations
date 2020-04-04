g = 9.8 ;
m = input('Enter the mass of the plank\n') ;
R = input('Enter the radius of hemisphere\n') ;
l = input(['Enter the length of plank (less than ' , num2str(R*pi) , ')\n']) ;
w(1) = input('Enter the starting angular velocity (degrees per second)\n') ;
max_oscil = input(['Enter the number of oscillations the plank should perform\n']) ;

w_der = @(th , w) (-th/(th^2 + ((l/R)^2)/12)) * (w^2 + (g/R)*cos(th)) ;
th_der = @(w) w ;

time(1) = 0 ;
w(1) = w(1) * pi/180 ;
th(1) = 0 ;
pth(1) = m*((l^2)/12 + (R^2)*((th(1))^2))*w(1) ;
T(1) =  (m/2)*((l^2)/12 + (R^2)*((th(1))^2))*(w(1)^2) ;
V(1) = m*g*R*(th(1)*sin(th(1)) + cos(th(1))) ;
E(1) = T(1) + V(1) ;
h = 0.075 ;
Fs = 1/h ;
arrow_scale = 0.5 ;


tp_cond = 1 ;

plot_fig = figure('Name' , 'Plots');
phase_fig = figure('Name' , 'Phase Space') ;
energy_fig = figure ('Name' , 'Energy plot') ;

it = 1 ;
for theta = 0:(pi/100):pi
circx(it) = R*cos(theta) ;
circy(it) = R*sin(theta) ;

it = it+1 ;
end

figure ('Name' , 'Animation') ;
it = 1 ;
t = 0 ;
oscil_count = 1 ;
while oscil_count <= max_oscil 
    th_start = th(it) ;
    th_end = th(it) + h*th_der(w(it)) ;
    w_start = w(it) ;
    w_end = w(it) + h*w_der(th(it) , w(it)) ;
    mw_1 = w_der(th_start , w_start) ;
    mw_2 = w_der(th_end , w_end) ;
    mth_1 = th_der(w_start) ;
    mth_2 = th_der(w_end) ;
    
    th(it+1) = th(it) + h/2 * (mth_1 + mth_2) ;
    w(it+1) = w(it) + h/2 * (mw_1 + mw_2) ;
    
    it = it + 1 ;
    time(it) = t + h ;
    pth(it) = m*((l^2)/12 + (R^2)*((th(it))^2))*w(it) ;
    T(it) =  (m/2)*((l^2)/12 + (R^2)*((th(it))^2))*((w(it))^2) ;
    V(it) = m*g*R*(th(it)*sin(th(it)) + cos(th(it))) ;
    E(it) = T(it) + V(it) ;
    
    if tp_cond == 1 && it>2
        if th(it)>0 && th(it-1)<0
            tp = t-h ;
            tp_cond = 0 ;
            oscil_count = 2 ;
        end
    else
        if ~(tp_cond == 1) && th(it)>0 && th(it-1)<0
            oscil_count = oscil_count + 1 ;
        end
    end
    
    plankx(1) = R*sin(th(it)) + (l/2 - R*th(it))*cos(th(it)) ;
    planky(1) = R*cos(th(it)) - (l/2 - R*th(it))*sin(th(it)) ;
    
    plankx(2) = R*sin(th(it)) - (l/2 + R*th(it))*cos(th(it)) ;
    planky(2) = R*cos(th(it)) + (l/2 + R*th(it))*sin(th(it)) ;
    
    plot (circx , circy , 'k') ;
    hold on 
    plot(plankx , planky , 'r') ;
    plot(R*sin(th(it)) , R*cos(th(it)) , 'o') ;
    
    xlabel (['X Time = ' , num2str(t) , 's']) ;
    ylabel ('Y') ;
    title(['No. of oscillations = ' , num2str(oscil_count)]) ;
    hold off
    
    %xlim([-(R*pi - l/2),(R*pi - l/2)]) ;
    %ylim([-(R*pi - l/2),(R*pi - l/2)]) ;
    
    if l/2 > R
        xlim([-(l/2 + 5) , (l/2 +5)]) ;
        ylim([-(l/2 + 5) , (l/2 +5)]) ;
    else
        xlim([-(R+5) , (R+5)]) ;
        ylim([-5 , R+5]) ;
    end
    
    drawnow ;
    t = t+h ;
end


figure (plot_fig) ;
subplot (3 , 2 , 1) ;
plot(time , th*(180/pi)) ;
title('Time plot of Angle') ;
xlabel('Time') ;
ylabel('Angle (degrees)') ;
grid on ;

subplot (3 ,2 , 2) ;
plot(time , w*(180/pi)) ;
title('Time plot of Angular Velocity') ;
xlabel ('Time') ;
ylabel ('Angular Velocity (degrees per second)') ;
grid on ;

subplot (3 ,2 , 3) ;
plot(time , pth) ;
title('Time plot of Angular Momentum') ;
xlabel ('Time') ;
ylabel ('Angular Momentum') ;
grid on ;

N = m*g*cos(th) ;
subplot (3, 2 , 4) ;
plot (time , N) ;
title('Time plot of Normal Force') ;
xlabel('Time') ;
ylabel('Normal Force (Newton)') ;
grid on ;

fric = abs(m*g*sin(th)) ;
subplot (3 , 2 , 5) ;
plot(time , fric) ;
title('Time plot of Frictional Force') ;
xlabel('Time') ;
ylabel('Frictional force (Newton)') ;
grid on ;

figure (phase_fig) ;
subplot (1, 2 , 1) ;
plot(th * (180/pi) , w * (180/pi)) ;
title ('Phase Space') ;
xlabel('Angle (degrees)') ;
ylabel('Angular Velocity (degrees per second)') ;
grid on ;

subplot (1, 2 , 2) ;
plot(th * (180/pi) , pth) ;
title ('Phase Space') ;
xlabel('Angle (degrees)') ;
ylabel('Angular Momentum') ;
grid on ;

figure (energy_fig) ;
subplot (2,2,1) ;
plot (time , T) ;
title ('Kinetic Energy vs. Time') ;
xlabel ('Time') ;
ylabel ('Kinetic Energy') ;
grid on ;

subplot (2,2,2) ;
plot (time , V) ;
title ('Potential Energy vs. Time') ;
xlabel ('Time') ;
ylabel ('Potential Energy') ;
grid on ;

subplot (2,2,3) ;
plot (time , E) ;
title ('Total Energy vs. Time') ;
xlabel ('Time') ;
ylabel ('Total Energy') ;
grid on ;

nfft = length(th) ;
nfft2 = 2^nextpow2(nfft) ;
ff = fft(th , nfft2) ;
fff = ff(1:nfft2/2) ;
fff = fff/max(fff) ;
xfft = Fs*(0:nfft2/2 - 1)/nfft2 ;
figure ('Name' , 'Fourier Transform') ;
plot(xfft,abs(fff)) ;
xlabel('Frequency (Hz)') ;
ylabel('Normalised Amplitude') ;
title('Frequency Domain') ;

small_angle_period = (2*pi*l)/sqrt(12*g*R) ;
error = (tp - small_angle_period)*100/small_angle_period ;
freq = 1/tp ;

disp(['Small angle period = ' , num2str(small_angle_period) , ' seconds']) ;
disp(['The time period = ' , num2str(tp) , ' seconds']) ;
disp(['The frequency = ' , num2str(freq) , ' Hz']) ;
disp(['Error = ' , num2str(error) , '%']) ;

