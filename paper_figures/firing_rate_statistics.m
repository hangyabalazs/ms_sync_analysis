function allStat = firing_rate_statistics()
%FIRING_RATE_STATISTICS collects statistics results for firing rate changes.
%   FIRING_RATE_STATISTICS calls the Wilcoxon signed rank test for firing
%   rate changes from delta to theta, and outputs raw p values, statistics
%   and the size of the samples.
%
%   See also CELL_GROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 15/02/2022

% Activate (uncomment) either the first (optotagging - opto groups) or the
% second (ana. rat, ana. mouse, free m. mouse) section!!!!!

%% Opto groups
OPTO_GLOBALTABLE
load(fullfile(RESULTDIR,'cell_features','allCell.mat'));
load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'));

% PV+:
rowIds = get_optoGroup_indices_in_allCell('PVR');
% Wilcoxon signed-rank test
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(1,:) = [p,Wplus,numel(rowIds)]; % ALLSTAT columns: p, W+, n
        
% GABAerg:
rowIds = get_optoGroup_indices_in_allCell('VGA');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(2,:) = [p,Wplus,numel(rowIds)];

% glutamaterg:
rowIds = get_optoGroup_indices_in_allCell('VGL');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(3,:) = [p,Wplus,numel(rowIds)];

%% Rhythmicity_groups
% ANA_RAT_GLOBALTABLE
% ANA_MOUSE_GLOBALTABLE
% FREE_MOUSE_GLOBALTABLE

load(fullfile(RESULTDIR,'cell_features','allCell.mat'));
load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'));

% putative pacemaker cells (CTB):
rowIds = get_rhGroup_indices_in_allCell('CTB');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(1,:) = [p,Wplus,numel(rowIds)];

% tonic theta cells (CTT):
rowIds = get_rhGroup_indices_in_allCell('CTT');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(2,:) = [p,Wplus,numel(rowIds)];

% theta skipping cells (CD):
rowIds = get_rhGroup_indices_in_allCell('CD_');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(3,:) = [p,Wplus,numel(rowIds)];

% follower cells (DT):
rowIds = get_rhGroup_indices_in_allCell('DT_');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(4,:) = [p,Wplus,numel(rowIds)];

% follower II. cells (NT):
rowIds = get_rhGroup_indices_in_allCell('NT_');
[p,Wplus] = wilcoxon_p_wplus(allCell(rowIds,mO('thetaFr')),allCell(rowIds,mO('deltaFr')));
allStat(5,:) = [p,Wplus,numel(rowIds)];
end