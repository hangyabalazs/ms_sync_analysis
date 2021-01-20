%ANA_RAT_GLOBALTABLE
%Urethane anaesthetized rat (formerly MSHCSp) project, global varriables 
%and path definitions. Creates a parameter.mat
%
%   See also ANA_MOUSE_GLOBALTABLE, FREE_MOUSE_GLOBALTABLE, 
%   OPTO_GLOBALTABLE, MODEL_GLOBALTABLE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 16/11/2017

clear all
% close all

% Add code folder to path
codepath = 'D:\MS_sync_codes';
% addpath(genpath(codepath));

global PROJECTID
PROJECTID = 'ANA_RAT';

% Directories
global ROOTDIR
ROOTDIR = fullfile('D:',PROJECTID);
% addpath(genpath(ROOTDIR));

global WORKFOLDER
WORKFOLDER = 'final_analysis';

global RESULTDIR
RESULTDIR = fullfile(ROOTDIR,'analysis',WORKFOLDER);
if ~exist(RESULTDIR,'dir')
    status = mkdir(RESULTDIR);   % create folder for this run
end
if ~exist(fullfile(RESULTDIR,'parameters.mat'))
    
    % create version backup of codes
    if ~exist(fullfile(RESULTDIR,'codes'))
        status = mkdir(fullfile(RESULTDIR,'codes'));
        copyfile(codepath, fullfile(RESULTDIR, 'codes'));
    end
    
    % Directories:
    global DATADIR
    DATADIR = fullfile('D:',PROJECTID,'DATA');
    global PREPROCDIR
    PREPROCDIR = fullfile(RESULTDIR,'PREPROC');
    
    % Recording parameters (do not change!!!):
    global SR   % sampling rate
    SR = 20000;
    global NLINCHANNELS % number of linear channels
    NLINCHANNELS = 32;
    global NSEPTALCHANNELS % number of septal probe channels
    NSEPTALCHANNELS = 32;
    
    % Preprocess:
    global NSR  % new sampling rate
    NSR = 1000;
    
    %Theta detection:
    global HPTHBAND   % theta frequency band
    HPTHBAND = [3, 8];
    global HPDEBAND   % delta frequency band
    HPDEBAND = [0.5, 2.5];
    global TSCCGSMWINDOW
    TSCCGSMWINDOW = 5; % window for smoothing fieldData (moving average, in tsccg, sec)
    global THRATIOTHRESH
    THRATIOTHRESH = 1; % threshold for theta/delta ratio
    global DERATIOTHRESH
    DERATIOTHRESH = 1; % threshold for theta/delta ratio
    
    % MS units' rhythmicity:
    global MSTHBAND   % theta frequency band
    MSTHBAND = [3, 8];
    global MSDEBAND   % delta frequency band
    MSDEBAND = [0.5, 2.5];
    global CGWINDOW   % CGWINDOW for acg
    CGWINDOW = 3;
    global CGBINS  % binsize for acg
    CGBINS = 20;
    global BURSTWINDOW % for burstiness detection
    BURSTWINDOW = [20,40];
    
    % Significance test (rhythmicity thresholding):
    global SIGNIFLEVEL
    SIGNIFLEVEL = 5; % significance level, in percent
    global THSUMACGTRESH
    THSUMACGTRESH = NSR * CGWINDOW * 4; % integral threshold
    global DESUMACGTRESH
    DESUMACGTRESH = NSR * CGWINDOW * 4; % integral threshold
    
    % Phase preference
    global PHASEHISTEDGES % phase histogram edges
    PHASEHISTEDGES = -pi:(2*pi/18):pi;
    
    activeRecIds = collect_active_recordings();
    %from D:\ANA_RAT\PYRAMIDAL_LAYER\MSHCSp_pyramidal_layer.pptx file (Should match with the recording order!!!)
    %recordings: recordingID | delta-theta transition (sec) | pyramidal
    %layer after sorting | radiatum layer
    recordings = [201003041, 1964, 17; 201003042, 685, 17; 201003043, 364, 17; ...%
        201003171, 2597, 21; 201003172, 1485, 21; 201003173, 1630, 21; 201003174, 1039, 21; ...%
        201003291, 1520.5, 22; 201003292, 501, 22; 201003293, 442.5, 22; 201003294, 357, 22; ...%
        201006021, 1062, 32; 201006022, 1105.5, 32; 201006023, 882, 32; ....
        201006024, 792.5, 32; 201006025, 298.8, 32; 201006026 741.1, 32; ...
        201006027 543, 32; 201006028 276, 32; 201006029 581.2, 32; 2010060210 100.5, 32; ...%
        201006161, 233, 25; 201006162, 1040, 25; 201006163, 992.5, 25; ...
        201006164, 946, 25; 201006165 1057, 25; 201006166 1299.5, 25; ...
        201006167 871, 25; 201006168 732.5, 25; 201006169 838, 25; 2010061610 758.5, 25; ...%
        201007281, 1255, 32; 201007282, 803, 32; 201007283, 1290, 32; ...
        201007284, 1236.7, 32; 201007285, 1138, 32; 201007286, 883.5, 32; ...
        201007287, 578.5, 32; 201007288, 938, 32; 201007289, 772.5, 32; 2010072810 878, 32; ...%
        201008051, 830.7, 32; 201008052, 607.5, 32; 201008053, 607, 32; ...
        201008054, 607.5, 32; 201008055 567, 32; 201008056 647, 32]; %delta-theta transitions in sec
    recordings(:,4) = recordings(:,3) - 8; %radiatum = pyramidaly layer -8 channel (~400 um)
    % CHANGE THOOSE VARRIABLES ABOVE IF YOU ADD MORE RECORDINGS
    
    save(fullfile(RESULTDIR, 'parameters'));
else
    load(fullfile(RESULTDIR, 'parameters'));
end
