function imagem_das = fastdas(imagem, element_pitch, tamanho, dy,janelamento,mapa_delay)
%%%%O seguinte script calcula o atraso e soma de imagens Pulso-Eco ou Fotoacústicas adquiridas utilizando single channel.
%Autor: J. H. Uliana
%fastdas(A, pitch, N, modalidade, janelamento)
%A: imagem (fotoacústica ou Pulso-Eco)
%pitch: distancia entre cada elemento piezoeletrico do transdutor
%N: número de elementos a serem somados
%dy: resolução axial (mm)
%modalidade: PE pulso eco e PA fotoacústica
%janelamento: tipo de janela usada na apodização

elementos = size(imagem,2);     %Nx
h = size(imagem,1);             %Ny
profundidade = round(h*dy);     %Cálculo da profundidade (PA)

switch janelamento              %Janelamento da apodização
    case 'hanning'
        janela = hann(tamanho+1);
    case 'none'
        janela = ones(tamanho+1);
    case 'blackman'
        janela = blackman(tamanho+1);
    case 'gauss'
        janela = gausswin(tamanho+1);
    case 'sonix'
        janela = gausswin(tamanho+1,4);
end

%%ATRASO E SOMA
for x = 1:elementos                                                                                     %varredura nas linhas
    
    %%ZONA CENTRAL
    if (x>fix(tamanho/2)&& x+fix(tamanho/2)<elementos)                                                  %zona em que a soma e atraso não é afetada pelas bordas (esquerda e direta) da imagem
        for y = 1:h                                                                                     %varredura na profundidade
            soma_delay =0;
            for i = x-fix(tamanho/2):x+fix(tamanho/2)-1                                                 %varredura em N
                
                indice_atraso = (y+mapa_delay(y,i,x));
                if indice_atraso>h                                                                      %tratamento da borda inferior da imagem
                    soma_delay = soma_delay + 0;
                else
                    %fix(tamanho/2+1)+(i-x)
                    soma_delay = soma_delay + janela(fix(tamanho/2+1)+(i-x))*imagem(indice_atraso,i);   %soma com apodização
                end
            end
            imagem_das(y,x) = soma_delay;
        end
    else
        %%BORDA ESQUERDA
        if(x<=fix(tamanho/2)&& x+fix(tamanho/2)<=elementos)
            for y = 1:h
                soma_delay =0;
                for i = 1:(fix(tamanho/2)+x);
                    indice_atraso = fix((y+mapa_delay(y,i,x)));
                    
                    if indice_atraso>h
                        soma_delay = soma_delay + 0;
                    else
                        soma_delay = soma_delay + janela(fix(tamanho/2)-(x-i))*imagem(indice_atraso,i);
                    end
                end
                imagem_das(y,x) = soma_delay;
            end
        end
        %%BORDA DIREITA
        if(x>fix(tamanho/2)&& x+fix(tamanho/2)>=elementos)
            for y = 1:h
                soma_delay =0;
                for i = (elementos-(fix(tamanho/2)+(elementos-x))):elementos
                    
                    indice_atraso = (y+mapa_delay(y,i,x));
                    if indice_atraso>size(imagem,1)
                        soma_delay = soma_delay + 0;
                    else
                        soma_delay = soma_delay + janela((fix(tamanho/2)-(x-i))+1)*imagem(indice_atraso,i);
                    end
                end
                imagem_das(y,x) = soma_delay;
            end
        end
    end
end

end


