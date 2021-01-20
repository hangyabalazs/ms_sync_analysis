function isTagged = isTaggedOpto(animalId,recordingId,cellIdFnameS,taggInx)
%ISTAGGEDOPTO Returns 1s for tagged cells, 0 for others.
%   ISTAGGED = ISTAGGEDOPTO(ANIMALID?RECORDINGID,CELLIDFNAMES,TAGGINX)
%   determines which cells are tagged from the input list.
%   Parameters:
%   ANIMALID: string (e.g. '20180814').
%   RECORDINGID: string (e.g. '1').
%   CELLIDFNAMES: string (e.g. 'TT2_32').
%   TAGGINX: optional, flag, tagging index threshold.
%   ISTAGGED: logical vector, containing 1 for tagged cells 1, 0 for
%   others.
%
%   See also HIPPO_FIELD_MS_UNIT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 27/08/2020

if ~exist('taggInx','var')
    taggInx = 0.05;
end
loadcb
isTagged = zeros(1,numel(cellIdFnameS));
for it = 1:numel(cellIdFnameS)
    [shankId,cellId] = cbId2shankcellId(cellIdFnameS{it});
    cbName = myName2cbName(animalId,recordingId,num2str(shankId),cellId);
    inx = strmatch(cbName,CELLIDLIST,'exact');
    isTagged(it) = TheMatrix(inx,1)<taggInx;
end

end