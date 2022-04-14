function MSsync_figure_S10()
%% Figure S10 (theta-skipping, arat):
ANA_RAT_GLOBALTABLE
 example_cells_plot({20100616,9,2,2;20100616,9,2,4;20100616,9,3,8},[832,844],[0,0.0014],[0,0.1]);
savefig(gcf,'Figure_S10_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CD_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end