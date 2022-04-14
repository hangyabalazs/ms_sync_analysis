function rhGroup_pie(rhythmGroups)
%RHGROUP_RATIOS Plots rhythmicity groups distributions.
%   RHGROUP_RATIOS(RHYTHMGROUPS) percentage distribution of rhythmicity 
%   groups.
%   Parameters:
%   RHYTHMGROUPS: cell array, containing 3 letter rhgroupIds of the
%   rhythmicity groups to calculate their incidence 
%   (e.g.: {'CTB','CTT','CD_','DT_','NT_','NN_'}).
%
%   See also CELL_GROUPS, GENERATE_RH_GROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 02/01/2020

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH

if nargin == 0
    variable_definitions; %rhythmGroups deifnition
end

if strcmp(rhythmGroups,'allGrp')
    load(fullfile(RESULTDIR, 'cell_features','groupTable.mat'),'groupTable');
    rhythmGroups = groupTable(3:end);
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Delete noisy cells:
nallCell = sum(allCell(:,mO('thsumacr'))>THSUMACGTRESH & allCell(:,mO('desumacr'))>DESUMACGTRESH);
% nallCell = sum(allCell(:,mO('thsumacr'))>THSUMACGTRESH | allCell(:,mO('desumacr'))>DESUMACGTRESH);
% nallCell = size(allCell,1);
nNN = length(get_rhGroup_indices_in_allCell('NN_')); %number of non rhythmic cells

grpPrcnt = zeros(1,length(rhythmGroups));
pieColorMap = zeros(numel(rhythmGroups),3);
for it = 1:numel(rhythmGroups)
    nGrp = length(get_rhGroup_indices_in_allCell(rhythmGroups{it}));
    grpPrcnt(it) = nGrp/nallCell;
%     grpPrcnt(it) = nGrp/nNN;
    sColor = rhgroup_colors(rhythmGroups{it});
    pieColorMap(it,:) = sColor;
end
lgndNames = erase(rhythmGroups,'_');
lgndNames(grpPrcnt==0) = [];
pieColorMap(grpPrcnt==0,:) = [];
grpPrcnt(grpPrcnt==0) = [];
pie(grpPrcnt), hold on
legend(lgndNames)
colormap(gca,pieColorMap)
end