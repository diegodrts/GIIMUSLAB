clear all
close all

%% User settings
limit = 50;         %Daq noise filter threshold (a.u.)
DaS_elements = 120; %Number of elements summed in Delay and Sum operation

%% Load data
auxpath = uigetdir('','Select folder');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
load([auxpath 'DAQ_data.mat'])
load([auxpath 'DAQ_parameters.mat'])

%% Daq noise filter
daq_data = DAQnoisefilt(daq_data,limit);

%% Delay and Sum
%L14-5/38 transducer, sampling frequency = 40MHz
dx = 0.3048;    %Lateral
dy = 0.01925;   %Axial

%Delay map
PEmapa_delay = single(zeros(size(daq_data,1),size(daq_data,2),size(daq_data,2)));   %alocate delay map matrix
PEDaS = single(zeros(size(daq_data,1),size(daq_data,2),size(daq_data,3)));          %alocate reconstructed image matrix
for x = 1:size(daq_data,2)
    PEmapa_delay(:,:,x) = delay_map(size(daq_data,1), size(daq_data,2), x, 0.2285, 0.01925);
end

%Delay and sum
NPE = size(daq_data,3);
f = waitbar(0,'PE Delay and Sum reconstruction...');
esptime_coef = (0.00030254*size(daq_data,1)-0);
total_time = esptime_coef*NPE;
for i = 1:NPE
    tic
    PEDaS(:,:,i) = fastdas(daq_data(:,:,i),dx,DaS_elements,dy,'hanning', PEmapa_delay);
    
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

%% Save data
save([auxpath 'PE_das.mat'], 'PEDaS')

'DaS Images: Done'

