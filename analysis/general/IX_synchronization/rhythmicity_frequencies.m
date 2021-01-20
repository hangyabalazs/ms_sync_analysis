function [thPeakLoc,dePeakLoc,thPeakVal,dePeakVal,smThetaAcgs,smDeltaAcgs,nPoints,IDs] = rhythmicity_frequencies(rowIds,frBands)
%RHYTHMICITY_FREQUENCIES Returns modulation frequencies.
%   [THPEAKLOC,DEPEAKLOC,THPEAKVAL,DEPEAKVAL,SMTHETAACGS,SMDELTAACGS,
%   NPOINTS,IDS] = RHYTHMICITY_FREQUENCIES(ROWIDS,FRBANDS) calculates acg's
%   peak locations (1/rhythmicity frequencies) and values, of the given 
%   cells (ROWIDS in allCell matrix) during both states (theta, non-theta).
%   It also returns smoothed acgs.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FRBANDS: 2x2 vector, specifying frequency bands of interest (Hz) (e.g.
%   theta frequency during theta, delta frequency during delta? [3,8;0.5,2.5]).
%   THPEAKLOC: vector, peak locations of acgs (in the interval: 
%   [1/frBands(1,2),1/frBands(1,1)].
%   DEPEAKLOC: vector, peak locations of acgs (in the interval: 
%   [1/frBands(2,2),1/frBands(2,1)].
%   interval).
%   THPEAKVAL: vector, peak values of acgs (in the interval: 
%   [1/frBands(1,2),1/frBands(1,1)].
%   DEPEAKVAL: vector, peak values of acgs (in the interval: 
%   [1/frBands(2,2),1/frBands(2,1)].
%   SMTHETAACGS: matrix, smoothed acgs during theta.
%   SMDELTAACGS: matrix, smoothed acgs during delta.
%   NPOINTS: number of elements in ROWIDS.
%   IDS: collection of cell Ids.
%
%   See also GROUP_SYNCHRONIZATION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global NSR
global CGWINDOW
global MSTHBAND

if nargin == 0
    variable_definitions; %rowIds, (frBand) definitions
end
if ~exist('frBands','var') % if not provided...
    frBands = [MSTHBAND;MSTHBAND]; % MS theta frequency band during both states
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

thLags = (NSR*CGWINDOW+round(NSR/frBands(1,2))):(NSR*CGWINDOW+round(NSR/frBands(1,1)));
deLags = (NSR*CGWINDOW+round(NSR/frBands(2,2))):(NSR*CGWINDOW+round(NSR/frBands(2,1)));

% Define smoothing kernel for acgs
conWindowSize = 20;
conWindow = ones(conWindowSize,1) / conWindowSize;

thPeakLoc = zeros(length(rowIds),1); % peak location, during theta (ms)
dePeakLoc = zeros(length(rowIds),1); % peak location, during delta (ms)
thPeakVal = zeros(length(rowIds),1); % peak value, during theta
dePeakVal = zeros(length(rowIds),1); % peak value, during delta
smThetaAcgs = zeros(NSR*CGWINDOW*2,length(rowIds)); % smoothed acgs, during theta
smDeltaAcgs = zeros(NSR*CGWINDOW*2,length(rowIds)); % smoothed acgs, during delta
for it1 = 1:numel(rowIds)
    % Theta:
    thetaAcg = allCell(rowIds(it1),mO('thetaAcgFirst'):mO('thetaAcgLast'));
    smThetaAcgs(:,it1) = conv(thetaAcg,conWindow,'same');
    [thPeakVal(it1),thLoc] = max(smThetaAcgs(thLags,it1));
    thPeakLoc(it1) = thLoc + round(NSR/frBands(1,2))-1;
    % Delta:
    deltaAcg = allCell(rowIds(it1),mO('deltaAcgFirst'):mO('deltaAcgLast'));
    smDeltaAcgs(:,it1) = conv(deltaAcg,conWindow,'same');
    [dePeakVal(it1),deLoc] = max(smDeltaAcgs(deLags,it1));
    dePeakLoc(it1) = deLoc + round(NSR/frBands(2,2))-1;
end

nPoints = numel(rowIds); % number of cells
IDs = [allCell(rowIds,mO('animalId'):mO('cellId')),rowIds]; %cell IDs
end