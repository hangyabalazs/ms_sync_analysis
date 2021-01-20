function create_ccgMatrixIds()
%CREATE_CCGMATRIXIDS Collects all corecorded intra and intergroup cell
%pairs.
%   CREATE_CCGMATRIXIDS() creates a 5x5 cell array, containing all possible 
%   (same recording) pairs (identified by rowIds in allCell matrix) from the
%   same (diagonal) and from different rhythmicity groups. 5 rhythmicity
%   groups are: CTB, CTT,CD, DT, NT.
%
%   See also PLOT_CCG_NETWORK, CREATE_CELLTYPES, CREATE_CCGMATRIX.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/05/2019

global RESULTDIR

if ~exist(fullfile(RESULTDIR,'cell_features','cellTypes.mat'))
    create_cellTypes();
    'cellTypes created'
end
load(fullfile(RESULTDIR, 'cell_features','cellTypes.mat'),'cellTypes');
load(fullfile(RESULTDIR, 'cell_features','groupTable.mat'),'groupTable');

CTBcol = find(cellfun(@(x) strcmp(x,'CTB'),groupTable));
CTTcol = find(cellfun(@(x) strcmp(x,'CTT'),groupTable));
CD_col = find(cellfun(@(x) strcmp(x,'CD_'),groupTable));
DT_col = find(cellfun(@(x) strcmp(x,'DT_'),groupTable));
NT_col = find(cellfun(@(x) strcmp(x,'NT_'),groupTable));
ccgMatrixIds = cell(5);

% Create all possible connections between and intra groups:
grouppairs = unique(nchoosek([1,1,2,2,3,3,4,4,5,5],2),'rows');

recordingTable = cellTypes(:,[CTBcol,CTTcol,CD_col,DT_col,NT_col]);
for it1 = 1:size(recordingTable,1) % go trough recordings
    for it2 = 1:size(grouppairs,1) % possible group connections
        grp1 = grouppairs(it2,1); % first rhythmicity group
        grp2 = grouppairs(it2,2); % second rhythmicity group
        group1 = recordingTable{it1,grp1};
        group2 = recordingTable{it1,grp2};
        if ~isempty(group1) & ~isempty(group2)
            [x,y] = meshgrid(group1,group2); % create all possible combinations
            pairIds = unique(sort([x(:),y(:)],2),'rows'); % delete duplications
            pairIds(pairIds(:,1)==pairIds(:,2),:) = []; % delete 'identical element' rows
            ccgMatrixIds{grp1,grp2} = [ccgMatrixIds{grp1,grp2};pairIds];
        end
    end
end

save(fullfile(RESULTDIR,'network','ccgMatrixIds.mat'),'ccgMatrixIds');
end