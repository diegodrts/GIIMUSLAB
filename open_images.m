function [data info] = open_images(PathName,FileName)
%[FileName, PathName] = uigetfile('*.info','Information of acquisition.');
fp = fopen([PathName, FileName], 'r');

% Information header
u = ux_header();
if fp > 0
    g = double(fread(fp, length(u),'int32'));
    if length(g) < length(u), 
        error('Error'); 
    end
    
    for k = 1:(length(u)),
        info.(u{k}) = g(k); 
    end
    
end
fclose(fp); 

% Loading data of RF
fpf = fopen([PathName,FileName(1:end-4) 'raw'], 'r');
%data = cell(1, info.frames);

for i = 1:info.frames,
    if ((info.type == 0) || (info.type == 16))        
        %data{i} = fread(fp,[header.us.h header.us.w],'int16=>double');
        [frame, count] = fread(fpf, info.w * info.h, 'int16');             
        data(:,:,i) = double(reshape(frame, info.h, info.w));        
    else        
        data(:,:,i) = fread(fpf,[info.h info.w],'uchar');        
    end
end
end