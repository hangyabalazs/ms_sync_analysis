function MSsync_figure6
% Requires almost all steps from MAIN_ANALYSIS (I-X. steps)!
%% Figure 6 (opto groups):
OPTO_GLOBALTABLE
%   panel A-H: PV
example_cells_plot({20180821,1,4,23},[296,308],[0,0.00044],[0,0.15]);
savefig(gcf,'panelABCG.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('PVR');
cell_groups(rowIds)
savefig(gcf,'panelDEFH.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelD_0.fig'), close

%   panel I-P: VGAT
example_cells_plot({20190512,5,3,34},[298,310],[0,0.00044],[0,0.15]);
savefig(gcf,'panelIJKO.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('VGA');
cell_groups(rowIds)
savefig(gcf,'panelLMNP.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelL_0.fig'), close

%   panel Q-X: VGLUT
example_cells_plot({20190510,6,4,65},[270,282],[0,0.00044],[0,0.15]);
savefig(gcf,'panelQRSW.fig'), close all
rowIds = get_optoGroup_indices_in_allCell('VGL');
cell_groups(rowIds)
savefig(gcf,'panelTUVX.fig')
close all
rhythmicity_bar(rowIds,true);
savefig(gcf,'panelT_0.fig'), close
end