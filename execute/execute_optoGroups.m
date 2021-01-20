function execute_optoGroups(funcCallDef)
%EXECUTE_OPTOGROUPS Executes instructions on all optogroups.
%   EXECUTE_OPTOGROUPS(FUNCCALLDEF) iterates trough all opto groups 
%   executing FUNCCALDEF function call definition on each.
%   Parameters:
%   FUNCCALDEF: string (e.g. 'cell_groups(rowIds,[''opto_groups\'',optoGroups{it}]);').
%
%   See also MAIN_ANALYSIS, EXECUTE_ACTIVERECIDS, EXECUTE_RHGROUPS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/09/2020

optoGroups = {'CHT','PVR','VGA','VGL'};

for it = 1:numel(optoGroups)
    [rowIds,cellBNames,isDel,taggInd] = get_optoGroup_indices_in_allCell(optoGroups{it});
    if ~isempty(rowIds)
        eval(funcCallDef);
    end
end
end