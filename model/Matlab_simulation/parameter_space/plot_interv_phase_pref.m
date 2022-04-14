function plot_interv_phase_pref(toI)
%PLOT_INTERV_PHASE_PREF calculates phase preference relative to a signal's
%phase on an interval for all simulated cells. Designed to demonstrate
%antiphasic behaviour during stronger network excitation in model
%simulations (if exists...).
%   Parameters:
%   TOI: vector, time of interest (e.g.: [6*NSR,15*NSR])
%
%   See also CCG_PEAKLAG_OFFSET, ALL_CCG, EXPLORE_PARAMETER_SPACE, 
%   SIMULATE_PARAMETER_SPACE, PLOT_INTERV_RASTER_CCG.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 31/03/2022

global PHASEHISTEDGES

% This snippet of code is repeated for all cells. Specify here the signal
% (e.g.: in model: theoretic hippocampal signal (summed activity of 
% simulated cells)) and the filter (e.g.: theta filter between 2 and 5 Hz).
% Calculate theta phase preference during given intervals (for all 
% simulations' all cells):
funcCallDef = ['fieldPot = loadFieldPot(animalId,recordingId);',...
    'fieldAngs = angle(hilbert(filtfilt(fir1(1024,[2,5]/500,''bandpass''),1,fieldPot)));',...
    'TS = loadTS(animalId,recordingId,shankId,cellId);',...
    '[~,hang,hmvl] = phase_pref(TS(',num2str(toI(1)),'<TS & ',num2str(toI(2)),'>TS),fieldAngs,false,PHASEHISTEDGES);',...
    'output2{cntr} = [hang,hmvl,sum(',num2str(toI(1)),'<TS & ',num2str(toI(2)),'>TS)];'];
[~,cellsData,IDs] = execute_activeRecIds(funcCallDef,'cell');
cellsData = cell2mat(cellsData);

% Plot
recIds = unique(IDs(:,1:2),'rows');
for it = 1:size(recIds,1) % iterate trough all recordings (= 1 parameter arrangement in model simulations)
    ccg_peakLag_offset(num2str(recIds(it,1)),num2str(recIds(it,2)),300,6,toI(1):toI(2),true)% ccg antiphase from cell pair recordings
    figure('Position',[1000,400,250,250]), hold on
    rowIds = find(ismember(IDs(:,1:2),recIds(it,:),'rows'));
    arrowColors = color_intensities(cellsData(:,3),rowIds); % get firing rate dependent color intensities
    plot_phase_pref_circular(cellsData(rowIds,1),cellsData(rowIds,2),arrowColors,PHASEHISTEDGES,[0,1,0]);
%     set(gca,'Visible','on'), title(num2str(recIds(it,:)))
    close all % place breakpoint here
end
end