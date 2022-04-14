function fieldPot = loadFieldPot(animalIdN,recordingIdN,isPyr)
%LOADFIELDPOT Loads hippo LFP data.
%   FIELDPOT = LOADFIELDPOT(ANIMALIDN,RECORDINGIDN) loads fieldPot of a 
%   recording, and cuts out stimulation (fmouse and opto) and 'noisy' parts
%   (amouse: TRUNCATE).
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   ISPYR: logical, flag, if exist and true: load pyramidal layer.
%
%   See also SAVE_HIPPOCAMPAL_FIELD, SAVE_SEPTAL_FIELD, 
%   HIPPO_STATE_DETECTION, LOADTS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global PROJECTID
global ROOTDIR
global PREPROCDIR

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

if exist('isPyr','var') & isPyr % load pyramidal layer
    load(fullfile(PREPROCDIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_pyramidal.mat']));
else % load radiatum data
    load(fullfile(PREPROCDIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_radiatum.mat']));
end
if ismember(PROJECTID,{'FREE_MOUSE','OPTOTAGGING'}) % cut out stimulation parts
    load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']),'stim');
    fieldPot(stim==1) = [];
    clear stim;
end
if exist(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'file')
    load(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'keepSegm');
    fieldPot = fieldPot(keepSegm);
end
end