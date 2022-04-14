function ccg_change(animalId,recordingId,shankIds,cellIds,windowS,minLe,isPlot)
%CCG_CHANGE visualize the cross-correlation change between pairs of cells.
%   CCG_CHANGE(ANIMALID,RECORDINGID,SHANKIDS,CELLIDS,WINDOWS,MINLE,ISPLOT)
%   calculates the average cross-correlations of cell pairs 1) WINDOWS sec 
%   before -, 2) WINDOWS sec following delta-theta transitions, and 3) last 
%   WINDOWS sec of theta segments (before theta-delta transitions).
%   Parameters:
%   ANIMALID: string (e.g. '20100728').
%   RECORDINGID: string (e.g. '5').
%   SHANKIDS: 2 element number vector (e.g. [4,4]).
%   CELLIDS: 2 element number vector (e.g [3,11]).
%   WINDOWS: number, +/- time to calculate cross-correlations around the
%   transitions (e.g.: 5 -> +/-5 sec).
%   MINLE: number, minimal length of dominant delta before and theta after
%   transition (e.g. 7 -> 7 sec).
%
%   See also MAIN_ANALYSIS, EXECUTE_CORECORDED_PAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 25/05/2021

global RESULTDIR
global NSR
global CGBINS

if nargin == 0
    variable_defintions; %animalId, recordingId, shankIds, cellIds definitions
end

% maximal lag to calculate cross-correlation:
maxLag = NSR/2; % HARD CODED HERE!!!

% Find delta-theta transition point(s) for the recording:
% Load theta logical vector (define theta/delta segments):
load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta');
theta = unifying_and_short_killer([0,theta,0],minLe*NSR,minLe*NSR);
dtheta = diff([0 theta 0]);
s1 = find(dtheta==1); % delta-theta transition
s2 = find(dtheta==-1); % theta-delta transition
% Delete too early and too late transitions:
delInx = s1-windowS*NSR<0 | s2+windowS*NSR>length(theta);
s1(delInx) = [];

% Load AP timestamps (TS):
TS1 = loadTS(animalId,recordingId,shankIds(1),cellIds(1));
TS2 = loadTS(animalId,recordingId,shankIds(2),cellIds(2));

% Cell_1
% Create logical vectors for unit activites:
actPattern1 = zeros(size(theta,2), 1);
% index in the actPattern (1 where actTime fires, 0 where not)
actPattern1(TS1) = 1;

% Cell_2
% Create logical vectors for unit activites:
actPattern2 = zeros(size(theta, 2), 1);
% index in the actPattern (1 where actTime fires, 0 where not)
actPattern2(TS2) = 1;

% Allocate storage:
corDe = zeros(numel(s1),maxLag*2+1);
corDeTh = zeros(numel(s1),maxLag*2+1);
corTh = zeros(numel(s1),maxLag*2+1);
for it = 1:numel(s1) % iterate trough all transitions
    % before delta-theta transition:
    tIndex = s1(it)-windowS*NSR:s1(it); % time index
    [corDe(it,:),~,lag] = correlation(actPattern1(tIndex),actPattern2(tIndex),false,[1,1,1],maxLag,CGBINS,'integrating');
    % before theta-delta transition:
    tIndex = s2(it)-windowS*NSR:s2(it); % time index 
    corDeTh(it,:) = correlation(actPattern1(tIndex),actPattern2(tIndex),false,[1,1,1],maxLag,CGBINS,'integrating');
    % after delta-theta transition:
    tIndex = s1(it):s1(it)+windowS*NSR; % time index
    corTh(it,:) = correlation(actPattern1(tIndex),actPattern2(tIndex),false,[1,1,1],maxLag,CGBINS,'integrating');
end

if exist('isPlot','var')
    % Plot:
    figure; hold on
    plot(lag,mean(corDe),'Color',[0.850,0.325,0.098])
    plot(lag,mean(corDeTh),'Color',[0.494,0.184,0.556])
    plot(lag,mean(corTh),'Color',[0,0.447,0.741])
end
end