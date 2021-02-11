close all
clear all

%% User settings

limit = 50;         %Daq noise filter threshold (a.u.)


%B-mode images
PEimages = true; %B-mode images? yes = 'true', no = 'false'

%frames remove
n_f = 1; %remove the first n_f frames 

%Multiangle Long-Axis Illumination Photoacoustic Imaging (MaLaIPaI) parameters
mean_frames = 4; %number of frames per angle
angles = 5; %number of angles
final_frames = 5; %number of frames of the final image (summed image)

%% Loading data
auxpath = uigetdir('','Selecione a pasta');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
load([auxpath 'PA_daq_data.mat'])
PA_daq(:,:,1:n_f)=[];
if PEimages
    load([auxpath 'PE_daq_data.mat'])
    PE_daq(:,:,1:n_f)=[];
end

%% Daq noise filter
PA_daq = DAQnoisefilt(PA_daq,limit);

%% Correcting PA subframes with real time energy data
fid = fopen([auxpath 'Energy_realtime.txt']);
strings = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);
decimal_strings = regexprep(strings{1}, ',', '.');
data = cellfun(@str2num, decimal_strings, 'uni', 0);
energy_ptp = cat(1, data{:});
ne_ptp = energy_ptp/max(energy_ptp);
for i = 1:length(ne_ptp)
    PA_daq(:,:,i) = PA_daq(:,:,i)/ne_ptp(i);
end

%% Mean of PA (and PE) subframes
x1 = fix(size(PA_daq,3)/mean_frames);
PA_daq_med = single(zeros(size(PA_daq,1),size(PA_daq,2),x1));
if PEimages
    PE_daq_med = single(zeros(size(PE_daq,1),size(PE_daq,2),x1));
end
bar = waitbar(0, 'Calculating...');
aux = 1;
hue=1;
for k = 1:x1
    for i = 1:mean_frames
        PA_daq_med(:,:,k) = PA_daq_med(:,:,k) + PA_daq(:,:,i+(mean_frames*(k-1)));
        if PEimages
            PE_daq_med(:,:,k) = PE_daq_med(:,:,k) + PE_daq(:,:,i+(mean_frames*(k-1)));
        end
    end
    PA_daq_med(:,:,k) = PA_daq_med(:,:,k)/mean_frames;
    if PEimages
        PE_daq_med(:,:,k) = PE_daq_med(:,:,k)/mean_frames;
    end
    waitbar(k/x1,bar,'Calculating...');
end
close(bar);

%clear variables
clear PA_daq
if PEimages
    clear PE_daq
end

%% Sum PA (and PE) subframes
fPA_daq = double(zeros(size(PA_daq_med,1),size(PA_daq_med,2),final_frames));
if PEimages
    fPE_daq = single(zeros(size(PE_daq_med,1),size(PE_daq_med,2),final_frames));
end
for k = 1:final_frames
    for i = 0:angles-1
        fPA_daq(:,:,k) = fPA_daq(:,:,k) + PA_daq_med(:,:,(angles*(k-1)+1)+i);
        if PEimages
            fPE_daq(:,:,k) = fPE_daq(:,:,k) + PE_daq_med(:,:,(angles*(k-1)+1)+i);
        end
    end
end

%% save data
save([auxpath 'fPA_daq.mat'],'fPA_daq')
if PEimages
    save([auxpath 'fPE_daq.mat'],'fPE_daq')
end
save([auxpath 'ne_ptp.mat'], 'ne_ptp')

'Mean and Sum Done'
