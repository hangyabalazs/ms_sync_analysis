function MSsync_figure_S12()
%% Figure S12 (tonic, arat):
ANA_RAT_GLOBALTABLE
example_cells_plot({20100304,2,1,4;20100304,2,1,3;20100304,2,2,3},[679,691],[0,0.0004],[0,0.1]);
savefig(gcf,'Figure_S12_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CTT');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end