function MSsync_figure_S11()
%% Figure S11 (theta-skipping, amouse):
ANA_MOUSE_GLOBALTABLE
example_cells_plot({201801082,1,1,21;201801082,1,1,79;201801082,1,1,85},[311,323],[0,0.0006],[0,0.15]);
savefig(gcf,'Figure_S11_panelABF.fig'), close all
rowIds = get_rhGroup_indices_in_allCell('CD_');
cell_groups(rowIds)
savefig(gcf,'panelCDEG.fig')
close all
end