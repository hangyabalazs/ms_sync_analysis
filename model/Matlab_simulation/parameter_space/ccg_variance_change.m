function ccgVarRatioMean = ccg_variance_change(animalId,recordingId,maxlag,maxFr,tStrong,tWeak,isPlot)
%CCG_VARIANCE_CHANGE estimates synchronization change between states from
%cell pairs ccgs.
%   CCG_VARIANCE_CHANGE combines simulated cells in all possible pairings 
%   from a recording (= fixed parameter arrangement) to calculate their
%   ccgs. It estimates ccg variance change between states (e.g.: theta vs. 
%   delta, or strong vs. weak excitation) for all cell pairs from a given 
%   recording (primarily in model simulations). The variance of the ccg
%   is dependent on synchronization.
%   Parameters:
%   ANIMALID: string (e.g. '202106259').
%   RECORDINGID: string (e.g. '20').
%   MAXLAG: maximum shift in sampling rate (e.g.: 0.3*NSR).
%   MAXFR: maximum frequency of ccgs, used to calculate peak phase (e.g.: 6).
%   TSTRONG: time of interest to compute ccgs (e.g.: strong excitation).
%   Can be 'theta', 'delta' or a numerical vector containing timepoints
%   (in NSR) of interest (e.g.: 6*NSR:15*NSR).
%   TWEAK: time of interest to compute ccgs (e.g.: weak excitation).
%   Can be 'theta', 'delta' or a numerical vector containing timepoints
%   (in NSR) of interest (e.g.: [1*NSR:5*NSR,16*NSR:20*NSR]).
%   ISPLOT: logical, plot?
%
%   See also CCG_PEAKLAG_OFFSET, ALL_CCG, EXPLORE_PARAMETER_SPACE, 
%   SIMULATE_PARAMETER_SPACE, PLOT_INTERV_RASTER_CCG, 
%   ORGANIZE_PARAMETER_SPACE_PNGS, MODEL_GLOBALTABLE_PAR,
%   MODEL_GLOBALTABLE_VAR, MODEL_PARAMETER_DEL.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 05/04/2022

global PREPROCDIR
global NSR
global CGBINS

if nargin == 0 
    variable_definitions; % animalId,recordingId,maxlag,maxFr,tStrong,tWeak,(isPlot) definitions
end

sumAcgTresh = 0; % minimum threshold for acg integrals (e.g.: 0, if we dont
%filter ccgs)

% Create list of animalIds
if numel(animalId) == 8 % if we want to take the average of repetitions
    animalIds = listdir(PREPROCDIR,animalId);
    ['Average of ' num2str(numel(animalIds)) ' recordings!']
else
    animalIds = {animalId};
end

% Create cell pairs ID list:
cellPairs = cell_IdPairs(animalIds,recordingId);

% Compute ccgs:
[allCorrStrong,peakLagsStrong,sumacrsStrong] = all_ccg(cellPairs,tStrong,maxlag,CGBINS,maxFr); %CGBINS*2!!!!!!!!!!!!!
[allCorrWeak,peakLagsWeak,sumacrsWeak] = all_ccg(cellPairs,tWeak,maxlag,CGBINS,maxFr); %CGBINS*2!!!!!!!!!!!!!
% thetaFilter = fir1(32,[3,6]/(NSR/2),'bandpass');
% allCorrStrong = filtfilt(thetaFilter,1,allCorrStrong.').';
% allCorrWeak = filtfilt(thetaFilter,1,allCorrWeak.').';
% % normalization after filtering:
% allCorrStrong = allCorrStrong./sum(allCorrStrong,2);
% allCorrWeak = allCorrWeak./sum(allCorrWeak,2);

% CUT FIRST AND LAST PARTS OF CCGS??, align peaks and plot average
ccgVarsStrong = var(allCorrStrong.');
ccgVarsWeak = var(allCorrWeak.');
ccgVarRatios = ccgVarsStrong./ccgVarsWeak;
ccgVarRatioMean = mean(ccgVarRatios(sumacrsStrong>sumAcgTresh & sumacrsWeak>sumAcgTresh));
ccgVarRatioMedian = median(ccgVarRatios(sumacrsStrong>sumAcgTresh & sumacrsWeak>sumAcgTresh));

% findMaxIn = maxlag/2+1:maxlag*1.5-1;
% shftccStrong = align_ccg_peaks(allCorrStrong.',findMaxIn,maxlag/2);
% shftccWeak = align_ccg_peaks(allCorrWeak.',findMaxIn,maxlag/2);

findMaxIn = maxlag*2/3+1:maxlag*4/3-1;
shftccStrong = align_ccg_peaks(allCorrStrong.',findMaxIn,maxlag*2/3);
shftccWeak = align_ccg_peaks(allCorrWeak.',findMaxIn,maxlag*2/3);

% Plot
if exist('isPlot','var')
    % Plot all ccgs
    figure('Position',[10,50,700,500])
    a1 = subplot(2,3,1:2)
    [~,inx] = sort(peakLagsStrong); % sort ccgs based on peak lags
    imageccgs(allCorrStrong(inx,:),-maxlag:maxlag), hold on, plot(peakLagsStrong(inx),1:numel(inx),'r.')
    title('All ccgs during stronger stimulation (sorted)')
    get(gcf,'zlim'), caxis([1.1,2.3]*1e-3)
    a2 = subplot(2,3,4:5)
    [~,inx] = sort(peakLagsWeak); % sort ccgs based on peak lags
    imageccgs(allCorrWeak(inx,:),-maxlag:maxlag), hold on, plot(peakLagsWeak(inx),1:numel(inx),'r.')
    title('All ccgs during weaker stimulation (rows DOESNT correspond to the top)')
    get(gcf,'zlim'), caxis([1.1,2.3]*1e-3)
    %
    linkaxes([a1,a2])
    subplot(2,3,3)
    plot(nanmean(shftccStrong.')), hplot(nanmean(shftccWeak.'))
    title({'Aligned ccgs mean (blue: strong, red: weak)', ...
        ['mean(var(ccgStrong)/var(ccgWeak)): ', num2str(ccgVarRatioMean)],...
        ['median(var(ccgStrong)/var(ccgWeak)): ', num2str(ccgVarRatioMedian)]})
end
end