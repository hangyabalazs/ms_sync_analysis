function rowIds = get_rhGroup_indices_in_allCell(rhythmGroup)
%GET_RHGROUP_INDICES_IN_ALLCELL Return rowIds of a given cell group.
%   ROWIDS = GET_RHGROUP_INDICES_IN_ALLCELL(RHYTHMGROUP) get rowIds 
%   (in allCell matrix) of cells belonging to the given rhythmicity group.
%   Parameter:
%   RHYTHMGROUP: string, specifying the rhythmicity group (e.g. 'CTB').
%   ROWIDS: vector, containing cells' row numbers in ALLCELL matrix.
%
%   See also GENERATE_RH_GROUPS, BUILD_ALLCELL,
%   GET_OPTOGROUP_INDICES_IN_ALLCELL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Load rhythmicity table:
load(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');

rhIndex = find(ismember(rhGroups(:,1),{rhythmGroup})); % find rhythmicity groups index

% Find indices (in allCell matrix) of cells belonging to STR group
rowIds = find(allCell(:,mO('rhGroup')) == rhIndex);
end