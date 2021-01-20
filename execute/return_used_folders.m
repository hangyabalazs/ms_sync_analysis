function folderList = return_used_folders(folderList,delFiles,ptrns)
%RETURN_USED_FOLDERS Filter folder list.
%   FOLDERLIST = RETURN_USED_FOLDERS(FOLDERLIST,DELFILES,PTRNS) filter 
%   input FOLDERLIST based on given PTRNS patterns. DELFILES: logical, 
%   whether to remove files from list.
%   Example: Sort out system folders and unused animals/recordings (marked
%   with '.' and 'n', respectively).
%
%   See also COLLECT_ACTIVE_RECORDINGS. 

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/03/2019

if delFiles
    folderList(~[folderList.isdir]) = [];
end

for it = 1:length(ptrns)
    folderList(cellfun(@(x) ~isempty(strfind(x(1),ptrns{it})),{folderList.name})) = [];
end
end