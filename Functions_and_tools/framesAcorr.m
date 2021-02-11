function [amap, dc] = framesAcorr(rfdata, header, roi)
%FRAMESELASTO Mapa de deslocamento axial a partir de mapas de RF de ecos
%ultrassonicos. Baseado em correlacao cruzada unidimensional e ajuste de
%pico maximo bilinear ou polinomial de ordem 2.
%
% [map, map_0] = framesElastoSL(RFMAPS,HEADER,ROI,TYPE)
%
% See also FRAMESLOAD, FRAMESARRANGE

% Author(s): D.R.T. Sampaio
% $Revision: 1.0 $  $Date: 27-Fev-2014 17:20:04 $
%
% References:
%
%

agonia = waitbar(0,'RAM: Mapa de autocorrelação (1D) - VMA Framework');


% region of interest
roi_h = roi.yi:roi.yf;
roi_w = roi.xi:roi.xf;

% parameters
fs = header.us.sf/2;
soundspeed = header.mg.soundspeed;

height = size(roi_h,2);
width = size(roi_w,2);

% window and shift
win_size = header.pp.winsize;
win_overlap = header.pp.overlap;
win_shift = win_size * (1 - win_overlap);

win_size_px = fix((win_size*1e-3) * 2 * fs/soundspeed);
shift_px = fix((win_shift*1e-3) * 2 * fs/soundspeed);

fft_size = header.pp.fftwinsize;
fft_mdz = 10;

% rect window
%win = ones(1,win_size_px);
% hanning window
win = hanning(win_size_px);

% 2d window replication
win_2d = repmat(win, 1, width);

% real peak adjust
adjust_type = 'poly2';

% alocate results
amap = cell(1,1);

%% Autocorr DC

% ROI for correlation
rf_0 = rfdata{1}(roi_h,roi_w);
rf_1 = rf_0;

% init variables
z0 = 0;
n = 1;

while z0 + win_size_px <= height,
    
    % time domain data
    x_0(1:win_size_px,:) = rf_0(z0+1:z0+win_size_px,:);
    x_1(1:win_size_px,:) = rf_1(z0+1:z0+win_size_px,:);
    
    % fourier Transform
    X_0 = fft(x_0 .* win_2d, fft_size);
    X_1 = fft(x_1 .* win_2d, fft_size);
    
    % normalized cross correlation
    %Rxx = real(ifft(X_0.*conj(X_1))/(norm(X_0) * norm(X_1)));
    
    % cross correlation
    Rxx = real(ifft(X_0.*conj(X_1)));
    %Rxx = fftshift(Rxx);
    
    %  correlation maximmum
    [y, p] = max(Rxx);
    
    % position using using interpolation
    for i = 1:width,
        pico(n,i) = peakAdjust(Rxx(:,i),p(i),fft_size,adjust_type);
    end
    
    % step window count
    n = n + 1;
    
    % window moves down shift size
    z0 = z0 + shift_px;
end

%amap{1} = (pico/fs)*(soundspeed/2);
amap{1} = pico;

dc = mean(mean(amap{1}));

close(agonia);
