function save_hippocampal_field(animalIdN,recordingIdN,issave,isPyr,isCMR)
%SAVE_HIPPOCAMPAL_FIELD Saves one channel of hippo probe (sufficient memory).
%   SAVE_HIPPOCAMPAL_FIELD(ANIMALIDN,RECORDINGIDN,ISSAVE,ISSAVE,ISPYR)
%   imports hippocampal field data, extracts radiatum  data
%   (pyramidal-0.4 mm in rat, -0.25 mm in mouse) and exports resampled
%   signal to .mat files.
%   After loads in the data choose the provided channel (based on
%   phase change (ROOTDIR\PYRAMIDAL_LAYER\) -> (channelID from
%   RESULTDIR\parameters.mat\recordings(:,4))), resamples it, and creates
%   a field potential vector.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   ISSAVE: logical, save?
%   ISPYR: optional, flag, if exist: save pyramidal layer.
%   ISCMR: optional, flag, make common median referencing across channels?
%
%   See also MAIN_ANALYSIS, PYRAMIDAL_PHASE_CHANGE, HIPPO_STATE_DETECTION,
%   SAVE_SEPTAL_FIELD,SAVE_HIPPOCAMPAL_FIELD2.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global NLINCHANNELS
global RESULTDIR
global DATADIR
global PREPROCDIR
global SR
global NSR

if nargin == 0
    variable_definitions; %animalIdN, recordingIdN, (issave,isPyr) definitions
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

% Find channelId:
load(fullfile(RESULTDIR, 'parameters'),'recordings');

if exist('isPyr','var') % save pyramidal layer
    fname = [animalId,'_',recordingId,'_pyramidal.mat'];
    channelId = recordings(recordings(:,1)==str2double([animalId,recordingId]),3);
else % save radiatum data
    fname = [animalId,'_',recordingId,'_radiatum.mat'];
    channelId = recordings(recordings(:,1)==str2double([animalId,recordingId]),4);
end

dataFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_hippo.dat']);

% If there is enough PC memory (if not, use save_hippocampal_field2 instead):
data = memmapfile(dataFile,'Format', 'int16');
% if binary file stores 32 samples, than 32 samples,... (every 32nd sample belongs to one channel)
data = reshape(data.Data,NLINCHANNELS,[]);
fieldPot = double(data(channelId,1:SR/NSR:end));

if exist('isCMR','var')
    CMRsignal = median(data,1); %common median referencing
    CMRsignal = double(CMRsignal(1:SR/NSR:end));
    fieldPot = fieldPot - CMRsignal;
end

if issave
    save(fullfile(PREPROCDIR,animalIdN,recordingIdN,fname),'fieldPot');
end

end