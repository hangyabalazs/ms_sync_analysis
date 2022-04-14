function frequency_synchronization_opto(rhGrp,optoGrp)
%FREQUENCY_SYNCHRONIZATION_OPTO Calculates and plots rhythmicity speed 
%differences of RHGRP cells, where at least one of the pair is tagged 
%(mouse Cre-line: OPTOGRP).
%   Parameters:
%   RHGRP: three letter abbreviation for one rhthmicity group (e.g.:
%   'CTB').
%   OPTOGRP: three letter abbreviation for one optotagged group (e.g.:
%   'PVR').
%
%   See also: FREQUENCY_SYNCHRONIZATION, GROUP_SYNCHRONIZATION.

%   Author: Barnabas Kocsis
%   Institute of Experimental Medicine, MTA
%   Date: 16/02/2022

global RESULTDIR
global MSTHBAND

% tagged & RHGROUP (weaker def.) cells' rowIds:
RHweak = get_rhGroup_indices_in_allCell_opto(rhGrp); % weaker definition of RHGRP cells
tagged = get_optoGroup_indices_in_allCell(optoGrp,1); % tagged cells
taggedRHs = intersect(RHweak,tagged); % tagged RHGROUP cells, condition: at least one member of the pair should be tagged

% Calculate group synchronization measures:
group_synchronization(taggedRHs,'PVR_PACEMAKER_SYNCH',[MSTHBAND;MSTHBAND]);

%% Replace frequency synchronization with PV+CTB(weaker) AND CTB(stronger) pairs!!!
RHstrong = get_rhGroup_indices_in_allCell(rhGrp); % conservative definition of RHGRP cells (tagged and non-tagged)
rowIds = union(taggedRHs,RHstrong); % tagged RHGRP(weaker) cell OR RHGRP(stronger) cells
% (nRowIds != nCTBstrong since the weaker definition of pacemakers...)
[thPoints,dePoints,nPoints,IDs,condPairs] = frequency_synchronization(rowIds,[MSTHBAND;MSTHBAND],taggedRHs);
save(fullfile(RESULTDIR,'PVR_PACEMAKER_SYNCH','frequency_synchronization'),...
        'thPoints','dePoints','IDs','nPoints');
resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
    'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
    'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
    'D:\OPTOTAGGING\analysis\final_analysis\PVR_PACEMAKER_SYNCH'};
signRanks = plot_synchronization_theories(resPaths);

% Statistics:
[p,Wplus] = wilcoxon_p_wplus(thPoints,dePoints)
        
% Replot (tagged & RHGROUP cells) & (tagged & RHGROUP) pairs on scatter
closebut(figure(26)); hold on
[sColor,symbol,markerSize] = dataset_colors('OPTOTAGGING');
eval(['scatter(thPoints(condPairs),dePoints(condPairs),markerSize,[1,0,0],',symbol,')']); % plot
% boxplots:
figure('Position',[510,50,150,500]); hold on, title(signRanks(6,4))
boxplot([dePoints,thPoints],'Labels',{'Non-theta','Theta'},'Colors','k','Widths',2/3,'symbol','');
figure('Position',[510,50,150,500]); hold on, title(signRanks(6,4))
boxplot(thPoints-dePoints,'Labels','Theta- Non-theta','Colors','k','Widths',2/3,'symbol','');
end