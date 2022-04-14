function [output,output1,output2] = execute_corecorded_pairs(rowIds,funcCallDef)
%EXECUTE_CORECORDED_PAIRS Execeutes instructions for all corecorded cells.
%   EXECUTE_CORECORDED_PAIRS(ROWIDS,FUNCCALLDEF) finds all cell pairs from
%   ROWIDS recorded together, and executes FUNCCALDEF function call 
%   definition on them.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   FUNCCALDEF: string (e.g. 'cross_correlation(animalId,recordingId,shankIds,cellIds)').
%   OUTPUT, OUTPUT1 and OUTPUT2: arrays (vector and cell), storing optional outputs.
%
%   See also MAIN_ANALYSIS, CROSS_CORRELATION, CELLS_WAVELET_COHERENCE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 20/05/2021

global RESULTDIR

if nargin == 0
    variable_definitions; %rowIds,funcCallDef definitions
end

load(fullfile(RESULTDIR,'cell_features','allCellMap.mat'),'mO'); % map object
load(fullfile(RESULTDIR,'cell_features','allCell.mat'),'allCell'); % all real cells data

% Extract all unique recording IDs of cells in ROWIDS:
recIds = allCell(rowIds,mO('animalId'):mO('recordingId'));
unRecIds = unique(recIds,'rows');

% Optional storages:
output = [];
output1 = zeros(1000,1);
output2 = cell(1000,1);
cntr = 1;
for it = 1:size(unRecIds,1)
    ind = find(ismember(recIds,unRecIds(it,:),'rows')); % find cells recorded together
    if numel(ind)>1 % at least one pair from the same recording
        pairIds = nchoosek(ind,2);
        for it2 = 1:size(pairIds,1)
            animalId = num2str(allCell(rowIds(pairIds(it2,1)),mO('animalId')));
            recordingId = num2str(allCell(rowIds(pairIds(it2,1)),mO('recordingId')));
            shankIds = allCell(rowIds(pairIds(it2,:)),mO('shankId'));
            cellIds = allCell(rowIds(pairIds(it2,:)),mO('cellId'));
            eval(funcCallDef);
            cntr = cntr + 1;
        end
    end
end
output1(cntr:end) = [];
output2(cntr:end) = [];
end