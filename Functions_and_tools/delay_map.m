function [delay_map] = delay_map(N,elementos,centro,element_pitch,dy)
%%% Cálculo do mapa de atraso de um transdutor linear
%delay_map(N, centro, pitch, dy).
%N: profundidade da imagem em numero de pontos.
%elementos: número de elementos piezoelétricos do transdutor linear.
%centro: posição do elemento piezoeletrico central (elemento de interesse).
%element_pitch: distância em mm entre dois elementos piezoelétricos.
%dy: distância axial entre dois pontos da imagem
%Autor: J. H. Uliana

%% Pré-alocação do mapa de atraso
delay_map = zeros(N, elementos);

%% Cálculo dos atrasos
for y = 1:N                                                         %varredura na profundidade
    for x = 1:elementos                                             %varredura lateral
        distancia = sqrt((y*dy)^2 + ((centro-x)*element_pitch)^2);  %d²=y²+x²
        diferenca = distancia - y*dy;                               %deltad = d-y
        delay_map(y,x) = floor(diferenca/dy);
    end
end

end
