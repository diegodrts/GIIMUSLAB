function M = filtro_mediana(A,a,b)
%filtro da mediana filtro_mediana(A,a,b)
%A = imagem
%a = tamanho axial da máscara (valores impares)
%b = tamanho lateral da máscara (valores impares)

if mod(a,2)==0;
    a = a+1;
end
if mod(b,2)==0;
    b = b+1;
end

%% FILTRO DO MEIO DA IMAGEM
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
        k = 1;
        for i = (x-floor(a/2)):(x+floor(a/2))
            for j = (y-floor(b/2)):(y+floor(b/2))
                v(k)= A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end
%% TRATAMENTO DE BORDAS
%BORDA SUPERIOR
for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
    for x = 1:floor(a/2)
        k = 1;
        for i = 1:(x+floor(a/2))
            for j = (y-floor(b/2)):(y+floor(b/2))
                v(k) = A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end

%BORDA INFERIOR
for y = floor(b/2)+1:size(A,2)-(floor(b/2)+1)
    for x = size(A,1)-floor(a/2):size(A,1);
        k = 1;
        for i = (x-floor(a/2)):size(A,1)
            for j = (y-floor(b/2)):(y+floor(b/2))
                v(k) = A(i,j);
                k = k+1;
            end
            
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end
%BORDA ESQUERDA
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = 1: floor(b/2);
        k = 1;
        for i = (x-floor(a/2)):(x+floor(a/2))
            for j = 1:(y+floor(b/2))
                v(k) = A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end

%BORDA DIREITA
for x = floor(a/2)+1:size(A,1)-(floor(a/2)+1)
    for y = size(A,2)-floor(b/2):size(A,2);
    k = 1;
    for i = (x-floor(a/2)):(x+floor(a/2))   
        for j = (y-floor(b/2)):size(A,2)
            v(k) = A(i,j);
            k = k+1;
        end
    end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
end
end

%% TRATAMENTO DOS CANTOS 

%CANTO SUPERIOR ESQUERDO
for y =1:floor(b/2)
    for x =1:floor(a/2);
        k = 1;
        for i = 1:(x+floor(a/2))
            for j = 1:(y+floor(b/2))
                v(k) = A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end
%canto superior direito
for y = size(A,2)-floor(b/2):size(A,2);
    for x =1:floor(a/2);
        k = 1;
        for i = 1:(x+floor(a/2))
            for j = y-floor(b/2):size(A,2)
                v(k) = A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end

%canto inferior esquerdo
for y =1:floor(b/2)
    for x = size(A,1)-floor(a/2):size(A,1)
        k = 1;
        for i = x-floor(a/2):size(A,1)
            for j = 1:(y+floor(b/2))
                v(k) = A(i,j);
                k = k+1;
            end
        end
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end

%canto inferior direito
for y =size(A,2)-floor(b/2):size(A,2)
    for x = size(A,1)-floor(a/2):size(A,1)
        k = 1;
        for i = x-floor(a/2):size(A,1)
            for j = y-floor(b/2):size(A,2)
                v(k) = A(i,j);
                k = k+1;
            end
        end
        
        v = sort(v,'ascend');
        M(x,y) = v(floor(length(v)/2));
    end
end
end

