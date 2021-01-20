function unitAct = truncate_unitAct(unitAct,animalId,recordingId)
%TRUNCATE_UNITACT() Cuts undesired parts from septal recordings.
%   UNITACT = TRUNCATE_UNITACT(UNITACT,ANIMALID,RECORDINGID) takes a septal
%   unit's timeseries and removes certain segments of it.
%   Parameters:
%   UNITACT: binary vector, 1 where spikes, 0 elsewhere (sampled at NSR).
%   ANIMALIDN: string (e.g. '20180906').
%   RECORDINGIDN: string (e.g. '7').
%
%   See also LOADTS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 01/05/2020

global ROOTDIR

if strcmp(animalId(1),'n') 
    animalId = animalId(2:end);
end
if strcmp(recordingId(1),'n') 
    recordingId = recordingId(2:end);
end

% Load undesired timepoints:
load(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'keepSegm');
keepVec = ones(1,unitAct(end));
keepVec(keepSegm) = 0;

unitAct(keepVec(unitAct)==1) = [];
shifts = cumsum(keepVec).';
unitAct = unitAct - shifts(unitAct);
end