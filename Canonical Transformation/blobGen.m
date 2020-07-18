function [x,y] = blobGen (mu, sigma, points)
    theta = linspace (0, 2*pi,points);
    pd = makedist('Lognormal','mu',mu,'sigma',sigma); 
    r = random(pd,points,1) ;
    r = [r(end-8:end);r;r(1:10)].' ;

    r = smoothListGaussian (r, 10) ;
    x = cos(theta) .* r ;
    y = sin(theta) .* r ;

    x(end+1) = x(1) ;
    y(end+1) = y(1) ;
    if (min(x) < 0)
        x = x - 2*min(x) ;
    end
    if (min(y) < 0)
        y = y - 2*min(y) ;
    end

    %{
    plot (x, y) ;
    xlim([-5,5]) ;
    ylim([-5,5]) ;
    %}
end