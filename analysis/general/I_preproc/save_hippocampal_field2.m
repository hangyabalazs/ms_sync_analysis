function save_hippocampal_field2(animalIdN,recordingIdN,issave,isPyr,isCMR)
%SAVE_HIPPOCAMPAL_FIELD2 Saves one channel of hippo probe (insufficient
%memory).
%   SAVE_HIPPOCAMPAL_FIELD2(ANIMALIDN,RECORDINGIDN,ISSAVE,ISSAVE,ISPYR)
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
%   SAVE_SEPTAL_FIELD, SAVE_HIPPOCAMPAL_FIELD.

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

%Use this method if PC's memory is too small (if not, use save_hippocampal_field instead):
datafile = fopen(dataFile,'r');
finfo = dir(dataFile);
nRecordings = finfo.bytes/2/NLINCHANNELS; %if recording precision was int16
fieldPot = zeros(1, floor(nRecordings/(SR/NSR))); %Allocate resampled field potential

%we will read data by section and than concatenate them
%(reading immediately the whole data would crash the memory)
bufferseconds = 10;  %read 10 second (10*sampling rate)

%create resampled data vector:
for x = 1:(nRecordings/(bufferseconds*SR))
    data = fread(datafile,[NLINCHANNELS,SR*bufferseconds],'int16');
    fieldPot(((x-1)*NSR*bufferseconds+1):x*NSR*bufferseconds) = data(channelId, 1:(SR/NSR):end);
%     fieldPot(((x-1)*NSR*bufferseconds+1):x*NSR*bufferseconds) = data(chOrder(channel), 1:(SR/NSR):end);
end
%Read last section:
remData = nRecordings/SR-x*bufferseconds; %remaining data (in s)
data = fread(datafile,[NLINCHANNELS,SR*remData],'int16');
fieldPot(x*NSR*bufferseconds+1:x*NSR*bufferseconds+remData*NSR) = data(channelId, 1:(SR/NSR):end);
fclose(datafile);

if issave
    save(fullfile(PREPROCDIR,animalIdN,recordingIdN,fname),'fieldPot');
end
end