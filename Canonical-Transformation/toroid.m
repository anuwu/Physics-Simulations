% Hamiltonian flow on the toroidal surface. Credits to Sathyanarayan Rao
% for the codes to the toroid plot. 
% Link at https://in.mathworks.com/matlabcentral/fileexchange/46444-visualizing-a-toroidal-surface-torus-in-matlab

clc ;
close all ;
clear all ;

R=5;
r=1;
u=linspace(0,2*pi,100);
v=linspace(0,2*pi,100);

[u,v]=meshgrid(u,v);

x=(R+r*cos(v)).*cos(u);
y=(R+r*cos(v)).*sin(u);
z=r*sin(v);

gcf = figure(1) ;
set(gcf,'position',[400,0,700,700]) ;
set (gcf, 'KeyPressFcn', @myKeyPressFcn) ;
global KEY_IS_PRESSED ;
KEY_IS_PRESSED = 0 ;

mesh(x,y,z);
hold on ;
wR = 1 ;
wr = pi ;

c = ['b', 'k', 'r', 'g', 'c', 'm'] ;
cit = 1 ;
%c = [0,0,0];
it = 1 ;
dt = (2*pi)/100 ;
t = 0 ;

display (c(it)) ;
while ~KEY_IS_PRESSED 
    xline(it) = (R+r*cos(wr*t))*cos(wR*t-pi) ;
    yline(it) = (R+r*cos(wr*t))*sin(wR*t-pi) ;
    zline(it) = r*sin(wr*t) ;
    if (length(xline) >= 2)
        if (mod(it,100) == 0)
            cit = mod(cit + 1, 6) + 1 ;
            %display(c(cit));
        end
        plot3(xline(end-1:end), yline(end-1:end), zline(end-1:end) , 'Color' , c(cit)) ;
    end

    view([-52,64]) ;
    axis([-7 7 -7 7 -2 2]) ;
    h=gca; 
    get(h,'FontSize') ;
    set(h,'FontSize',14) ;
    xlabel('X','fontSize',14);
    ylabel('Y','fontSize',14);
    zlabel('Z','fontsize',14);
    title('Press any key to exit','fontsize',14)
    fh = figure(1);
    set(fh, 'color', 'white'); 
    drawnow ;

    t = t + dt ;
    it = it + 1 ;
end

function myKeyPressFcn(hObject, event)
    global KEY_IS_PRESSED ;
    KEY_IS_PRESSED  = 1 ;
    display('Done with torus. Thank you') ;
end



%-------------------------------------------------------------------------
