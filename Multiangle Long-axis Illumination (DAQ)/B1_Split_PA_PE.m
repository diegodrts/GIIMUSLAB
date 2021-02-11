clear all
close all

%% User settings
shift = 95; %Shift of PA image

%% Load data
auxpath = uigetdir('','Selecione a pasta');
if (auxpath(end) ~= '\') 
    auxpath = [auxpath,'\']; 
end
load([auxpath 'DAQ_data.mat'])
load([auxpath 'DAQ_parameters.mat'])

%% Split PA/PE and apply PA shift
NFrames = size(daq_data,3)-2;
aux = 1;
PA_daq = single(zeros(fix(size(daq_data,1)/2),128,fix(NFrames/2)));
PE_daq = single(zeros(size(daq_data,1),128,fix(NFrames/2)));
bar = waitbar(0, 'Spliting...');
for i=3:2:size(daq_data,3)-(size(daq_data,3)-NFrames)
    if (shift <0)
        PA_daq(1:end,:,aux) = daq_data((abs(shift)+1:abs(shift)+fix(size(daq_data,1)/2)),:,i); 
    else
        PA_daq((shift+1):end,:,aux) = daq_data((1:fix(size(daq_data,1)/2)-shift),:,i);
    end
    PE_daq(:,:,aux) = daq_data(:,:,(i+1));
    PA_daq(1:shift+100,:,aux)=0;
    aux = aux+1;
    waitbar(i/NFrames,bar,'Spliting...')
end
close(bar)

%Clear variables
clear daq_data

%% Save data
save([auxpath 'PA_daq_data.mat'], 'PA_daq')
clear PA_daq
save([auxpath 'PE_daq_data.mat'] ,'PE_daq')
clear PE_daq
delete([auxpath 'DAQ_data.mat'])
'Split Done'
