function CTB_tagged_pie()
%CTB_TAGGED_PIE Overlaping percentage of pacemakers and PVR neurons.
%   CTB_TAGGED_PIE() percentage distribution of tagged groups in CTB cells.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 09/05/2020

global RESULTDIR
global THSUMACGTRESH
global DESUMACGTRESH

taggInx = 0.01;
CTBinx = get_rhGroup_indices_in_allCell('CTB'); 

[~,isDel,rowIds] = get_optoGroup_indices_in_allCell('VGL',taggInx);
rowIds = rowIds(isDel==0);
CTBPVRs = sum(ismember(rowIds,CTBinx))


% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Delete noisy cells:
nallCell = sum(allCell(:,mO('thsumacr'))>THSUMACGTRESH & allCell(:,mO('desumacr'))>DESUMACGTRESH);
% nallCell = sum(allCell(:,mO('thsumacr'))>THSUMACGTRESH | allCell(:,mO('desumacr'))>DESUMACGTRESH);
% nallCell = size(allCell,1);
nNN = length(get_rhGroup_indices_in_allCell('NN_')); % number of non rhythmic cells

grpPrcnt = zeros(1,length(rhythmGroups));
for it = 1:length(rhythmGroups)
    nGrp = length(get_rhGroup_indices_in_allCell(rhythmGroups{it}))
    grpPrcnt(it) = nGrp / nallCell;
%     grpPrcnt(it) = nGrp / nNN;
end
pieColorMap = grpColorMap(1:length(rhythmGroups),:);
pie(grpPrcnt), hold on
lgndNames = erase(rhythmGroups,'_');
lgndNames(grpPrcnt==0) = [];
legend(lgndNames)
pieColorMap(grpPrcnt==0,:) = [];
colormap(gca,pieColorMap)
end