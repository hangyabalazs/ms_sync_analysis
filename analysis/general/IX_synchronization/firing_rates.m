function [thFr,deFr,nPoints,IDs] = firing_rates(rowIds)
%FIRING_RATES Calculates firing rates during theta, non-theta
%   [THFR,DEFR,NPOINTS,IDS] = FIRING_RATES(ROWIDS).
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   THFR: firing rate during theta.
%   DEFR: firing rate during delta.
%   NPOINTS: number of elements in ROWIDS.
%   IDS: collection of cellIDs.
%
%   See also GROUP_SYNCHRONIZATION.
%
%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global NSR

if nargin == 0
    variable_definitions; %rowIds definitions
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

thFr = allCell(rowIds,mO('nAPtheta'))./allCell(rowIds,mO('thetaLength')) * NSR;
deFr = allCell(rowIds,mO('nAPdelta'))./allCell(rowIds,mO('deltaLength')) * NSR;
nPoints = numel(rowIds); % number of cells
IDs = [allCell(rowIds,mO('animalId'):mO('cellId')),rowIds]; % cell IDs
end