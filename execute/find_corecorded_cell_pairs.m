function indPairs = find_corecorded_cell_pairs(rowIds1,rowIds2)
%FIND_CORECORDED_CELL_PAIRS() creates all possible pairings from the two 
% input list of cells (can be identical lists), when they are from the same
% recording. (In model simulations recordings = fixed parameter arrangement).
%   Parameters:
%   ROWIDS1: vector, containing cells' row numbers in ALLCELL matrix (e.g.:
%   get_rhGroup_indices_in_allCell('CTB')).
%   ROWIDS2: vector, containing cells' row numbers in ALLCELL matrix (e.g.:
%   get_rhGroup_indices_in_allCell('CTT')).
%
%   See also CCG_SCORE_TEST, ALL_CCG, CELL_IDPAIRS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 14/04/2022

global RESULTDIR

load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO'); % map object
load(fullfile(RESULTDIR,'cell_features','allCell.mat'),'allCell'); % all real cells data

recIds2 = [allCell(rowIds2,mO('animalId')),allCell(rowIds2,mO('recordingId'))];

cntr = 1;
indPairs = zeros(15000,2);
for it = 1:numel(rowIds1)
    recId1 = [allCell(rowIds1(it),mO('animalId')),allCell(rowIds1(it),mO('recordingId'))];
    ind = find(ismember(recIds2,recId1,'rows'));
    ind(rowIds2(ind) == rowIds1(it)) = []; % erase self comparison
    nPairs = numel(ind);
    if nPairs > 0
        indPairs(cntr:cntr+nPairs-1,:) = [repmat(rowIds1(it),numel(ind),1),rowIds2(ind)];
        cntr = cntr + nPairs;
    end
end
indPairs(cntr:end,:) = []; % remove excess
indPairs = unique(sort(indPairs,2),'rows'); % remove mirrored lines
end