function MSsync_figure_S22()
%% Figure S22 (panel B = Figure R2):
OPTO_GLOBALTABLE
% panel A: opto vs rh groups boxplot
opto_rh_group
savefig(gcf,'Figure_S22_A.fig'), close all

% panel B: opto PV+&CTB sync
frequency_synchronization_opto('CTB','PVR');
savefig(figure(26),'Figure_S22_B_1.fig')
savefig(figure(1),'Figure_S22_B_2.fig')
savefig(figure(2),'Figure_S22_B_3.fig')
close all
end