function [FilteredRFdata] = DAQnoisefilt(RFdata, limit)
% DAQnoisefilt(RFdata,limit)
% Clear horizontal and vertical noise from DAQ prebeamformed data
% RFdata = prebeamformed RF data
% limit = Threshold of noise value(a.u)

%number of points
frames = size(RFdata,3);    %frames
Ny = size(RFdata,1);        %Axial
Nx = size(RFdata,2);        %Lateral

fbar =  waitbar(0, 'Filtering...');
for i = 1:frames
    
    %horizontal noise
    for y = 1:Ny
        aux_h = 0;
        aux_h2 = 0;
        for x = 1:Nx
            if (abs(RFdata(y,x,i))<=limit)
                aux_h = aux_h + RFdata(y,x,i);
                aux_h2 = aux_h2+1;
            end
        end
        if aux_h2 >0
            h(y) = aux_h/aux_h2; %mean signal above limit
        else
            h(y) = 0;
        end
    end
    for x = 1:Nx
        RFdata(:,x,i) = RFdata(:,x,i)-h';
    end
    
    %vertical noise
    clear h
    for x = 1:Nx
        aux_h = 0;
        aux_h2 = 0;
        for y = 1:Ny
            if (abs(RFdata(y,x,i))<=limit)
                aux_h = aux_h + abs(RFdata(y,x,i));
                aux_h2 = aux_h2+1;
            end
        end
        if aux_h2 >0
            h(x) = aux_h/aux_h2;
            if h(x) == 0;
                h(x) = 1;
            end
        end
    end
    for x = 1:Nx
        RFdata(:,x,i) = RFdata(:,x,i)/(h(x));
    end
    waitbar(i/frames,fbar,'Filtering...');
end
close(fbar);

FilteredRFdata = RFdata;
end
