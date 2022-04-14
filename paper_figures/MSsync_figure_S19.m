function MSsync_figure_S19()
%% Figure S19 
resPaths = {'D:\ANA_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\FREE_MOUSE\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\ANA_RAT\analysis\final_analysis\PACEMAKER_SYNCH';...
     'D:\MODEL\analysis\final_analysis\PACEMAKER_SYNCH'};
plot_synchronization_theories(resPaths);
%   panelA: firing rate
savefig(figure(1),'Figure_S19_panelA_1.fig')
savefig(figure(4),'Figure_S19_panelA_2.fig')
savefig(figure(9),'Figure_S19_panelA_3.fig')
%   panelB: rhythmicity frequency difference
savefig(figure(11),'Figure_S19_panelB_1.fig')
savefig(figure(14),'Figure_S19_panelB_2.fig')
savefig(figure(15),'Figure_S19_panelB_3.fig')
%   panelC: ISI
savefig(figure(16),'Figure_S19_panelC_1.fig')
savefig(figure(19),'Figure_S19_panelC_2.fig')
savefig(figure(20),'Figure_S19_panelC_3.fig')
%   panelD: theta cycle skipping
savefig(figure(21),'Figure_S19_panelD_1.fig')
savefig(figure(24),'Figure_S19_panelD_2.fig')
savefig(figure(25),'Figure_S19_panelD_3.fig')
%   panelE: frequency synchronization
savefig(figure(26),'Figure_S19_panelE_1.fig')
savefig(figure(29),'Figure_S19_panelE_2.fig')
savefig(figure(30),'Figure_S19_panelE_3.fig')
% panel F: rhythmicity frequency deviations (Added after review1)
savefig(figure(31),'Figure_S19_panelF_1.fig') 
savefig(figure(34),'Figure_S19_panelF_2.fig')
savefig(figure(35),'Figure_S19_panelF_3.fig')
close all
end