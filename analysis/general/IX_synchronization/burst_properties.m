function [ibISITh,ibISIDe,ibnAPTh,ibnAPDe,bLeTh,bLeDe,nPoints,IDs] = burst_properties(rowIds)
%BURST_PROPERTIES Baseic burst properties of cells.
%   [IBISITH,IBISIDE,IBNAPTH,IBNAPDE,BLETH,BLEDE,NPOINTS,IDS] = 
%   BURST_PROPERTIES(ROWIDS) calculates basic properties of the bursts of 
%   the given cells (ROWIDS in allCell matrix) during both states (theta, 
%   non-theta). 
%   It returns median values of:
%   - intraburst interspike intervals (units: ms, IBISITH, IBISIDE).
%   - intraburst number of spikes (IBNAPTH, IBNAPDE).
%   - burst lengths (units: ms, BLETH, BLEDE).
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   IBISITH: vector, median intraburst interspike interval lengths during
%   theta.
%   IBISIDE: vector, median intraburst interspike interval lengths during
%   delta.
%   IBNAPTH: vector, median intraburst numbers of spikes during theta.
%   IBNAPDE: vector, median intraburst numbers of spikes during delta.
%   BLETH: vector, median burst lengths during theta.
%   BLEDE: vector, median burst lengths during delta.
%   NPOINTS: number of elements in ROWIDS.
%   IDS: collection of cellIds.
%
%   See also GROUP_SYNCHRONIZATION, MERGE_BURSTS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global BURSTWINDOW

if nargin == 0
    variable_definitions; %rowIds definition
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

maxBurstL = BURSTWINDOW(2); % maximum length of intraburst interspike time (ms)

% Allocate vectors:
ibISITh = zeros(numel(rowIds),1); % intraburst interspike intervals, theta
ibISIDe = zeros(numel(rowIds),1); % intraburst interspike intervals, delta
ibnAPTh = zeros(numel(rowIds),1); % intraburst number of APs, theta
ibnAPDe = zeros(numel(rowIds),1); % intraburst number of APs, delta
bLeTh = zeros(numel(rowIds),1); % burst length, theta
bLeDe = zeros(numel(rowIds),1); % burst length, delta
for it1 = 1:numel(rowIds)
    animalId = num2str(allCell(rowIds(it1),mO('animalId')));
    recordingId = num2str(allCell(rowIds(it1),mO('recordingId')));
    shankId = num2str(allCell(rowIds(it1),mO('shankId')));
    cellId = allCell(rowIds(it1),mO('cellId'));
    
    % load state vectors:
    load(fullfile(RESULTDIR,'theta_detection', 'theta_segments', [animalId, recordingId]),'theta','delta');
    % load AP timestamps (TS)
    TS = loadTS(animalId,recordingId,shankId,cellId);
    
    thetaTS = TS(theta(TS) == 1);
    deltaTS = TS(delta(TS) == 1);
    
    % during theta:
    [nSpikesTh,burstLeTh] = merge_bursts(thetaTS,maxBurstL);
    bIndTh = find(nSpikesTh>1); % burst indices
    ibnAPTh(it1) = median(nSpikesTh(bIndTh));
    bLeTh(it1) = median(burstLeTh(bIndTh));
    ibISITh(it1) = median(burstLeTh(bIndTh)./(nSpikesTh(bIndTh)-1));
    
    % during delta:
    [nSpikesDe,burstLeDe] = merge_bursts(deltaTS,maxBurstL);
    bIndDe = find(nSpikesDe>1); % burst indices
    ibnAPDe(it1) = median(nSpikesDe(bIndDe));
    bLeDe(it1) = median(burstLeDe(bIndDe));
    ibISIDe(it1) = median(burstLeDe(bIndDe)./(nSpikesDe(bIndDe)-1));
end

nPoints = numel(rowIds); % number of cells
IDs = [allCell(rowIds,mO('animalId'):mO('cellId')),rowIds]; %cell IDs
end