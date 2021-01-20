function rowIds = find_rowIds(animalId,recordingId,shankIds,cellIds)
%FIND_ROWID Returns rowIDs of given cells in ALLCELL matrix.
%   ROWIDS = FIND_ROWID(ANIMALID,RECORDINGID,SHANKIDS,CELLIDS) finds row 
%   ID in allCell matrix based on animalId, recordingId, shankId, cellId.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   SHANKIDS: number vector, (e.g. [1,2]).
%   CELLIDS: number vector, (e.g [2,3]).
%
%   See also RASTER_PLOT, BUILD_ALLCELL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 23/06/2018

global RESULTDIR

if isstr(animalId)
    animalId = str2num(animalId);
end
if isstr(recordingId)
    recordingId = str2num(recordingId);
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

rowIds = zeros(length(cellIds), 1);
for it = 1:length(cellIds)
    rowIds(it) = find(allCell(:, mO('animalId')) == animalId & ...
        allCell(:, mO('recordingId')) == recordingId & ...
        allCell(:, mO('shankId')) == shankIds(it) & ...
        allCell(:, mO('cellId')) == cellIds(it));
end
end