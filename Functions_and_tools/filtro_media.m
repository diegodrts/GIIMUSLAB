function M = filtro_media(A,a,b)
%filtro da média filtro_media(A,a,b)
%A = imagem
%a = tamanho axial da máscara (valores impares)
%b = tamanho lateral da máscara (valores impares)

%valores impares;
if mod(a,2)==0;
    a = a+1;
end
if mod(b,2)==0;
    b = b+1;
end

%% FILTRO DO MEIO DA IMAGEM
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
        sum = 0;
        for i = (x-floor(a/2)):(x+floor(a/2))
            for j = (y-floor(b/2)):(y+floor(b/2))
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/(a*b);
    end
end
%% TRATAMENTO DE BORDAS
%BORDA SUPERIOR
for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
    for x = 1:floor(a/2)
        sum = 0;
        for i = 1:(x+floor(a/2))
            for j = (y-floor(b/2)):(y+floor(b/2))
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/((floor(a/2)+x)*b);
    end
end

%BORDA INFERIOR
for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
    for x = size(A,1)-floor(a/2):size(A,1);
        sum = 0;
        for i = (x-floor(a/2)):size(A,1)
            for j = (y-floor(b/2)):(y+floor(b/2))
                sum = sum + A(i,j);
            end
            
        end
        M(x,y) = sum/((floor(a/2)+abs(size(A,1)-x+1))*b);
    end
end
%BORDA ESQUERDA
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = 1: floor(b/2);
        sum = 0;
        for i = (x-floor(a/2)):(x+floor(a/2))
            for j = 1:(y+floor(b/2))
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/(a*(floor(b/2)+y));
    end
end

%BORDA DIREITA
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = size(A,2)-floor(b/2):size(A,2);
    sum = 0;
    for i = (x-floor(a/2)):(x+floor(a/2))   
        for j = (y-floor(b/2)):size(A,2)
            sum = sum + A(i,j);
        end
    end
        M(x,y) = sum/(a*(floor(b/2)+abs(size(A,2)-y+1)));
end
end

%% TRATAMENTO DOS CANTOS 

%CANTO SUPERIOR ESQUERDO
for y =1:floor(b/2)
    for x =1:floor(a/2);
        sum = 0;
        for i = 1:(x+floor(a/2))
            for j = 1:(y+floor(b/2))
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/((floor(a/2)+x)*(floor(b/2)+y));
    end
end
%canto superior direito
for y = size(A,2)-floor(b/2):size(A,2);
    for x =1:floor(a/2);
        sum = 0;
        for i = 1:(x+floor(a/2))
            for j = y-floor(b/2):size(A,2)
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/((floor(a/2)+x)*(floor(b/2)+abs(size(A,2)-y+1)));
    end
end

%canto inferior esquerdo
for y =1:floor(b/2)
    for x = size(A,1)-floor(a/2):size(A,1)
        sum = 0;
        for i = x-floor(a/2):size(A,1)
            for j = 1:(y+floor(b/2))
                sum = sum + A(i,j);
            end
        end
        M(x,y) = sum/((floor(a/2)+abs(size(A,1)-x+1))*(floor(b/2)+y));
    end
end

%canto inferior direito
for y =size(A,2)-floor(b/2):size(A,2)
    for x = size(A,1)-floor(a/2):size(A,1)
        sum = 0;
        for i = x-floor(a/2):size(A,1)
            for j = y-floor(b/2):size(A,2)
                sum = sum + A(i,j);
            end
        end
        
        M(x,y) = sum/((floor(a/2)+abs(size(A,1)-x+1))*(floor(b/2)+abs(size(A,2)-y+1)));
    end
end
end

