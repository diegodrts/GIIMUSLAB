close all
clear all

frame = 2; %frame to show 

%% Load data
auxpath = uigetdir('','Select folder');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
load([auxpath 'PE_das.mat'])

%dimensions
dx = 0.3048;    %Lateral
dy = 0.01925;   %Axial
dimy = 0:dy:size(PEDaS,1)*dy;
dimx = -(size(PEDaS,2)/2*dx):dx:(size(PEDaS,2)/2*dx);


%% Show image
close all
imagesc(dimx,dimy,sqrt(abs(hilbert(PEDaS(:,:,frame)))),[max(max(sqrt(abs(hilbert(PEDaS(:,:,frame))))))*0.05 max(max(sqrt(abs(hilbert(PEDaS(:,:,frame))))))*0.85])
axis image
colormap gray
xlabel('Lateral (mm)')
ylabel('Axial (mm)')
set(gca,'fontsize',15)