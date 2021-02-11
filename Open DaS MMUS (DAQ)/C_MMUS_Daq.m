clear all
close all

%% User parameters
depth = 55;           %Image depth (mm)
framerate = 2;          %Image framerate (kHz)
i_mean = true;          %Image averaging of 'i_frames' inital frames
i_frames = 10;          %number of initial frames to calculate the averaged first frame
mean_frames = false;    %mean of 2 frames along all data
remove_dc = true;       %remove constant displacement
a = 9; %Axial dimension of mask
b = 6; %Lateral dimension of mask

%% RF data processing
%Time between 2 frames
fdt = (1/framerate);%ms;

%Load data
[filename, auxpath] = uigetfile('*.mat','Load DAQ data...');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
auxload = load([auxpath filename]);
auxname = whos('-file',[auxpath filename]);
rf_DaS = auxload.(auxname.name);
rf_DaS(:,:,1)=[];
clear auxload;

%Diferentials
bdy = 0.0195;   %B-Mode axial
dx = 0.3048;    %Lateral

%Image averaging of initial frames
if (i_mean)
    Nframes = size(rf_DaS,3);
    aux = rf_DaS(1:fix(depth/bdy),:,i_frames:Nframes);
    aux(:,:,1) = mean(rf_DaS(1:fix(depth/bdy),:,1:i_frames),3);
    clear rf_DaS
    rf_DaS = aux;
end

%Dimensions
Nframes = size(rf_DaS,3);
Ny = size(rf_DaS,1);
Nx = size(rf_DaS,2);
dimx = -(Nx/2*0.3048):0.3048:(Nx/2*0.3048);
bdimy = 0:bdy:Ny*bdy;
dimx(1)=[];
bdimy(1) =[];

%Image averaging along all data
aux_a = 1;
if (mean_frames)
    %Image averaging on
    for i = 2 : 2 : Nframes-1
        rfdata{aux_a} = (rf_DaS(:,:,i)+ rf_DaS(:,:,i+1))/2;
        aux_a = aux_a+1;
    end
    fdt = fdt*2; %new image framerate
else
    %Image averaging off
    for i = 1:Nframes
        rfdata{i} = rf_DaS(:,:,i);
    end
end

%% Displacement map calculation
%Parameters
header.us.frames = size(rfdata,2);  %#frames
header.us.sf = 40000000;            %Sampling frequency (Hz)
header.mg.soundspeed = 1540;        %m.s^-1
header.mg.depth = Ny*bdy;           %mm

%Displacement map dimensions
dy = header.mg.depth/Ny; %DispMap axial
dimy = 0:dy:header.mg.depth;
dimy(1)=[];

%Region of interest
roi.xi = 1;
roi.xf = 128;
roi.yi = 1;
roi.yf = Ny;

%Processing
header.pp.dt = 1;
header.pp.inif = 1;
header.pp.endf = size(rfdata,2);
header.pp.winsize = 1.0; %mm
header.pp.overlap = 0.85;
header.pp.fftwinsize = 128;

%Pair to pair mm.s^{-1}
%base_disp = framesVelo(rfdata,header,roi);

%1 fix \mum
base_disp = framesDisp(rfdata,header,roi);


%% Median filter
process_disp = zeros(size(base_disp{1},1),size(base_disp{1},2),size(base_disp,2));
f = waitbar(0,'Median Filter...');
Disp_frames = size(base_disp,2);
Disp_Ny = size(base_disp{1},1);
Disp_Nx = size(base_disp{1},2);
for i = 1 :Disp_frames
    aux_cell{i} = filtro_mediana(base_disp{i}, a,b);
    process_disp(:,:,i) = aux_cell{i};
    waitbar(i/Disp_frames, f, 'Median Filter...');
end
close(f)

%% Remove dc
if(remove_dc)
    f = waitbar(0,'Removing DC...');
    for k = 1:Disp_frames
        for x = 1:Disp_Nx
            correc = mean(process_disp(:,x,k));
            process_disp(:,x,k) = process_disp(:,x,k)-correc;
        end
        waitbar(k/Disp_frames, f, 'Median Filter...');
    end
    close(f)
end

%% Save
save([auxpath 'process_disp.mat'],'process_disp')

%% Show video
close all
vidfile = VideoWriter([auxpath 'Displacement.mp4'],'MPEG-4');   %video file
vidfile.FrameRate = 5;                                          %video framerate
open(vidfile);
vlim1 = 0;                                                      %Inferior limit of colorbar (um)
vlim2 = 15;                                                     %Superior limit of colorbar (um)

for ind = 1:Disp_frames
    imagesc(dimx,dimy,19.5*process_disp(:,:,ind),[vlim1 vlim2]);
    set(gca,'fontsize',13)
    axis image
    xlabel('Lateral(mm)','fontsize',13)
    ylabel('Depth(mm)','fontsize',13)
    colormap jet
    g = colorbar;
    ylabel(g,'Displacement \mum')
    colormap ();
    title(sprintf('Displacement at %1.1f ms',ind*fdt));
    colormap jet
    frame = getframe(gcf);
    writeVideo(vidfile,frame);
end
close(vidfile)

%% Show displacement frames
close all
sframe = 20;     %Frame to show
slim1 = 0;      %Inferior limit of colorbar (um)
slim2 = 15;     %Superior limit of colorbar (um)
showmmus(process_disp,dimx,dimy,slim1,slim2,fdt,sframe);

%% Show B-Mode images
figure
blim1 = 2;  %Inferior limit of colorbar (a.u.)
blim2 = 10; %Superior limit of colorbar (a.u.)
imagesc(dimx,bdimy,sqrt(abs(hilbert(rf_DaS(:,:,1)))),[blim1 blim2])
axis image
colorbar()
colormap gray
