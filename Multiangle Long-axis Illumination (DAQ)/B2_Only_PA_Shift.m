clear all
close all

%% User settings
shift = 95; %shift of PA image

%% Load data
auxpath = uigetdir('','Selecione a pasta');
if (auxpath(end) ~= '\')
    auxpath = [auxpath,'\'];
end
load([auxpath 'DAQ_data.mat'])
load([auxpath 'DAQ_parameters.mat'])

%% Apply PA shift
NFrames = size(daq_data,3);
aux = 1;
PA_daq = single(zeros(fix(size(daq_data,1)),fix(size(daq_data,2)),NFrames));
bar = waitbar(0, 'Applying shift...');
for i=1:NFrames
    if (shift <0)
        PA_daq(1:fix(size(daq_data,1)+shift),:,i) = daq_data((abs(shift)+1):end,:,i);
    else
        PA_daq((shift+1):end,:,i) = daq_data((1:fix(size(daq_data,1))-shift),:,i);
    end
    PA_daq(1:shift+100,:,i)=0;
    aux = aux+1;
    waitbar(i/NFrames,bar,'Applying shift...')
end
close(bar)

%clear variables
clear daq_data

%% save data
save([auxpath 'PA_daq_data.mat'], 'PA_daq')
clear PA_daq
delete([auxpath 'DAQ_data.mat'])

'Shift Done'
