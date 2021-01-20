function MSsync_figure8
% Requires almost all steps from MAIN_ANALYSIS (I-IX. steps)!
%% figure8
resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\MODEL\analysis\final_analysis\PACEMAKER_SYNCH'};
plot_synchronization_theories(resPaths);
%   panelA: firing rate
savefig(figure(1),'panelA_1.fig')
savefig(figure(4),'panelA_2.fig')
savefig(figure(9),'panelA_3.fig')
%   panelB: rhythmicity frequency difference
savefig(figure(11),'panelB_1.fig')
savefig(figure(14),'panelB_2.fig')
savefig(figure(15),'panelB_3.fig')
%   panelC: ISI
savefig(figure(16),'panelC_1.fig')
savefig(figure(19),'panelC_2.fig')
savefig(figure(20),'panelC_3.fig')
%   panelD: theta cycle skipping
savefig(figure(21),'panelD_1.fig')
savefig(figure(24),'panelD_2.fig')
savefig(figure(25),'panelD_3.fig')
%   panelE: frequency synchronization
savefig(figure(26),'panelE_1.fig')
savefig(figure(29),'panelE_2.fig')
savefig(figure(30),'panelE_3.fig')
close all
end