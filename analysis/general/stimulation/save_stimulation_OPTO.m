function save_stimulation_OPTO(animalId,recordingId)
%SAVE_STIMULATION_OPTO Save stimulation times in OPTO project.
%   SAVE_STIMULATION_OPTO(ANIMALID,RECORDINGID) save optogenetic stimulation
%   timepoints.
%   Later on we will mostly exclude thoose intervals from analysis.
%   Parameters:
%   ANIMALID: string (e.g. '20180814').
%   RECORDINGID: string (e.g. '1').
%
%   See also OPTO_GLOBALTABLE, LOADFIELDPOT, LOADTS, CUT_STIMULATION_FROM_UNITACT,
%   FREE_MOUSE_STIMULATIONS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27/08/2020

global ROOTDIR
global DATADIR
global SR
global NSR

if nargin == 0
    variable_definitions; %animalId,recordingId definitions
end

% Calculating total length of recording:
[channelData,timestamps] = load_open_ephys_data_faster(fullfile(DATADIR,animalId,recordingId,...
    '100_CH1.continuous'));
recLength = floor(length(channelData)/(SR/NSR));
[data, stimTimestamps,info] = load_open_ephys_data_faster(fullfile(DATADIR,animalId,recordingId,...
    'all_channels.events'));
if sum(data==2) == 0
    stimPoints = stimTimestamps(info.eventId==1);
else
    stimPoints = stimTimestamps(data==2 & info.eventId==1);
end

% Align to zero:
stimPoints = stimPoints - timestamps(1);
stimPoints = round(stimPoints*NSR);

% Create stimulation vector:
stim = zeros(1,recLength);
stim(stimPoints) = 1;
concatTime = 4 * NSR; % inter-stimulation times
[~,s1,s2] = unifying_and_short_killer(stim,concatTime,0);
% if s1>2 %accidental stimulus protocoll
%     s1(1) = [];
%     s2(1) = [];
% end
stim = ones(1,recLength);
stim(s2(1):s1(2)) = 0; % keep only the segment between stimulations
dStim = diff(stim);
s1 = find(dStim==1);
s2 = find(dStim==-1);

nplot(stim)
saveas(gcf,fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.jpg']))
close
save(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']), 'stim', 's1', 's2')
end