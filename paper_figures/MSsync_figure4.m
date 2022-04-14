function MSsync_figure4()
% Requires almost all steps from MAIN_ANALYSIS (I-IX., XI. steps)!
% This code relies on (included in MAIN_ANALYSIS):
% - Figure 4: you need to run first GROUP_SYNCHRONIZATION for the calculation of
% synchronization measures!!
% - Figure S17: you need to run first CREATE_CCGMATRIX for the calculation of
% cross correlations between rhythmicity groups!!
% - Figure S22

%% Figure 4 (pacemaker synchronization):
resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH'};
plot_synchronization_theories(resPaths);
% panel A: firing rate
savefig(figure(1),'panelA_1.fig')
savefig(figure(2),'panelA_2.fig')
savefig(figure(7),'panelA_3.fig')

% panel B: rhythmicity frequency difference
savefig(figure(11),'panelB_1.fig')
savefig(figure(12),'panelB_2.fig')
savefig(figure(13),'panelB_3.fig')

% panel C: ISI
savefig(figure(16),'panelC_1.fig')
savefig(figure(17),'panelC_2.fig')
savefig(figure(18),'panelC_3.fig')

% panel D: theta cycle skipping
savefig(figure(21),'panelD_1.fig')
savefig(figure(22),'panelD_2.fig')
savefig(figure(23),'panelD_3.fig')

% panel E: frequency synchronization
savefig(figure(26),'panelE_1.fig')
savefig(figure(27),'panelE_2.fig')
savefig(figure(28),'panelE_3.fig')

% panel F: rhythmicity frequency deviations (Added after review1)
savefig(figure(31),'panelF_1.fig') 
savefig(figure(32),'panelF_2.fig')
savefig(figure(33),'panelF_3.fig')
close all

% panel G: example wavelet coherence of 4-11 and 4-13 cells from 20100728_5
% recording (mean of all transitions):
cells_wavelet_coherence('20100728','5',[4,4],[11,13],5,7,[]);
set(gca,'clim',[0.3,0.7])
set(gca,'ytick',[1,13,22,34,53])
set(gca,'yticklabel',{20,10,6,3,1})
savefig(gcf,'panelG_1.fig')

% panel H: average wavelet coherence of all corecorded pacemaker pairs 
% (mean of all transitions):
funcCallDef = ['[wcoh,f] = cells_wavelet_coherence(animalId,recordingId,shankIds,cellIds,5,7);',...
    'output = f;'...
    'output2{cntr} = wcoh;'];
[f,~,output2] = execute_corecorded_pairs(get_rhGroup_indices_in_allCell('CTB'),funcCallDef);
frInd = find(f<21 & f>0.5); % interesting frequencies
avgWcoh = squeeze(mean(cat(3,output2{:}),3,'omitnan'));
figure, imagesc(1:size(avgWcoh,2),1:numel(frInd),avgWcoh(frInd,:));
set(gca,'clim',[0.3,0.5])
set(gca,'ytick',[1,13,22,34,53])
set(gca,'yticklabel',{20,10,6,3,1})
savefig(gcf,'panelH_1.fig')
close all
end