function [delay_map] = delay_map(N,elementos,centro,element_pitch,dy)
%%% C�lculo do mapa de atraso de um transdutor linear
%delay_map(Y, N, centro, pitch, mod).
%Y: profundidade da imagem.
%N n�mero de elementos piezoel�tricos do transdutor linear.
%centro: posi��o do elemento piezoeletrico central (elemento de interesse).
%pitch: dist�ncia em mm entre dois elementos piezoel�tricos.
%Autor: J. H. Uliana

%% Pr�-aloca��o do mapa de atraso
delay_map = zeros(N, elementos);

%% C�lculo dos atrasos
for y = 1:N                                                         %varredura na profundidade
    for x = 1:elementos                                             %varredura lateral
        distancia = sqrt((y*dy)^2 + ((centro-x)*element_pitch)^2);  %d�=y�+x�
        diferenca = distancia - y*dy;                               %deltad = d-y
        delay_map(y,x) = floor(diferenca/dy);
    end
end

end