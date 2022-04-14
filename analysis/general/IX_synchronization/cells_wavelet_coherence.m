function [wcoh,f] = cells_wavelet_coherence(animalId,recordingId,shankIds,cellIds,windowS,minLe,isPlot)
%CELLS_WAVELET_COHERENCE calculates the wavelet coherence between 
% corecorded cells around delta-theta transition(s).
%   Parameters:
%   ANIMALID: string (e.g. '20100728').
%   RECORDINGID: string (e.g. '5').
%   SHANKIDS: 2 element number vector (e.g. [4,4]).
%   CELLIDS: 2 element number vector (e.g [3,11]).
%   WINDOWS: number, +/- time to calculate cross coherence around the
%   transition (e.g.: 5 -> +/-5 sec).
%   MINLE: number, minimal length of dominant delta before and theta after
%   transition (e.g. 7 -> 7 sec). Specify MINLE as 0 if you want to calculate
%   cross coherence only at a specific point (determined in
%   "PROJECTID"_GLOBALTABLE.m for all recordings).
%
%   See also MAIN_ANALYSIS, EXECUTE_CORECORDED_PAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 20/05/2021

global RESULTDIR
global NSR

if nargin == 0
    variable_definitions; %animalId,recordingId,shankIds,cellIds,windowS,minLe,isPlot definitions
end

% Define convolving kernel for spike trains:
nPoints = 50; % HARD CODED HERE!!!
kernel = gausswin(nPoints)/nPoints*2;

recLength = length(loadFieldPot(animalId,recordingId)); % recording length

% Derive theoretical continuous signals:
TS1 = loadTS(animalId,recordingId,shankIds(1),cellIds(1)); % time of spikes, cell 1
timeseries1 = zeros(recLength,1); % create timeseries for cell 1
timeseries1(TS1) = 1;
smTimeseries1 = conv(timeseries1,kernel,'same'); % convolve with gaussian kernel

TS2 = loadTS(animalId,recordingId,shankIds(2),cellIds(2)); % time of spikes, cell 2
timeseries2 = zeros(recLength,1); % create timeseries for cell 2
timeseries2(TS2) = 1;
smTimeseries2 = conv(timeseries2,kernel,'same'); % convolve with gaussian kernel

% % Ccgs, acgs:
% cross_correlation(animalId,recordingId,shankIds,cellIds,'maxlag',1000,'isPlot',true);
% set(gcf,'Position',[1100,40,420,710]);

% Find delta-theta transition point(s) for the recording:
if minLe == 0 % OPTION 1: one specific transition for each recording:
    load(fullfile(RESULTDIR,'parameters'),'recordings');
    inx = find(recordings(:,1) == str2num([animalId,recordingId]));
    tWindow = [recordings(inx,2)-windowS,recordings(inx,2)+windowS];
    %     % Plot hippo field and unit activity:
    %     IDs = {animalId,recordingId,shankIds(1),cellIds(1);...
    %         animalId,recordingId,shankIds(2),cellIds(2)};
    %    figure, raster_plot(IDs,tWindow);
else % OPTION 2: all transitions with MINLE minimal length of delta before and theta after
    % Load theta logical vector (define theta/delta segments):
    load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta');
    theta = unifying_and_short_killer([0,theta,0],minLe*NSR,minLe*NSR);
    dtheta = diff([0 theta 0]);
    s1 = find(dtheta==1).';
    tWindow = [s1/NSR-windowS,s1/NSR+windowS]; % time windows ([start,end]) around transitions
    % If no sufficient time around transitions (recording start and end)
    tWindow(tWindow(:,1)<1/NSR | tWindow(:,2)>length(theta)/NSR,:) = [];
end

% Calculate wavelet coherences around transition(s):
nFreqs = size(wcoherence(zeros(windowS*NSR*2+1,1),zeros(windowS*NSR*2+1,1),NSR),1); % number of frequencies
allMatrix = zeros(size(tWindow,1),nFreqs,windowS*NSR*2+1); % store all trasnitions' cross coherences
for it = 1:size(tWindow,1) % iterate trough all transitions in the recording
    cutTime = round(tWindow(it,1)*NSR):round(tWindow(it,2)*NSR);
    % Wavelet coherence:
    [wcoh,~,f] = wcoherence(smTimeseries1(cutTime),smTimeseries2(cutTime),NSR);
    allMatrix(it,:,:) = wcoh;
end
wcoh = squeeze(mean(allMatrix,1,'omitnan')); % calculate average wavelet coherence for cell pair

if exist('isPlot','var')
    % Plot:
    figure('Position',[1,550,1097,200]);
    frInd = find(f<21 & f>0.5); % interesting frequencies
    if minLe ~= 0 % if more transitions were averaged
        cutTime = 1:windowS*NSR*2+1;
    end
    imagesc(cutTime/NSR,1:numel(frInd),wcoh(frInd,:));
    set(gca,'clim',[0.1,0.7])
    set(gca,'ytick',[1,13,22,34,53])
    set(gca,'yticklabel',{20,10,6,3,1})
end
end