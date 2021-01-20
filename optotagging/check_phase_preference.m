function check_phase_preference()
%CONVERT_ALL_FIGS Shows phase locking of cells.
%   CHECK_PHASE_PREFERENCE() checks whether the cells are phase-locked to 
%   the hippocampal theta or not. If no, than its a theta frequency 
%   artefact presumably.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/01/2019

global ROOTDIR
global PREPROCDIR
global PROJECTID
global NSR
global TSCCGSMWINDOW
global THRATIOTHRESH
global DERATIOTHRESH

if nargin == 0
    variable_definitions; %animalId,recordingId,noiseBand,otherBand definitions
end
edges = -pi:(2*pi/18):pi; % phase histogram edges

% Load stimulus
if isequal(PROJECTID,'FREE_MOUSE') | isequal(PROJECTID,'OPTOTAGGING') % cut out stimulation parts
    load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']),'stim');
end

% Load hippocampus:
load(fullfile(PREPROCDIR,animalId,recordingId,[animalId,'_',recordingId,'_radiatum.mat']),'fieldPot');
[isNoisy,isOther,noiseTransf,otherTransf] = theta_detection(fieldPot,noiseBand,otherBand,NSR,TSCCGSMWINDOW,THRATIOTHRESH,DERATIOTHRESH,TSCCGSMWINDOW);
hold on, plot(1/NSR:1/NSR:length(stim)/NSR,stim)
noisePhases = angle(noiseTransf);
otherPhases = angle(otherTransf);

% Load MS units:
cellIdFnameS = listfiles(fullfile(PREPROCDIR,animalId, recordingId),'TT');
[shankIds,cellIds] = cellfun(@cbId2shankcellId,cellIdFnameS);
for it = 1:length(shankIds) %iterate trough all recordings
    figure, subplot(3,1,1), hold on
    title([animalId,' ',recordingId,' ',num2str(shankIds(it)),' ',num2str(cellIds(it))])
    load(fullfile(PREPROCDIR,animalId,recordingId,['TT',num2str(shankIds(it)),'_',num2str(cellIds(it)),'.mat']),'TS');
    histogram(noisePhases(TS(isNoisy(TS)==1)),edges,'Normalization','probability','DisplayStyle','stairs');
    histogram(otherPhases(TS(isOther(TS)==1)),edges,'Normalization','probability','DisplayStyle','stairs');
    subplot(3,1,2), hold on
    correlation(TS(isNoisy(TS)==1),TS(isNoisy(TS)==1),[0,0,1]);
    correlation(TS(isOther(TS)==1),TS(isOther(TS)==1),[1,0,0]);
    subplot(3,1,3), hold on
    correlation(TS(stim(TS)==1),TS(stim(TS)==1),[0,0,1],NSR/4,1,'integrating');
    correlation(TS(stim(TS)==0),TS(stim(TS)==0),[1,0,0],NSR/4,1,'integrating');
    %     close
end
end