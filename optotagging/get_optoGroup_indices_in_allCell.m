function [rowIds,cellBNames,isDel,taggInd] = get_optoGroup_indices_in_allCell(optoGroup,isDel,taggInx)
%GET_OPTOGROUP_INDICES_IN_ALLCELL Returns rowIds of given opto gruop cells.
%   [ROWIDS,CELLBNAMES,ISDEL,TAGGIND] = GET_OPTOGROUP_INDICES_IN_ALLCELL(
%    OPTOGROUP,ISDEL,TAGGINX) get rowIds (in allCell matrix), cellbase 
%   names, tagging indices of cells belonging to the given optotagged group.
%   ISDELL logical vector tells which cells are not included in the analysis 
%   (isdell=1), or dont have enough spikes 
%   (median(diff(TS))>=500 | length(TS)<=500) (isdell=2).
%   Needs cellbase package to be downloaded and a CB initalized before 
%   runing this!
%   Parameter:
%   OPTOGROUP: string, specifying the optotagged group (e.g. 'PVR').
%   ISDEL: logical, delete automatically non/analyzed/noisy cells?
%   TAGGINX: optional, number, tagging index threshold (defult: 0.01).
%
%   See also BUILD_ALLCELL, GET_RHGROUP_INDICES_IN_ALLCELL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/09/2020

global RESULTDIR

if ~exist('taggInx','var') taggInx = 0.01; end

loadcb

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

inx = strmatch(optoGroup,CELLIDLIST);
inx(TheMatrix(inx,1)>taggInx) = [];
taggInd = TheMatrix(inx,1);
if isempty(inx)
    return
end
cellBNames = [CELLIDLIST(inx)];
isDel = zeros(numel(cellBNames),1);
rowIds = zeros(numel(cellBNames),1);
for it = 1:numel(cellBNames)
    [animalId,recordingId,shankId,cellId,isIncluded] = cbName2myName(cellBNames{it});
    if ~isIncluded
        %not included in the analysis
        isDel(it) = 1;
        rowIds(it) = NaN;
    else
        Id = [str2num(animalId),str2num(recordingId),str2num(shankId),str2num(cellId)];
        [~,rowId] = ismember(Id,allCell(:,mO('animalId'):mO('cellId')),'rows');
        rowIds(it) = rowId;
        %         if allCell(rowId,mO('thsumacr'))<THSUMACGTRESH |...
        %                 allCell(rowId,mO('desumacr'))<DESUMACGTRESH
        %             isDel(it) = 2;
        TS = loadTS(animalId,recordingId,shankId,cellId);
        if median(diff(TS))>=500 | length(TS)<=500 % not enough, rare spikes
            isDel(it) = 2;
        else
            isDel(it) = 0;
        end
    end
end

if exist('isDel','var')
    rowIds = rowIds(isDel==0);
    cellBNames = cellBNames(isDel==0);
    taggInd = taggInd(isDel==0);
    isDel = isDel(isDel==0);
end
end