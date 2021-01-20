function cellBaseId = myName2cbName(animalId,recordingId,shankId,cellId)
%MYNAME2CBNAME Converts project conventional names to cellbase names.
%   CELLBASEID = MYNAME2CBNAME(ANIMALID,RECORDINGID,SHANKID,CELLID) 
%   converts a cellname to a cellbase name 
%   (e.g. myName2cbName('20180821','1',1,32) -> 'PVR02_180821a_1.32').
%   Parameters:
%   ANIMALID: string (e.g. '20180821').
%   RECORDINGID: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g 32).
%
%   See also CBNAME2MYNAME.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/09/2020

loadcb
recAlphabet = {'a','b','c','d','e','f','g','h','i','j'};

cellbaseId = [animalId(3:end),recAlphabet{str2num(recordingId)},'_1.',num2str(cellId)];
rowId = find(cellfun(@(x) endsWith(x,cellbaseId),CELLIDLIST));
cellBaseId = CELLIDLIST{rowId};
end