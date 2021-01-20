function pyramidal_phase_change(animalIdN,recordingIdN,tWindow)
%PYRAMIDAL_LAYER_PHASE_CHANGE Helps to find hippocampal pyramidal layer.
%   PYRAMIDAL_LAYER_PHASE_CHANGE(ANIMALIDN,RECORDINGIDN,TWINDOW) 
%   identifying hippocampal pyramidal layer based on theta phase reversal 
%   between adjacent channels.
%   Reads in a channel-ordered binary file and plots a TWINDOW (1x2
%   vector: start and endpoint in s) segment of the whole recording, both
%   theta-filtered and raw data. Choose an appropriate TWINDOW during theta
%   oscillation.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '3').
%   TWINDOW: 1x2 vector, (e.g. [366,376]).
%
%   See also MAIN_ANALYSIS, SAVE_HIPPOCAMPAL_FIELD, HIPPO_STATE_DETECTION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global PROJECTID
global ROOTDIR
global NLINCHANNELS
global DATADIR
global SR
global NSR
global HPTHBAND

if nargin == 0
    variable_definitions; %animalIdN, recordingIdN, tWindow definitions
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

dataFile = fullfile(DATADIR,animalIdN,recordingIdN,[animalId,'_',recordingId,'_hippo.dat']);
data = memmapfile(dataFile,'Format', 'int16');
%if binary file stores NSEPTALCHANNELS samples, than NSEPTALCHANNELS samples,... 
%(every NSEPTALCHANNELSth sample belongs to one channel)
data = reshape(data.Data,NLINCHANNELS,[]);
allCH = double(data(:,1:SR/NSR:end)).';

if ismember(PROJECTID,{'FREE_MOUSE','OPTOTAGGING'}) % cut out stimulation parts
    load(fullfile(ROOTDIR,'STIMULATIONS',[animalId,recordingId,'.mat']),'stim');
    allCH(stim==1,:) = [];
end

% Theta filter:
firOrder = 1024;
if size(allCH)<firOrder*3 
    firOrder = 64,
end %short data -> firOrder would be too large
thetaFilter = fir1(firOrder,HPTHBAND/(NSR/2),'bandpass');
thetaFeeg = filtfilt(thetaFilter,1,allCH);

% Plot theta filtered signal
thetaSegm = thetaFeeg(tWindow(1)*NSR:tWindow(2)*NSR,:);
thetaSegmCAR = thetaSegm - median(thetaSegm,1); % median referencing
% figure, plotMat(fliplr(thetaSegmCAR),'shft',1000); % bottom channel: tip
figure, plotMat(fliplr(thetaSegmCAR),'shft',1000);

% Plot raw data (In fmouse stim segments are stil there!):
rawSegm = double(data(:,tWindow(1)*SR:tWindow(2)*SR)).';
rawSegmCAR = rawSegm - median(rawSegm,1);
figure, plotMat(fliplr(rawSegmCAR),'shft',1000)
% figure, plotMat(fliplr(rawSegmCAR),'shft',4000)
hold on, plot([1,SR],[0,0],'k','LineWidth',2) % 1 sec bar
plot([1,1],[0,1/0.000195],'k','LineWidth',2) % 1 mV bar
end