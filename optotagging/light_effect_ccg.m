function light_effect_ccg(varargin)
%LIGHT_EFFECT_CCG Stimulations - action potentials correlation for a cell.
%   LIGHT_EFFECT_CCG() calculates stimulation AP correlation for the provided
%   cell.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 19/01/2019

if nargin == 0
    dataPath = 'D:\OPTOTAGGING\DATA';
    animalId = '20180906';
    recordingId = '7';
    shankId = '4';
    cellId = 67; % channel ID
    figure;
else
    dataPath = varargin{1};
    animalId = varargin{2};
    recordingId = varargin{3};
    shankId = varargin{4};
    cellId = varargin{5};
end

sr = 30000;
nsr = 1000;

% Cell activity:
clu = load(fullfile(dataPath,animalId, recordingId,[animalId,recordingId,'.clu.',num2str(shankId)]));
res = load(fullfile(dataPath,animalId, recordingId,[animalId,recordingId,'.res.',num2str(shankId)]));
actTime = round(res(clu==cellId)/(sr/nsr)); %activity pattern

% Stimulation time points:
[~, timestamps] = load_open_ephys_data_faster(fullfile(dataPath,animalId,recordingId,...
    '100_CH1.continuous'));
[data, stimTimestamps,info] = load_open_ephys_data_faster(fullfile(dataPath,animalId,recordingId,...
    'all_channels.events'));
stimPoints = stimTimestamps(data==2 & info.eventId==1);
stimPoints = stimPoints - timestamps(1);
stimPoints = round(stimPoints*nsr);

vecLength = max(stimPoints(end),actTime(end));
actPatternCell = zeros(vecLength, 1);
actPatternCell(actTime) = 1;
actPatternStim = zeros(vecLength, 1);
actPatternStim(stimPoints) = 1;

% Correlation
maxlag = nsr * 0.1;
[cor,lag] = xcorr(actPatternStim, actPatternCell, maxlag);
timeVec = -100:1000/nsr:100;
plot(timeVec, cor)
title([animalId,recordingId,' ',shankId,' ',num2str(cellId)])
end