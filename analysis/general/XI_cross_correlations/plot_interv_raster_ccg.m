function plot_interv_raster_ccg(animalId,recordingId,shankIds,cellIds,toI)
%PLOT_INTERV_RASTER_CCG shows the activity of a cell pair (raster) and
%crosscorrelation during a given time interval. Can be used to demonstrate
%antiphasic behaviour during stronger network excitation in model
%simulations.
%   Parameters:
%   ANIMALID: string (e.g. '202106259').
%   RECORDINGID: string (e.g. '20').
%   SHANKIDS: vector (e.g. [1,1]).
%   CELLID: vector (e.g [18,9]).
%   TOI: vector, time of interest (e.g.: [6*NSR,15*NSR])
%
%   See also CCG_PEAKLAG_OFFSET, ALL_CCG, EXPLORE_PARAMETER_SPACE, 
%   SIMULATE_PARAMETER_SPACE, PLOT_INTERV_PHASE_PREF.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 31/03/2022

global NSR
global CGBINS

if nargin == 0
    variable_definitions; %animalId,recordingId,shankIds,cellIds,toI definitions
end

% Load data:
TS1 = loadTS(animalId,recordingId,shankIds(1),cellIds(1)); % cell 1
TS1trunc = TS1(TS1>toI(1) & TS1<toI(2));
TS2 = loadTS(animalId,recordingId,shankIds(2),cellIds(2)); % cell 2
TS2trunc = TS2(TS2>toI(1) & TS2<toI(2));

figure
subplot(2,1,1), hold on % raster plot
plot_raster_lines_fast(TS1trunc/NSR,[0,1]);
plot_raster_lines_fast(TS2trunc/NSR,[1,2]);
subplot(2,1,2) % crosscorrelation
[normLrCor,sumacr,lags] = correlation(TS1trunc,TS2trunc,...
            false,[0,0,0],0.5*NSR,CGBINS,'integrating');
title([animalId,' ',recordingId,', cells (sh1, sh2, cell1, cell2): ',num2str(shankIds),' ',num2str(cellIds)])
end