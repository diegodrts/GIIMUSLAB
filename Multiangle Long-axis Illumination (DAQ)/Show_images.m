close all
clear all

%Load data
[filename, auxpath] = uigetfile('*.mat','Load PA data...');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
auxload = load([auxpath filename]);
auxname = whos('-file',[auxpath filename]);
PA_DaS = auxload.(auxname.name);
clear auxload;
dx = 0.3048;
dy = 0.0395;
dimx = -(size(PA_DaS,2)/2*dx):dx:(size(PA_DaS,2)/2*dx);
dimy = 0:dy:(size(PA_DaS,1)*dy);
dimy(1)=[];


%Load data
[filename, auxpath] = uigetfile('*.mat','Load PE data...');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
auxload = load([auxpath filename]);
auxname = whos('-file',[auxpath filename]);
PE_DaS = auxload.(auxname.name);
clear auxload;
bdy = 0.0395/2;
bdimy = 0:bdy:(size(PE_DaS,1)*bdy);
bdimy(1)=[];


%% Show Images
close all
h1 = subplot(1,2,1);
imagesc(dimx,dimy,sqrt(abs(hilbert(PA_DaS(:,:,1)))),[max(max(sqrt(abs(hilbert(PA_DaS(:,:,1))))))*0.12 max(max(sqrt(abs(hilbert(PA_DaS(:,:,1))))))*1]);
axis image
colormap(h1, 'hot')
xlabel('Lateral (mm)')
ylabel('Axial (mm)')
title('PA image')
set(gca,'fontsize',15)

h2 = subplot(1,2,2);
imagesc(dimx,dimy,sqrt(abs(hilbert(PE_DaS(:,:,1)))),[max(max(sqrt(abs(hilbert(PE_DaS(:,:,1))))))*0.12 max(max(sqrt(abs(hilbert(PE_DaS(:,:,1))))))*1]);
axis image
colormap gray
xlabel('Lateral (mm)')
ylabel('Axial (mm)')
title('B-Mode image')
set(gca,'fontsize',15)

