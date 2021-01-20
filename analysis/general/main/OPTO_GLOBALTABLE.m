%OPTO_GLOBALTABLE
%Urethane anaesthetized, opto-tagged mouse project, global varriables 
%and path definitions.
%
%   See also ANA_RAT_GLOBALTABLE, ANA_MOUSE_GLOBALTABLE, 
%   FREE_MOUSE_GLOBALTABLE, MODEL_GLOBALTABLE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 13/09/2018

clear all
% close all

% % Add code folder to path
codepath = 'D:\MS_sync_codes';
% addpath(genpath(codepath));

global PROJECTID
PROJECTID = 'OPTOTAGGING';

% Directories
global ROOTDIR
% ROOTDIR = fullfile('L:\Barni\septo_hippo_project',PROJECTID);
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
    
    
    global DATADIR
    DATADIR = fullfile('D:',PROJECTID,'DATA');
    global PREPROCDIR
    PREPROCDIR = fullfile(RESULTDIR, 'PREPROC');
    global CELLBASEDIR
    CELLBASEDIR = fullfile(ROOTDIR, 'cellbase_opto');
    
    % Recording parameters (do not change!!!):
    global SR   % sampling rate
    SR = 30000;
    global NLINCHANNELS % number of linear channels
    NLINCHANNELS = 32;
    global NSEPTALCHANNELS % number of septal probe channels
    NSEPTALCHANNELS = [32,64];
    
    % Preprocess:
    global NSR  % new sampling rate
    NSR = 1000;
    
    % Theta detection:
    global HPTHBAND   % theta frequency band
    HPTHBAND = [1.5,4];
    global HPDEBAND   % delta frequency band
    HPDEBAND = [0.5,1.5];
    global TSCCGSMWINDOW
    TSCCGSMWINDOW = 5; % window for smoothing fieldData (moving average, in tsccg, sec)
    global THRATIOTHRESH
    THRATIOTHRESH = 1.5; % threshold for theta/delta ratio
    global DERATIOTHRESH
    DERATIOTHRESH = 1.5; % threshold for theta/delta ratio
    
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
    %from D:\OPTOTAGGING\PYRAMIDAL_LAYER\OPTO_pyramidal_layer.pptx file (Should match with the recording order!!!)
    %recordings: recordingID | delta-theta transition (sec) | pyramidal
    %layer after sorting | radiatum layer
    recordings = [201808141, 420, 18; 201808142, 290, 18; 201808143, 300, 18; 201808144, 420, 18; ... %
        201808211, 300, 8; 201808212, 300, 8; 201808213, 420, 8; 201808214, 415, 8; 201808215, 300, 8; ...
        201808216, 310, 8; 201808217, 430, 8; 201808218, 420, 8; 201808219, 310, 8; ... %
        201808221, 410, 14; 201808222, 420, 14; 201808223, 410, 14; 201808224, 410, 14; ...
        201808225, 550, 14; 201808226, 420, 14; 201808227, 300, 14;... %
        201808291, NaN, 0; 201808292, NaN, 0; ... %
        201809061, 300, 1; 201809062, 310, 1; 201809063, 300, 1; 201809064, 300, 1; 201809065, 280, 1; ...
        201809066, NaN, 1; 201809067, 290, 1; 201809068, 540, 1; 201809069, 280, 1; ... %
        201809131, 60, 17; 201809132, NaN, 17; 201809133, NaN, 17; 201809134, NaN, 17; ... %
        201810041, NaN, 12; 201810042, NaN, 12; ... %
        201810111, NaN, 15; 201810112, NaN, 15; 201810113, NaN, 15; ...
        201810114, NaN, 15; 201810115, NaN, 15; 201810116, NaN, 15; ... %
        201902121, NaN, 6; 201902122, NaN, 6; 201902123, NaN, 6; 201902124, NaN, 6; ...
        201902125, NaN, 6; 201902126, NaN, 6; 201902127, NaN, 6; ... %
        201905101, NaN, 6; 201905102, 310, 6; 201905103, NaN, 6; 201905104, NaN, 6; ...
        201905105, NaN, 6; 201905106, 280, 6; 201905107, 570, 6; ... %
        201905121, 290, 18; 201905122, 290, 18; 201905123, 290, 18; 201905124, 290, 18; ...
        201905125, 300, 18; 201905126, 300, 18; 201905127, 290, 18; 201905128, 290, 18; ... %
        201905181, NaN, 15; 201905182, NaN, 15; 201905183, NaN, 15; 201905184, NaN, 15; ...
        201905185, NaN, 15; 201905186, NaN, 15; 201905187, NaN, 15; ... %
        201905261, NaN, 5; 201905262, NaN, 5; 201905263, NaN, 5; 201905264, NaN, 5; 201905265, NaN, 5; ... %
        201905311, NaN, 15; 201905312, NaN, 15; 201905313, NaN, 15; ...
        201905314, NaN, 15; 201905315, NaN, 15; 201905316, NaN, 15; ... %
        201907211, NaN, 9; 201907212, NaN, 9; 201907213, NaN, 9; ... 
        201907214, NaN, 9; 201907215, NaN, 9; 201907216, NaN, 9; ... %
        201909111, 290, 18; 201909112, 290, 18; 201909113, 290, 18; ... %
        201909251, NaN, 17; ... %
        201910141, 530, 13; 201910142, 290, 13; 201910143, 410, 13; 201910144, 260, 13; 201910145, 230, 13; ... %
        201910161, NaN, 14; 201910162, NaN, 14; ... %
        201910181, 300, 16; 201910182, NaN, 16; 201910183, NaN, 16; 201910184, 410, 16; 201910185, 300, 16; ... %
        201910221, NaN, 19; 201910222, NaN, 19; 201910223, 300, 19; 201910224, NaN, 19; 201910225, NaN, 19]; %
    recordings(:,4) = recordings(:,3) + 5; %radiatum = pyramidaly layer +5 channel (~250 um)
    % CHANGE THOOSE VARRIABLES ABOVE IF YOU ADD MORE RECORDINGS
    recOptoType = {'20180814', 'PVR01'; '20180821', 'PVR02'; '20180822', 'PVR03'; '20180829', 'VGA01'; ...
        '20180906', 'VGL01'; '20180913', 'VGL02'; '20181004', 'CHT01'; '20181011', 'PVR04'; ...
        '20190212', 'CHT02'; '20190510', 'VGL03'; '20190512', 'VGA02'; '20190518', 'VGL04'; ...
        '20190526', 'VGL05'; '20190531', 'VGA03'; '20190721', 'CHT03'; '20190911', 'CHT04'; ...
        '20190925', 'CHT05'; '20191014', 'CHT06'; '20191016', 'CHT07'; '20191018', 'CHT08'; ...
        '20191022', 'VGA04'};
    
    save(fullfile(RESULTDIR, 'parameters'));
else
    load(fullfile(RESULTDIR, 'parameters'));
end
