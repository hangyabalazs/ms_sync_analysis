function stim = automatic_stimulation_detector(animalIdN,recordingIdN,stFr,issave)
%AUTOMATIC_STIMULATION_DETECTOR Detects stimulation segments.
%   STIM = AUTOMATIC_STIMULATION_DETECTOR(ANIMALIDN,RECORDINGIDN,STFR,ISSAVE)
%   calculates suggested stimulations segments (energy in STFR+/-2 Hz band
%   increase rapidly (>median(bandenergy)+mad(bandenergy)*2) and stays
%   there at least 5 secs (probably with interruptions ->
%   UNIFYING_AND_SHORT_KILLER).
%   Attention!! This doesnt return the original stimulation protocol, just
%   gives a more or less accurate suggestion!
%   Parameters:
%   ANIMALIDN: string (e.g. '20161750').
%   RECORDINGIDN: string (e.g. '1417').
%   STFR: stimulation frequency (e.g.: 20, hz)
%   ISSAVE: logical, save (if exist and true)?
%
%   See also UNIFYING_AND_SHORT_KILLER.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 26/01/2021

global NSR
global PREPROCDIR
global RESULTDIR

if ~exist('stFr','var')
    stFr = 20; % stimulation frequency (Hz)
end

% Hard coded:
minStimLe = 5 * NSR; % minimal stimulation lenght
stimFilter = fir1(1024,[stFr-2,stFr+2]/(NSR/2),'bandpass'); % stimulation filter

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

% Load radiatum data:
load(fullfile(PREPROCDIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_radiatum.mat']),'fieldPot');

% Filter:
filtFieldPot = filtfilt(stimFilter,1,fieldPot);
stimEnergy = abs(hilbert(filtFieldPot)); % energy in stimulation frequency band

%Search for signifcant parts:
thresh = median(stimEnergy) + mad(stimEnergy) * 2;
stim = stimEnergy >= thresh;
stim = unifying_and_short_killer(stim,minStimLe,minStimLe);
nplot(stimEnergy)
hplot(stim*thresh)

if exist('issave','var') & issave
%     savefig(fullfile(RESULTDIR,'STIMULATIONS',[animalId, recordingId]));
    saveas(gcf,fullfile(RESULTDIR,'STIMULATIONS',[animalIdN,recordingIdN,'.png']));
    close;
end
end