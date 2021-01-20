function execute_subfolders(folderNames,funcCallDef,levelId)
%EXECUTE_SUBFOLDERS Executes instructions on all subfolder levels.
%   EXECUTE_SUBFOLDERS(FOLDERNAMES,FUNCCALDEF,LEVELID) iterates trough all 
%   FOLDERNAMES (and subfolders at a given level LEVELID) executing 
%   FUNCCALDEF function call definition on each.
%
%   See also EXECUTE_DATADIR, COLLECT_ACTIVE_RECORDINGS, EXECUTE_ACTIVERECIDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 31/10/2020

if nargin == 0
    variable_definitions; %folderNames,funcCallDef,levelId definitions
end

allPath = {};
for it1 = 1:length(folderNames)
    [~,folderPaths] = recursive_folder(folderNames{it1},{});
    % Delete folders above and below the given folder level
    if exist('levelId','var')
        origLevel = length(strfind(folderNames{it1},'\'));
        keepId = ones(length(folderPaths),1);
        for it2 = 1:length(folderPaths)
            actLevel = length(strfind(folderPaths{it2},'\'))-origLevel;
            if ismember(actLevel,levelId)
                keepId(it2) = 0;
            end
        end
        folderPaths(find(keepId)) = [];
        allPath = [allPath,folderPaths];
    end
end

for it1 = 1:length(allPath) % iterate trough all folders
    eval(funcCallDef); % evaluate function call
end

end