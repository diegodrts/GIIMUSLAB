function peak = peakAdjust(Rxx, x0, N, type)

% 3 points
if (x0 == 1),
    xm = N;
    xp = x0 + 1;
    
elseif (x0 == N),
    xm = x0 - 1;
    xp = 1;
    
else
    xm = x0 - 1;
    xp = x0 + 1;
    
end


switch type
    case 'poly2'      
        
        a = 2*(2*Rxx(x0) - Rxx(xp) - Rxx(xm));
        b = Rxx(xp) - Rxx(xm);
        
        if (a == 0)
           delta = 0;
        else
           delta = b/a;
        end
        
        if (x0 > N/2)
           x0 = x0 - N;
        end
       
        peak = x0 + delta;
        
    
    case 'cos'
        
        w_0 = acos((Rxx(x0) + Rxx(xp)) / (2*Rxx(x0)));
        arg_0 = atan( (Rxx(x0)-Rxx(xm))/(2*Rxx(x0)*sin(w_0)));
        
        delta = arg_0/w_0;
        
        if (x0 > N/2)
            x0 = x0 - N;
        end
        
        peak = x0 + delta;
        
        
    otherwise
        warning('Não implementado!');
        
end