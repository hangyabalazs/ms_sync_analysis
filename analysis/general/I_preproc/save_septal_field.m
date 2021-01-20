function save_septal_field(animalIdN,recordingIdN,channelId,issave,isCMR)
%SAVE_SEPTAL_FIELD Saves one channel of septal probe.
%   SAVE_SEPTAL_FIELD(ANIMALIDN,RECORDINGIDN,CHANNELID,ISSAVE) imports 
%   multichannel septal field data and exports the given channel's 
%   resampled signal to a .mat file.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   CHANNELID: number (e.g. 9).
%   ISSAVE: logical, save?
%   ISCMR: optional, flag, make common median referencing across channels?
%
%   See also MAIN_ANALYSIS, SAVE_HIPPOCAMPAL_FIELD, HIPPO_STATE_DETECTION,
%   SAVE_HIPPOCAMPAL_FIELD2.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NSEPTALCHANNELS
global DATADIR
global PREPROCDIR
global SR
global NSR

if nargin == 0
    variable_definitions; %animalIdN,recordingIdN,channelId,(issave) definitions
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

dataFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_septum.dat']);
data = memmapfile(dataFile,'Format', 'int16');
%if binary file stores NSEPTALCHANNELS samples, than NSEPTALCHANNELS samples,... 
%(every NSEPTALCHANNELSth sample belongs to one channel)
% data = reshape(data.Data,NSEPTALCHANNELS(2),[]); % In Opto recordings...
data = reshape(data.Data,NSEPTALCHANNELS(1),[]);
fieldPot = double(data(channelId,1:SR/NSR:end));

if exist('isCMR','var')
    CMRsignal = median(data,1); %common median referencing
    CMRsignal = double(CMRsignal(1:SR/NSR:end));
    fieldPot = fieldPot - CMRsignal;
end

if issave
    save(fullfile(PREPROCDIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_septum.mat']),'fieldPot');
end

end