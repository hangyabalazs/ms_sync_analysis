function [animalId,recordingId,shankId,cellId,isIncluded] = cbName2myName(cellBaseId)
%CBNAME2MYNAME Converts cellbase name to project conventional name.
%   [ANIMALID,RECORDINGID,SHANKID,CELLID,ISINCLUDED] = CBNAME2MYNAME(
%   CELLBASEID) converts a cellbase name to animalId, recordingId, shankId,
%   cellId. (e.g. cbName2myName('PVR02_180821a_1.32') -> '20180821','1',1,32).
%   ISINCLUDED tells if the cell was included in the analysis.
%   Parameters:
%   CELLBASEID: string (e.g. 'PVR02_180821a_1.32').
%
%   See also MYNAME2CBNAME.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/09/2020

global PREPROCDIR

recAlphabet = {'a','b','c','d','e','f','g','h','i','j'};
animalId = ['20',cellBaseId(7:12)];
recordingId = num2str(find(cellfun(@(x) isequal(x,cellBaseId(13)),recAlphabet)));
cellId = cellBaseId(strfind(cellBaseId,'.')+1:end);
% cellFiles = listfiles(fullfile(CELLBASEDIR,cellBaseId(1:5),cellBaseId(7:13)),'TT');
isIncluded = 1;
if ~exist(fullfile(PREPROCDIR,animalId),'dir') %& exist(fullfile(PREPROCDIR,['n',animalId]),'dir')
    animalId = ['n',animalId];
    isIncluded = 0;
end
if ~exist(fullfile(PREPROCDIR,animalId,recordingId),'dir') %& exist(fullfile(PREPROCDIR,animalId,['n',recordingId]),'dir')
    recordingId = ['n',recordingId];
    isIncluded = 0;
end

if isIncluded
    % Determine shankId:
    cellFiles = listfiles(fullfile(PREPROCDIR,animalId,recordingId),'TT');
    outputs = regexp(cellFiles,['TT(\d)_',num2str(cellId),'.mat']);
    ind = find(~cellfun('isempty',outputs));
    shankId = cellFiles{ind}(3);
else
    shankId = 0;
end
end