function hdr = ux_header()
% data type - data types can also be determined by file extensions
hdr{1} = 'type';
% number of frames in file
hdr{2} = 'frames';	
% width - number of vectors for raw data, image width for processed data    
hdr{3} = 'w';
% height - number of samples for raw data, image height for processed data
hdr{4} = 'h';
% data sample size in bits    
hdr{5} = 'ss';
% roi - upper left (x)
hdr{6} = 'ulx';
% roi - upper left (y)
hdr{7} = 'uly';
% roi - upper right (x)
hdr{8} = 'urx';
% roi - upper right (y)
hdr{9} = 'ury';
% roi - bottom right (x)
hdr{10} = 'brx';
% roi - bottom right (y)
hdr{11} = 'bry';
% roi - bottom left (x)
hdr{12} = 'blx';
% roi - bottom left (y)
hdr{13} = 'bly';
% probe identifier - additional probe information can be found using this id
hdr{14} = 'probe';
% transmit frequency
hdr{15} = 'txf';
% sampling frequency
hdr{16} = 'sf';    
% data rate - frame rate or pulse repetition period in Doppler modes
hdr{17} = 'dr';
% line density - can be used to calculate element spacing if pitch and native # elements is known
hdr{18} = 'ld';
% extra information - ensemble for color RF
hdr{19} = 'extra';
