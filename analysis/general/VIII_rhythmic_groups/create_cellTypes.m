function create_cellTypes()
%CREATE_CELLTYPES Collects cell groups in one recording.
%   CREATE_CELLTYPES() creates a Matlab cell, collecting all rhythmic cells'
%   indices from the same recordings (columns: rhythimicity grups, rows: recordings).
%
%   See also MAIN_ANALYSIS, GENERATE_RH_GROUPS, BUILD_ALLCELL,
%   CREATE_CCG_NETWORK.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 23/06/2018

global RESULTDIR

% Load data table
load(fullfile(RESULTDIR, 'cell_features', 'allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features', 'allCellMap.mat'),'mO');

% Load rhythmicity table:
load(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');
nRhGroups = size(rhGroups,1); %number of rhythmicity groups

[recIDs, inx] = unique([allCell(:, mO('animalId')), allCell(:, mO('recordingId'))], 'stable', 'rows');

% cellTypes: 1st 2 columns are records ID, 2nd: CTB IDs in the record, 3rd: CTT IDs in the record ...
cellTypes = cell(size(recIDs,1), nRhGroups+2); %nRecordings x nRhythmicityGroups+2(animalId,recordingId) cell
cellTypes(:, 1:2) = num2cell(recIDs);

% Fill cellTypes:
inx = [inx; length(allCell(:, 2))+1]; % length(allCell(:, 2))+1 is the endpoint
for it = 1:size(recIDs,1) % go trough all recording
    % rhythmicity groups in the recording:
    actRhGroups = allCell(inx(it):inx(it+1)-1,mO('rhGroup'));
    for it2 = 1:length(actRhGroups)
        % store rowId in the appropriate column (rhythmGroup):
        cellTypes{it,actRhGroups(it2)+2}(end+1) = inx(it)+it2-1;
    end
end

groupTable = {'animalId','recordingId',rhGroups{:,1}};
save(fullfile(RESULTDIR, 'cell_features', 'cellTypes.mat'), 'cellTypes');
save(fullfile(RESULTDIR, 'cell_features', 'groupTable.mat'), 'groupTable');
end