function free_mouse_stimulations_check(animalId,recordingId1,recordingId2)
%FREE_MOUSE_STIMULATIONS_CHECK Double check stimulation times.
%   FREE_MOUSE_STIMULATIONS_CHECK(ANIMALID,RECORDINGID1,RECORDINGID2)
%   It plots Andor suggested stimulation times. 
%   This function is called from FREE_MOUSE_STIMULATIONS.
%   Parameters:
%   ANIMALID: string (e.g. '1695').
%   RECORDINGID1: string (e.g. '18').
%   RECORDINGID2: string (e.g. '24').
%
%   See also FREE_MOUSE_GLOBALTABLE, FREE_MOUSE_STIMULATIONS.

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

load(fullfile(ROOTDIR,'STIMULATIONS','stimEpochs_Andor','stimEpochs.mat'));
rowId1 = find(ismember((stimEpochs(:,1)),[animalId,'_',num2str(recordingId1)]));
rowId2 = find(ismember((stimEpochs(:,1)),[animalId,'_',num2str(recordingId2)]));

filename1 = ['Z:\hippocampo-septal\',animalId,'\amplipex\',animalId,'_',num2str(recordingId1)];
fileinfo1 = dir([filename1,'.dat']);
recLength1 = fileinfo1.bytes/2/chNum/(SR/NSR);

filename2 = ['Z:\hippocampo-septal\',animalId,'\amplipex\',animalId,'_',num2str(recordingId2)];
fileinfo2 = dir([filename2,'.dat']);
recLength2 = fileinfo2.bytes/2/chNum/(SR/NSR);

starts1 = stimEpochs{rowId1,2}(:);
starts2 = stimEpochs{rowId2,2}(:)+recLength1*(SR/NSR);
ends1 = stimEpochs{rowId1,3}(:);
ends2 = stimEpochs{rowId2,3}(:)+recLength1*(SR/NSR);
stimStarts = [starts1;starts2];
stimEnds = [ends1;ends2];

stim = zeros(1,recLength1+recLength2);
for it = 1:length(stimStarts)
    stim(round(stimStarts(it)/(SR/NSR)):round(stimEnds(it)/(SR/NSR))) = 1;
end

plot(stim,'k')
end