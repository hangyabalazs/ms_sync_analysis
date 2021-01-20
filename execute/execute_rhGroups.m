function execute_rhGroups(funcCallDef,m)
%EXECUTE_RHGROUPS Execeutes instructions on all rhythimcity groups.
%   EXECUTE_RHGROUPS(FUNCCALLDEF,M) iterates trough all rhythmicity groups
%   executing FUNCCALDEF function call definition on each.
%   Parameters:
%   FUNCCALDEF: string (e.g. 'cell_groups(rowIds,[''rhythmic_groups\'',rhGroups{it,1}]);').
%   M: optional, flag, if given, than it iterates trough only 'CTB', 'CTT', 
%   'CD_', 'DT_' and 'NT_' groups.
%
%   See also MAIN_ANALYSIS, EXECUTE_ACTIVERECIDS, EXECUTE_OPTOGROUPS,
%   GENERATE_RH_GROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR

load(fullfile(RESULTDIR,'rhythmic_groups','rhGroups'),'rhGroups');

if exist('m')
    [~,inx] = ismember({'CTB','CTT','CD_','DT_','NT_'},rhGroups(:,1));
    rhGroups = rhGroups(inx,:);
end

for it = 1:size(rhGroups,1)
    rowIds = get_rhGroup_indices_in_allCell(rhGroups{it,1});
    eval(funcCallDef);
end
end