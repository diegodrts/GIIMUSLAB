function [coef_map, header] = framesCoef(rfdata, header, roi)
%FRAMESELASTO Mapa de deslocamento axial a partir de mapas de RF de ecos
%ultrassonicos. Baseado em correlacao cruzada unidimensional e ajuste de
%pico maximo bilinear ou polinomial de ordem 2.
%
% [map, map_0] = framesElastoSL(RFMAPS, HEADER, ROI, TYPE)
%
% See also FRAMESLOAD, FRAMESARRANGE

% Author(s): D.R.T. Sampaio
% $Revision: 1.0 $  $Date: 27-Fev-2014 17:20:04 $
% Githubbed: 11-fev-2021
%
% References:
%
%

agonia = waitbar(0,'RAM: Coeficiente de correlação - MMUS');

% region of interest
% it's possible to hardcode the boundaries of the ROI
% if it's a square-ROI, differences between the axial and lateral resolutions
% must be compensated.
roi_h = roi.yi:roi.yf; 
roi_w = roi.xi:roi.xf;

% parameters
% it's possible to hardcode the US parameters
fs         = header.us.sf;
depth      =  header.mg.depth;
soundspeed = header.mg.soundspeed;

height = size(roi_h,2);
width  = size(roi_w,2);

% frame interval
df = header.pp.dt;
f0 = header.pp.inif;
ff = header.pp.endf;

if (f0 <= 0),
    f0 = 1;
end

if (ff <= f0),
    ff = size(rfdata,2);
end

win_size    = header.pp.winsize; % window and shift
win_overlap = header.pp.overlap;
win_shift   = win_size * (1 - win_overlap);

win_size_px = fix((win_size*1e-3) * 2 * fs/soundspeed); % window and shift px
shift_px    = fix((win_shift*1e-3) * 2 * fs/soundspeed);

% inicializaton for frame
% TODO: I don't remember what is this "bound"
% may improve it (shout coding)
bound = 7; 

%% Coeffient 
%
m     = 1;
f = f0;
disp('ram')
tic
% process
while f + df <= ff,
    
    waitbar(f/ff);
    
    % inicializaton for depth
    z0 = 0;
    n = 1;
    
    % boundary
    A = zeros(length(roi_h), bound-1);
    
    % frames ensemble
    rf_0 = [A, rfdata{f0}(roi_h,roi_w), A];
    rf_1 = [A, rfdata{f+df-f0}(roi_h,roi_w), A]; 
       
    % depth discretization
    while z0 + win_size_px <= height,
        
        % time domain data
        x_0(1:win_size_px,:) = rf_0(z0+1:z0+win_size_px,:);
        x_1(1:win_size_px,:) = rf_1(z0+1:z0+win_size_px,:);
        
        for j = 1:width,
           ro_ = corrcoef(x_0(:, j:j+(bound-1)), x_1(:, j:j+(bound-1)));
           ro(n,j) = ro_(1,2);
        end
        
        % move to next window
        n = n + 1;
        
        % window moves down shift size
        z0 = z0 + shift_px;
        
    end
    
    f = f + df;
    
    % TODO: I don't remember what is this part
    % may improve it (shout coding)
    if ((m == 1)&&(f0 == 1)),
        Mro = mean(mean(ro(:,:)));
    else
        Mro = 0;
    end
    
    %coef{m} = ro(:,:) - Mro;
    coef_map{m} = (ro(:, :) - 1) * -1;
    
    m = m + 1;
end
toc
close(agonia);

end


