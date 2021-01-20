function MSsync_figure6
% Requires almost all steps from MAIN_ANALYSIS (I-IX., XI. steps)!
% This code relies on (included in MAIN_ANALYSIS):
% - figure6: you need to run first GROUP_SYNCHRONIZATION for the calculation of
% synchronization measures!!
% - figure6 supp1: you need to run first CREATE_CCGMATRIX for the calculation of
% cross correlations between rhythmicity groups!!

%% figure6
resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH'};
plot_synchronization_theories(resPaths);
%   panelA: firing rate
savefig(figure(1),'panelA_1.fig')
savefig(figure(2),'panelA_2.fig')
savefig(figure(7),'panelA_3.fig')
%   panelB: rhythmicity frequency difference
savefig(figure(11),'panelB_1.fig')
savefig(figure(12),'panelB_2.fig')
savefig(figure(13),'panelB_3.fig')
%   panelC: ISI
savefig(figure(16),'panelC_1.fig')
savefig(figure(17),'panelC_2.fig')
savefig(figure(18),'panelC_3.fig')
%   panelD: theta cycle skipping
savefig(figure(21),'panelD_1.fig')
savefig(figure(22),'panelD_2.fig')
savefig(figure(23),'panelD_3.fig')
%   panelE: frequency synchronization
savefig(figure(26),'panelE_1.fig')
savefig(figure(27),'panelE_2.fig')
savefig(figure(28),'panelE_3.fig')
close all

%% figure6 supp 1 (arat):
ANA_RAT_GLOBALTABLE
plot_ccg_network();
savefig(gcf,'supp1.fig')
close all
end