function free_mouse_stimulations(animalId,recordingId1,recordingId2)
%FREE_MOUSE_STIMULATIONS Saves stimulation times for FREE_MOUSE project.
%   FREE_MOUSE_STIMULATIONS(ANIMALID,RECORDINGID1,RECORDINGID2) helps to
%   identify stimulated segments in the concatenated recordings 
%   (recordingId1 and recordingId2). Creates STIMULATIONS folder in ROOTDIR
%   and save stimulated segments and a snapshot.
%   Parameters:
%   ANIMALID: string (e.g. '1695').
%   RECORDINGID1: string (e.g. '18').
%   RECORDINGID2: string (e.g. '24').
%
%   See also FREE_MOUSE_GLOBALTABLE, FREE_MOUSE_STIMULATIONS_CHECK,
%   LOADFIELDPOT, LOADTS, CUT_STIMULATION_FROM_UNITACT,
%   SAVE_STIMULATION_OPTO.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 17/11/2017

global ROOTDIR
global SR
global NSR
global NLINCHANNELS
global NSEPTALCHANNELS
    
if nargin == 0
    variable_definitions; %animalId,recordingId1,recordingId2 definitions
end

chNum  = NLINCHANNELS + NSEPTALCHANNELS + 3;

recordingId = [num2str(recordingId1), num2str(recordingId2)];

load(fullfile(ROOTDIR,'STIMULATIONS','Pulsedetect',['HS_',animalId,'_pulsedetect.mat']), 'XLS','stim_Start','stim_StartEnd');

filename1 = ['Z:\hippocampo-septal\', animalId, '\amplipex\', animalId, '_', ...
    num2str(recordingId1)];
filename2 = ['Z:\hippocampo-septal\', animalId, '\amplipex\', animalId, '_', ...
    num2str(recordingId2)];

fileinfo1 = dir([filename1, '.dat']);
recLength1 = fileinfo1.bytes/2/chNum/(SR/NSR);
fileinfo2 = dir([filename2, '.dat']);
recLength2 = fileinfo2.bytes/2/chNum/(SR/NSR);

% collect recordingIds:
recIds = zeros(1, size(XLS.file, 1));
for it=1:size(XLS.file, 1)
    id = sscanf(XLS.file{it}, '%d_%d');
    recIds(it) = id(2);
end

% First recording (homecage)
rowId1 = find(recIds == recordingId1);
if ~exist('stim_StartEnd','var') % in case of CH animals (only blue (10 sec) stimuli)
    stimStarts1 = stim_Start{rowId1,1}(1:2:end);
    stimEnds1 = stim_Start{rowId1,1}(2:2:end);
else  % in the case of SwichR animals (blue (10 sec) and yellow (2 sec) stimuli)
    blueStimTime1 = stim_StartEnd{rowId1, 1};
    yelStimTime1 = stim_StartEnd{rowId1, 2};
    stimStarts1 = [blueStimTime1(:,1);yelStimTime1(:,1)];
    stimEnds1 = [blueStimTime1(:,2);yelStimTime1(:,2)];
end

% Second recording (linear track)
rowId2 = find(recIds == recordingId2);
if ~exist('stim_StartEnd','var') % in case of CH animals (only blue (10 sec) stimuli)
    stimStarts2 = stim_Start{rowId2,1}(1:2:end);
    stimEnds2 = stim_Start{rowId2,1}(2:2:end);
else  % in the case of SwichR animals (blue (10 sec) and yellow (2 sec) stimuli)
    blueStimTime2 = stim_StartEnd{rowId2, 1};
    yelStimTime2 = stim_StartEnd{rowId2, 2};
    stimStarts2 = [blueStimTime2(:,1);yelStimTime2(:,1)];
    stimEnds2 = [blueStimTime2(:,2);yelStimTime2(:,2)];
end

% Concatenate two recordings (homecage + linear track):
stimStarts = [stimStarts1;stimStarts2+recLength1*(SR/NSR)];
stimEnds = [stimEnds1;stimEnds2+recLength1*(SR/NSR)];
if length(stimStarts)>length(stimEnds)
    'Different stimStarts, stimEnds lengths'
end
% Create stimulus vector:
stim = zeros(1, recLength1+recLength2);
for it = 1:size(stimStarts, 1)
    stim(round(stimStarts(it)/(SR/NSR)):round(stimEnds(it)/(SR/NSR))) = 1;
end

% Plot
figure, hold on
plot(stim)
stim = [0 stim 0];
[stim,s1,s2] = unifying_and_short_killer(stim,NSR,1); % Merge bursts
hold on, plot(stim)
ylim([0,1.2])
free_mouse_stimulations_check(animalId,recordingId1,recordingId2)

saveas(gcf,fullfile(ROOTDIR,'STIMULATIONS',['2016',animalId,recordingId,'.jpg']));
close
save(fullfile(ROOTDIR,'STIMULATIONS',['2016',animalId,recordingId,'.mat']),'stim','s1','s2');
end