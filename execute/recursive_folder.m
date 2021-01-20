function [actFolderPath,folderPaths] = recursive_folder(actFolderPath,folderPaths)
%RECURSIVE_FOLDER Collects all subfolders paths.
%   [ACTFOLDERPATH,FOLDERPATHS] = RECURSIVE_FOLDER(ACTFOLDERPATH,
%   FOLDERPATHS) collect all folders and subfolders' full path.
%   Parameters:
%   ACTFOLDERPATH: parent folder path.
%   FOLDERPATHS: collection of folder paths.
%
%   See also COLLECT_ACTIVE_RECORDINGS, RETURN_USED_FOLDERS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

subfolders = return_used_folders(dir(actFolderPath),true,{'.','n'});
% subfolders = return_used_folders(dir(actFolderPath),true,{'.'});
if length(subfolders) > 0
    for it = 1:length(subfolders)
        actFolderPath = fullfile(actFolderPath,subfolders(it).name);
        [actFolderPath,folderPaths] = recursive_folder(actFolderPath,folderPaths);
    end
end
folderPaths{end+1} = actFolderPath;
% jump up one folder:
sepPos = strfind(actFolderPath, '\');
actFolderPath(sepPos(end):end) = [];
end