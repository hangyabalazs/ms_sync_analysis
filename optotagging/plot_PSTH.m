function plot_PSTH(cellBName,H)
%PLOT_PSTH Plots peri stimulus time histogram of the given cell.
%   PLOT_PSTH(CELLBNAME,H) plots PSTH of a specfied cell to a given figure.
%   Parameters:
%   CELLBNAME: string, cellbaseId of a cell (e.g. 'PVR02_180821a_1.32').
%   H: figure handle.
%
%   See also .

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: //

if nargin == 0
    H = figure;
    variable_definitions; %cellBName definition
end

TrigEvent = 'BurstOn';
SEvent = 'BurstOff';
win = [-0.45 0.45];
% parts = 'all';
parts = '#BurstNPulse';
dt = 0.001;
sigma = 0.001;
PSTHstd = 'on';
ShEvent = {{'PulseOn','PulseOff','BurstOff'}};
ShEvColors = hsv(length(ShEvent{1}));
ShEvColors = mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
viewcell2b(cellBName,'TriggerName',TrigEvent,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
    'FigureNum',H,'eventtype','stim','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
    'EventMarkerWidth',0,'PlotZeroLine','off')
end