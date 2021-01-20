function TS = loadTS(animalId,recordingId,shankId,cellId)
%LOADTS Loads spiketimes of the provided cell
%   TS = LOADTS(ANIMALID,RECORDINGID,SHANKID,CELLID) loads spiketimes of 
%   the provided cell, and cuts out stimulation (fmouse and opto) and 
%   'noisy' parts (amouse: TRUNCATE).
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   SHANKID: number (e.g. 1).
%   CELLID: number (e.g. 2).
%   TS: vector, specifying timepoints of spikes.
%
%   See also GENERATE_TS_FILES, LOADFIELDPOT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global PROJECTID
global ROOTDIR
global PREPROCDIR

%load files:
load(fullfile(PREPROCDIR,animalId,recordingId,['TT',num2str(shankId),'_',num2str(cellId),'.mat']),'TS');
if ismember(PROJECTID,{'FREE_MOUSE','OPTOTAGGING'})
    TS = cut_stimulation_from_unitAct(TS,animalId,recordingId); % cut out stimulation parts
end
if exist(fullfile(ROOTDIR,'TRUNCATE',[animalId,'_',recordingId,'.mat']),'file')
    TS = truncate_unitAct(TS,animalId,recordingId);
end
end