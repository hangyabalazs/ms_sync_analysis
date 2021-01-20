%ANA_MOUSE_GLOBALTABLE
%Urethane anaesthetized mouse (formerly TTKmouse) project, global varriables
%and path definitions.
%
%   See also ANA_RAT_GLOBALTABLE, FREE_MOUSE_GLOBALTABLE, 
%   OPTO_GLOBALTABLE, MODEL_GLOBALTABLE.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 16/11/2017

clear all
% close all

% % Add code folder to path
codepath = 'D:\MS_sync_codes';
% addpath(genpath(codepath));

global PROJECTID
PROJECTID = 'ANA_MOUSE';

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
    PREPROCDIR = fullfile(RESULTDIR, 'PREPROC');
    
    % Recording parameters (do not change!!!):
    global SR   % sampling rate
    SR = 20000;
    global NLINCHANNELS % number of linear channels
    NLINCHANNELS = 32;
    global NSEPTALCHANNELS % number of septal probe channels
    NSEPTALCHANNELS = 128;
    
    % Preprocess:
    global NSR  % new sampling rate
    NSR = 1000;
    
    % Theta detection:
    global HPTHBAND   % theta frequency band
    HPTHBAND = [2,4];
    global HPDEBAND   % delta frequency band
    HPDEBAND = [0.5,2];
    global TSCCGSMWINDOW
    TSCCGSMWINDOW = 5; % window for smoothing fieldData (moving average, in tsccg, sec)
    global THRATIOTHRESH
    THRATIOTHRESH = 1; % threshold for theta/delta ratio
    global DERATIOTHRESH
    DERATIOTHRESH = 1; % threshold for theta/delta ratio
    
    % MS units' rhythmicity:
    global MSTHBAND   % theta frequency band
    MSTHBAND = [2,8];
    global MSDEBAND   % delta frequency band
    MSDEBAND = [0.5,2];
    global CGWINDOW   % CGWINDOW for acg
    CGWINDOW = 3;
    global CGBINS  % binsize for acg
    CGBINS = 20;
    global BURSTWINDOW % for burstiness detection
    BURSTWINDOW = [20,50];

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
    %from D:\ANA_MOUSE\PYRAMIDAL_LAYER\TTKmouse_pyramidal_layer.pptx file (Should match with the recording order!!!)
    %recordings: recordingID | delta-theta transition (sec) | pyramidal
    %layer after sorting | radiatum layer
    recordings = [2017021623, 1660, 15; 2017021645 220, 15; 2017021667 715, 15; ...%
        2017060723, 1305, 24; 2017060745, 1300, 24; ...%
        2017060845, 314, 22; 201706086, 295, 22;...%
        2017120712, 1210, 21; 201712073, 305, 21; ...%
        2017120812, 329, 10; 201712083, 161, 10; 2017120845, 213, 10; ...%
        2018010821, 300, 10; 2018010823, 300, 10; ...%
        20180109112, 300, 23; 20180109134, 300, 23; 2018010915, 300, 23; ...%
        20180110112, 300, 10; 20180110134, 300, 10; 20180110156, 300, 10; ...%
        20180110212, 300, 13; 20180110234, 300, 13; 20180110256, 300, 13; ...
        2018011112, 344, 11; 2018011134, 355, 11; 2018011156, 310, 11; ...
        %20180112112, 300; 20180112134, 300; 20180112156, 300; ... %
        20180112212, 300, 18; 20180112234, 300, 18; 2018011225, 300, 18];
    recordings(:,4) = recordings(:,3) + 5; %radiatum = pyramidaly layer +5 channel (~250 um)
    % CHANGE THOOSE VARRIABLES ABOVE IF YOU ADD MORE RECORDINGS
    
    save(fullfile(RESULTDIR, 'parameters'));
else
    load(fullfile(RESULTDIR, 'parameters'));
end