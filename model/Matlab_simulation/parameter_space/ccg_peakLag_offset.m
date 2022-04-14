function [phases,h,f] = ccg_peakLag_offset(animalId,recordingId,maxlag,maxFr,toI,isPlot)
%CCG_PEAKLAG_OFFSET estimates in-phase and antiphase synchronization 
%(primarily in model simulations).
%   CCG_PEAKLAG_OFFSET combines simulated cells in all possible pairings 
%   from a recording (= fixed parameter arrangement) to calculate their
%   ccgs. The rhthmicity offset is defined as the closest to zero peak's
%   lag. Relative phase can be computed by dividing the offset lag with the
%   rhthmicity cycle length (= distance between the first two different- 
%   side peak lags). Proportions of in- and antiphasic ccgs is quantified 
%   by histograms. Primarily used in model parameter space exploration!
%   Parameters:
%   ANIMALIDN: string (e.g. '202106259').
%   RECORDINGID: string (e.g. '20').
%   MAXLAG: maximum shift in sampling rate (e.g.: 0.3*NSR).
%   MAXFR: maximum frequency of ccgs, used to calculate peak phase (e.g.: 6).
%   TOI: time of interest to compute ccgs. Can be 'theta', 'delta' or a
%   numerical vector containing timepoints (in NSR) of interest (e.g.: 6*NSR:15*NSR).
%   ISPLOT: logical, plot?
%
%   See also ALL_CCG, EXPLORE_PARAMETER_SPACE, SIMULATE_PARAMETER_SPACE, 
%   PLOT_INTERV_RASTER_CCG, MODEL_SYNCH_SCORE, COLLECT_PROPERTIES, 
%   MAIN_ANALYSIS, ORGANIZE_PARAMETER_SPACE_PNGS, MODEL_GLOBALTABLE_PAR,
%   MODEL_GLOBALTABLE_VAR, MODEL_PARAMETER_DEL, CCG_VARIANCE_CHANGE.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 30/03/2022

global PREPROCDIR
global RESULTDIR
global NSR
global CGBINS

if nargin == 0 
    variable_definitions; % animalId,recordingId,maxlag,maxFr,toI,(isPlot) definitions
end
nBins = maxlag/25; % number of histogram bins
sumAcgTresh = 0; % minimum threshold for acg integrals (e.g.: 0, if we dont
%filter ccgs)

% Create list of animalIds
if numel(animalId) == 8 % if we want to take the average of repetitions (-> last character is not specified)
    animalIds = listdir(PREPROCDIR,animalId);
    ['Average of ' num2str(numel(animalIds)) ' recordings!']
else
    animalIds = {animalId};
end

% Create cell pairs ID list:
cellPairs = cell_IdPairs(animalIds,recordingId);

% Compute all ccgs:
[allCorr,peakLags,sumacrs,cycT] = all_ccg(cellPairs,toI,maxlag,CGBINS,maxFr); % during stronger stimulation
phases = peakLags./cycT*2*pi; % extract phase values

h = histcounts(abs(phases(sumacrs>sumAcgTresh)),0:pi/4:pi,'Normalization','probability');

% Plot
if exist('isPlot','var')
    f = figure('Position',[10,50,1400,400])    
    % Plot all ccgs
    subplot(1,4,1)
    [~,inx] = sort(peakLags); % sort ccgs based on peak lags
    imageccgs(allCorr(inx,:),-maxlag:maxlag), hold on, plot(peakLags(inx),1:numel(inx),'r.')
    %         set(gca,'xtick',[1,maxlag+1,maxlag*2+1]), set(gca,'xticklabels',{-maxlag,0,maxlag})
    xlabel('Lag (ms)'), ylabel('cell pairs')
    title([animalId,' ',recordingId])
    % Plot theta peak lags histogram
    subplot(1,4,2)
    histogram(abs(peakLags(sumacrs>sumAcgTresh)),0:maxlag/nBins:maxlag,'Normalization','probability')
    xlabel('CCG peak lag (ms)')
    title(cellstr(num2str(convert_model_ID_parameter(recordingId))))
    % Phase histogram:
    subplot(1,4,3)
    histogram(abs(phases(sumacrs>sumAcgTresh)),0:pi/4:pi,'Normalization','probability')
    xlabel('peak phase (rad)')
    subplot(1,4,4), rose(phases(sumacrs>sumAcgTresh),0:pi/2:1.5*pi)
end
end