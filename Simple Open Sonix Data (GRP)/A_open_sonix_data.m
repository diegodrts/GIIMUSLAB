close all
clear all

frame = 1; %frame to show

%% Load data
[filename, auxpath] = uigetfile('*.info','Load DAQ data...');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end

rf_data = open_images(auxpath,filename);

%dimensions
dx = 0.3048;    %Lateral
dy = 0.01925;   %Axial
dimy = 0:dy:size(rf_data,1)*dy;
dimx = -(size(rf_data,2)/2*dx):dx:(size(rf_data,2)/2*dx);


%% Show image
close all
imagesc(dimx,dimy,sqrt(abs(hilbert(rf_data(:,:,frame)))),[max(max(sqrt(abs(hilbert(rf_data(:,:,frame))))))*0.05 max(max(sqrt(abs(hilbert(rf_data(:,:,frame))))))*0.85])
axis image
colormap gray
xlabel('Lateral (mm)')
ylabel('Axial (mm)')
set(gca,'fontsize',15)