function raster_plot(IDs,tWindow)
%RASTER_PLOT Shows rasterplot of given MS units with hippo LFP.
%   RASTER_PLOT(IDS,TWINDOW) plots activity of the given cells (IDS) from 
%   one recording between TWINDOW(1) and TWINDOW(2) seconds.
%   Parameters:
%   IDS: 3x4 cell array containing 3 IDs (animalId, recordingId, shankId,
%   cellId) of MS cells (e.g. {20180821,1,4,23;20180821,1,4,34;20180821,1,4,38});
%   or a 1x3 vector containing rowIds (in allCell).
%   TWINDOW: 1x2 vector, (e.g. [832,844]).
%
%   See also EXAMPLE_CELLS_PLOT, CONVERT_IDS, HIPPO_STATE_DETECTION, 
%   PLOT_HIPPO_AND_CELLS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 23/06/2018

global RESULTDIR
global NSR

if nargin == 0
    variable_definitions; %rowIds, tWindow definitions
    figure('Position',get(0,'Screensize'));
end

IDs = convert_IDs(IDs);

animalId = IDs{1,1};
recordingId = IDs{1,2};

if ~exist('tWindow','var') % if timewindow is not specified
    load(fullfile(RESULTDIR, 'parameters'),'recordings');
    inx = find(recordings(:,1) == str2num([animalId,recordingId]));
    tWindow = [recordings(inx,2)-3,recordings(inx,2)+3]; % +/-3 sec around a given point
end

% % Total length of the recording (if allCell is already created, load it before):
% recLength = allCell(rowIds(1), mO('thetaLength')) + allCell(rowIds(1), mO('deltaLength'));
% if tWindow(2)*NSR>recLength % if too large window was given
%     tWindow = [0,recLength]/NSR;
% end

% Open hippocampal field plot:
hippo_state_detection(animalId,recordingId);
xlim(tWindow)
hold on
% legend(gca,'off')

% Length of lines in vertical (y) direction
% axis 'auto y'
% yLims = [-3,9];
yLims = ylim;
lineYLength = -diff(yLims) / size(IDs,1) / 2;
% yLims = [-3,8]; lineYLength = -0.5;
if size(IDs,1) == 1 % if there is only 1 cell
    lineYLength = -diff(yLims) / size(IDs,1) / 6;
end

for it = 1:size(IDs,1)
    shankId = IDs{it,3};
    cellId = IDs{it,4};
    
    % load AP timestamps (TS)
    TS = loadTS(animalId,recordingId,shankId,cellId);
    
    unitActsegm = TS(TS>tWindow(1)*NSR & TS<tWindow(2)*NSR);
    unitActsegm = unitActsegm/NSR;
    yCoords = [yLims(1)+lineYLength*(it-1),yLims(1)+lineYLength*it];
    plot_raster_lines_fast(unitActsegm,yCoords);
end

% text(repmat(tWindow(1),numel(rowIds),1), yLims(1)+(0:numel(rowIds)-1)*lineYLength, ...
%     num2str([allCell(rowIds, mO('shankId')),allCell(rowIds, mO('cellId'))]));
ylim([yCoords(2),yLims(2)])
% title([animalId,recordingId,', timewindow: ',num2str(tWindow),' (s)'])
end