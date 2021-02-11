clear all
close all

%% User settings

DaS_elements = 128; %Number of elements summed in Delay and Sum operation
%B-mode images
PEimages = true; %B-mode images? yes = 'true', no = 'false'

%desired depth
depth = 40;

%% Load data
auxpath = uigetdir('','Selecione a pasta');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
load([auxpath 'fPA_daq.mat'])
if PEimages
    load([auxpath 'fPE_daq.mat'])
end

%% Delay and Sum PA
%L14-5/38 transducer, sampling frequency = 40MHz
dx = 0.3048;
dy = 0.0395;

%delay map
mapa_delay = single(zeros(size(fPA_daq,1),size(fPA_daq,2),size(fPA_daq,2)));
DaS = single(zeros(size(fPA_daq,1),size(fPA_daq,2),size(fPA_daq,3)));
for x = 1:size(fPA_daq,2)
    mapa_delay(:,:,x) = delay_map(size(fPA_daq,1), size(fPA_daq,2), x, 0.2285, dy-0.01);
end

%delay and sum
NPA = size(fPA_daq,3);
f = waitbar(0,'Delay and Sum reconstruction...');
esptime_coef = (0.00030254*size(fPA_daq,1)-0);
total_time = esptime_coef*NPA;
for i = 1:NPA
    tic
    DaS(:,:,i) = fastdas(fPA_daq(:,:,i),0.2285,DaS_elements,dy-0.01,'hanning', mapa_delay);
    
    %time remain
    auxtime = toc;
    esptime_coef = (esptime_coef + auxtime)/2;
    total_time = esptime_coef*NPA;
    remain = total_time - i*esptime_coef;
    minutes = fix(remain/60);
    seconds = mod(remain,60);
    waitbar(i/NPA, f, ['PA Delay and Sum reconstruction...' int2str(minutes) ' min and ' num2str(seconds,2) 's']);
end
close(f)

%% Delay and Sum PE
if PEimages
    %L14-5/38 transducer, sampling frequency = 40MHz
    PEdy = dy/2;
    
    %delay map
    PEmapa_delay = single(zeros(size(fPE_daq,1),size(fPE_daq,2),size(fPE_daq,2)));
    PEDaS = single(zeros(size(fPE_daq,1),size(fPE_daq,2),size(fPE_daq,3)));
    for x = 1:size(fPA_daq,2)
        PEmapa_delay(:,:,x) = delay_map(size(fPE_daq,1), size(fPE_daq,2), x, 0.2285, 0.01925);
    end
    
    %delay and sum
    NPE = size(fPE_daq,3);
    f = waitbar(0,'PE Delay and Sum reconstruction...');
    esptime_coef = (0.00030254*size(fPE_daq,1)-0);
    total_time = esptime_coef*NPE;
    for i = 1:NPE
        tic
        PEDaS(:,:,i) = fastdas(fPE_daq(:,:,i),0.2285,DaS_elements,0.01925,'hanning', PEmapa_delay);
        
        %time remain
        auxtime = toc;
        esptime_coef = (esptime_coef + auxtime)/2;
        total_time = esptime_coef*NPE;
        remain = total_time - i*esptime_coef;
        minutes = fix(remain/60);
        seconds = mod(remain,60);
        
        waitbar(i/NPE, f, ['PE Delay and Sum reconstruction...' int2str(minutes) ' min and ' num2str(seconds,2) 's']);
    end
    close(f)
end

%% Save data
for i = 1:size(DaS,3)
    fPA_das(:,:,i) = (DaS(1:fix(depth/dy),:,i));
    if PEimages
        fPE_das(:,:,i) = (PEDaS(1:fix(depth/PEdy),:,i));
    end
end
save([auxpath 'fPA_das.mat'], 'fPA_das')
delete([auxpath 'PA_daq_data.mat'])
if PEimages
    save([auxpath 'fPE_das.mat'], 'fPE_das')
    delete([auxpath 'PE_daq_data.mat'])
end

'DaS PA Images: Done'

