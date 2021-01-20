function TS = cut_stimulation_from_unitAct(TS,animalIdN,recordingIdN)
%CUT_STIMULATION_FROM_UNITACT Removes stimulations segments from MS unit
%activity.
%   TS = CUT_STIMULATION_FROM_UNITACT(TS,ANIMALIDN,RECORDINGIDN) cuts
%   stimulation parts from hippocampal recordings.
%   Stimulation times are stored in ROOTDIR\STIMULATION folder.
%   Parameters:
%   TS: vector, containing spike times of a cell.
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%
%   See also LOADTS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 06/08/2018

global ROOTDIR

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

% Load stimulation timepoints:
load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId, '.mat']));

TS(stim(TS)==1) =[];
shifts = cumsum(stim).';
TS = TS - shifts(TS);
end