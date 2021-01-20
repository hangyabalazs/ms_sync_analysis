function generate_rh_groups()
%GENERATE_RH_GROUPS Creates possible rhythmicity group labels.
%   GENERATE_RH_GROUPS() creates all possible combinations of theta-delta
%   rhythmicities during the two states. Determines MS unit rhythmicities.
%
%   See also MAIN_ANALYSIS, BUILD_ALLCELL, CELL_GROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR

% rhGroups columns: [rhGroupID|rhythm_during_delta|rhythm_during_theta]
% (0: non-rhythmic, 1: delta-rhythmic, 2: theta-rhythmic, 3: not enough data)
rhGroups = {
    'CTB',2,2; % constitutive theta bursting
    'CTT',2,2; % constitutive theta tonic
    'CD_',1,1; % constitutive delta slow
    'TD_',2,1; % theta-delta cells (theta under delta, delta under theta)
    'DT_',1,2; % delta-theta cells
    'AT_',3,2; % not enough data-theta cells (absent-theta)
    'AD_',3,1; % not enough data-delta cells (absent-delta)
    'TA_',2,3; % theta-not enough data (theta-absent)
    'DA_',1,3; % delta-not enough data cells
    'AA_',3,3; % not enough data-not enough data cells (absent-absent)
    'AN_',3,0; % not enough data-nothing cells (absent-nothing)
    'NA_',0,3; % nothing- not enough data cells (nothing-absent)
    'NT_',0,2; % nothing-theta
    'ND_',0,1; % nothing-delta
    'TN_',2,0; % theta-nothing
    'DN_',1,0; % delta-nothing
    'NN_',0,0}; % nothing-nothing

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Find rhGroupId for all MS units: 
a = cell2mat(rhGroups(:,2:3));
for it = 1:size(allCell,1)
    % Pay attention to the order of actCell
    actCell = [allCell(it,mO('duringDelta')),allCell(it,mO('duringTheta'))];
    actRhGroup = find(ismember(a,actCell,'rows'));
    if length(actRhGroup) > 1 % in the case of constitutive theta cells
        if allCell(it,mO('thetaBurstInx')) > 0 % bursting
            actRhGroup = actRhGroup(1);
        elseif allCell(it,mO('thetaBurstInx')) < 0 % tonic
            actRhGroup = actRhGroup(2);
        end
    end
    allCell(it,mO('rhGroup')) = actRhGroup;
end

save(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');
save(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');

end