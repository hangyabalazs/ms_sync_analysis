function cell_groups(rowIds,trgtFolder)
%CELL_GROUPS Plots all calculated properties of a cell group.
%   CELL_GROUPS(ROWIDS,TRGTFOLDER) plots acgs, mean acgs, firing rate
%   boxplots, phase preferences for a given group of cells, identified by
%   ROWIDS (rowIds in allCell matrix).
%   Parameters:
%   ROWIDS: nCellx1 vector, containing rowIds in allCell matrix (e.g.
%   [437,439,448]).
%   TRGTFOLDER: optional, string. If exists plots are saved to
%   RESULTDIR\trgtFolder directory (e.g. 'rhythmic_groups\CTB').
%
%   See also MAIN_ANALYSIS, GENERATE_RH_GROUPS, BUILD_ALLCELL,
%   PLOT_PHASE_PREF_CIRCULAR, GET_RHGROUP_INDICES_IN_ALLCELL,
%   EXAMPLE_CELLS_PLOT, RHYTHMICITY_BAR, WILCOXON_P_WPLUS.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 18/04/2017

global RESULTDIR
global PHASEHISTEDGES
global CGWINDOW
global NSR

if nargin == 0
    variable_definitions; %rowIds,(trgtFolder) definitions
end

% Load data table
load(fullfile(RESULTDIR, 'cell_features','allCell.mat'),'allCell');
% Load map for allCell matrix (mO):
load(fullfile(RESULTDIR, 'cell_features','allCellMap.mat'),'mO');

%% All autocorrelations:
% Sort acgs based on theta-index-during-theta:
sortedCells1 = sortrows(allCell(rowIds,:),mO('ThAcgThInx'));

% Ticks and labels for displaying
w = CGWINDOW*NSR; % ACG length
xticks = [1,w/3,w/1.5,w/1.2,w,7*w/6,4*w/3,5*w/3,w*2];
xlabels = {-w,-w*2/3,-w/3,-w/6,0,w/6,w/3,w*2/3,w};

% During theta
H1 = figure;
imageccgs(sortedCells1(:,mO('thetaAcgFirst'):mO('thetaAcgLast')));
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
% set(gca,'xlim',[(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]) %limit between +/-2 sec
text(zeros(1,size(rowIds,1)),[1:size(rowIds,1)],...
    num2str(sortedCells1(:,[mO('animalId'), mO('recordingId'), mO('shankId'), mO('cellId')])));
title('During theta');
% During delta
H2 = figure;
imageccgs(sortedCells1(:,mO('deltaAcgFirst'):mO('deltaAcgLast')));
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels);
% set(gca,'xlim',[(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]) %limit between +/-2 sec
title('During delta');

%% Mean autocorrelations:
mThAcg = mean(allCell(rowIds,mO('thetaAcgFirst'):mO('thetaAcgLast'))); % mean theta acg
mDeAcg = mean(allCell(rowIds,mO('deltaAcgFirst'):mO('deltaAcgLast'))); % mean delta acg
H3 = figure;
plot(mThAcg), hold on, plot(mDeAcg)
set(gca,'xtick',xticks); set(gca,'xticklabel',xlabels)

%% Firing rate boxplot:
H4 = figure;
hold on, plot([ones(1,length(rowIds));ones(1,length(rowIds))*2],...
    allCell(rowIds,[mO('deltaFr'),mO('thetaFr')]).','Color',[0.1,0.1,0.1,0.2])
if size(rowIds,1)>1
    boxplot(allCell(rowIds,[mO('deltaFr'),mO('thetaFr')]),'Labels',{'delta','theta'},'Colors','k','Widths',2/3,'symbol','');
    frSignif = signrank(allCell(rowIds,mO('deltaFr')),allCell(rowIds,mO('thetaFr')));
    % title(frSignif)
end

%% Circular phase preferences:
allPoints = [allCell(:,mO('thetaFr'));allCell(:,mO('deltaFr'))];
tharrowColors = color_intensities(allPoints,rowIds);
dearrowColors = color_intensities(allPoints,rowIds+size(allCell,1));

% During theta:
ThHangs = allCell(rowIds,mO('thetaMA')); % mean resultant vector angle matrix during theta
ThHmvls = allCell(rowIds,mO('thetaMRL')); % mean resultant vector length matrix during theta
H5 = figure; hold on
thplotColor = [0,0.4470,0.7410];
plot_phase_pref_circular(ThHangs,ThHmvls,tharrowColors,PHASEHISTEDGES,thplotColor);

% During delta:
DeHangs = allCell(rowIds,mO('deltaMA')); % mean resultant vector angle matrix during delta
DeHmvls = allCell(rowIds,mO('deltaMRL')); % mean resultant vector length matrix during delta
H6 = figure; hold on
deplotColor = [0.850,0.325,0.098];
plot_phase_pref_circular(DeHangs,DeHmvls,dearrowColors,PHASEHISTEDGES,deplotColor);

%% Save
if exist('trgtFolder','var')
    savefig(H1,fullfile(RESULTDIR,trgtFolder,'allAcgTheta.fig'));
    savefig(H2,fullfile(RESULTDIR,trgtFolder,'allAcgDelta.fig'));
    savefig(H3,fullfile(RESULTDIR,trgtFolder,'meanAcg.fig'));
    savefig(H3,fullfile(RESULTDIR,trgtFolder,'firing_rates.fig'));
    savefig(H5,fullfile(RESULTDIR,trgtFolder,'phasePrefTheta.fig'));
    savefig(H6,fullfile(RESULTDIR,trgtFolder,'PhasePrefDelta.fig'));
end

% Collect all plots:
%     F = figure('Position',get(0,'Screensize'));
F = figure('Position',[1,41,1097,505]);
s = subplot(2,7,1:3); copy_figure_to_subplot(H1,F,s), xlim([(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]), title('Theta acgs')
s = subplot(2,7,8:10); copy_figure_to_subplot(H2,F,s), xlim([(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]), title('Delta acgs')
s = subplot(2,7,4:5); copy_figure_to_subplot(H3,F,s), xlim([(CGWINDOW-2)*NSR,(CGWINDOW+2)*NSR]), title('Mean acgs')
s = subplot(2,7,11:12); copy_figure_to_subplot(H4,F,s), title('Firing rates')
s = subplot(2,7,6:7); copy_figure_to_subplot(H5,F,s), axis equal, title('Theta phases')
s = subplot(2,7,13:14); copy_figure_to_subplot(H6,F,s), axis equal, title('Delta phases')
close([H1,H2,H3,H4,H5,H6])

if exist('trgtFolder','var')
    grpName = trgtFolder(find(trgtFolder=='\')+1:end);
    savefig(fullfile(RESULTDIR,trgtFolder,[grpName,'.fig']));
    close(F)
end
end