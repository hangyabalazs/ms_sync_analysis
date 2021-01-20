function fileList = return_used_files(fileList,ptrns,isKeep)
%RETURN_USED_FILES Filters file list.
%   FILELIST = RETURN_USED_FILES(FILELIST?PTRNS,ISKEEP) sorts out system 
%   folders and unused folders (marked with 'n') from FILELIST.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/03/2019

fileList([fileList.isdir]) = [];

for it = 1:length(ptrns)
    if isKeep
        fileList(cellfun(@(x) isempty(strfind(x,ptrns{it})),{fileList.name})) = [];
    else
        fileList(cellfun(@(x) ~isempty(strfind(x,ptrns{it})),{fileList.name})) = [];
    end
end
end