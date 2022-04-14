function [thDevs,deDevs,nPairs,IDs] = rh_frequency_deviations(rowIds,frBands)
%RH_FREQUENCY_DEVIATIONS Calculates rhythmicity frequency (rh-fr)
%deviations of corecorded cells relative to the median rh-fr in the recording.
%   [THDEVS,DEDEVS,NPAIRS,IDS] = RH_FREQUENCY_DEVIATIONS(ROWIDS,FRBANDS,COND)
%   takes the median of rh-fr of cells recorded simultaneously (least 2)
%   and subtracts it from each cells rh-fr, both during theta and delta.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%   THDEVS: vector, rhythmicity frequency deviaitons of cells during theta 
%   (in interval: [1/frBands(1,2),1/frBands(1,1)]).
%   DEDEVS: vector, rhythmicity frequency deviaitons of cells during delta 
%   (in interval: [1/frBands(2,2),1/frBands(2,1)]).
%   NPAIRS: number of elements in ROWIDS (cell pairs).
%   IDS: collection of cell-pair Ids.
%
%   See also FREQUENCY_SYNCHRONIZATION, GROUP_SYNCHRONIZATION,
%   RHYTHMICITY_FREQUENCIES, PLOT_SYNCHRONIZATION_THEORIES.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 20/05/2021

global RESULTDIR
global MSTHBAND
global NSR

if nargin == 0
    variable_definitions; %rowIds,frband definitions
end
if ~exist('frBands','var') % if not provided...
    frBands = [MSTHBAND;MSTHBAND]; % MS theta frequency band during both states
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

% Calculate rhythmicity cycle times (1/frequency)s from acgs:
[ctThAll,ctDeAll] = rhythmicity_frequencies(rowIds,frBands);

% Allocate:
thDevs = zeros(200,1); % theta accaleration ratio
deDevs = zeros(200,1); % delta accaleration ratio
IDs = zeros(200,5);
cnt = 0;

% Find neurons recorded in the same recording:
[~,~,ind] = unique(allCell(rowIds,mO('animalId'):mO('recordingId')),'rows');
for it1 = 1:ind(end)
    coRecIds = find(ind==it1); % neurons from the same recording
    nActCells = numel(coRecIds);
    if nActCells > 1
        thActFrs = NSR./ctThAll(coRecIds);
        deActFrs = NSR./ctDeAll(coRecIds);
        indRange = cnt+1:cnt+nActCells;
        thDevs(indRange) = thActFrs - mean(thActFrs); % deviations from mean in recording (theta)
        deDevs(indRange) = deActFrs - mean(deActFrs); % deviations from mean in recording (delta)
        IDs(indRange,:) = [allCell(rowIds(coRecIds),mO('animalId'):mO('cellId')),rowIds(coRecIds)];
        cnt = cnt + nActCells;
    end
end
thDevs(cnt+1:end) = [];
deDevs(cnt+1:end) = [];
IDs(cnt+1:end,:) = [];
nPairs = cnt;
end