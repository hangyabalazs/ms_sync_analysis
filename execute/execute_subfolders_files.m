function execute_subfolders_files(folderNames,funcCallDef,levelId,ptrn)
%EXECUTE_SUBFOLDERS_FILES Executes instructions on all subfolder levels.
%   EXECUTE_SUBFOLDERS_FILES(FOLDERNAMES,FUNCCALDEF,LEVELID,PTRN) iterates
%   trough all FOLDERNAMES (or subfolders at a given level LEVELID),
%   filtering files based on PTRN string, and executing FUNCCALDEF function
%   call definition on each.
%
%   See also EXECUTE_DATADIR, COLLECT_ACTIVE_RECORDINGS, EXECUTE_ACTIVERECIDS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 22/03/2021

if nargin == 0
    variable_definitions; %folderNames,funcCallDef,levelId,ptrn definitions
end

% execute_subfolders_files({'D:\ANA_MOUSE\DATA'},'s=dir(fName);output{cntr,2}=s.bytes;',2,'.dat')
% execute_subfolders_files({'D:\ANA_MOUSE\DATA'},'s=dir(fName);output{cntr,2}=s.bytes;',2,'128ch_probe')

% Get all relevant folders:
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

output = cell(1000,2);
cntr = 1;
for it1 = 1:length(allPath) % iterate trough all folders
    if exist('ptrn','var')
        fNames = listfiles(allPath{it1},ptrn);
    else
        fNames = listfiles(allPath{it1});
    end
    for it2 = 1:numel(fNames)
        fName = fullfile(allPath{it1},fNames{it2});
        output{cntr,1} = fName;
        eval(funcCallDef); % evaluate function call
        cntr = cntr + 1;
    end
end

output(cntr:end,:) = [];
end