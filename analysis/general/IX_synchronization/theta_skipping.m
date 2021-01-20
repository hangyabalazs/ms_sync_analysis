function [skipRatioTh,skipRatioDe,nPoints,IDs] = theta_skipping(rowIds,frBands)
%THETA_SKIPPING Measures theta skipping of MS cell.
%   [SKIPRATIOTH,SKIPRATIODE,NPOINTS,IDS] = THETA_SKIPPING(ROWIDS,FRBANDS)
%   calculates ratio of theta cycle skipping of pacemakers: 
%   (#silent cycles)/(#theoretical cycles). Theoretical cycles: if the cell
%   would fire at its rhythmicity frequency (computed from the acg) during
%   the whole recording.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%   SKIPRATIOTH: vector, #silent/#all periods during theta.
%   SKIPRATIODE: vector, #silent/#all periods during delta.
%   NPOINTS: number of elements in ROWIDS.
%   IDS: collection of cell Ids.
%
%   See also GROUP_SYNCHRONIZATION, RHYTHMICITY_FREQUENCIES, BURST_DETECTOR.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 07/02/2019

global RESULTDIR
global BURSTWINDOW
global MSTHBAND

if nargin == 0
    variable_definitions; %rowIds,(frBands) definition
end
if ~exist('frBands','var') % if not provided...
    frBands = [MSTHBAND;MSTHBAND]; % MS theta frequency band during both states
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

% Calculate rhythmicity cycle times (1/frequency) from acgs:
[ctThAll,ctDeAll] = rhythmicity_frequencies(rowIds,frBands);

% Allocate
skipRatioTh = zeros(numel(rowIds),1);
skipRatioDe = zeros(numel(rowIds),1);
for it=1:numel(rowIds)
    animalId = num2str(allCell(rowIds(it),mO('animalId')));
    recordingId = num2str(allCell(rowIds(it),mO('recordingId')));
    shankId = allCell(rowIds(it),mO('shankId'));
    cellId = allCell(rowIds(it),mO('cellId'));
    
    % Load state vectors:
    load(fullfile(RESULTDIR,'theta_detection','theta_segments',[animalId,recordingId]),'theta','delta');
    % Derive theoretical theta signals:
    % create histogram edge vector based on acg's rhythmicity frequency
    thCycles = 1:ctThAll(it):length(theta); % during theta
    thCycles(delta(thCycles)==1) = [];
    deCycles = 1:ctDeAll(it):length(theta); % during delta
    deCycles(theta(deCycles)==1) = [];
    % Get bursts:
    TS = loadTS(animalId,recordingId,shankId,cellId);
    % During theta:
    thetaTs = TS(theta(TS)==1);
    [~,burstStartTh,~,singleSpksTh] = burst_detector(thetaTs,BURSTWINDOW(2),length(theta));
    thN = histcounts([burstStartTh;singleSpksTh],thCycles); % all activity (burst and single spikes)
%     thN = histcounts(burstStartTh,thCycles); % only bursts
    skipRatioTh(it) = sum(thN==0) / length(thN); % ratio: #silent/#all periods
    
    % During delta:
    deltaTs = TS(delta(TS)==1);
    [~,burstStartDe,~,singleSpksDe] = burst_detector(deltaTs,BURSTWINDOW(2),length(delta));
    deN = histcounts([burstStartDe;singleSpksDe],deCycles); % all activity (burst and single spikes)
%     deN = histcounts(burstStartDe,deCycles); % only bursts
    skipRatioDe(it) = sum(deN==0) / length(deN); % ratio: #silent/#all periods
end

nPoints = numel(rowIds); % number of cells
IDs = [allCell(rowIds,mO('animalId'):mO('cellId')),rowIds]; %cell IDs
end