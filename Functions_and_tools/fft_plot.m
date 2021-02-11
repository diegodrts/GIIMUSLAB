function [P1 f] = fft_plot(data, Fs, type)

%fft_plot(data, Fs,type') calcula e mostra o gráfico do espectro de potência de um sinal unidimensional
%data: dados do sinal
%Fs: frequência de amostragem
%type: mostra o gráfico em hetz (sting: 'Hz'), quilohertz (string: 'kHz') ou megahertz (string: 'MHz')

T = 1/Fs;             % Sampling period       
L = length(data);     % Length of signal
t = (0:L-1)*T;        % Time vector
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

switch type
    case 'MHz'
        plot(f/1000000,P1)
        xlabel('f (MHz)')
        ylabel('|P1(f)|')
    case 'kHz'
        plot(f/1000,P1)
        xlabel('f (kHz)')
        ylabel('|P1(f)|')
    case 'Hz'
        plot(f,P1)
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
end
        

end
