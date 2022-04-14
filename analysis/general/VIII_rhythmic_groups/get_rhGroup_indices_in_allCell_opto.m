function rowIds = get_rhGroup_indices_in_allCell_opto(rhythmGroup)
%GET_RHGROUP_INDICES_IN_ALLCELL_OPTO Return rowIds of a given cell group.
%   ROWIDS = GET_RHGROUP_INDICES_IN_ALLCELL_OPTO(RHYTHMGROUP) get rowIds 
%   (in allCell matrix) of cells belonging to the given rhythmicity group. 
%   In opto project experiments the requirement for sufficiently active
%   cells was not based on the integral of the autocorrelation!!! Here the
%   minimal criteria concerned to the interspike intervals
%   (median(diff(TS))>=500) AND the number of spikes (length(TS)<=500)!!!
%   Parameter:
%   RHYTHMGROUP: string, specifying the rhythmicity group (e.g. 'CTB').
%   ROWIDS: vector, containing cells' row numbers in ALLCELL matrix.
%
%   See also GENERATE_RH_GROUPS, BUILD_ALLCELL,
%   GET_OPTOGROUP_INDICES_IN_ALLCELL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 05/04/2021

global RESULTDIR

% Load:
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell'); % data table
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO'); % map for allCell matrix (mO):
load(fullfile(RESULTDIR,'Fictious_cell_rhythmicity','thresholds','indexTresholds')); % rhythmicity index thresholds:

% Determine rhythmicities:
rhMatrix = zeros(size(allCell,1),2);
% During theta
rhMatrix(find(allCell(:,mO('ThAcgThInx'))/thetaThInxtrsh > max(allCell(:,mO('ThAcgDeInx'))/thetaDeInxtrsh,1)),1) = 2; % theta rhythmic
rhMatrix(find(allCell(:,mO('ThAcgDeInx'))/thetaDeInxtrsh > max(allCell(:,mO('ThAcgThInx'))/thetaThInxtrsh,1)),1) = 1; % delta rhythmic
rhMatrix(find(allCell(:,mO('ThAcgThInx'))<thetaThInxtrsh & allCell(:,mO('ThAcgDeInx'))<thetaDeInxtrsh),1) = 0; % non-rhythmic

% During delta
rhMatrix(find(allCell(:,mO('DeAcgThInx'))/deltaThInxtrsh > max(allCell(:,mO('DeAcgDeInx'))/deltaDeInxtrsh,1)),2) = 2; % theta rhythmic
rhMatrix(find(allCell(:,mO('DeAcgDeInx'))/deltaDeInxtrsh > max(allCell(:,mO('DeAcgThInx'))/deltaThInxtrsh,1)),2) = 1; % delta rhythmic
rhMatrix(find(allCell(:,mO('DeAcgThInx'))<deltaThInxtrsh & allCell(:,mO('DeAcgDeInx'))<deltaDeInxtrsh),2) = 0; % non-rhythmic

switch rhythmGroup
    case 'CTB'
        rowIds = find(ismember(rhMatrix,[2,2],'rows') & allCell(:,mO('thetaBurstInx'))>0);
    case 'CTT'
        rowIds = find(ismember(rhMatrix,[2,2],'rows') & allCell(:,mO('thetaBurstInx'))<0);
    case 'CD_'
        rowIds = find(ismember(rhMatrix,[1,1],'rows'));
    case 'DT_'
        rowIds = find(ismember(rhMatrix,[2,1],'rows'));
    case 'NT_'
        rowIds = find(ismember(rhMatrix,[2,0],'rows'));
    case 'NN_'
        rowIds = find(ismember(rhMatrix,[0,0],'rows'));
end

% Sufficient activity criteria (delete silent clusters):
isDel = zeros(1,numel(rowIds));
for it = 1:numel(rowIds)
    animalId = num2str(allCell(rowIds(it), mO('animalId')));
    recordingId = num2str(allCell(rowIds(it), mO('recordingId')));
    shankId = allCell(rowIds(it), mO('shankId'));
    cellId = allCell(rowIds(it), mO('cellId'));
    TS = loadTS(animalId,recordingId,shankId,cellId);
    if median(diff(TS))>=500 | length(TS)<=500
        isDel(it) = 1;
    end
end
rowIds(find(isDel)) = [];
end