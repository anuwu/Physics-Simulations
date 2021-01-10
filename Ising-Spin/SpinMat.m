%{
A = [1,2,3;4,5,6;7,8,9] ;
A 
shiftright = circshift (A , [0,1]) 
shiftleft = circshift(A , [0,-1]) 
shiftdown = circshift(A , [1,0]) 
shiftup = circshift(A , [-1,0]) 
%}

%{
J = 1 ;
K = 1 ;
T = 1 ;
T_av = 2 ;
size = 100 ;
%}

J = input('Enter the value of coupling constant J\n') ;
K = input('Enter the value of boltzmann constant K\n') ;
T_start = input('Enter the starting temperature\n') ;
T_end = input('Enter the ending temperature\n') ;
T_step = input('Enter the step of temperature\n') ;
size = input('Enter the size of the matrix\n') ;


spin = ones (size , size) ;
count = 1 ;
%rand_scale = exp(-4*J/(K*T_av)) ;
rand_scale = 1 ;

temp_it = 1 ;

for T = T_start:T_step:T_end
    m_temp(temp_it) = 0 ;
    for it = 1 : 1 : 100
        for i = 1 : 1 : size
                for j = 1 : 1 : size
                    spin(i,j) = -spin(i,j) ;
                    shiftright = circshift (spin , [0,1]) ;
                    shiftleft = circshift(spin , [0,-1]) ;
                    shiftdown = circshift(spin , [1,0]) ;  
                    shiftup = circshift(spin , [-1,0]) ;
                    del_E = -2*J*spin(i,j) * (shiftright(i,j) + shiftleft(i,j) + shiftdown(i,j) + shiftup(i,j)) ;
                    if del_E > 0
                        q = rand * rand_scale ;
                        p = exp(-del_E/(K*T)) ;
                        if p < q
                            spin(i,j) = -spin(i,j) ;
                        end
                    end

                    %string = ['count = ' , num2str(count) , ' del_E = ' , num2str(del_E) , ' p = ' , num2str(p), ' q = ' , num2str(q)] ;
                    %disp(string) ;
                    %spin
                    %count = count + 1 ;
                end
        end

         m(it) = mean(mean(spin)) ;
         iteration(it) = it ;
         if it > 90
            m_temp(temp_it) = m_temp(temp_it) + m(it) ;
         end

         %disp(['Iteration = ' , num2str(it)]) ;
         %spin 
         
     %colormap(gray)
     %imagesc(spin)
     %drawnow
     
    colormap(gray)
    imagesc(spin)
    xlabel(['T = ' , num2str(T) , 'Iteration = ' , num2str(it)]) ;
    drawnow  
         
    end
   
    %plot (iteration , m) ;
    %drawnow
   
    temp(temp_it) = T ;
    m_temp(temp_it) = m_temp(temp_it)/10 ;
    m_temp(temp_it) = m(it) ;
    temp_it = temp_it + 1 ;
end

plot (temp , m_temp) ;
beta = 0 ;
below_crit_count = 1 ;

crit_temp = input('Read the reduced temperature from the graph\n') ;
for temp_it = 1:1:length(temp)
    if temp_it > 1 & temp(temp_it) <= crit_temp
        red_temp(temp_it) = crit_temp - temp(temp_it) ;
        beta = beta + log(m_temp(temp_it)/m_temp(temp_it - 1))/log(red_temp(temp_it)/red_temp(temp_it-1)) ;
        below_crit_count = below_crit_count + 1 ;
    end
end

beta = beta/below_crit_count ;
disp(['The value of beta = ' , num2str(beta)]) ;