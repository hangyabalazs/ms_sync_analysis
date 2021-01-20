function plot_hippo_and_cells(animalIdN,recordingIdN,shankIds,cellIds,channelId,tWindow)
%PLOT_HIPPO_AND_CELLS Shows rasterplot of given MS units with hippo LFP.
%   PLOT_HIPPO_AND_CELLS(ANIMALIDN,RECORDINGIDN,SHANKIDS,CELLIDS,CHANNELID,
%   TWINDOW) plots activity of the given cells (ROWIDS) from one
%   recording between TWINDOW(1) and TWINDOW(2) seconds.
%   Parameters:
%   ANIMALIDN: string (e.g. '20100304').
%   RECORDINGIDN: string (e.g. '1').
%   SHANKIDS: number vector, (e.g. [1,2]).
%   CELLIDS: number vector, (e.g [2,3]).
%   CHANNELID: number (e.g.: 32).
%   TWINDOW: 1x2 vector, time window to extract spikes and hippo signal 
%   (e.g. [832,844]).
%
%   See also RASTER_PLOT.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 23/06/2018

global DATADIR
global NSEPTALCHANNELS
global SR

if nargin == 0
    variable_definitions; %animalId,recordingId,shankIds,cellIds,channelId,tWindow definitions
    figure('Position',get(0,'Screensize'));
end

animalId = regexprep(animalIdN,'n',''); % remove n from filename begining
recordingId = regexprep(recordingIdN,'n',''); % remove n from filename begining

% load septum:
dataFile = fullfile(DATADIR,animalId,recordingId,[animalId,'_',recordingId,'_septum.dat']);
data = memmapfile(dataFile,'Format', 'int16');
data = reshape(data.Data,NSEPTALCHANNELS,[]);
fieldPot = double(data(channelId,tWindow(1)*SR:tWindow(2)*SR));
% filter
% bandpFilter = fir1(1024,[600,6000]/(SR/2),'bandpass');
% bandPPot = filtfilt(bandpFilter,1,fieldPot);
figure, hold on
plot(normalize(fieldPot,'range'),'k')
% plot(normalize(bandPPot,'range')+1,'k')
hold on, plot([0,0],[0,0.2/0.000195/range(fieldPot)],'k') % 0.2 mV bar
plot([0,0.05*SR],[0,0],'k') % 50 ms bar
yLims = ylim;
lineYLength = -diff(yLims)/numel(shankIds)/10;

for it = 1:length(shankIds)
    % load cell's activity:
    clu = load(fullfile(DATADIR,animalId,recordingId,[animalId,recordingId,'.clu.',num2str(shankIds(it))]));
    res = load(fullfile(DATADIR,animalId,recordingId,[animalId,recordingId,'.res.',num2str(shankIds(it))]));
    TS = res(clu==cellIds(it)).'; %activity pattern
    TS = TS(tWindow(1)*SR<TS & tWindow(2)*SR>TS)-tWindow(1)*SR;
    
%     plot([TS;TS],[-0.5;-0.01],'k','LineWidth',1)
    yCoords = [yLims(1)+lineYLength*(it-1),yLims(1)+lineYLength*it];
    plot_raster_lines_fast(TS,yCoords);
end

end