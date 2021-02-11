close all
clear all

%% Folder path
auxpath = uigetdir('','Select folder');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end

%% Load acquisition parameters
nCh = 128;              %Number of channels
reRoute = true;         %True: transducer element (correct image), false: DAQ element
chanls = ones(1,nCh);   %What channels to read (DAQ element), for each channel set to 1
                        %if you want to read the data

parameters = textread([auxpath 'parameters.txt'],'%s','delimiter', '\n');
%Mode
para_aux = parameters{1};
idx = strfind(para_aux,' ');
mode = (para_aux(idx(1)+1:end-1));

%Depth
para_aux = parameters{2};
idx = strfind(para_aux,' ');
depth = str2num(para_aux(idx(1)+1:end-1));

%Number of frames
para_aux = parameters{4};
idx = strfind(para_aux,' ');
N = str2num(para_aux(idx(1)+1:end-1));

%Emission frequency
para_aux = parameters{6};
idx = strfind(para_aux,' ');
frequency = str2num(para_aux(idx(1)+1:end-1));

%Speed of sound
para_aux = parameters{7};
idx = strfind(para_aux,' ');
speedOfSound = str2num(para_aux(idx(1)+1:end-1));

%% Open data
%Load 2nd frame
frameN = 2;
[hdr, RFmap, N] = readDAQ(auxpath, chanls, frameN , reRoute);

%Alocate matrix
daq_data = single(zeros(size(RFmap,1),size(RFmap,2),N));

%Load daq data
f = waitbar(0,'Loading DAQ data...');
for i = 1:N
    tic
    [hdr, RFmap, N] = readDAQ(auxpath, chanls, i , reRoute);
    daq_data(:,:,i) = RFmap(:,:);
    
    %Estimated time left
    if i == 1
        est_time = toc;
    end
    auxtime = toc;
    est_time = (est_time + auxtime)/2;
    total_time = est_time*N;
    remain = total_time - i*est_time;
    minutes = fix(remain/60);
    seconds = mod(remain,60);
    if mod(i,10)==0
        waitbar(i/N, f, ['Loading DAQ data...' int2str(minutes) ' min and ' num2str(seconds,2) 's']);
    end
end
close(f)

%Clear variables
clear RFmap hdr

%% Save data as .mat
save([auxpath 'DAQ_data.mat'],'daq_data')
save([auxpath 'DAQ_parameters.mat'],'mode','depth', 'N', 'frequency','speedOfSound')

'Open DAQ data: Done'


