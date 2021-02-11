function [concord] = con_coef(dados1, dados2)
% cálculo da concordância de Lin entre dois conjuntos de dados (dados1 e dados2)

m_y1 = mean(dados1);%media
m_y2 = mean(dados2);%media

aux_S1 = 0;
aux_S2 = 0;
aux_S12 = 0;
for i = 1:length(dados1)
    aux_S1 = aux_S1 + (dados1(i)-m_y1)^2;
    aux_S2 = aux_S2 + (dados2(i)-m_y2)^2;
    aux_S12 = aux_S12 + (dados1(i)-m_y1)*(dados2(i)-m_y2);
end

S1 = aux_S1/i;
S2 = aux_S2/i;
S12 = aux_S12/i;
concord = (2*S12)/(S1+S2+(m_y1-m_y2)^2); %Concordância de Lin
end
