%MODELGLOBALTABLE_PAR
%Modeling project parameter space (VARIED: connection rate, synaptic weight, 
%baseline tonic excitation; FIXED: excitation variance, synaptic delay, 
%synaptic decay) global varriables and path definitions.
%
%   See also MODEL_GLOBALTABLE, MODELGLOBALTABLE_DELAY, MODEL_GLOBALTABLE_VAR.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 29/10/2020

clear all
% close all

% % Add code folder to path
codepath = 'C:\Users\Barni\Documents\MSsync_codes';
% addpath(genpath(codepath));

global PROJECTID
PROJECTID = 'MODEL';

% Directories
global ROOTDIR
ROOTDIR = fullfile('D:',PROJECTID);

global WORKFOLDER
WORKFOLDER = 'parameter_space';

global RESULTDIR
RESULTDIR = fullfile(ROOTDIR,'analysis',WORKFOLDER);
if ~exist(RESULTDIR,'dir')
    status = mkdir(RESULTDIR);   % create folder for this run
end
if ~exist(fullfile(RESULTDIR,'parameters.mat'))
    
    %create version backup of codes
%     if ~exist(fullfile(RESULTDIR,'codes'))
%         status = mkdir(fullfile(RESULTDIR,'codes'));
%     end
%     copyfile(codepath, fullfile(RESULTDIR,'codes'));
    
    global DATADIR
    DATADIR = fullfile('D:',PROJECTID,'DATA',WORKFOLDER);
    global PREPROCDIR
    PREPROCDIR = fullfile(RESULTDIR, 'PREPROC');
    
    %Recording parameters (do not change!!!):
    global SR   % sampling rate
    SR = 40000;
    global NLINCHANNELS %number of linear channels
    NLINCHANNELS = 1;
    global NSEPTALCHANNELS %number of septal probe channels
    NSEPTALCHANNELS = 1;
    
    %Preprocess:
    global NSR  % new sampling rate
    NSR = 1000;
    
    %Theta detection:
    global HPTHBAND   % theta frequency band
    HPTHBAND = [4,6];
    global HPDEBAND   % delta frequency band
    HPDEBAND = [0.5,4];
    global TSCCGSMWINDOW
    TSCCGSMWINDOW = 0.5; %window for smoothing fieldData (moving average, in tsccg, sec)
    global THRATIOTHRESH
    THRATIOTHRESH = 2; %threshold for theta/delta ratio
    global DERATIOTHRESH
    DERATIOTHRESH = 2; %threshold for theta/delta ratio
    
    %MS units' rhythmicity:
    global MSTHBAND   % theta frequency band
    MSTHBAND = [4,6];
    global MSDEBAND   % delta frequency band
    MSDEBAND = [0.5,4];
    global CGWINDOW   % CGWINDOW for acg
    CGWINDOW = 3;
    global CGBINS  % binsize for acg
    CGBINS = 20;
    global BURSTWINDOW %for burstiness detection
    BURSTWINDOW = [20,40];
    
    %Significance test (rhythmicity thresholding):
    global SIGNIFLEVEL
    SIGNIFLEVEL = 5; % significance level, in percent
    global THSUMACGTRESH
    THSUMACGTRESH = NSR * CGWINDOW / 2; %*4; % integral threshold
    global DESUMACGTRESH
    DESUMACGTRESH = NSR * CGWINDOW / 2;%*4; % integral threshold
    
    %Phase preference
    global PHASEHISTEDGES %phase histogram edges
    PHASEHISTEDGES = -pi:(2*pi/18):pi;
    
    activeRecIds = collect_active_recordings();
    
    save(fullfile(RESULTDIR, 'parameters'));
else
    load(fullfile(RESULTDIR, 'parameters'));
end