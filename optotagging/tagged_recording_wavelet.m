function tagged_recording_wavelet(rowIds,tWindow)
%TAGGED_RECORDING_WAVELET is used to demonstarate that photostimulation of 
% glumaterg cells evokes theta in opto project (can be used for any
% arbitrary set of cells).
%   TAGGED_RECORDING_WAVELET first extracts the recording IDs where input 
%   ROWIDS cells (tagged cells) were recorded. It computes the wavelet 
%   spectra of hippo LFPs for all extracted, non-truncated (contains 
%   photostimulation and noisy parts) recordings and takes their average.
%   The increasing theta-delta frequency band power ratio between the 
%   begining of stimulation vs. immediately after its termination is 
%   visualized on a boxplot.
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   get_optoGroup_indices_in_allCell('VGL',1)).
%   TWINDOW: 1x2 vector, specifying time limits (e.g.: [1/NSR,400]).
%
%   See also WAVELET_AVERAGE, WAVELET_SPECTRUM.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 08/04/2022

global RESULTDIR

% HARD-CODED HERE:
nnsr = 10; % resampling rate for ploting

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

% Extract all unique recording IDs of cells in ROWIDS:
recIds = allCell(rowIds,mO('animalId'):mO('recordingId'));
unRecIds = unique(recIds,'rows');
nRecordings = size(unRecIds,1);

% Calculate average wavelet and theta-delta ratios:
[avgWavelet,f,thDeRatio] = wavelet_average(unRecIds,tWindow,nnsr,true);

% Plot:
% Wavelet average
figure 
timeVec = tWindow(1):1/nnsr:tWindow(2);
cLims = prctile(avgWavelet(:),[5,95]); % limit colors
% levels = cLims(1):diff(cLims)/100:cLims(2); % could keep white areas
levels = 0:cLims(2)/100:cLims(2);
contourf(timeVec,f,avgWavelet,levels,'LineStyle','none');
colormap('jet')
setmyplot_balazs
xlim([0,400]), xlabel('Times (s)'), set(gca,'xtick',[0,120,240,360])
ylim([0.5,6]), ylabel('Frequency (Hz)'), set(gca,'ytick',[0.5,3,6])

% Theta-delta power ratio change (at the begining of photostimulation 
% vs. immediately after):
figure 
p = signrank(thDeRatio(:,1),thDeRatio(:,2)); % statistics: paired signrank 
d = thDeRatio(:,1) - thDeRatio(:,2);
d(d == 0) = [];
R = tiedrank(abs(d));
Wplus = sum(R(d>0)); % W+ test statistics
Wminus = sum(R(d<0)); % W- test statistics

boxplot(thDeRatio(:),[repmat(1,nRecordings,1);repmat(2,nRecordings,1)],...
    'Labels',{'0-10 s','stim end +[0,10]  s'},'Colors','k','Widths',2/3,'symbol','');
% hold on, plot([ones(1,nRecordings);ones(1,nRecordings)*2],...
%     thDeRatio.','Color',[0.1,0.1,0.1,0.2]); % individual recordings
title(['Signrank, p = ',num2str(p)])
ylim([0,4]), ylabel('Theta-delta power ratio'), set(gca,'ytick',[0,1,2,3,4])
setmyplot_balazs
end