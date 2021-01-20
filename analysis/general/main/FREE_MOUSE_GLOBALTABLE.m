%FREE_MOUSE_GLOBALTABLE
%Freely moving mouse (formerly Andor) project, global varriables and path 
%definitions.
%
%   See also ANA_RAT_GLOBALTABLE, ANA_MOUSE_GLOBALTABLE, 
%   OPTO_GLOBALTABLE, MODEL_GLOBALTABLE, FREE_MOUSE_STIMULATIONS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 17/11/2017

clear all
% close all

% % Add code folder to path
codepath = 'D:\MS_sync_codes';
% addpath(genpath(codepath));

global PROJECTID
PROJECTID = 'FREE_MOUSE';

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
    end
    copyfile(codepath, fullfile(RESULTDIR, 'codes'));
    
    % Directories:
    global DATADIR
    DATADIR = fullfile('D:',PROJECTID,'DATA');
    global PREPROCDIR
    PREPROCDIR = fullfile(RESULTDIR, 'PREPROC');
    
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
    
    % Theta detection:
    global HPTHBAND   % theta frequency band
    HPTHBAND = [5,10];
    global HPDEBAND   % delta frequency band
    HPDEBAND = [0.5,4];
    global TSCCGSMWINDOW
    TSCCGSMWINDOW = 3; % window for smoothing fieldData (moving average, in tsccg, sec)
    global THRATIOTHRESH
    THRATIOTHRESH = 2; % threshold for theta/delta ratio
    global DERATIOTHRESH
    DERATIOTHRESH = 2; % threshold for theta/delta ratio
    
    % MS units' rhythmicity:
    global MSTHBAND   % theta frequency band
    MSTHBAND = [5,10];
    global MSDEBAND   % delta frequency band
    MSDEBAND = [0.5,4];
    global CGWINDOW   % CGWINDOW for acg
    CGWINDOW = 3;
    global CGBINS  % binsize for acg
    CGBINS = 20;
    global BURSTWINDOW % for burstiness detection
    BURSTWINDOW = [10,30];
    
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
    %from D:\Andor\PYRAMIDAL_LAYER\FREE_MOUSE_pyramidal_layer.pptx file (Should match with the recording order!!!)
    %recordings: recordingID | delta-theta transition (sec) | pyramidal
    %layer after sorting | radiatum layer
    recordings = [201616951824, 545, 25; 201616953135 592, 25; ...%
        201617501417, 808, 10; 201617502125, 619, 10; 201617503741 748, 10; ...
        201617505054, 147, 10; 201617505862, 50, 10; ... %
%         20161865104105 2063, 21; 20161865106107 121, 21; 20161865110111 1740, 21; ...%
%         2016186945 958, 17; 201618691314 2495, 17; ... %201618692021 1020, 17; 201618693031 340, 17; ...%
        201619887778, 1726, 4; 20161988101102, 2634, 4; 20161988183184, 865, 4; ...
        20161988191192, 1014, 4; 20161988281282, 241, 4; ... %
        20161989100101, 580, 17; 20161989107108, 675, 17; 20161989113114, 2555, 17;...
        20161989119120, 897, 17; 20161989127128, 652, 17; 20161989133134, 1322, 17; ...
        20161989139140, 1151, 17; 20161989145146, 826, 17; 20161989151152, 1915, 17; ...
        20161989157158, 534, 17; 20161989163164, 1961, 17; 20161989169170, 324, 17; ...
        20161989175176, 987, 17;  20161989177178, 2077, 17];
    recordings(:,4) = recordings(:,3) + 5; %radiatum = pyramidaly layer +5 channel (~250 um)
    % CHANGE THOOSE VARRIABLES ABOVE IF YOU ADD MORE RECORDINGS
    
    save(fullfile(RESULTDIR, 'parameters'));
else
    load(fullfile(RESULTDIR, 'parameters'));
end

%%Cut out stimulations from hippocampal field and unit activities before analyzing!!!
% See FREE_MOUSE_STIMULATIONS, LOADTS
