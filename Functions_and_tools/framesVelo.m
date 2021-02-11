function [velo_map, header] = framesVelo(rfdata, header, roi)
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

agonia = waitbar(0,'RAM: Taxa deslocamento - VMA Framework');


% region of interest
roi_h = roi.yi:roi.yf;
roi_w = roi.xi:roi.xf;

% parameters
fs = 40000000;
depth =  40;
soundspeed = 1540;

height = size(roi_h,2);
width = size(roi_w,2);

% frame interval
df = header.pp.dt;
f0 = header.pp.inif;
ff = header.pp.endf;

if (f0 <= 0),
    f0 = 1;
end
if (ff <= f0),
    ff = header.us.frames;
end

win_size = header.pp.winsize; % window and shift
win_overlap = header.pp.overlap;
win_shift = win_size * (1 - win_overlap);

win_size_px = fix((win_size*1e-3) * 2 * fs/soundspeed); % window and shift px
shift_px = fix((win_shift*1e-3) * 2 * fs/soundspeed);

fft_size = header.pp.fftwinsize; % size of correlation

%win = ones(1,win_size_px); % rect window
win = hanning(win_size_px); % hanning window
win_2d = repmat(win, 1, width); % 2D window

% real peak adjust
adjust_type = 'poly2';

% alocate results
%map_velo = cell(1,ff-f0-df);


%% zero correlogram to cancel dc level
[amap, dc] = framesAcorr(rfdata, header, roi);
%dc = 0;

%% Cross correlation theorem
%

% inicializaton for frame
m = 1;
f = f0;

% process
tic
while f + df <= ff,
    
    waitbar(f/ff);
    
    % inicializaton for depth
    z0 = 0;
    n = 1;
    
    % frames ensemble
    rf_0 = rfdata{f}(roi_h,roi_w);
    rf_1 = rfdata{f+df}(roi_h,roi_w);
       
    % depth discretization
    while z0 + win_size_px <= height,
        
        % time domain data
        x_0(1:win_size_px,:) = rf_0(z0+1:z0+win_size_px,:);
        x_1(1:win_size_px,:) = rf_1(z0+1:z0+win_size_px,:);
        
        % fourier Transform
        X_0 = fft(x_0 .* win_2d, fft_size);
        X_1 = fft(x_1 .* win_2d, fft_size);
        
        % normalized cross correlation
        %Rxx = real(ifft(conj(X_0).*X_1)/(norm(X_0) * norm(X_1)));
        
        % cross correlation
        Rxx = real(ifft(conj(X_0).*X_1));
        
        %  correlation maximmum
        [y, p] = max(Rxx);
        
        % position interpolation
        for j = 1:width,
            pico(n,j) = peakAdjust(Rxx(:,j),p(j),fft_size,adjust_type);
        end
        
        % step window count
        n = n + 1;
        
        % window moves down shift size
        z0 = z0 + shift_px;
        
    end
    
    f = f + df;
    
    % mm.s^{-1}
    %velo_map{m} =  (((pico/fs)*(soundspeed/2)) - dc);
    velo_map{m} = pico - dc;
    
    m = m + 1;
end
toc

close(agonia);

end


